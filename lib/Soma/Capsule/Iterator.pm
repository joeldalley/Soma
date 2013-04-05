
#/ Subs that produce iterators of Soma::Song::Capsules.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/30

use stern;
package Soma::Capsule::Iterator;

use Soma::Db;
use Soma::Const;
use Soma::Capsule::Load;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string $query    a search query
#/ @return coderef    iterator of Soma::Song::Capsules
sub search($) { 
    my $query = shift;
    my $clauses = 'title LIKE ? OR '
                . 'album.name LIKE ? OR '
                . 'artist.name LIKE ?';
    my @values = map "%$query%", (1..3);
    my $opts = {order => 'artist.name,album.name,track'};
    _iter([$clauses], \@values, $opts);
}


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @param hashref [optional] $opts    select options
#/ @return coderef    iterator of Soma::Capsule::Objects
sub _iter(;$$$) {
    my ($clauses, $values, $opts) = @_;

    my $table = _table();
    my $cols = ['song.id'];
    my $iter = Db::iterator($table, $cols, $clauses, $values, $opts);

    sub {
        my $data = $iter->();
        $data ? Soma::Capsule::Load::forSongId($data->[0]) : undef;
    };
}

#/ @return string    joined table
sub _table() {
    return Soma::Const::Song::TABLE 
         . ' JOIN ' . Soma::Const::Album::TABLE 
         . ' ON song.album_id=album.id '
         . ' JOIN ' . Soma::Const::Artist::TABLE 
         . ' ON album.artist_id=artist.id';
}

1;
