
#/ Express a row from the album table as an object.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::Album::Object; 

use Soma::Album;
use Soma::Const;
use Soma::String;
use Soma::DbObject;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string $type    object type
#/ @param arrayref [optional] $data    object data, or undef
#/ @return object    a Soma::Album::Object
sub new {
    my ($type, $data) = @_;
    my $table = Soma::Const::Album::TABLE;
    my $cols = [Soma::Const::Album::COLS];
    Soma::DbObject::new($type, $table, $cols, $data);
}

#/ @param object    a Soma::Album::Object
#/ @return int    album's id
sub id { Soma::DbObject::id(shift) }

#/ @param object    a Soma::Album::Object
#/ @return string    the album subdir
sub subdir { Soma::String::flatten(shift->field('name')) }

#/ @param object    a Soma::Album::Object
#/ @return string    cover art image file name
sub coverFile { shift->id() . '.jpg' }

#/ @param object    a Soma::Album::Object
#/ @return string    full UNIX path to cover art image file
sub coverPath { 
    join '/', Soma::Const::Album::COVER_DIR, shift->coverFile() 
}

#/ @param object    a Soma::Album::Object
#/ @param string    album's data field name
#/ @param mixed [optional]    album's new data field value
#/ @return mixed    album's data field value
sub field { Soma::DbObject::datumReadOnlyPK(@_) }

#/ @param object $this    a Soma::Album::Object
sub save { 
    my $this = shift;

    Soma::DbObject::save($this, sub {
        my $name = $this->field('name');
        my $artistId = $this->field('artist_id');
        Soma::Album::toId($name, $artistId);
    });
}

#/ @param object    a Soma::Album::Object
sub delete { Soma::DbObject::delete(shift) }

1;
