
#/ Subs that produce iterators of Soma::Artist::Objects.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Artist::Iterator;

use Soma::Db;
use Soma::Const;
use Soma::Artist::Object;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @return coderef    iterator of Soma::Artist::Objects
sub all() { _iter() }

#/ @param string    a letter
#/ @return coderef    iterator of Soma::Artist::Objects
sub forLetter($) { _iter(['name LIKE ?'], [(shift) . '%']) }


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @return coderef    iterator of Soma::Artist::Objects
sub _iter(;$$) {
    my ($clauses, $values) = (shift || [], shift || []);

    my $table = Soma::Const::Artist::TABLE;
    my $cols = [Soma::Const::Artist::COLS];
    my $iter = Db::iterator($table, $cols, $clauses, $values);

    sub {
        my $data = $iter->();
        $data ? Soma::Artist::Object->new($data) : undef;
    };
}

1;
