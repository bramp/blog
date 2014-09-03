---
title: Alignment of Raphaël Paper.text(…) and Paper.print(…)
author: bramp
layout: post
date: 2013-03-31
permalink: /2013/03/31/alignment-of-raphael-text/
dsq_thread_id:
  - 1614111094
categories:
  - Blog
---
Working with [Raphaël][1] I noticed the alignment of text drawn with the [Paper.text(&#8230;)][2] and [Paper.print(&#8230;)][3] methods differed. The documentation wasn&#8217;t helpful in explaining the difference, so I wrote a simple test to work out their behaviour, and then a small method to normalise them.  
<!--more-->

  
[<img src="http://bramp.net/blog/wp-content/uploads/raphaeljs-text-test.svg" alt="raphaeljs-text-test" class="aligncenter size-full wp-image-627" />][4]  
In this I&#8217;m drawing text with it&#8217;s bounding box show, and a cross over the x,y coordinates the text is meant to appear. As you can see [Paper.text(&#8230;)][2] defaults to centre aligning vertically and horizontally. [Paper.print(&#8230;)][3] aligns with the baseline of the first line, and I&#8217;m guess horizontally with the left edge (with a small amount of padding). The last example I wrote a simple method to centre [Paper.print(&#8230;)][3] so it acts like [Paper.text(&#8230;)][2]

Code to draw this SVG is below, with my normalised print method named print_center.

<pre class="prettyprint">Raphael.fn.line = function(x1, y1, x2, y2) {
    //assert(_.all([x1,x2,y1,y2], _.isFinite), "x1,x2,y1,y2 must be numeric");
    return this.path("M{0},{1} L{2},{3}", x1, y1, x2, y2);
};

/**
 * Prints, but aligns text in a similar way to text(...)
 */
Raphael.fn.print_center = function(x, y, string, font, size, letter_spacing) {
    var path = this.print(x, y, string, font, size, 'baseline', letter_spacing);
    var bb = path.getBBox();

    var dx = (x - bb.x) - bb.width / 2;
    var dy = (y - bb.y) - bb.height / 2;

    return path.transform("t" + dx + "," + dy);
}

$(document).ready(function(){
    var paper = new Raphael("diagram", 300, 600);

    function draw_cross(x, y) {
        var SIZE = 50;
        paper.line(x, y - SIZE, x, y + SIZE);
        paper.line(x - SIZE, y, x + SIZE, y);
    }

    function draw_coord(x, y) {
        var p = paper.text(x, y, x.toFixed(0) + "," + y.toFixed(0));
        p.attr({'font-size': 10});
    }

    function draw_bb(bb) {
        paper.rect(bb.x, bb.y, bb.width, bb.height);

        draw_coord(bb.x, bb.y);
        draw_coord(bb.x + bb.width, bb.y);
        draw_coord(bb.x, bb.y + bb.height);
        draw_coord(bb.x + bb.width, bb.y + bb.height);
    }

    //////////
    draw_cross(100, 100);
    var p = paper.text(100, 100, "Text\n100,100\nThird");
    p.attr({'font-size': 32});

    draw_bb( p.getBBox() );

    //////////
    draw_cross(100, 300);
    var font = paper.getFont('daniel')
    var p = paper.print(100, 300, "Print\n100,300\nThird", font, 32, 'baseline');

    draw_bb( p.getBBox() );

    //////////
    draw_cross(100, 500);
    var font = paper.getFont('daniel')
    var p = paper.print_center(100, 500, "MyPrint\n100,500\nThird", font, 32);

    draw_bb( p.getBBox() );
});
</pre>

 [1]: http://raphaeljs.com/
 [2]: http://raphaeljs.com/reference.html#Paper.text
 [3]: http://raphaeljs.com/reference.html#Paper.print
 [4]: http://bramp.net/blog/wp-content/uploads/raphaeljs-text-test.svg