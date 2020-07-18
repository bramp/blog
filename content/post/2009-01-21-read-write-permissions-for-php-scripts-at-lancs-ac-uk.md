---
title: Read/Write permissions for PHP scripts at lancs.ac.uk
slug: read-write-permissions-for-php-scripts-at-lancs.ac.uk
author: bramp
layout: post
date: 2009-01-21
categories:
  - Blog
tags:
  - acl
  - lancs
  - SunOS
  - www
aliases:
  - /blog/2009/01/21/read-write-permissions-for-php-scripts-at-lancs-ac-uk/
---
My girlfriend wanted to create a blog, and she attempted to use her [university provided web space][1]. However, the blog software seemed unable to write to her webspace. Typically you would fix this by changing the write permissions on the file/directory like so:

```bash
chmod g+w filename
```

or 

```bash
chmod o+w filename
```

However this did not seem to work. I noticed that the files which hosted the website were on a SunOS 5.8 machine, and this seemed to support access control lists (ACLs). So I looked at a few of the ACLs for the files and they looked like this:

```bash
$ getfacl filename
user::rwx
group::rwx              #effective:rwx
group:httpadmin:rwx     #effective:rwx
mask:rwx
other:r--
```

Since there is the group:httpadmin line, ISS are clearly using these ACLs. So I figured I would add the user the webserver is running under to the ACL. A quick look at a phpinfo() page showed me that the web server is running under user www in group www. So I first tried the following:

```bash
setfacl -m user:www:rw- filename
```

But that oddly didn&#8217;t work, but then I noted that the webserver was a linux machine, not SunOS, and that the UID of www was 48. A quick look at the UID of www on SunOS and it shows it is a completely different number. So for what ever reason ISS were unable to make the UIDs match between computers, so the correct command to type is:

```bash
setfacl -m user:48:rw- filename
```

Bottom line, if you wish to make your files or directories writable by scripts running on the webserver you must log into cent1 (via ssh), change to your www directory &#8220;/home/cent1/NN/username/www/public_html&#8221; and then issue the above command to the appropriate files.

 [1]: http://www.lancs.ac.uk/ug/cranen
