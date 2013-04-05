
#/ Express a row from the genre table as an object.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/26

use stern;
package Soma::Genre::Object; 

use Soma::Genre;
use Soma::Const;
use Soma::DbObject;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string $type    object type
#/ @param arrayref [optional] $data    object data, or undef
#/ @return object    a Soma::Genre::Object
sub new {
    my ($type, $data) = @_;
    my $table = Soma::Const::Genre::TABLE;
    my $cols = [Soma::Const::Genre::COLS];
    Soma::DbObject::new($type, $table, $cols, $data);
}

#/ @param object    a Soma::Genre::Object
#/ @return int    genre's id
sub id { Soma::DbObject::id(shift) }

#/ @param object    a Soma::Genre::Object
#/ @param string    genre's data field name
#/ @param mixed [optional]    genre's new data field value
#/ @return mixed    genre's data field's value
sub field { Soma::DbObject::datumReadOnlyPK(@_) }

#/ @param object $this   a Soma::Genre::Object
sub save { 
    my $this = shift;
    
    Soma::DbObject::save($this, sub {
        Soma::Genre::toId($this->field('name'))
    });
}

#/ @param object    a Soma::Genre::Object
sub delete { Soma::DbObject::delete(shift) }

1;
