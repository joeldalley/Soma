use stern;
use context;

#/ Imports music files from a given directory.
#/ Creates <artist>/<album>/<song> directory structure, if necessary.
#/
#/ If the -mp3 option is used, then avconv is invoked to convert 
#/ any input files into mp3s, if they aren't already.
#/
#/ @author Joel Dalley
#/ @version 2013/Apr/14

use File::Copy;
use Soma::Song::Meta;
use Soma::DirWalk 'song_walk';

#/ arguments
my $indir = clean(shift) || die usage();
my $outdir = clean(shift) || die usage();
-d $indir or die "Input dir doesn't exist `$indir`";
-d $outdir or die "Output dir doesn't exist `$outdir`";
my $convert = shift;


song_walk($indir, sub {
    my $file = shift;

    my %m; eval { %m = Soma::Song::Meta::forFile($file) };
    if ($@) {
        warn $@;
        return;
    }

    #/ <artist>/<album>/<song> structure is created using
    #/ the file meta data, not the input directory/file names
    $file =~ /\.([0-9a-z]+)$/i;
    my $ext = $1 && lc $1 || die "No file ext `$file`";
    my $albdir = ensure_dir($m{'artist'}, $m{'album'});
    my $name = filename($m{'track'}, $m{'title'}, $ext);
    my $copy = "$albdir/$name";

    #/ copy, instead of move (non-destructive); 
    #/ leave it up to the user to delete originals
    copy($file, $copy) or die "Cannot make copy `$copy` -- $!";
    print "Made copy $copy\n";

    return unless $convert and $ext ne 'mp3';
    convert($copy, ($_ = $copy) =~ s/$ext$/mp3/ && $_);
});


exit;


#/ NOTE: The avconv system call will not fail gracefully.
#/
#/ @param string $from    starting file path
#/ @param string $to    ending file path, after conversion to mp3
sub convert {
    my ($from, $to) = @_;
    my $cmd = qq{avconv -loglevel fatal -y -i "$from" -b 256k "$to"};
    system $cmd and die "Command failure `$cmd`";
    unlink $from or die $!;
    print "Converted into $to\n";
}

#/ @param string $art    an artist name
#/ @param string $alb    an album name
#/ @return string    the destination directory
sub ensure_dir {
    my ($art, $alb) = (flatten(shift), flatten(shift));
    $art =~ s/^The //;

    for ($art, "$art/$alb") {
        next if -d "$outdir/$_";
        mkdir "$outdir/$_" or die $!;
        print "Made dir $outdir/$_\n";
    }
    "$outdir/$art/$alb";
}

#/ @param int $track   a track number
#/ @param string $title    a song title
#/ @param string $ext    a file extension
#/ @return    the output file name
sub filename {
    my ($track, $title, $ext) = @_;
    sprintf('%02d', $track) . '_' . flatten($title) . ".$ext";
}

#/ @param string $s    a string
#/ @return string    a new string (most non-word chars removed)
sub flatten {
    my $s = shift;
    my @l = split '', $s;
    for (@l) { /[\w\(\)\[\]]/ or $_ = '_' }
    $s = join '', @l;
    $s =~ s/_+/_/g;
    $s =~ s/^_//;
    $s =~ s/_$//;
    $s;
}

#/ @param string $d    a directory
#/ @return string     directory, minus any trailing slash "/"
sub clean {
    my $d = shift;
    return unless $d;
    $d =~ s|/$||;
    $d;
}

#/ @return string    script usage
sub usage { 'Usage: perl ' . __FILE__ . ' <input dir> <output dir>' }
