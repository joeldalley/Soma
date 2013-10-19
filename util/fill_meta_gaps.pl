use stern;
use context;

#/ Example (require confirmation):
#/
#/     ~$ perl fill_meta_gaps.pl /my/music/Smashing_Pumpkins
#/
#/     Recursively look through Smashing_Pumpkins sub-dirs
#/     for files with meta data gaps, fill them (if possible),
#/     and require user confirmation before writing changes.
#/
#/ Example (automatic): 
#/
#/     ~$ perl fill_meta_gaps.pl /my/music/Smashing_Pumpkins 1
#/  
#/     Same as above, but updates files w/o user input.
#/
#/ This script assumes your song files are located within a 
#/ directory structure like this:
#/
#/        .../<artist>/<album>/<song file 1>
#/        .../<artist>/<album>/<song file 2>
#/        ...
#/
#/ @author Joel Dalley
#/ @version 2013/Apr/14

use File::Basename;
use Soma::Song::Meta;
use Soma::DirWalk 'song_walk';

#/ arguments
my $dir = shift || die usage();
my $auto = shift && 1 || 0;


my %ref;  #/ reference data
my %gaps; #/ meta data gaps

song_walk($dir, sub {
    my $file = shift;

    #/ cannot proceed
    if (!(split '/', $file)[-3]) {
       warn assumption($file);
       return; 
    }

    my $alb = basename(dirname($file));
    my $art = basename(dirname(dirname($file)));
    my %m = Soma::Song::Meta::extract($file);

    #/ reference data: the first choice
    #/ when filling in missing meta data
    if ($m{'artist'} && $m{'album'}) {
        $ref{$art}{$alb} = {} if !$ref{$alb}{$art};
        for (qw(artist album genre year)) { 
            $ref{$art}{$alb}{$_} = $m{$_} 
                unless $ref{$art}{$alb}{$_};
        }
    }

    #/ check the following meta data keys, and if any of
    #/ them are missing ("" and 0 values count as missing),
    #/ then record that this song file has meta data gaps.
    for (qw(artist album title track year genre duration)) {
        if (!$m{$_}) {
            $gaps{$art}{$alb} = [] if !$gaps{$art}{$alb};
            push @{$gaps{$art}{$alb}}, [$file, \%m];
            last;
        }
    }
});

#/ for each song file with gaps, attempt to fill those gaps:

for my $art (sort keys %gaps) {
    for my $alb (sort keys %{$gaps{$art}}) {
        for my $pair (@{$gaps{$art}{$alb}}) {
            my ($file, $m) = @$pair;

            #/ transform given meta value by key; first try
            #/ the reference value, then the existing meta
            #/ data value, or fall back to transforming sub
            my $trans = sub {
                my ($key, $sub) = @_;
                $ref{$art}{$alb}{$key}
                || $m->{$key}
                || $sub->();
            };

            #/ mapping between meta data keys and a
            #/ transforming sub that tries to use information
            #/ in a sub-dir or filename to "guess" a value
            my %map = (
                year => sub {''},
                genre => sub {''},
                artist => sub { 
                    (my $a = $art) =~ s/_/ /g; $a;
                    },
                album => sub { 
                    (my $a = $alb) =~ s/_/ /g; $a;
                    },
                track => sub {
                    basename($file) =~ /^(\d+)_/;
                    $1 && sprintf('%0d', $1) || 0;
                    },
                title => sub {
                    my $ttl = basename($file);
                    $ttl =~ s/^\d+_//;
                    $ttl =~ s/\.\w+$//;
                    $ttl =~ s/_/ /g;
                    $ttl;
                    },
                duration => sub { 
                    get_duration($file) || 0 
                    },
                );

            #/ perform transformations;
            #/ skip if nothing changed
            my $changed;
            for (keys %map) {
                my $new = $trans->($_, $map{$_});
                next if $m->{$_} eq $new;
                print " -- CHANGE: [$_] $m->{$_} => $new\n";
                $m->{$_} = $new;
                $changed = 1;
            }
            next unless $changed;

            #/ a shortened file path, for printing
            my $name = join '/', $art, $alb, basename($file);

            #/ require confirmation, if 'auto' wasn't chosen
            if (!$auto) {
                print "Confirm update: $name\n\nOk? [y/n]: ";
                chomp(my $confirm = <STDIN>);
                next unless $confirm =~ /^y/io;
            }

            #/ update the file
            eval { 
                Soma::Song::Meta::update($file, %$m);
                print "Saved changes: $name\n\n";
            };
            warn $@ if $@;
        }
    }
}


exit;


#/ If you don't have ffprobe, this will fail gracefully.
#/ @param string $file    UNIX file path
#/ @return mixed    duration, if found, or undef
sub get_duration {
    my $file = shift;
    my $cmd = "ffprobe \"$file\" 2>&1"
            . '| grep -m 1 Duration: '
            . '| cut -c 13-23';
    chomp(my $dur = `$cmd`);
    return if $dur !~ /^(\d{2}):(\d{2}):([\d\.]+)$/;
    int($1*3600 + $2*60 + $3);
}

#/ @param string $file    UNIX file path
#/ @return string    usage assumption message
sub assumption {
    my $file = shift;
    "Given a path of `$file` -- this utility "
    . "assumes a directory structure of "
    . ".../<artist>/<album>/<song file>";
}

#/ @return string    script usage
sub usage { 'perl ' . __FILE__ . ' <music dir> [auto 0/1]' }

