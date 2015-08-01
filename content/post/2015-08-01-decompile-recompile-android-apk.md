---
title: Decompile and Recompile Android APK
author: bramp
categories:
- Blog
date: 2015-08-01T12:24:59-07:00
layout: post
tags:
- android
- java
---

I had the need to take an existing [Android APK](https://en.wikipedia.org/wiki/Android_application_package), tweak it, and rebuild. This is not too difficult, but I did have to download the tools from a few different sites, and find a full list of instructions. Thus to make this easier, here is a quick recap of what's needed.

Download the following:

* [apktool](http://ibotpeaches.github.io/Apktool/) - tool for reverse engineering Android apk files. In this case can extract and rebuild.
* [keytool](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html) - Java tool for creating keys/certs. Comes with the JDK.
* [jarsigner](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jarsigner.html) Java tool for signing JAR/APK files. Comes with the JDK.
* [zipalign](https://developer.android.com/tools/help/zipalign.html) - archive alignment tool, that comes with the Android SDK.

Some extras:

* [JD-GUI](http://jd.benow.ca/) - Java Decompiler
* [dex2jar](https://github.com/pxb1988/dex2jar) - Converts Android dex files to class/jar files.

## Instructions:

We assume you are on a Linux or Mac, but this will work (with some tweaking) on Windows. Install a recent Java JDK, then the [Stand-alone Android SDK](https://developer.android.com/sdk/installing/index.html?pkg=tools), and finally [apktool](http://ibotpeaches.github.io/Apktool/). 

Optionally setup some alias:

```bash
alias apktool='java -jar ~/bin/apktool_2.0.1.jar'
alias dex2jar='~/bin/dex2jar-2.0/d2j-dex2jar.sh'
alias jd-gui='java -jar ~/bin/jd-gui-1.3.0.jar'
```

First, unpack the application.apk file. This will create a "application" directory with assets, resources, compiled code, etc.

```bash
apktool d -r -s application.apk
```

Now poke around, and edit any of the files in the application directory. If you wish to decompile any java you can do the following:

```bash
# Convert the Dex files into standard class files
d2j-dex2jar.sh application/classes.dex

# Now use the JD (Java Decompiler) to inspect the source
jd-gui classes-dex2jar.jar
```

Once you have made your changes, you need to repack the APK. This will create a `my_application.apk` file:
```bash
apktool b -f -d application
mv application/dist/application.apk my_application.apk
```

The APK must be signed before it will run on a device. Create a key if you don't have an existing one. If prompted for a password, enter anything (but remember it).
```bash
keytool -genkey -v -keystore my-release-key.keystore -alias alias_name \
                   -keyalg RSA -keysize 2048 -validity 10000
```

Now sign the APK with the key:
```bash
# Sign the apk
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore my_application.apk alias_name

# Verify apk
jarsigner -verify -verbose -certs my_application.apk
```

Finally, the apk must be aligned for optimal loading:
```bash
zipalign -v 4 my_application.apk my_application-aligned.apk
```

Voila, now you have a `my_application-aligned.apk` file, which you can side load onto your device.
