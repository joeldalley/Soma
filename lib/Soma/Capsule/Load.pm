 
#/ Subs that produce a single Soma::Capsule.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/26

use stern;
package Soma::Capsule::Load;

use Soma::Const;
use Soma::Capsule;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @return object    a Soma::Capsule
sub random() { forSongId(Soma::Const::Song::RAND) }

#/ @param string $id    a song id
#/ @return object    a Soma::Capsule
sub forSongId($) {
    my $id = shift;

    require Soma::Song::Load;
    my $song = ($id ne Soma::Const::Song::RAND)
             ? Soma::Song::Load::forId($id)
             : Soma::Song::Load::random();

    die "No song for `$id`" if !$song->id();
    forSong($song);
}

#/ @param object $song    a Soma::Song::Object
#/ @return object    a Soma::Capsule
sub forSong($) {
    my $song = shift;
    require Soma::Album::Load;
    require Soma::Genre::Load;
    require Soma::Artist::Load;

    my $albId = $song->field('album_id');
    my $album = Soma::Album::Load::forId($albId);
    die "No album for id `$albId`" if !$album->id();

    my $genreId = $album->field('genre_id');
    my $genre = Soma::Genre::Load::forId($genreId);
    die "No genre for `$genreId`" if !$genre->id();

    my $artId = $album->field('artist_id');
    my $artist = Soma::Artist::Load::forId($artId);
    die "No artist for id `$artId`" if !$artist->id();

    Soma::Capsule->new([$genre, $artist, $album, $song]);
}

#/ @param string $file    UNIX path to a music file
#/ @return object    a Soma::Capsule
sub forFile($) {
    my $file = shift;
    require Soma::Song::Meta;
    my %meta = Soma::Song::Meta::forFile($file);
    forSong(_metaToSong($file, %meta));
}


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param hash %m   meta data
#/ @return object    a Soma::Artist::Object
sub _metaToArtist(%) {
    my %m = @_;
    require Soma::Artist::Load;

    my $artist = Soma::Artist::Load::forName($m{'artist'});
    $artist->id() or do {
        $artist->field('name', $m{'artist'});
        $artist->save();
    };

    $artist;
}

#/ @param hash %m   meta data
#/ @return object    a Soma::Genre::Object
sub _metaToGenre(%) {
    my %m = @_;
    require Soma::Genre::Load;

    my $genre = Soma::Genre::Load::forName($m{'genre'});
    $genre->id() or do {
        $genre->field('name', $m{'genre'});
        $genre->save();
    };

    $genre;
}

#/ @param hash %m    meta data
#/ @return object    a Soma::Album::Object
sub _metaToAlbum(%) {
    my %m = @_;
    require Soma::Album::Load;

    my $artist = _metaToArtist(%m);
    my $id = Soma::Album::toId($m{'album'}, $artist->id());
    my $album = Soma::Album::Load::forId($id);

    $album->id() or do {
        my $genre = _metaToGenre(%m);
        $album->field('genre_id', $genre->id());
        $album->field('artist_id', $artist->id());
        $album->field('name', $m{'album'});
        $album->field('year', $m{'year'});
        $album->save();
    };

    $album;
}

#/ @param string $f    file path
#/ @param hash %m    meta data
#/ @return object    a Soma::Song::Object
sub _metaToSong($%) {
    my ($f, %m) = @_;
    require Soma::Song::Load;

    my $album = _metaToAlbum(%m);
    my $id = Soma::Song::toId($m{'track'}, $album->id());
    my $song = Soma::Song::Load::forId($id);

    $song->id() or do {
        $song->field('album_id', $album->id());
        $song->field('title', $m{'title'});
        $song->field('track', $m{'track'});
        $song->field('duration', $m{'duration'});
        $song->field('filepath', $f);
        $song->save();
    };

    $song;
}

1;
