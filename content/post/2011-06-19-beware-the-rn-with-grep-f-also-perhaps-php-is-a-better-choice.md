---
title: Beware the \r\n with grep -f, also perhaps PHP is a better choice?
author: bramp
layout: post
date: 2011-06-19
categories:
  - Blog
aliases:
  - /blog/2011/06/19/beware-the-rn-with-grep-f-also-perhaps-php-is-a-better-choice/
---
I had two files, one large CSV file (10million rows), and another file (600K rows). I wanted to find all the lines in the large CSV file that contained a word in the smaller file. The smaller file was a simple text with one word per line.

I found that grep could do: 

```bash
grep -f smallfile largefile > results.csv
```

Which would build a list of patterns from the contents of the smallfile. This seemed simple enough, however it didn&#8217;t work. Some investiagtion showed that the smallfile had windows  
new lines, and grep assumed the \r was part of the pattern. Using [dos2unix][1] fixed my problem.

However, new problem, grep used 100% of my CPU and 2GB of my RAM and took over 5 hours. I actually gave up before I let it finish. I assume it was building a large regexp parse tree.  
So I figured to allow it to make a simpler tree I would alter my smallfile to contain &#8220;^keyword&#8221;, instead of just &#8220;keyword&#8221;. I could do this because I knew the keyword would always  
be at the beginning of the line. So **awk &#8216;{print &#8220;^&#8221;$1} smallfile** allowed me to do that. I tried grep again but it seemed to again be taking a long time.

While waiting for grep to finish, I started to write a PHP script:

```php
<?php
// Prints out each line from a CSV where the first entry is in another list
// By Andrew Brampton March 2011
// php inlist.php bigfile smallfile
// TODO we need better names and more error checking

$bigfile = $argv[1];
$littlefile = $argv[2];

$little = array();
$fp = fopen($littlefile, 'r') or die('Failed to open little file');
while ($line = fgets($fp)) {
        $line = trim($line);
        $little[ $line ] = true;
}
fclose($fp);

$fp = fopen($bigfile, 'r') or die ('Failed to open big file');
while ($line = fgets($fp)) {
        $num = strpos($line, ',');
        $num = substr($line, 0, $num);

        if (isset($little[$num])) {
                unset($little[$num]); // We unset so we can get a count/list of all those not in the list
                echo $line;
        }
}
fclose($fp);
?>
```

It took me 10 minutes to write this. I quickly ran it, and it completed within 20seconds. Looks like this is a far more efficient way to do it :)

 [1]: http://linux.die.net/man/1/dos2unix
