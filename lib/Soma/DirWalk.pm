#/ Wrapper for File::DirWalk.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/22

use stern;
package Soma::DirWalk;

use Exporter 'import';
our @EXPORT_OK = qw(song_walk);

use Soma::Song;
use File::DirWalk;

#/ @param string $path    path to music files
#/ @param coderef $callback    called on each music file
sub song_walk($&) {
    my ($path, $callback) = @_;

    #/ callback is wrapped so it always skips non-music
    #/ files, and always returns File::DirWalk::SUCCESS 
    my $wrapper = sub {
        my $file = shift;
        $callback->($file) if Soma::Song::validFile($file);
        File::DirWalk::SUCCESS;
    };

    my $walker = File::DirWalk->new();
    $walker->onFile($wrapper);
    $walker->walk($path);
}

1;
