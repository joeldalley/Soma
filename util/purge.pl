use stern;

#/ Removes song(s) matching a query from the soma.db database.
#/
#/ If all an album's songs are removed, then the album is 
#/ removed. If all an artist's albums are removed, then the 
#/ artist is removed.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Apr/03

use Soma::Song::Iterator;
use Soma::Album::Iterator;
use Soma::Capsule::Iterator;

#/ input 
my $query = shift or die "Usage: perl purge.pl <query>";

#/ keep track of artists and albums encountered
my %haveSeen = (artist => [], album => []);

#/ results
my $iter = Soma::Capsule::Iterator::search($query);
my @results; while ($_ = $iter->()) { push @results, $_ }
die "No results for `$query`" unless @results;

#/ menu
for (my $i = 0; $i < @results; $i++) { printResult($i) }
print "[all] all\n" if @results > 1;
print "Enter number: ";
chomp(my $num = <STDIN>);

#/ validate
die "Invalid choice `$num`"
    unless $num eq 'all' || defined $results[$num];


#/ purge songs
if ($num eq 'all') { purge_song($_) for @results }
else { purge_song($results[$num]) }

#/ check for albums with no songs, and purge
my $albsub = \&Soma::Song::Iterator::forAlbumId;
purge_artist_or_album('album', $albsub);

#/ check for artists with no albums, and purge
my $artsub = \&Soma::Album::Iterator::forArtistId;
purge_artist_or_album('artist', $artsub);


exit;


#/ @param int $idx    results array index
sub printResult {
    my $idx = shift;
    my $cap = $results[$idx];
    my $title = $cap->song()->field('title');
    my $albName = $cap->album()->field('name');
    my $artName = $cap->artist()->field('name');
    print "[$idx] $artName\t$albName\t$title\n";
}

#/ @param string $key    'artist' or 'album'
#/ @param object $obj    a Soma::Album::Object or
#/                       a Soma::Artist::Object
sub addHaveSeen($$) {
    my ($key, $obj) = @_;
    return if grep {$_->id() eq $obj->id()} @{$haveSeen{$key}};
    push @{$haveSeen{$key}}, $obj;
}

#/ @param object $cap    a Soma::Capsule::Object
sub purge_song {
    my $cap = shift;
    my $title = $cap->song()->field('title');
    addHaveSeen('album', $cap->album());
    addHaveSeen('artist', $cap->artist());
    $cap->song()->delete();
    print "Purged song: $title\n";
}

#/ @param string $key    'album' or 'artist'
#/ @param coderef $sub    sub that returns an iterator
sub purge_artist_or_album {
    my ($key, $sub) = @_;
    for my $obj (@{$haveSeen{$key}}) {
        next if not_empty($obj, $sub);
        my $name = $obj->field('name');
        $obj->delete();
        print "Purged $key: $name\n";
    }
}

#/ @param object $obj    a Soma::Artist::Object or
#/                       a Soma::Album::Object
#/ @param coderef $sub    sub that returns an iterator
#/ @return int    1 if not empty, or 0
sub not_empty {
    my ($obj, $sub) = @_;
    my $iter = $sub->($obj->id());
    my $count = 0; while ($iter->()) { $count += 1 }
    $count && 1 || 0;
}
