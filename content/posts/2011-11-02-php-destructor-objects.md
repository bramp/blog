---
title: PHP Destructor objects
author: bramp
layout: post
date: 2011-11-02
permalink: /2011/11/02/php-destructor-objects/
categories:
  - Blog
tags:
  - hack
  - PHP
---
PHP&#8217;s lack of a finally keyword is apalling, and even though there seems to be some hacks around it, I have come up with own today. I&#8217;m following the C++ concept of allocating objects on the stack, and letting them cleanup any resources when the stack is rolled back.

Take an example. I am creating some files that I want to always be deleted after the script has finished. In any sane language (that has Exceptions) I would write:

<pre class="prettyprint">try {
  // Create files
  // Do something with the files
} finally {
  // Delete files - This code will run no matter what exceptions or errors occur while creating the files.
}
</pre>

However, this is the hack I&#8217;ve managed with PHP:

<pre class="prettyprint">class UnlinkMe {
	var $filename;

	function __construct($filename) {
		$this-&gt;filename = $filename;
	}

	function __destruct() {
		unlink($this-&gt;filename);
	}
}

// To use:
function doSomething() {
  $unlinkme = new UnlinkMe('/tmp/filename'):

  // Do some work with the files

  return;
}
</pre>

Here we are creating a UnlinkMe object, that has a destructor set up to delete a file. This UnlinkMe object is only used in the doSomething() function. Once that function returns, there are no longer any references to the object. When PHP decides to garbage collect (to free up some memory), it will destroy the UnlinkMe object, and thus call the __destruct method. Voila, we now call unlink and have cleaned up the file, even after the script has finished running.

There is lots of room for improvement, and this technique has lots of gotchas. For example, PHP has some bizzare rules for when __destruct method will not be called. So please don&#8217;t rely on this technique, but it might be useful, and keep your code cleaner and more organised.