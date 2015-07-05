---
title: Setting up git-p4
author: bramp
layout: post
date: 2012-09-04
categories:
  - Blog
tags:
  - Git
  - perforce
aliases:
  - /blog/2012/09/04/setting-up-git-p4/
---
I couldn&#8217;t find a good article on setting up git-p4, and for some reason most of the articles out there point to dead URLs. So I figured I&#8217;d quickly write this up. <!--more-->

Git-p4 is a tool for using git on top of a perforce server. This is great if your team wants to work with a DVCS, but your company requires a centralised VCS.

There were multiple github projects [1][1], [2][2], [3][3], that had forks of the git-p4 script, however, I found the latest mixed in with the official git source code. So download it from [here][4]. Tip: Don&#8217;t forget to &#8220;chmod +x git-p4.py&#8221; once it&#8217;s downloaded.

Next, I wanted to be able to type &#8220;git p4&#8243;, so I used an [alias][5] to do this. Edit/create the file ~/.gitconfig and add:

```ini
[alias]
p4 = !~/bin/git-p4.py
```

Once that&#8217;s done you should be able to:

```bash
# Fetch only the head
git p4 clone //depot/path/to/project/ project

# or Fetch all revisions (takes a little longer)
git p4 clone //depot/path/to/project/@all project
```

If that returns an error, such as &#8220;p4 returned an error: Perforce password (P4PASSWD) invalid or unset.&#8221;, then you most likely don&#8217;t have your p4 command line set up. To set mine up, I added the following to my .bashrc

```bash
export P4CLIENT=myclient
export P4HOST=perforce:1666
export P4USER=myuser
export P4EDITOR=nano
```

and then logged in

```bash
p4 login
```

More information on that set up can be found in the [ official documentation][6].

Once cloned, you can change to the project directory and use many of the normal git commands, such as &#8220;git log&#8221;. You may notice that your newly checked out git repo only has one commit. If you want to see a full history use @all on the end of your depot path.

 [1]: https://github.com/baldrick/git-p4/
 [2]: https://github.com/gkielSfdc/git-p4
 [3]: https://github.com/jendave/git-p4
 [4]: https://raw.github.com/git/git/master/git-p4.py
 [5]: https://git.wiki.kernel.org/index.php/Aliases
 [6]: http://www.perforce.com/perforce/doc.current/manuals/p4guide/02_config.html
 
