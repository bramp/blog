---
title: Derren Brown’s Coin Game
author: bramp
layout: post
date: 2009-09-12
categories:
  - Blog
tags:
  - coin
  - derren brown
aliases:
  - /2009/09/12/derren-brown-s-coin-game/
---
**Update: I found out this coin game is called [Penney&#8217;s Game][1] and is played slightly differently to how I thought.**

On TV tonight Derren Brown (poorly) described a game where two players would each pick a sequence of 3 heads or tails and then keep flipping a coin until they obtained their sequence. The winner would be the one that flips their own sequence the most times. Derren suggested that by having a team of supporters they could influence the coin tosses and allow you to win. In the programme the player with the supports won, but how?

So to start with the basics there are 8 different sequences to pick:

| Combination | Probability |
|:-----------:|:-----------:|
|     HHH     |     1/8     |
|     HHT     |     1/8     |
|     HTH     |     1/8     |
|     HTT     |     1/8     |
|     THH     |     1/8     |
|     THT     |     1/8     |
|     TTH     |     1/8     |
|     TTT     |     1/8     |

Each sequence of flips is equally likely, and on face value you would expect a 1 in 8 chance of any of these combinations to occur. Now this is true, however, if you play the game in the same way that Derren Brown does, then a different outcome will happen. 

The difference in Derren's game is what happens when you fail to flip the correct face. Instead of starting from the beginning you are allowed to carry on. So instead of having to get 3 in a row from scratch, you have to get your sequence from the last 3 attempts. The player would score a point with the combination HTT if they had previous flipped HTHTT. 

This can be used to your advantage by picking a sequence which starts and ends with different sides. If, for example, your sequence starts with a head and ends in a tail, then if you fail to flip the 3rd coin correctly, then you have already successfully flipped once for the next attempt.

The worst combinations to pick are HHH and TTT because you can never capitalise on a previous bad flip. The next worst are HTH or THT, as with these you can capitalise on one previous flip if you fail to flip the 2nd coin. Finally the best combinations are, HHT, HTT, THH, TTH, as here you can always capitalise on a bad flip regardless if it is the second or third flip.

Because I'm too lazy to work out the exact odds, I used Monte-Carlo simulations to generate this table of results:

| Combination | Percentage Outcome |
|:-----------:|:------------------:|
|     HHH     |       8.4697%      |
|     HHT     |      14.8300%      |
|     HTH     |      11.8627%      |
|     HTT     |      14.8335%      |
|     THH     |      14.8326%      |
|     THT     |      11.8603%      |
|     TTH     |      14.8356%      |
|     TTT     |       8.4756%      |

Derren suggested that if you ever played this game you should let your opponent chose first, and then you should transpose their sequence by flipping the middle value, placing it on the front, and then dropping the fourth value. So, for example, HHH has its middle value of H, flip this and move it to the front to make THHH, and finally drop the final H, leaving us with THH. If you do this with any combination you always get one of the better combinations. However, Derren incorrectly explained that this combination would always win over your opponent, this is not true if they picked one of the four best combinations. I did notice however, that this is true if you are playing with 4 flip sequences, and I even found a Wolfram [ demonstration ][2] of this.

 [1]: http://en.wikipedia.org/wiki/Penney's_game
 [2]: http://demonstrations.wolfram.com/CoinFlips/
