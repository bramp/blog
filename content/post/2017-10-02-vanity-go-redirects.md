---
title: "Vanity Go Import Paths"
author: bramp
date: 2017-10-02T07:48:23-07:00
layout: post
categories:
  - Blog
tags:
  - Go
  - Goredirects
  - GitHub
---

When using third-party packages in Go, they are imported by a path that represents
how to download that package from the Internet. For example, to use the
popular structured logging library, [Logrus](https://github.com/sirupsen/logrus), it would imported at the top of the Go program like so:

```go
import (
  "github.com/sirupsen/logrus"
)
```

When `go get` is then executed, it fetches the Logrus source code from GitHub
and places the code in the `$GOPATH/src` directory. Take a look for yourself:

```bash
$ tree $GOPATH/src
...
├── github.com
│   ├── Sirupsen
│   │   └── logrus
...
```

An astute reader may wonder, how exactly does `go get` know that `github.com/sirupsen/logrus` is a Git repository, and that it can be fetched via the git protocol from that URL. The `go get` binary could have some smarts in it, that knows about GitHub, and does the right thing. But that seems inflexible, and problematic if new sites want to be supported. Instead the Go developers built a layer of indirection that allows the `go get` tool to discover the correct source repo.

As outlined in the [Remote Import Paths](https://golang.org/cmd/go/#hdr-Remote_import_paths) docs,  the `go get` binary will make a normal HTTP request to `https://github.com/sirupsen/logrus` (falling back to http if needed) and look at the returned HTML for a `<meta name="go-import"` tag. This meta tag, can then redirect the `go get` binary to the correct source code repository for the package.

This meta tag can been seen with `curl`:

```bash
$ curl https://github.com/sirupsen/logrus | grep meta | grep go-import
```
```html
<meta name="go-import"
  content="github.com/sirupsen/logrus git https://github.com/sirupsen/logrus.git">
```

That tag says, the package rooted at `github.com/sirupsen/logrus` can be fetched with git, at the
URL `https://github.com/sirupsen/logrus.git`. The meta tag can express other source control systems, e.g Mercurial, Bazaar, Subversion.

GitHub is a very convenient place to host source code, but the GitHub URL is generic. Instead it is possible to use the `<meta>` tag to create vanity domains to host projects. For example, the package hosted at [github.com/bramp/goredirects](https://github.com/bramp/goredirects) could instead be imported as `bramp.net/goredirects`. All that is needed is a static HTML page at `bramp.net/goredirects`, containing the following `<meta>` tag pointing at GitHub.

```html
<meta name=go-import
  content="bramp.net/goredirects git https://github.com/bramp/goredirects.git">
```

Incase a user attempted to visit that page directly with their web browser, it is worthwhile
placing more information about the project on the page, or simply making the page redirect.

To help make these redirect pages, I wrote a simple go tool, `[goredirects](https://github.com/bramp/goredirects)`, that inspects all local repositories under a vanity domain directory in the local `$GOPATH/src/` and outputs static HTML pages that can be hosted on that domain.

For example, create your new project on GitHub, but check out the project under `$GOPATH/src/example.com/project`. Then run the tool:

```bash
$ go install bramp.net/goredirects
$ goredirects example.com outputdir
```

The directory `outputdir` will now contain multiple directories and html files, one for each project under `$GOPATH/src/example.com`. These HTML files contain the appropriate goimports meta tag to redirect the download of source code from the vanity name, to GitHub. Just upload these files to your website, voilà you are done. Examples of these vanity redirect files can be found on bramp.net, e.g [bramp.net/goredirects/index.html](https://bramp.net/goredirects/index.html). This tool even works for packages with sub-packages under the main root.

Finally, it is possible to ensure that if someone finds your project via GitHub, that `go get` will always place it under your vanity domain. This be can be achieved with an [import comment](https://golang.org/cmd/go/#hdr-Import_path_checking). Within the source code, ensure that at least one of the files in your page has a comment like so:

```go
package project // import "example.com/project"
```

Then `go get` will enforce the correct/vanity URL to use, instead of the true location.

More helpful links on the topic:

* [golang.org/cmd/go/#hdr-Import_path_checking](https://golang.org/cmd/go/#hdr-Import_path_checking)
* [golang.org/cmd/go/#hdr-Remote_import_paths](https://golang.org/cmd/go/#hdr-Remote_import_paths)
* [golang.org/doc/go1.4#canonicalimports](https://golang.org/doc/go1.4#canonicalimports)
* [godoc.org/golang.org/x/tools/cmd/fiximports](https://godoc.org/golang.org/x/tools/cmd/fiximports)
* [texlution.com/post/golang-canonical-import-paths/](https://texlution.com/post/golang-canonical-import-paths/)
