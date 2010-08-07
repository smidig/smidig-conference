# Smidig 2010 Conference site

## Recommended tools

### OSX

* Ruby 1.8.7
* RubyMine, like IDEA for all you lame java developers ;) or TextMate
* git

### Windows

* "RubyInstaller": http://rubuinstaller.org	
* "Msysgit":http://code.google.com/p/msysgit/downloads (Git command line)
* "TortoiseGit":http://code.google.com/p/tortoisegit/downloads (Git Explorer integration)
* "Notepad++":http://notepad-plus-plus.org/download (Text editor)
* "Putty":http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html (SSH Client for Windows)

#### Setting up SSH certificates

    Download and install Putty from http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
    Use PuTTYgen to generate a new keypair (you can usually leave the keyphrase empty)
    Save the private key to you home directory
    Copy the text of the public key into HOME/.ssh/id_rsa.pub
    Register your public key with Github at https://github.com/account#ssh_bucket (copy from the text field in PuTTYgen)
    Start Pageant
    Right-click on the Pageant icon in the System Tray and Add Key

You need to start Pageant before using git to push to Github or Heroku. You may want to add this as a Startup file.


## Getting started

    Check out the code from git://github.com/smidig/smidig-conference.git
    Install Ruby
    $ gem update --system
    $ gem install bundler rake
    $ bundle install
    ON WINDOWS: Also grab sqlite DLL from http://www.sqlite.org/download.html and stuff it in your path
    $ rake db:migrate
    $ rake test
    # Start the server
    $ ruby script/server
    Go to http://localhost:3000

## Checking in

You need to be a collaborator (at github.com) of the conference site, otherwise commit to your own fork, and make a pull request.

## Deploying to Heroku

Login as dev@smidig.no and add your user as a collaborator (at heroku.com)

Setup:

    # Install the heroku gem
    $ gem install heroku
    # Install your SSH keys (Uses ~/.ssh/id_rsa.pub)
    $ heroku keys:add
    $ cd smidig-conference
    $ git remote add production git@heroku.com:smidig2010.git
	$ git remote add staging git@heroku.com:stagingsmidig.git

Update (push):

    $ git push [production|staging|master]

## GIT (github)

Create a github user and add your public SSH-key (usually ~/.ssh/id_rsa.pub) to the github user.

To commit directly to the repository, ask at dev@smidig.no for collaborator status.

Otherwise; fork the project (http://github.com:smidig/smidig-conference - click the "fork project" button).

For working on your fork (replace <username> with 'smidig' if you are allowed to work on the main project).

    $ git clone git@github.com:<username>/smidig-conference.git
    $ cd smidig-conference
    $ mate README (or another editor, make a change)
    $ git status (shows what is changed, i.e. README should now be marked red (if you have colors))
    $ git add README (adds README file which should be changed now)
    git status (Will now show README as green - meaning it will be committed)
    git commit -am "My first commit, added some text to README" (Commit to your local repository)
    git push (Push local changes to the central (origin) repository to github.com/<username>/smidig-conference)


(To verify the format for this file, use http://attacklab.net/showdown/)
