
#/ @package Soma::Song
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/22

use stern;
package Soma::Song;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param int $track   song track number
#/ @param int $albumId    song's album id
#/ @return string    the song id
sub toId($$) {
    my ($track, $albumId) = @_;
    $track && $albumId or do {
        require Carp;
        Carp::confess("Missing track") if !$track;
        Carp::confess("Missing album id");
    };
    $albumId . sprintf '%04d', $track;
}

#/ @param string $file    a file name
#/ @return int    1 if valid, or 0
sub validFile($) {
    my $file = shift;
    isMp3($file) || isM4a($file);
}

#/ @param string $file    a file name
#/ @return int    1 if mp3, or 0
sub isMp3($) {
    my $file = shift;
    $file && $file =~ /\.mp3$/o && 1 || 0;
}

#/ @param string $file    a file name
#/ @return int    1 if m4a, or 0
sub isM4a($) {
    my $file = shift;
    $file && $file =~ /\.m4a$/o && 1 || 0;
}

1;
