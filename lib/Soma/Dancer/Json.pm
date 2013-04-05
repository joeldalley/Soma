
#/ Handles Dancer route /json.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

use stern;
package Soma::Dancer::Json;

use JSON;
use URI::Escape;
use Soma::Capsule::Load;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param int $howMany    how many entries to return
#/ @return string    JSON data
sub covers($) {
    my $howMany = shift;
    return encode_json([]) if !$howMany;

    my @data;
    require Soma::Album::Iterator;
    my $iter = Soma::Album::Iterator::random($howMany);
    while ($_ = $iter->()) { push @data, {'id' => $_->id()} }
    encode_json(\@data);
}

#/ @param string    search query
#/ @return string    JSON data
sub search($) {
    my $query = uri_unescape(shift);
    return encode_json([]) unless $query;

    my @data;
    require Soma::Capsule::Iterator;
    my $iter = Soma::Capsule::Iterator::search($query);
    while ($_ = $iter->()) { push @data, _capsule($_) }
    encode_json(\@data);
}

#/ @param string $mode    json route mode
#/ @param string $id    json route id
#/ @return string    JSON data
sub modal($$) {
    my ($mode, $id) = @_;
    return _forArtistId($id) if $mode eq 'artist';
    return _forAlbumId($id) if $mode eq 'album';
    return _forSongId($id) if $mode eq 'song';
    die "Invalid mode `$mode`";
}


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param string    an artist id
#/ @return string    JSON data for all songs by artist
sub _forArtistId($) {
    my @data = _artist(shift);
    encode_json(\@data);
}

#/ @param string   an album id
#/ @return string    JSON data for all songs on album
sub _forAlbumId($) {
    my @data = _album(shift);
    encode_json(\@data);
}

#/ @param string    a song id
#/ @return string    JSON data for one song
sub _forSongId($) { encode_json([_song(shift)]) }


#/ @param string    an artist id
#/ @return array    array of capsule data hashrefs
sub _artist($) {
    my @data;
    require Soma::Album::Iterator;
    my $iter = Soma::Album::Iterator::forArtistId(shift);
    while ($_ = $iter->()) { push @data, _album($_->id()) }
    @data;
}

#/ @param string    an album id
#/ @return array    array of capsule data hashrefs
sub _album($) {
    my @data;
    require Soma::Song::Iterator;
    my $iter = Soma::Song::Iterator::forAlbumId(shift);
    while ($_ = $iter->()) { push @data, _song($_->id()) }
    @data;
}

#/ @param string    a song id
#/ @return hashref    capsule data
sub _song($) {
    my $capsule = Soma::Capsule::Load::forSongId(shift);
    _capsule($capsule);
}

#/ @param object    a Soma::Capsule
#/ @return hashref    capsule data
sub _capsule($) {
    my $capsule = shift;

    return {
        albumId  => $capsule->album()->id(),
        album    => $capsule->album()->field('name'),
        genre    => $capsule->genre()->field('name'),
        artistId => $capsule->artist()->id(),
        artist   => $capsule->artist()->field('name'),
        songId   => $capsule->song()->id(),
        track    => $capsule->song()->field('track'),
        title    => $capsule->song()->field('title'),
        duration => $capsule->song()->field('duration'),
        };
}

1;
