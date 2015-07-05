---
title: 'SQLSTATE[HY000]: General error: 2053'
author: bramp
layout: post
date: 2011-10-25
categories:
  - Blog
tags:
  - mysql
  - pdo
  - PHP
aliases:
  - /blog/2011/10/25/sqlstate-hy000-general-error-2053/
---
I encountered the following odd exception:

```text
PHP Fatal error:  Uncaught exception 'PDOException' with message 'SQLSTATE[HY000]: General error: 2053 ' in /home/bramp/my.php:29
Stack trace:
#0 /home/bramp/my.php(29): PDOStatement->fetch(2)
```

Searching on Google didn&#8217;t reveal much help, but I eventually figure out the root cause. Spot the mistake:

```php
...
$sql = 'SELECT TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME FROM QRTZ_TRIGGERS';
$sth = $dbh->prepare($sql) or die('Failed to prepare SELECT TRIGGER query');
while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
...
```

I am missing a 

```php
$sth->execute();
```

in between the prepare and the fetch. Easy fix. For reference I&#8217;m using a old version of PHP 5.1.6, and MySQL client 5.0.45.
