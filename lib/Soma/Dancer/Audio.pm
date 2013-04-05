
#/ Handles Dancer route /audio.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

use stern;
package Soma::Dancer::Audio;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @param string $id    a song id
#/ @return mixed    params for Dancer's send_file()
sub paramsFor($) {
    my $id = shift;

    my $cap;
    require Soma::Capsule::Load;
    eval { $cap = Soma::Capsule::Load::forSongId($id) };

    if ($@) {
        warn "$@";
        return undef;
    }

    my $file = $cap->song()->field('filepath');
    -e $file or do {
        warn "No such file `$file`";
        return undef;
    };

    return (
        $file,
        streaming    => 1,
        system_path  => 1,
        content_type => 'audio/mpeg'
        );
}

1;
