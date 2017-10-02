// makegoredirects searchs my $GOROOT/src/bramp.net and sets up
// go-import redirects to github. This allows me to have a vanity
// path for my packages.
//
// by Andrew Brampton (bramp.net)
//
// TODO:
// * Turn into a robust command line tool.
//
package main

import (
	"fmt"
	"go/build"
	git "gopkg.in/src-d/go-git.v4"
	"html/template"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

const VANITY = "bramp.net"
const OUTPUT = "public"
const TEMPLATE = `<html>
<head>
<meta name="go-import" content="{{.Name}} git {{.RepoURL}}">
<meta http-equiv="refresh" content="0; url={{.SiteURL}}" />
<link rel="canonical" href="{{.SiteURL}}" />
<script>
	window.location.replace("{{.SiteURL}}");
</script>
</head>
<body>
	<h1>Redirecting to <a href="{{.SiteURL}}">{{.SiteURL}}</a></h1>
</body>
</html>
`

type Data struct {
	Name    string // Root name "bramp.net/dsector"
	RepoURL string // https://github.com/bramp/dsector.git
	SiteURL string // https://github.com/bramp/dsector
}

var tmpl = template.Must(template.New("index").Parse(TEMPLATE))

var githubSSHrx = regexp.MustCompile("git@github.com:([^/]*)/(.*).git")
var githubHTTPSrx = regexp.MustCompile("https://github.com/([^/]*)/(.*).git")

// githubSSHtoHTTPS takes a URL to a SSH repo, and returns the equlivant HTTPS url.
func githubSSHtoHTTPS(url string) string {
	// https://github.com/bramp/dsector.git
	// git@github.com:bramp/dsector.git
	matches := githubSSHrx.FindStringSubmatch(url)
	if len(matches) == 3 {
		return fmt.Sprintf("https://github.com/%s/%s.git", matches[1], matches[2])
	}

	// Perhaps it is already a HTTPS URL?
	if githubHTTPSrx.MatchString(url) {
		return url
	}

	panic(fmt.Sprint("not a github repo URL %q", url))
	return ""
}

// githubHTTPStoWeb takes a URL to a HTTPS repo, and returns the site.
func githubHTTPStoWeb(url string) string {
	if !githubHTTPSrx.MatchString(url) {
		panic(fmt.Sprint("not a github HTTP URL %q", url))
	}
	return url[:len(url)-4] // drop the .git from the end
}

func isDir(path string) bool {
	fi, err := os.Stat(path)
	if err != nil {
		log.Printf("Failed to stat %q: %s", path, err)
		return false
	}
	return fi.Mode().IsDir()
}

func handleRepo(srcdir, repopath string) error {
	name, err := filepath.Rel(srcdir, repopath)
	if err != nil {
		return fmt.Errorf("Failed to lookup repo name %q: %s", repopath, err)
	}

	repo, err := git.PlainOpen(repopath)
	if err != nil {
		return fmt.Errorf("Failed to open %q: %s", repopath, err)
	}

	remote, err := repo.Remote("origin")
	if err != nil {
		// TODO Use repo.Remotes() to find one if origin doesn't exist
		return fmt.Errorf("Failed to get %q remote %q: %s", "origin", repopath, err)
	}

	urls := remote.Config().URLs
	if len(urls) != 1 {
		return fmt.Errorf("Expected only one URL %q: %q", repopath, urls)
	}

	url := githubSSHtoHTTPS(urls[0])

	data := Data{
		Name:    name,
		RepoURL: url,
		SiteURL: githubHTTPStoWeb(url),
	}

	writeIndex(name, data)

	// Find all sub-packages, and create a similar file
	subpackages := make(map[string]bool)
	subpackages[name] = true

	if err := filepath.Walk(repopath, func(path string, info os.FileInfo, err error) error {
		if strings.HasSuffix(path, ".go") {
			dir, err := filepath.Rel(srcdir, filepath.Dir(path))
			if err != nil {
				return err
			}
			if _, found := subpackages[dir]; !found {
				writeIndex(dir, data)
			}
			subpackages[dir] = true
		}

		return nil
	}); err != nil {
		return fmt.Errorf("Failed to walk for subpackages %q: %s", repopath, err)
	}

	return nil
}

func writeIndex(name string, data Data) error {
	// Drop the domain from the beginning. This is a bit of a hack.
	name = strings.TrimPrefix(name, VANITY)

	path := filepath.Join(OUTPUT, name)

	log.Printf("Writing %q\n", path)

	if err := os.MkdirAll(path, 0755); err != nil {
		return fmt.Errorf("Failed to mkdir %q: %s", path, err)
	}

	f, err := os.Create(filepath.Join(path, "index.html"))
	if err != nil {
		return fmt.Errorf("Failed to create %s/index.html: %s", path, err)
	}
	return tmpl.Execute(f, data)
}

func main() {
	srcdir := filepath.Join(build.Default.GOPATH, "src")
	root := filepath.Join(srcdir, VANITY)
	repos, err := filepath.Glob(filepath.Join(root, "*"))
	if err != nil {
		log.Fatalf("Failed to read repos: %s", err)
	}

	for _, repopath := range repos {
		// Skip files, and hidden directories.
		if !isDir(repopath) || strings.HasPrefix(filepath.Base(repopath), ".") {
			continue
		}

		if err := handleRepo(srcdir, repopath); err != nil {
			log.Printf("%s", err)
		}
	}
}
