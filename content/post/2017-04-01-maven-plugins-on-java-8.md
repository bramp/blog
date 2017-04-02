---
author: bramp
categories:
- Blog
date: 2017-04-01T15:21:27-07:00
layout: post
tags:
- maven
- java
- google
title: Maven Plugins on Java 8
---

As part of my standard Maven configuration, I like to use two plugins backed by Google technologies, the first to help keep my code formatted correctly, and the second to check for compile time errors. However, Google recently moved to require JDK 1.8, which broke anyone trying to compile my projects with an older JDK. In this article I'll quickly explain how to configure Maven to work around this problem. 

Specifically I use the following two plugins:

* [coveo/fmt-maven-plugin](https://github.com/coveo/fmt-maven-plugin) (which uses [google-java-format](https://github.com/google/google-java-format)). This follows the [Google's Java Style](https://google.github.io/styleguide/javaguide.html) guide, and reformats the code to ensure it stays consistent. This is great when accepting external contributions, as it keeps the code base uniform, and avoids style discussion on pull requests.

* [plexus-compiler-javac-errorprone](https://github.com/codehaus-plexus/plexus-compiler) (which uses Google's [errorprone](https://github.com/google/error-prone)). This is a static code analysis tool, that checks for simple errors at compile time, and fails the build if they are found. Again, this helps improve the quality of the code.

Even though my projects typically target 1.7, these plugins require to run under 1.8. Really I'd prefer I could bump all my projects to target 1.8+, but since a few of my projects are libraries (which other people include into their projects), that is easier said than done. To deal with this, I changed my Maven configuration to only run these two plugins when run under the sufficient JDK. This means those using a older JDK don't get the benefits, but since locally I use JDK 8, and all my open source projects use [Travis CI](https://travis-ci.org), eventually these issues will be identified.

So if you get an error like
```
java.lang.UnsupportedClassVersionError: com/google/googlejavaformat/java/FormatterException : Unsupported major.minor version 52.0
```

or

```
An API incompatibility was encountered while executing org.apache.maven.plugins:maven-compiler-plugin:3.5.1:compile: java.lang.UnsupportedClassVersionError: javax/tools/DiagnosticListener : Unsupported major.minor version 52.0
```

Please update to JDK 1.8, or update your Maven configuration to restrict these plugins to when run on a modern JDK:

```xml
<project>
...
    <profiles>
        <profile>
            <id>java18</id>
            <activation>
                <jdk>1.8</jdk>
            </activation>
            <build>
                <plugins>
                    <plugin>
                        <groupId>com.coveo</groupId>
                        <artifactId>fmt-maven-plugin</artifactId>
                        <executions>
                            <execution>
                                <goals>
                                    <goal>format</goal>
                                </goals>
                            </execution>
                        </executions>
                    </plugin>
                    <plugin>
                        <groupId>org.apache.maven.plugins</groupId>
                        <artifactId>maven-compiler-plugin</artifactId>
                        <configuration>
                            <compilerId>javac-with-errorprone</compilerId>
                            <forceJavacCompilerUse>true</forceJavacCompilerUse>
                            <showWarnings>true</showWarnings>
                            <compilerArgs>
                                <arg>-Xlint:all</arg>
                            </compilerArgs>
                        </configuration>
                        <dependencies>
                            <dependency>
                                <groupId>org.codehaus.plexus</groupId>
                                <artifactId>plexus-compiler-javac-errorprone</artifactId>
                                <version>2.8.1</version>
                            </dependency>
                            <!-- override plexus-compiler-javac-errorprone's dependency on
                                 Error Prone with the latest version -->
                            <dependency>
                                <groupId>com.google.errorprone</groupId>
                                <artifactId>error_prone_core</artifactId>
                                <version>2.0.19</version>
                            </dependency>
                        </dependencies>
                    </plugin>
                </plugins>
            </build>
        </profile>
    </profiles>
...
</project>
```

This defines a new profile, that is only "activated" under Java 1.8. When activated the `<build>` section has the two additional plugins added. 
Ensure that these plugins are no longer mentioned in the regular `<build>` section, and only in the `<profile><build>` section.

An example of this change can be found in [recent commit](https://github.com/bramp/ffmpeg-cli-wrapper/commit/4985ba3ab3ef84839bc0f4ca8b63573b77e33c67).