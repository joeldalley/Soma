Soma
====

Soma is a very simple HTML5 music player.

Soma is copyright (c) 2013 Joel Dalley. Soma is distributed under the same license as Perl itself. For more details, see the full text of the license in the file LICENSE.


Overview
========

Video
    Here is a video overview of its features, and a few comments on installing the application:

    http://youtu.be/pI6cWmg2wx4


Installation
============

0. Choose a location for Soma; in my example, I use /home/joel/soma.
1. Add a PERL5LIB path to your shell environment: for example, in my .bashrc file, I have this:
       export PERL5LIB="/home/joel/soma/lib"
2. Set the value of Soma::Const::SOMA\_DIR in lib/Soma/Const.pm to match the Soma location from step (0).
3. Choose a cover art image directory: in my example, I use /usr/local/media/music/.art. Update the value of Soma::Const::Album::COVER\_DIR in lib/Soma/Const.pm to this directory, and copy res/default.jpg into this directory.
4. Test your environment by executing test/compile\_check.pl, which will fail and inform you why if, for instance, you're missing a required Perl package. Using a package manager or a cpan program, add all of the required packages and their dependencies. I prefer cpanm for this.
5. Execute db/replace.sh, to create an empty SQLite database in the file, soma.db.
6. Execute util/populate\_db.pl, giving it file path argument to where your music files are. Currently only mp3 and m4a files are recognized by Soma.
   - Note: here you may want to alter the callback function that operates on each music file to also place a copy of each album's cover image into your COVER\_DIR directory. Each album will show "default.jpg" for its cover image unless it has a cover image file in COVER\_DIR.
7. Execute bin/dancer.pl to start your dancer app (on port 3000 by default), and then point your browser to http://your-server:3000 to see the home page. Note that this a single-threaded process, and so I don't recommend running your app this way for general use; however, to just see that the application is working and has been populated with music, this will suffice.

Afterward
    - You can add and update album cover images (using URLs) by running util/album\_cover.pl at any time.
    - Consider using the Perl Starman web server instead of running dancer.pl as a stand-alone application. See bin/restart.sh for my example.
    - More options for and examples of Dancer deployment: http://search.cpan.org/dist/Dancer/lib/Dancer/Deployment.pod


Notes
=====

I wrote this app to scratch a personal itch. Accordingly, I kept things very simple. A few things would need to generalized or expanded upon for this player to truly be a "drop-in" app for a wide range of environments. Here are a few examples:

 - I chose SQLite to store data, but moving to MySQL, which could support multiple concurrent users, would be almost trivial.
 - The system only recognizes mp3 and m4a files currently, but expanding coverage to include ogg files, for example, could easily be done.
 - In sending the HTTP headers for audio, I assume mpeg, because my files are all mp3s. An upgrade to choose a header based on the file extension, for instance, would be easy to implement. 
 - Likewise for the album cover image HTTP headers, where I assume jpeg, because all my images are jpg files. This could also be generalized easily.
 - I've only tested and used the app in the Chrome browser, so there could issues with the audio playback javascript in Firefox or Safari. Internet Explorer is anybody's guess.
