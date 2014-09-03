---
title: My experiences with developing multi-threaded nodejs addon
author: bramp
layout: post
date: 2011-10-17
permalink: /2011/10/17/my-experiences-with-developing-multi-threaded-nodejs-extensions/
categories:
  - Blog
tags:
  - Javascript
  - nodejs
  - threads
---
I&#8217;ve been modifying an [existing nodejs extension][1], that wraps [libcwiid][2] (a C library written to interface with a [Wiimote][3]). This extension uses polling to check if the state of the Wiimote has changed (such as a button being pressed). Libcwiid however provides a callback mechanism to be alerted as soon as a state change occurs. This has the benefit of being instantaneous, instead of at the polling interval.

While adapting [nodewii][4] to use this callback mechanism I learnt a couple of things about developing multi-threaded nodejs extensions that I thought I&#8217;d share.

#### 1) All V8 operations must run from the main thread

[Nodejs][5] uses a single thread for executing the [V8 JavaScript engine][6], and multiple worker threads to execute longer running non-JavaScript blocking tasks. Because V8 is not thread safe, all V8 operations must be executed from this single V8 thread. That means you are not allowed to create V8 objects, integers, strings, etc, from any other thread. If you try, race conditions happen, memory get corrupted and nodejs is likely to crash. Helpfully, nodejs does provide a mechanism to simplify using these threads: 

<pre class="prettyprint">eio_custom(eio_cb execute, int pri, eio_cb cb, void *data);</pre>

This function allows you to execute a blocking task in a worker thread. Once that task is finished another callback is called on the main JavaScript thread. Multiple extensions use it, and this is the basis for how nodejs provides it&#8217;s callback mechanism. Here is a very short example (adapted from [wiimote.cc][7]) of how to use eio_custom.

<pre class="prettyprint">Handle&lt;Value&gt; WiiMote::Connect(const Arguments& args) {
  WiiMote* wiimote = ObjectWrap::Unwrap&lt;WiiMote&gt;(args.This());
  Local&lt;Function&gt; callback;

  HandleScope scope;

  // Pass the arguments like you would any other method
  if(args.Length() == 0 || !args[0]-&gt;IsFunction()) {
    return ThrowException(
      Exception::Error(String::New("Callback is required and must be a Function."))
    );
  }

  callback = Local&lt;Function&gt;::Cast(args[0]);

  // Create a struct to pass into worker thread
  connect_request* ar = new connect_request();
  ar-&gt;wiimote = wiimote;
  ar-&gt;callback = Persistent&lt;Function&gt;::New(callback);

  // Add a reference to the wiimote, so it isn't garbage collected between now
  // and the callback being run
  wiimote-&gt;Ref();

  // Add reference to the EV (JavaScript) thread
  ev_ref(EV_DEFAULT_UC);

  // Schedule the Connect function to be called.
  eio_custom(Connect, EIO_PRI_DEFAULT, AfterConnect, ar);

  return Undefined();
}


int WiiMote::Connect(eio_req* req) {
  // This method is running in a worker thread, and NOT the main nodejs
  // thread. This mean you can't use any V8 methods.

  connect_request* ar = static_cast&lt;connect_request* &gt;(req-&gt;data);
  // Do some work with the connect_request, and put the results back into the struct
  ...

  return 0;
}

int WiiMote::AfterConnect(eio_req* req) {
  // Once the â€œConnectâ€ method has finished, this method will be called on
  // the main nodejs thread. This means we can now use normal V8 methods.

  HandleScope scope;

  // Retrieve the info from the request
  connect_request* ar = static_cast&lt;connect_request* &gt;(req-&gt;data);
  WiiMote * wiimote = ar-&gt;wiimote;

  // We no longer need a reference to the follow things
  ev_ref(EV_DEFAULT_UC);
  wiimote-&gt;Unref();

  // Create some JavaScript objects, and call the callback
  Local&lt;Value&gt; argv[1] = { Integer::New(ar-&gt;err) };

  TryCatch try_catch;

  ar-&gt;callback-&gt;Call(Context::GetCurrent()-&gt;Global(), 1, argv);

  if(try_catch.HasCaught())
    FatalException(try_catch);

  // Now cleanup!
  ar-&gt;callback.Dispose();
  delete ar;

  return 0;
}
</pre>

This simple pattern makes writing callback code relatively simple. However, this only works well if you are in control of creating the callback.

#### 2) How to run something on the main thread without eio_custom

Libcwiid creates it&#8217;s own thread, which is uses to read data from the wiimote. When data is received, it invokes a callback function passing this new data. This callback function is run on the libcwiid thread. This restricts us from interacting with V8. We ideally need this callback function running in the context of the main thread. The answer to this problem is:

<pre class="prettyprint">eio_req *eio_nop       (int pri, eio_cb cb, void *data);</pre>

It is safe to call this function from any thread. It will place the eio_cb callback task on the main event queue. This task is then eventually executed on the V8&#8242;s thread. An example of this follows:

<pre class="prettyprint">void WiiMote::HandleMessages(cwiid_wiimote_t *wiimote, int len, union cwiid_mesg mesgs[]) {
  // This thread is running on the libcwiid's thread, and thus we can not use V8 operations
  WiiMote *self = const_cast&lt;WiiMote*&gt;(static_cast&lt;const WiiMote*&gt;(cwiid_get_data(wiimote)));

  // Create a struct to pass to the V8 thread
  struct message_request * req = (struct message_request *)malloc( sizeof(*req) + sizeof(req-&gt;mesgs) * (len - 1) );

  // Copy all the data into this struct
  req-&gt;wiimote = self;
  req-&gt;len = len;
  memcpy(req-&gt;mesgs, mesgs, len * sizeof(union cwiid_mesg));

  // Now pass this over to the main V8 thread
  eio_nop (EIO_PRI_DEFAULT, WiiMote::HandleMessagesAfter, req);
}

int WiiMote::HandleMessagesAfter(eio_req *req) {
  // We are now running in the V8 thread.
  message_request* r = static_cast&lt;message_request* &gt;(req-&gt;data);
  WiiMote * self = r-&gt;wiimote;

  HandleScope scope;

  // Create JavaScript objects with the message_request
  ...

  // Emit this event to a JavaScript callback.
  this-&gt;Emit(event, 1, argv);
}
</pre>

Using a combination of eio\_custom and eio\_nop you should be able to interface with any external library of service. You just have to make sure you always know what thread you are on, and what methods you are allowed to use in that context.

Finally, writing correct thread-safe code is hard. From the various nodejs extensions I have come across I regularlly find memory management, or threading issues with them. So I suggest you rigorously use [valgrind][8] while developing, and simplify your designs so that most of the heavily lifting is done by nodejs itself.

 [1]: https://github.com/tbranyen/nodewii
 [2]: http://abstrakraft.org/cwiid/wiki/libcwiid
 [3]: http://en.wikipedia.org/wiki/Wii_Remote
 [4]: https://github.com/bramp/nodewii
 [5]: http://nodejs.org/
 [6]: http://code.google.com/p/v8/
 [7]: https://github.com/bramp/nodewii/blob/master/src/wiimote.cc
 [8]: http://valgrind.org/