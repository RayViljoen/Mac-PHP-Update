#PHP v5.4* update for Mac OS X Lion.

####**Shell script to update Mac OS X's bundled PHP to latest 5.4***

---

####Dependencies:

- **[Xcode v4.4+](https://developer.apple.com/xcode/)**

- **[xQuartz](http://xquartz.macosforge.org/landing/)**

- **[Homebrew](http://mxcl.github.com/homebrew/)**

Visit [Homebrew](http://mxcl.github.com/homebrew/) for more information or alternitively install Homebrew by running the following command in Terminal:<br/>
`/usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"`

####Usage:

Simply run the script with sudo from Terminal: `sudo ./osx_php_update.sh`

Optionally run with `--test` flag to also perform `make test` prior to install: `sudo ./osx_php_update.sh --test`<br/>
**NB: Please note this will take SIGNIFICANTLY longer. ( Possibly hours )**