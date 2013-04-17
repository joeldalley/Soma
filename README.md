Soma
====

Soma is a very simple HTML5 music player.

Soma is copyright &copy; 2013 Joel Dalley.<br/>
Soma is distributed under the same license as Perl itself.<br/>
For more details, see the full text of the license in the file LICENSE.


Overview
========

Here is a video overview of its features, and a few comments on installing the application:

http://www.youtube.com/watch?v=pI6cWmg2wx4


Requirements
============

Soma assumes that, whatever operating system you use, you have access to a UNIX-like shell, with directories separated by "/" and commands like "ls".

**Database**<br/>
SQLite

**Perl**<br/>
[Dancer](http://www.perldancer.org/)<br/>
[DBI](http://search.cpan.org/dist/DBI/DBI.pm)<br/>
[LWP::Simple](http://search.cpan.org/~gaas/libwww-perl-6.05/lib/LWP/Simple.pm)<br/>
[Digest::MD5](http://search.cpan.org/~gaas/Digest-MD5-2.52/MD5.pm)<br/>

**Recommended Perl**<br/>
[Starman Web Server](http://search.cpan.org/~miyagawa/Starman-0.1000/lib/Starman.pm)

**Misc**<br/>
In order to use the import files utiltiy, you will need `avconv`.

Strictly speaking, Perl Dancer isn't required. You could use Soma as an Apache CGI script, for example, but I don't recommend doing that.


Installation
============

Assuming your Soma directory is `/home/user/soma`, update the values of the following in `~/soma/lib/Soma/Const.pm`:

```perl
package Soma::Const;
sub SOMA_DIR { '/home/user/soma' }

...

package Soma::Const::Album;
sub COVER_DIR { '/home/user/soma/covers' }
```

And then execute these shell commands:

```
echo 'export PERL5LIB="/home/user/soma/lib" >> ~/.bashrc
mkdir ~/soma/covers && cp ~/soma/res/default.jpg ~/soma/covers
cd ~/soma/test && perl compile_check.pl
cd ~/soma/db && sh ./replace.sh
cd ~/soma/util && perl populate_db.pl /path/to/your/music/files
cd ~/soma/bin && perl dancer.pl
```

The first is so Soma libraries will be found. The second installs the default album cover image into your album covers directory. The third makes sure you've got all the required software installed. The forth creates an empty SQLite database for Soma. The fifth imports your music files into the Soma database. And the sixth starts Soma as a Dancer app on port 3000.

[I deploy my app using the Perl Starman web server](https://github.com/joeldalley/Soma/blob/master/bin/restart.sh).<br/>
[More Perl Dancer deployment options](http://search.cpan.org/dist/Dancer/lib/Dancer/Deployment.pod).

Notes
=====

I wrote this app to scratch a personal itch. Accordingly, I kept things very simple. A few things would need to generalized or expanded upon for this player to truly be a "drop-in" app for a wide range of environments. Here are a few examples:

 - I chose SQLite to store data, but moving to MySQL, which could support multiple concurrent users, would be almost trivial.
 - The system only recognizes mp3 and m4a files currently, but expanding coverage to include ogg files, for example, could easily be done.
 - In sending the HTTP headers for audio, I assume mpeg, because my files are all mp3s. An upgrade to choose a header based on the file extension, for instance, would be easy to implement. 
 - Likewise for the album cover image HTTP headers, where I assume jpeg, because all my images are jpg files. This could also be generalized easily.
 - I've only tested and used the app in the Chrome browser, so there could issues with the audio playback javascript in Firefox or Safari. Internet Explorer is anybody's guess.
