#Stalkqr

[![Build Status](https://secure.travis-ci.org/adunkman/stalkqr.png?branch=master)](http://travis-ci.org/adunkman/stalkqr)

An open source project by the NodeKC group.

http://nodekc.org

##Overview

This project will generate URL's that can be used by others to add your social contact information to their contact list. URL's can be generated for various events to track where your contact was made. URL's can be easily shared through the use of QR codes.

#Authentication setup

###Set up your environment variables

#### UNIX
    export KEY=value

#### Windows
    set KEY=value

#### Heroku
    heroku config:add KEY=value

##Twitter API Key

    TWITTER_CONSUMER_KEY
    TWITTER_CONSUMER_SECRET

Visit http://developer.twitter.com and create an application. Once created, you'll be given an API key and SECRET. It's important that you set the callback url correctly.

##Github API Key

    GITHUB_CLIENT_ID
    GITHUB_CLIENT_SECRET

https://github.com/account/applications Once again, it's important to set the callback url correctly for where the application is hosted.

##Base URL for callbacks

    CALLBACK_BASE_URL

You will need to set up your base callback url. This is the root url to where the site is hosted. Examples include: http://localhost:3000 or http://hazy-mist-1110.herokuapp.com

