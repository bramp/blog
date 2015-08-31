---
title: PHP Polygon Clipper using the Sutherland-Hodgman algorithm
author: bramp
layout: post
date: 2011-11-26
categories:
  - Blog
tags:
  - algorithm
  - clip
  - PHP
aliases:
  - /blog/2011/11/26/php-polygon-clipper-using-the-sutherland-hodgman-algorithm/
---
I wrote a PHP implementation of the polygon clipping algorithm by Sutherland-Hodgman. Available below, or from [github][1].

```php
<?php
/**
 * Polygon Clipping
 * @author Andrew Brampton me <at> bramp <dot> net
 * @url http://bramp.net/blog/2011/11/php-polygon-clipper-using-the-sutherland-hodgman-algorithm/
 *
 * Based on the Sutherland-Hodgman algorithm (1974).
 * http://en.wikipedia.org/wiki/Sutherland%E2%80%93Hodgman_algorithm
 *
 * This approache assumes four clip edges (the bounding box).
 * The original algorithm iterated though each clip edge, and then each point. Instead
 * we iterate each point, and then clip edge. This reduces the memory usage. TODO Measure if that is useful!
 *
 * Usage:
 *   require('clip.class.php');
 * 
 *   // Create a cliper with bounds defined by the points (x1, y1)-(x2,y2);
 *   $clip = new SutherlandHodgman($x1, $y1, $x2, $y2);
 * 
 *   // Create array of 2 tuple coordinates
 *   $points = { {x1, y1}, {x2, y2} ... {xN, yN} }'
 *
 *   // Clip! The resulting array will only have points within the bounds
 *   $points = $clip->clip($points);
 *
 */

abstract class Edge {

	var $bound;

	function __construct($bound) {
		$this->bound = $bound;
	}

	/**
	 * Is point $p inside the bounds. Techinically is it on the inside
	 * of the infinite edge defined by $bound
	 *
	 * @param point $p
	 */
	abstract function inside($p);

	/**
	 * Finds the intersection with the bounds, on the line p1-p2
	 *
	 * @param point $p1 The point inside the bounds
	 * @param point $p2 The point outside the bounds
	 */
	abstract function intersect($p1, $p2);
}

abstract class HorzEdge extends Edge {

	/**
	 * Returns the point at which the line $p1-$p2 hits the horz boundary
	 *
	 * @param point $p1
	 * @param point $p2
	 *
	 * @return point
	 */
	function intersect($p1, $p2) {
		$dY = $p2[1] - $p1[1];

		if ($dY == 0)
			return array($p1[0], $this->bound);

		$dX = $p2[0] - $p1[0];
		$dY2 = ($this->bound - $p1[1]);

		return array(($dY2 / $dY) * $dX + $p1[0], $this->bound);
	}
}

abstract class VertEdge extends Edge {

	/**
	* Returns the point at which the line $p1-$p2 hits the vertical boundary
	*
	* @param point $p1
	* @param point $p2
	*
	* @return point
	*/
	function intersect($p1, $p2) {
		$dX = $p2[0] - $p1[0];

		if ($dX == 0)
			return array($this->bound, $p1[1]);

		$dY = $p2[1] - $p1[1];
		$dX2 = ($this->bound - $p1[0]);

		return array($this->bound, ($dX2 / $dX) * $dY + $p1[1]);
	}
}

function intersect($p1, $p2) {
	$dX = $p2[0] - $p1[0];
	$dY = $p2[1] - $p1[1];
}

class RightEdge extends VertEdge {
	function inside($p) {
		return $p[0] < $this->bound; //X
	}
}

class LeftEdge extends VertEdge {
	function inside($p) {
		return $p[0] >= $this->bound; //X
	}
}

class TopEdge extends HorzEdge {
	function inside($p) {
		return $p[1] >= $this->bound; //Y
	}
}

class BottomEdge extends HorzEdge {
	function inside($p) {
		return $p[1] < $this->bound; //Y
	}
}

function check_point($p, $msg) {
	if ($p[0] < -180 || $p[0] > 180 || $p[1] < -90 || $p[1] > 90) {
		var_dump($p);
		var_dump(debug_backtrace());
		die("Something went wrong! $msg");
	}
}

class SutherlandHodgman {

	var $edges;

	/**
	 * Construct with the bounds of the clipped area
	 *
	 * @param unknown_type $x1
	 * @param unknown_type $y1
	 * @param unknown_type $x2
	 * @param unknown_type $y2
	 */
	function __construct($x1, $y1, $x2, $y2) {
		assert($x1 < $x2);
		assert($y1 < $y2);

		$this->edges = array(
			new RightEdge($x2),
			new TopEdge($y1),
			new LeftEdge($x1),
			new BottomEdge($y2)
		);
	}

	/**
	 * Clip the array of (x,y) coords to the bounds
	 * specified in the constructor
	 *
	 * @param array $points
	 */
	function clip($points) {

		if (count($points) < 3)
			throw "Clip requires a polygon of three points or more";

		foreach ($this->edges as $edge) {
			$output = array();

			if (empty($points))
				return $points;

			$previous = $points[0];
			$previousInside = $edge->inside($previous);

			// Add the first onto the end so it eventually gets processed
			$points_count = count($points);
			if ($points[$points_count - 1] !== $points[0]) {
				$points[] = $points[0];
				$points_count++;
			}

			for ($i = 1; $i < $points_count; $i++) {
				$point = $points[$i];

				assert(is_array($point));
				assert(count($point) == 2);

				$inside = $edge->inside($point);

				if ($inside) {
					if (!$previousInside) {
						assert(!$edge->inside($previous));
						$output[] = $edge->intersect($point, $previous);
					}

					$output[] = $point;

				} else if ($previousInside) {
					assert($edge->inside($previous));
					$output[] = $edge->intersect($previous, $point);
				}

				$previous = $point;
				$previousInside = $inside;
			}

			$points = $output;
		}

		return $output;
	}
}
```

[1]: https://gist.github.com/bramp/1396058#file-clip-class-php
