#Stalkqr

An open source project by the NodeKC group. 

http://nodekc.org

##Overview

This project will generate URL's that can be used by others to add your social contact information to their contact list. URL's can be generated for various events to track where your contact was made. URL's can be easily shared through the use of QR codes.

#Authentication setup

##Twitter API Key 

visit http://developer.twitter.com and create an application. Once created, you'll be given an API key and SECRET. It's important that you set the callback url correctly.

###Set up your environment variables

export TWITTER_CONSUMER_KEY=<consumerkey>
export TWITTER_CONSUMER_SECRET=<secret>

##Github API Key

https://github.com/account/applications Once again, it's important to set the callback url correctly for where the application is hosted.

##Set up your environment variables

export GITHUB_CLIENT_ID=<clientid>
export GITHUB_CLIENT_SECRET=<secret>
