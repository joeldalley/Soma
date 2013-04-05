
#/ Project file utilities.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

use stern;
package Soma::File;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @param string $file    file path
#/ @param int [optional] $size    buffer size; default 1024
#/ @return string    file content
sub read($;$) {
    my ($file, $size) = (shift, shift || 1024);

    my ($data, $buff);
    open F, '<', $file or die $!;
    while (read F, $buff, $size) { $data .= $buff }
    close F;
    $data;
}

1;
