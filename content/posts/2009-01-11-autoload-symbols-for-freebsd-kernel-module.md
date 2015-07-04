---
title: Autoload symbols for FreeBSD kernel module
author: bramp
layout: post
date: 2009-01-11
permalink: /2009/01/11/autoload-symbols-for-freebsd-kernel-module/
categories:
  - Blog
tags:
  - debug
  - FreeBSD
  - gdb
  - kernel
  - python
---
When debugging FreeBSD kernel modules with GDB, you have to tell GDB the correct symbols for the module, and the location the module is loaded in RAM. This is helpfully explained in the [FreeBSD Developers&#8217; Handbook][1]. First you must load the module, then run kldstat, note down the address the module is loaded at, and finally execute a command in GDB that looks like the following.

```
add-symbol-file /sys/modules/linux/linux.ko 0xc0ae22d0
```

However, I find this process tedious, so instead I wrote a quick python script which can be used with an [experimental gdb built with python scripting support][2].

So here is the script:

```python
import gdb
class FreeBSD_ReloadModuleSymbols (gdb.Command):
	"Reloads the symbol files for all loaded kernel modules"

	def __init__ (self):
		super (FreeBSD_ReloadModuleSymbols, self).__init__ ("reload-freebsd-module-symbols",
			gdb.COMMAND_FILES,
			gdb.COMPLETE_NONE)

	def invoke (self, arg, from_tty):
		link = gdb.parse_and_eval("linker_files-&gt;tqh_first")
		while link != 0:
			print link['filename'].string()
			if link['filename'].string() != "kernel":
				gdb.execute( "add-symbol-file " + 
					link['pathname'].string() + " " +  
					str(link['address'].address()) )
			link = link['link']['tqe_next']

FreeBSD_ReloadModuleSymbols ()
```

You load this by running the following command in GDB:

```bash
source freebsd_load_modules.py
```

Then the command `reload-freebsd-module-symbols` is magically added to GDB. Running this command will parse the linker table inside the FreeBSD kernel, determine which modules are loaded, and attempt to load their symbols.

 [1]: http://www.freebsd.org/doc/en/books/developers-handbook/kerneldebug-kld.html
 [2]: http://sourceware.org/gdb/wiki/PythonGdb
