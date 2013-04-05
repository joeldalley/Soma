
#/ @package Soma::Artist
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/22

use stern;
package Soma::Artist;

use Encode;
use Digest::MD5 'md5_hex';


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string    artist name
#/ @return string    an artist id
sub toId($) { 
    my $name = shift;
    $name or do {
        require Carp;
        Carp::confess("Missing artist name");
    };
    substr md5_hex(encode_utf8($name)), 0, 12;
}

1;
