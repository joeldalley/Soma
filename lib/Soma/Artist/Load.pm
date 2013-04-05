
#/ Subs which produce a single Soma::Artist::Object.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Artist::Load;

use Soma::Db;
use Soma::Const;
use Soma::Artist::Object;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @return object    a Soma::Artist::Object
sub empty() { Soma::Artist::Object->new() }

#/ @param int    an artist id
#/ @return object    a Soma::Artist::Object
sub forId($) { _load(['id=?'], [shift]) }

#/ @param string    an artist name
#/ @return object    a Soma::Artist::Object
sub forName($) { _load(['name=?'], [shift]) }


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @return object    a Soma::Artist::Object
sub _load(;$$) {
    my ($clauses, $values) = @_;

    my $table = Soma::Const::Artist::TABLE;
    my $cols = [Soma::Const::Artist::COLS];
    my $data = Db::iterator($table, $cols, $clauses, $values)->();
    Soma::Artist::Object->new($data);
}

1;
