
#/ Dancer route params.
#/ @author Joel Dalley
#/ @version 2013/Mar/30

package Soma::Dancer::Params; 

use Dancer ':syntax';

use Exporter 'import';
our @EXPORT = qw(MODE ID SONG_ID ALBUM_ID QUERY COUNT);

sub ALBUM_ID { params->{'albumid'} }
sub SONG_ID  { params->{'songid'} }
sub COUNT    { params->{'count'} }
sub QUERY    { params->{'query'} }
sub MODE     { params->{'mode'} }
sub ID       { params->{'id'} }

1;
