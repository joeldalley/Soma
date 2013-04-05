
#/ Express a row from the song table as an object.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Song::Object; 

use Soma::Song;
use Soma::Const;
use Soma::DbObject;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string $type    object type
#/ @param arrayref [optional] $data    object data, or undef
#/ @return object    a Soma::Song::Object
sub new {
    my ($type, $data) = @_;
    my $table = Soma::Const::Song::TABLE;
    my $cols = [Soma::Const::Song::COLS];
    Soma::DbObject::new($type, $table, $cols, $data);
}

#/ @param object    a Soma::Song::Object
#/ @return int    song's id
sub id { Soma::DbObject::id(shift) }

#/ @param object    a Soma::Song::Object
#/ @param string    song's data field name
#/ @param mixed [optional]    song's new data field value
#/ @return mixed    song's data field's value
sub field { Soma::DbObject::datumReadOnlyPK(@_) }

#/ @param object $this   a Soma::Song::Object
sub save { 
    my $this = shift;

    Soma::DbObject::save($this, sub {
        my $track = $this->field('track');
        my $albumId = $this->field('album_id');
        Soma::Song::toId($track, $albumId);
    });
}

#/ @param object    a Soma::Song::Object
sub delete { Soma::DbObject::delete(shift) }

1;
