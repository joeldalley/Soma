
#/ Subs that produce iterators of Soma::Album::Objects.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Album::Iterator;

use Soma::Db;
use Soma::Const;
use Soma::Album::Object;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @return coderef    iterator of Soma::Album::Objects
sub all() { _iter() }

#/ @param int $howMany   how many to select
sub random($) {
    my $howMany = shift;
    _iter([], [], {order => 'RANDOM()', limit => $howMany});
}

#/ @param string $query   a search query
#/ @return coderef    iterator of Soma::Album::Objects
sub search($) {
    my $query = shift;
    _iter(['name LIKE ?'], ["%$query%"], {order => 'name'});
}

#/ @param string    an artist id
#/ @return coderef    iterator of Soma::Album::Objects
sub forArtistId($) { 
    _iter(['artist_id=?'], [shift], {order => 'name'}) 
}

#/ @param int    a genre id
#/ @return coderef    iterator of Soma::Album::Objects
sub forGenreId($) { _iter(['genre_id=?'], [shift]) }


#///////////////////////////////////////////////////////////////
#/ Internal use ////////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @param hashref [optional] $opts    select options
#/ @return coderef    iterator of Soma::Album::Objects
sub _iter(;$$$) {
    my ($clauses, $values, $opts) = @_;

    my $table = Soma::Const::Album::TABLE;
    my $cols = [Soma::Const::Album::COLS];
    my $iter = Db::iterator($table, $cols, $clauses, $values, $opts);

    sub {
        my $data = $iter->();
        $data ? Soma::Album::Object->new($data) : undef;
    };
}

1;
