use stern;
use context;

#/ Populates soma.db with any detected music files contained
#/ within the given directory. 
#/
#/ In populating your database, you might want to also populate 
#/ your album covers image file directory--assuming you have 
#/ the files.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use File::Copy;
use Soma::Capsule::Load;
use Soma::DirWalk 'song_walk';
use Digest::MD5 'md5_hex';

#/ user input
my $musicDir = shift || die "Usage: perl populate_db.pl <directory>";
-d $musicDir or die "No such directory `$musicDir`";

#/ walk the given directory and enter every file Soma
#/ recognizes as a music file into the database. 
song_walk($musicDir, sub {
    my $file = shift;
 
    #/ if a given song file already has data in the database,
    #/ then it won't be re-created; however, its meta data
    #/ will still be printed below.
    my $capsule;
    eval { $capsule = Soma::Capsule::Load::forFile($file) };

    #/ warn of any errors; music files where an error 
    #/ occurs are not added to the database.
    if ($@) {
        warn $@;
        return;
    }

    #/ print details of what was added.
    
    my $artist = $capsule->artist();
    my $album = $capsule->album();
    my $song = $capsule->song();

    my $details = join "\t",
                      $song->field('title'),
                      $song->field('track'),
                      $song->field('duration');

    print "Created:\n",
          "\t$details\n",
          "\t  by ", $artist->field('name'), "\n",
          "\t  on ", $album->field('name'), "\n",
          "\n";
});
