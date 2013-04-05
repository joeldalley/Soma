
#/ Express a row from the artist table as an object.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Artist::Object; 

use Soma::Const;
use Soma::Artist;
use Soma::DbObject;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string $type    object type
#/ @param arrayref [optional] $data    object data, or undef
#/ @return object    a Soma::Artist::Object
sub new {
    my ($type, $data) = @_;
    my $table = Soma::Const::Artist::TABLE;
    my $cols = [Soma::Const::Artist::COLS];
    Soma::DbObject::new($type, $table, $cols, $data);
}

#/ @param object    a Soma::Artist::Object
#/ @return int    artist's id
sub id { Soma::DbObject::id(shift) }

#/ @param object    a Soma::Artist::Object
#/ @param string    artist's data field name
#/ @param mixed [optional]    artist's new data field value
#/ @return mixed    artist's data field's value
sub field { Soma::DbObject::datumReadOnlyPK(@_) }

#/ @param object $this   a Soma::Artist::Object
sub save { 
    my $this = shift;
    
    Soma::DbObject::save($this, sub {
        Soma::Artist::toId($this->field('name'))
    });
}

#/ @param object    a Soma::Artist::Object
sub delete { Soma::DbObject::delete(shift) }

1;
