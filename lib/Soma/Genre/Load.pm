
#/ Subs which produce a single Soma::Genre::Object.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/26

use stern;
package Soma::Genre::Load;

use Soma::Db;
use Soma::Const;
use Soma::Genre::Object;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @return object    a Soma::Genre::Object
sub empty() { Soma::Genre::Object->new() }

#/ @param int    a genre id
#/ @return object    a Soma::Genre::Object
sub forId($) { _load(['id=?'], [shift]) }

#/ @param string    a genre name
#/ @return object    a Soma::Genre::Object
sub forName($) { _load(['name=?'], [shift]) }


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @return object    a Soma::Genre::Object
sub _load(;$$) {
    my ($clauses, $values) = @_;

    my $table = Soma::Const::Genre::TABLE;
    my $cols = [Soma::Const::Genre::COLS];
    my $data = Db::iterator($table, $cols, $clauses, $values)->();
    Soma::Genre::Object->new($data);
}

1;
