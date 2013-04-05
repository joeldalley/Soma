Soma
====

Soma is a very simple HTML5 music player.

Here is a video overview of its features, and a few notes on installing the application:

http://youtu.be/pI6cWmg2wx4


Notes
=====

I wrote this app to scratch a personal itch. Accordingly, I kept things very simple. A few things would need to generalized or expanded upon for this player to truly be a "drop-in" app for a wide range of environments. Here are a few examples:

 - I chose SQLite to store data, but moving to MySQL, which could support multiple concurrent users, would be almost trivial.
 - The system only recognizes mp3 and m4a files currently, but expanding coverage to include ogg files, for example, could easily be done.
 - In sending the HTTP headers for audio, I assume mpeg, because my files are all mp3s. An upgrade to choose a header based on the file extension, for instance, would be easy to implement. 
 - Likewise for the album cover image HTTP headers, where I assume jpeg, because all my images are jpg files. This could also be generalized easily.
 - I've only tested and used the app in the Chrome browser, so there could issues with the audio playback javascript in Firefox or Safari. Internet Explorer is anybody's guess.
