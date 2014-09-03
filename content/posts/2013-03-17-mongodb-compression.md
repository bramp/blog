---
title: MongoDB Compression
author: bramp
layout: post
date: 2013-03-17
permalink: /2013/03/17/mongodb-compression/
categories:
  - Blog
tags:
  - compression
  - mongodb
---
For a while people have wanted MongoDB to [compress their data][1], or at least [compress their field names][2]. This would be beneficial in not only reducing the amount of disk space required, but also in theory improving performance as we trade disk IO with CPU IO. I thought this be a fun project to investigate, so I started by working out if this would actually be useful. <!--more-->

Lets start with compressing the data. I&#8217;ve taken a project I&#8217;ve been working on, where most of the records have the similar set of fields. An example record may look like (which across the database had an average size of 547 bytes):

<pre>{
	"_id" : ObjectId("5134b1c644ae658fc8c050c0"),
	"version" : NumberLong(0),
	"attributes" : {
		"firstName" : "Andrew",
		"lastName" : "Brampton",
		"birthday" : "1982-01-01T00:18:00.000-05:00",		
	},
	"tags" : ["25-30 years", "dc", "male" ],
	"contactPoints" : [{
		"_id" : "+11235551234",
		"type" : "sms",
		"number" : {
			"E164" : "+11235551234"
		},
		"version" : NumberLong(0),
		"subscriptions" : [{
			"version" : NumberLong(0),
			"event" : ObjectId("5134b1c644ae658fc8c050aa"),
			"status" : "ACTIVE"
		}]
	},{
		"_id" : "a@b.com",
		"type" : "email",
		"email" : "a@b.com",
		"version" : NumberLong(0),
		"subscriptions" : [ ]
	}]
}
</pre>

There are some excellent [presentations][3] and [articles][4] on how MongoDB structures the data on the disk. For the sake of this investigation I took a single data file (of size 2 GiB) that was full of just these kinds of records.

## Full Compression

<pre>gzip datafile.5</pre>

**Original size:** 2,146,435,072 bytes (2.0 GiB)  
**Compressed gzip size:** 453,359,908 bytes (432 MiB) / 21% of the original size

Simple gzip across the whole file gave a 4.7x saving in file size. This is obviously best case, as it covers the full file. Next lets look at the savings from compressing the field names.

## Field name Compression

<pre>strings -n3 datafile.5 | sort | uniq -c | sort -n | tail -n20 </pre>

That prints out a list of the most popular strings in the data file, sorted by frequency. From those stats we can infer

**Unique fields:** 14  
**Fields:** 75,764,300  
**Field bytes:** 506,244,611 bytes (482 MiB) / 23% of the total data file size

If we assume that we can encode each field to just a single byte, then we reduce the bytes taken by the field names from 482 MiB to 72.2 MiB, a 6.6x saving of the field names. That&#8217;s a good saving, but as the field names only take up 23% of the file, the overall saving would be 20% of the total data file size.

## Document Compression

Compression of individual document might provide a better solution than field compression. It&#8217;s not possible to compress the whole database, as that&#8217;ll make it extremely hard to alter individual documents. So instead each document would be compressed independently of the others. This is different to field compression would would have to be compressed across documents.

To try this out I wrote a [simple Python script][5] instead of hacking the MongoDB code. This script simulates the compression by finding each BSON encoded document on disk, compresses it (with zlib), and sums up the uncompressed and compressed document sizes.

**Uncompressed document length:** 1,888,733,156 bytes (1.75 GiB)  
**Compressed document length:** 1,261,267,661 bytes (1.17 GiB) / 66% of the total document length

The keen reader will notice the documents only made up 1.75 GiB, of the total 2 GiB data file. The rest of the file contains non-document data, such as indexes, padding, and perhaps deleted documents. As the non-document data wasn&#8217;t compressed in this test, the total savings was about 30% of the total file. This could improve if the document was more compressible (for example if they were larger), or if a better compression scheme was used.

## Conclusion

In conclusion, compression could certainly help reduce the size on disk, and this could lead to performance improvements. Field level compression gave us 20% reduction and document compression gave us 30%. The next step is to actually implement this, and run various benchmarks.

## Future

My current thinking on field level compression is to create a simple lookup table that maps field names to a token. This lookup table would be stored in the extents, which contains numerous documents. As new extents are created new lookup tables will be created. This allows the lookup tables to adapt as new types of documents are put into the system. The lookup table will only be appended to, to ensure existing documents continue to work. The table can then be optimised when a compact operation is called.

Looking at the existing MongoDB code, adding field level compression might be quite tricky, as the BSON objects are memory mapped, and multiple places make assumptions about being able to access fields. So an easier approach might be to do full BSON object compression, and create uncompressed copies in memory.

[Look forward to my attempt of compression][6].

 [1]: https://jira.mongodb.org/browse/SERVER-164
 [2]: https://jira.mongodb.org/browse/SERVER-863
 [3]: http://www.10gen.com/presentations/mongosv-2011/mongodb-storage-engine-bit-by-bit
 [4]: http://blog.fiesta.cc/post/13975691790/mongosv-live-blog-mongodbs-storage-engine-bit-by-bit
 [5]: https://gist.github.com/bramp/5183117
 [6]: https://github.com/bramp/mongo/tree/SERVER-164