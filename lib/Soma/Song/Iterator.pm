
#/ Subs that produce iterators of Soma::Song::Objects.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Song::Iterator;

use Soma::Db;
use Soma::Const;
use Soma::Song::Object;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @return coderef    iterator of Soma::Song::Objects
sub all() { _iter() }

#/ @param string    an album id
#/ @return coderef    iterator of Soma::Song::Objects
sub forAlbumId($) { 
    _iter(['album_id=?'], [shift], {order => 'track'}) 
}

#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @param hashref [optional] $opts    select options
#/ @return coderef    iterator of Soma::Song::Objects
sub _iter(;$$$) {
    my ($clauses, $values, $opts) = @_;

    my $table = Soma::Const::Song::TABLE;
    my $cols = [Soma::Const::Song::COLS];
    my $iter = Db::iterator($table, $cols, $clauses, $values, $opts);

    sub {
        my $data = $iter->();
        $data ? Soma::Song::Object->new($data) : undef;
    };
}

1;
