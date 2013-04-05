
#/ Handles Dancer route /cover.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

use stern;
package Soma::Dancer::Cover;

use Soma::Const;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @param string    an album id
#/ @return array    params for Dancer's send_file()
sub paramsFor($) {
    my $path = _album_cover(shift)
            || Soma::Const::Album::DEFAULT_COVER;

    return (
        $path,
        system_path  => 1,
        content_type => 'image/jpeg'
        );
}


#///////////////////////////////////////////////////////////////
#/ Internal use ////////////////////////////////////////////////

sub _album_cover($) {
    my $id = shift;

    require Soma::Album::Load;
    my $album = Soma::Album::Load::forId($id);

    $album->id() or do {
        warn "No album for `$id`"; 
        return undef;
    };
    
    -e $album->coverPath() or do {
        warn "No cover for `$id`"; 
        return undef;
    };

    $album->coverPath();
}

1;
