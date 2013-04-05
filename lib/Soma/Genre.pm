
#/ @package Soma::Genre
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/26

use stern;
package Soma::Genre;

use Encode;
use Digest::MD5 'md5_hex';


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string    genre name
#/ @return string    a genre id
sub toId($) { 
    my $name = shift || '';
    substr md5_hex(encode_utf8($name)), 0, 12; 
}

1;
