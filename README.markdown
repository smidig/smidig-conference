# Smidig 2010 Conference site

## Setting up your environment

### OSX / Linux

* Ruby 1.8.7
* RubyMine, like IDEA for all you lame java developers ;) or TextMate
* git

### Windows

Install the following tools or the equivalent.

* [RubyInstaller 1.8.7](http://rubyinstaller.org)
* [Msysgit](http://code.google.com/p/msysgit/downloads) (Git command line)
* [TortoiseGit](http://code.google.com/p/tortoisegit/downloads) (Git Explorer integration)
* [Notepad++](http://notepad-plus-plus.org/download) (Text editor)
* [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) (SSH Client for Windows)

#### Configure line endings

Because Windows has its own line endings (CRLF \r\n) as opposed to Unix / Linux (LF), it is advised
to align these line endings on commits, so that all line endings in GitHub are LF only.

Windows users can do so either with:
<code>git config --global core.autocrlf true</code> if they prefer Windows file endings locally. Or
with <code>git config --global core.autocrlf input</code> if they prefer to keep whatever they 
checkout (both will save to repo with LF-endings).


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

    You need to be added as a collaborator on the project. Talk to Ole-Morten.
    Check out the code: git clone git@github.com:smidig/smidig-conference.git
    $ gem update --system
    $ gem install bundler
    $ gem install rails --version 2.3.8
    # In application directory
    $ bundle install
    ON WINDOWS: Also grab sqlite DLL from http://www.sqlite.org/download.html and stuff it in your path
    ON UBUNTU: sudo aptitude install libsqlite3-dev
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

Fool around:

    $ gem install taps
    # remote console
    $ heroku console --app stagingsmidig
    $ heroku console --app smidig2010
    # Pull data from the heroku app to your local db
    $ heroku db:pull --app [stagingsmidig|smidig2010]

Update (push):

    $ git push [production|staging|master]
    #DB changes? remember to migrate the server
    $ heroku rake db:migrate --app [stagingsmidig|smidig2010]

Heroku app-owner privileges:

    For å switche mellom dine heroku-identiteter (som 'oma', eller 'tech@tindetech.no') kan du følge dennne
    http://www.aeonscope.net/2010/02/22/managing-multiple-heroku-accounts/
    for å kunne bruke det på kommandolinjen.
    Det meste (unntatt app create) kan styres ved å logge inn som app-owner på heroku.com

Heroku SendGrid:
    # For å sjekke user/pass:
    $ heroku config --long --app smidig2010

Bundle without development or test gems. Set this once pr app
    $ heroku config:add BUNDLE_WITHOUT="development test"


## GIT (github)

Create a github user and add your public SSH-key (usually ~/.ssh/id_rsa.pub) to the github user.

To commit directly to the repository, ask at dev@smidig.no for collaborator status.

    $ git clone git@github.com:<username>/smidig-conference.git
    $ cd smidig-conference
    $ mate README (or another editor, make a change)
    $ git status (shows what is changed, i.e. README should now be marked red (if you have colors))
    $ git add README (adds README file which should be changed now)
    git status (Will now show README as green - meaning it will be committed)
    git commit -am "My first commit, added some text to README" (Commit to your local repository)
    git push (Push local changes to the central (origin) repository to github.com/<username>/smidig-conference)


(To verify the format for this file, use http://attacklab.net/showdown/)
