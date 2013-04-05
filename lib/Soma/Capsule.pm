
#/ A Soma::Capsule possesses the relevant DbObjects
#/ whose data fully expresses a particular song.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/25

use stern;
package Soma::Capsule;

use Soma::Const;
use fields Soma::Const::Capsule::FIELDS;

#/ @param string $type    object type
#/ @param arrayref $data    object data
#/ @return object    a Soma::Capsule
sub new {
    my ($type, $data) = @_;
    my $this = fields::new($type);
    @$this{(Soma::Const::Capsule::FIELDS)} = @$data;
    $this;
}

#/ @param object    a Soma::Capsule
#/ @return object    a Soma::Genre::Object
sub genre  { shift->{'genre'} }

#/ @param object    a Soma::Capsule
#/ @return object    a Soma::Artist::Object
sub artist { shift->{'artist'} }

#/ @param object    a Soma::Capsule
#/ @return object    a Soma::Album::Object
sub album  { shift->{'album'} }

#/ @param object    a Soma::Capsule
#/ @return object    a Soma::Song::Object
sub song   { shift->{'song'} }

1;
