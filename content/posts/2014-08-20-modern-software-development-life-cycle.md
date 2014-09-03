---
title: Modern Software Development Life Cycle
author: bramp
layout: post
date: 2014-08-20
permalink: /2014/08/20/modern-software-development-life-cycle/
categories:
  - Blog
tags:
  - development
  - sdlc
  - testing
---
I recently got asked by a friend at a start-up on how to ensure better quality in their product. They were looking for advise on the QA process, but after digging a little I found they needed improvements to their full software development life cycle (SDLC). After a few emails back and forth I ended up writing what&#8217;s below. It has plenty of references for further reading, and I thought it would be good to share.

Generally people view the SDLC as a pipeline, and there are different ways to manage the pipeline, Scrum, Kanban, Waterfall, etc. Each with their pros and cons, and all can help your quality, but I’ll address that later

The pipeline typically consists of the following steps; Requirements, Design, Development, Testing, Deployment. At each stage you can ensure quality in your product. However, you should consider this an iterative process, always going back to the beginning to re-evaluate your thoughts/findings/etc

**Requirements**  
Firstly, it sounds like your customers weren&#8217;t getting what they were expecting. I can’t stress how important correct requirements gathering can be. [Office Space][1] may have made fun of this, but you should be sitting with your client, understanding their use cases, understand why they want what they want. These are all important to building a good product. Some would argue you should only [listen to your clients in moderation][2], but, if you only have a couple of clients, and if they are paying you for the work, then you should listen. 

Once you think you know what they want, wireframe it, mock it up, write a document, and get the client to sign off on it. The sign off is key as it ensures both parties are in agreement as to what is being delivered. [A good product manager][3] would be doing the bulk of this phase.

At this point, you might also have time estimates, know how long it will take, and how much it will cost. Setting correct expectations with clients on timing is always important. Sometimes people don’t care how long it will take as long as your estimate is accurate. Missing deadline is never good.

**Design**  
Once you know what you want, design it, diagram the flows, create a database schema, the API endpoints, maybe even make a proof of concept, to learn the technology.

Learning to design software takes practices, and I don’t think is something you can learn from reading, instead practice makes perfect. However, sites like [Highly Scalability][4] show you how others have solved problems, and there are certainly many books on the topic; [Software Design][5], [Design Patterns][6], [Architectures][7], [etc][8].

One way to make your design work easier, is to use a framework. A good framework will force you to break your code into layers, such as controllers, services and data access. This helps to keep your project well organised, and has many additional benefits, such making your code testable, giving you access to large pools of plugins, and developers who already have knowledge in your framework.

**Development**  
What do developers spend most of their time doing, reading code or writing code? Contrary to what you may think you pay them for, they spend most of their time [reading code][9]. Not just other people&#8217;s code, but their own code. Most developers forget what they wrote the previous day.

So to help developers you should do everything to keep code clean, readable and maintainable. That doesn&#8217;t just mean adding comments here and there, instead using various simple techniques such as sensible variable names, short functions ([that do one thing][10]), keeping the code well indented, etc. There are a few [great books][11] on [the topic][12].

Clean simple code is very important, it makes the developer&#8217;s job easier, reducing mistakes and bugs. I actually like to [track lines of code][13] my team writes over time. Not in the traditional IBM [KLOC][14] way, but instead looking for the number to decrease over time. This can happen when we realise things are [redundant][15], find libraries that take the burden of the work, or simplify the design once we have a better understanding. There are even tools to help you measure [how complex your software is][16]!

Never reinvent the wheel, there are 1000s of awesome open source projects out that, and one of them will solve whatever problem you have. Whoever solved the problem, more than likely spent more time thinking about it than you! Otherwise they wouldn&#8217;t have deemed it worth sharing online. This typically means you get a lot of value for free, that you don&#8217;t have to maintain.

You should focus your effort on adding business logic, and value to your product, not focusing on implementing a clever caching algorithm, or figuring out the ins-and-outs of how SMTP works. Those problems are worth solving, but not now, and not unless you could gain measurably value.

**Testing**  
To keep your pipeline quick and efficient, you should be automating as much as possible. Testing is one area you can easily automate, but sadly many people leave this as an after thought. Concepts like [Test Driven Development][17] (TDD) are useful for ensuing tests get written upfront, and code is well design. Even without TDD you should be writing Unit tests, Integration Tests, and maybe later, Performance tests.

Unit tests, are very simple and should test one unit of code. Lets consider a system that accepts user input, validates it, and if needed displays an error. The unit tests here, would create fake input, and test the function under each condition. If the function depends on some underlying system (such as a database) that complexity should be [mocked][18]. That is, not really using a database but instead using a fake system underneath, which behaves like a real database but under your control. The end goal is that a unit test should test one thing, and do it quickly. If a single test takes more than 100ms you are doing it wrong. Some will even argue a developer must run all unit tests before checking any code in.

With mocking/stubbing and other techniques, you should be able to test many layers of your application. However, your application most likely depends on external processes, and this is where integration testing comes in. Typically, this is testing your database behaves how it should, and the code you have written interacts with it correctly. Since it depends on external applications, integration testing usually takes longer to run, and is more complex to set up. In many cases a application like [Jenkins][19] or [Bamboo][20] is used to help automate the testing.

There are other classes of testing, such as performance testing, acceptance testing, and web based testing. Performance testing measures latency, throughput, etc, and graphs this over time to ensure that no new code is negatively impacting performance. Acceptance is as simple as verifying that all your requirements are actually satisfied, and can be [automated][21]. Finally, web based testing (for lack of a better name) is using software like [Selenium][22] , that fires up a real browser and automates clicking on buttons, and interacting with your UI. I’m personally not a fan of Selenium as good unit/integration tests can catch most of those issues.

