
#/ Subs which produce a single Soma::Song::Object.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Song::Load;

use Soma::Db;
use Soma::Const;
use Soma::Song::Object;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @return object    a Soma::Song::Object
sub empty() { Soma::Song::Object->new() }

#/ @return object    a Soma::Song::Object
sub random() { 
    my $opts = {order => 'RANDOM()', limit => 1};
    _load(undef, undef, $opts);
}

#/ @param string    a song id
#/ @return object    a Soma::Song::Object
sub forId($) { _load(['id=?'], [shift]) }


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param arrayref [optional] $clauses    SQL WHERE clauses
#/ @param arrayref [optional] $values    values for clauses
#/ @param hashref [optionsl] $opts    select options
#/ @return object    a Soma::Song::Object
sub _load(;$$$) {
    my ($clauses, $values, $opts) = @_;

    my $table = Soma::Const::Song::TABLE;
    my $cols = [Soma::Const::Song::COLS];
    my $data = Db::iterator($table, $cols, $clauses, $values, $opts)->();
    Soma::Song::Object->new($data);
}

1;
