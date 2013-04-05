
#/ Subs that produce a single Soma::Album::Object.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Album::Load;

use Soma::Db;
use Soma::Const;
use Soma::Album::Object;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @return object    a Soma::Album::Object
sub empty() { Soma::Album::Object->new() }

#/ @param int    an album id
#/ @return object    a Soma::Album::Object
sub forId($) { _load(['id=?'], [shift]) }


#///////////////////////////////////////////////////////////////
#/ Internal use ////////////////////////////////////////////////

#/ @param arrayref $clauses    SQL WHERE clauses
#/ @param arrayref $values    values for clauses
#/ @return object    a Soma::Album::Object
sub _load($$) {
    my ($clauses, $values) = @_;

    my $table = Soma::Const::Album::TABLE;
    my $cols = [Soma::Const::Album::COLS];
    my $data = Db::iterator($table, $cols, $clauses, $values)->();
    Soma::Album::Object->new($data);
}

1;