Once you have written tests there are numerous tools to help you measure your [coverage][23]. How many functions/lines of code did you actually test!. This software can help you target your most critical functions, and ensure things are being tested as expected.

Last, but not least, is QA/QC. Actual humans in the loop, following test plans, and actually validating that the application does what it’s expected to do. This is as simple as described, and should be repeatable and auditable.

In fact, one more step, User Acceptance Testing, or in other words, putting the product in front of your client before you go live. Set up a staging environment, or as some call it a UAT environment. This mirrors your production env, but allows clients to play with new features before they are rolled out. This is a good way to make the client feel part of the process, and give regularly feedback. Make it clear that the UAT env is for testing, and that all data gets wiped every couple of weeks. Let them do your QA for you <img src="http://bramp.net/blog/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley" /> 

**Bug Tracking**  
While conducting QA/UAT/etc you should certainly be logging all defects to a bug tracking database. This enables you to regularly prioritise what needs to gets fixed, it allows users to track the status of their bug, and it also means things don’t get forgotten about.

**Deployments**  
Finally, your code has been written, it must be pushed out into production. Some will tell you that you should no longer do deployments manually, and you should use automation tools such as [Chef][24]/[Puppet][25]/[Capistrano][26], and I would agree. It makes the deployments testable, repeatable, and predictable. You remove a large amount of human error from the process. However, when things do go wrong, they typically go wrong fast and wide spread. So make sure you test your deployment scripts, as you would test your code.

**SLDC**  
I mention there were different techniques for the SDLC, Agile based approaches (Scrum, Kanban, etc), Waterfall, etc. The SLDC should allow for [continuous integration][27], constantly running the pipeline and revalidating each step. Some will argue Agile is the way to go, and I would tend to agree. Agile seems to prefer short iterations with constant feedback. Feedback should be often, and rapid. If you break some code, a unit test should notify a human quickly, and not at the end of a development cycle. QA should be done in an agile manner, testing as soon as the feature is complete. This allows a human is quickly test the new feature and give feedback to the developers shortly after the code was written.

Different teams, and different projects, require different SLDCs. I personally have a team working on two week Scrum sprints, with deployments happening at the end of each. In other cases, I have projects with far less rigorous schedules.

I highly recommend the [The Phoenix Project][28], it talks about SLDC, and is a good read (even for those non-technical readers).

Finally, I’d like to quickly introduce the newer concept of [Continuous Delivery][29]. This extends continuous integration, by making your pipeline end at deployment. From code check-in to being live in a production environment, should be as automated as possible. Companies like [Etsy][30] and [Facebook][31] like to advertise that they deploy numerous times a day.

 [1]: http://www.imdb.com/title/tt0151804/
 [2]: http://theleanstartup.com/
 [3]: https://www.kennethnorton.com/essays/leading-cross-functional-teams.html
 [4]: http://highscalability.com/
 [5]: http://www.amazon.com/gp/product/0596007124/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0596007124&linkCode=as2&tag=brampnet-20&linkId=I3KLFHLMXOGO4ZDN
 [6]: http://www.amazon.com/gp/product/0201633612/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0201633612&linkCode=as2&tag=brampnet-20&linkId=ODUHCI2LZNSVYXTT
 [7]: http://www.amazon.com/gp/product/0321127420/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321127420&linkCode=as2&tag=brampnet-20&linkId=5UIJ57SD2XFINFEC
 [8]: http://aosabook.org/
 [9]: http://blog.codinghorror.com/when-understanding-means-rewriting/
 [10]: http://butunclebob.com/ArticleS.UncleBob.SrpInRuby
 [11]: http://www.amazon.com/gp/product/0137081073/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0137081073&linkCode=as2&tag=brampnet-20&linkId=4QYVI3KDZFAGECFF
 [12]: http://www.amazon.com/gp/product/0321751043/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321751043&linkCode=as2&tag=brampnet-20&linkId=32Z4Y2F36B6WWXIH
 [13]: http://www.sonarqube.org/
 [14]: https://en.wikipedia.org/wiki/Source_lines_of_code
 [15]: https://en.wikipedia.org/wiki/Don't_repeat_yourself
 [16]: https://stackoverflow.com/questions/125898/tool-for-calculating-cyclomatic-complexity
 [17]: http://www.agiledata.org/essays/tdd.html
 [18]: https://stackoverflow.com/questions/2665812/what-is-mocking
 [19]: http://jenkins-ci.org/
 [20]: https://www.atlassian.com/software/bamboo
 [21]: http://www.fitnesse.org/
 [22]: http://docs.seleniumhq.org/
 [23]: https://en.wikipedia.org/wiki/Code_coverage
 [24]: http://www.getchef.com/chef/
 [25]: http://puppetlabs.com/
 [26]: http://capistranorb.com/
 [27]: http://www.amazon.com/gp/product/0321336380/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321336380&linkCode=as2&tag=brampnet-20&linkId=IMYQST6ZM7V6733U
 [28]: http://www.amazon.com/gp/product/0988262592/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0988262592&linkCode=as2&tag=brampnet-20&linkId=36PJQM4IDQIMEWXH
 [29]: http://www.amazon.com/gp/product/0321601912/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321601912&linkCode=as2&tag=brampnet-20&linkId=VBPKIQYH5SL4PKCD
 [30]: http://www.slideshare.net/mikebrittain/principles-and-practices-in-continuous-deployment-at-etsy
 [31]: http://www.forbes.com/sites/quora/2013/08/12/how-do-facebook-and-google-manage-software-releases-without-causing-major-problems/