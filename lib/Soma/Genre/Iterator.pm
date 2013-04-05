
#/ Subs that produce iterators of Soma::Genre::Objects.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/26

use stern;
package Soma::Genre::Iterator;

use Soma::Db;
use Soma::Const;
use Soma::Genre::Object;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @return coderef    iterator of Soma::Genre::Objects
sub all() { _iter() }


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @return coderef    iterator of Soma::Genre::Objects
sub _iter(;$$) {
    my ($clauses, $values) = (shift || [], shift || []);

    my $table = Soma::Const::Genre::TABLE;
    my $cols = [Soma::Const::Genre::COLS];
    my $iter = Db::iterator($table, $cols, $clauses, $values);

    sub {
        my $data = $iter->();
        $data ? Soma::Genre::Object->new($data) : undef;
    };
}

1;
