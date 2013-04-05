
#/ @package Soma::Album
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/22

use stern;
package Soma::Album;

use Digest::MD5 'md5_hex';
use Encode;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string    album name
#/ @param int    album's artist id
#/ @return string    an album id
sub toId($$) { 
    my ($name, $artistId) = @_;
    $name and $artistId or do {
        require Carp;
        Carp::confess("Missing album name") if !$name;
        Carp::confess("Missing artist id");
    };
    substr md5_hex(encode_utf8($name . $artistId)), 0, 12;
}

1;
