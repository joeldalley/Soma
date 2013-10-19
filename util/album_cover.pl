use stern;
use context;

#/ Add or replace an album cover.
#/ @author Joel Dalley
#/ @version 2013/Mar/30

use LWP::Simple;
use Soma::Const;
use Soma::Album::Iterator;
use Soma::Artist::Load;

#/ input
my $query = shift || die "Usage: perl album_cover.pl <query>";

#/ search
my $iter = Soma::Album::Iterator::search($query);
my @results; while ($_ = $iter->()) { push @results, $_ }
die "No results `$query`" unless @results;

#/ menu
my $num;
if (@results > 1) {
    for (my $i = 0; $i < @results; $i++) { printResult($i) }
    print "[all] all\n";
    print "Enter number: ";
    chomp($num = <STDIN>);
}
else {
    printResult(0);
    $num = 0;
}

#/ validate
die "Invalid choice `$num`" 
    unless $num eq 'all' || defined $results[$num];

#/ GET url
print "Cover image URL: ";
chomp(my $url = <STDIN>);
my $content = get($url) or die "Cannot GET $url";

#/ save
print "\n";
if ($num eq "all") { saveImg($_) for @results }
else { saveImg($results[$num]) }


exit;


#/ @param object $album    a Soma::Album::Object
sub saveImg {
    my $album = shift;
    open F, '>', $album->coverPath() or die $!;
    print F $content;
    close F;
    print "Saved! ", $album->coverPath(), "\n";
}

#/ @param object $album    a Soma::Album::Object
#/ @return string     the associated artist name
sub toArtistName {
    my $album = shift;
    my $artId = $album->field('artist_id');
    my $artist = Soma::Artist::Load::forId($artId);
    $artist->field('name');
}

#/ @param int $idx    results array index
sub printResult {
    my $idx = shift;
    my $artName = toArtistName($results[$idx]);
    my $albName = $results[$idx]->field('name');
    print "[$idx] $artName\t$albName\n";
}
