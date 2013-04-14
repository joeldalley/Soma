 
#/ Provides forFile() and extract(), both of which
#/ return a meta data hash; the difference being that
#/ forFile() will die on bad/missing data.
#/
#/ Also provides update(), for updating mp3 meta data;
#/ currently this is the only type that can be updated.
#/
#/ @author Joel Dalley
#/ @version 2013/Apr/13

use stern;
package Soma::Song::Meta;

use Soma::Song;
use Soma::Const;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string $file    UNIX path to a music file
#/ @return hash    meta data hash
sub forFile($) {
    my $file = shift;
    my %meta = extract($file);

    COMPLETE_DATA_REQUIRED: {
        my $size = scalar keys %meta;
        my @def = grep {defined $meta{$_}} keys %meta;
        my $max = Soma::Const::Song::MAX_FILEPATH;

        die "No duration `$file`" if !$meta{'duration'};
        die "Track is zero (0) `$file`" if !$meta{'track'};
        die "Track NaN `$file`" if $meta{'track'} !~ /^\d+$/;
        die "File path too long `$file`" if length $file > $max;
        die "At least one undef meta datum `$file`" if @def < $size;
    }

    %meta;
}

#/ @param string $file    UNIX path to a music file
#/ @return hash    meta data hash
sub extract($) {
    my $file = shift;
    die "No such file `$file`" unless -e $file;

    my %meta;
    switch: {
        Soma::Song::isMp3($file) and do {
            require MP3::Tag;
            my $mp3 = MP3::Tag->new($file);
            my $secs = $mp3->total_secs() || 0;
            my @info = $mp3->autoinfo();

            $meta{'title'} = $info[0];
            $meta{'track'} = $info[1];
            $meta{'artist'} = $info[2];
            $meta{'album'} = $info[3];
            $meta{'year'} = $info[5];
            $meta{'genre'} = $info[6];
            $meta{'duration'} = int($secs + .5);

            last switch;
        };

        Soma::Song::isM4a($file) and do {
            require MP4::Info;
            my $tag = MP4::Info::get_mp4tag($file);
            my $mins = $tag->{'MM'} || 0;
            my $secs = $tag->{'SS'} || 0;

            $meta{'title'} = $tag->{'NAM'};
            $meta{'track'} = $tag->{'TRKN'}[0];
            $meta{'artist'} = $tag->{'ART'};
            $meta{'album'} = $tag->{'ALB'};
            $meta{'year'} = $tag->{'DAY'};
            $meta{'genre'} = $tag->{'GNRE'};
            $meta{'duration'} = int($mins*60 + $secs);

            last switch;
        };

        die "Invalid file `$file`";
    }

    #/ simplify track
    $meta{'track'} =~ /^(\d+)/;
    $meta{'track'} = $1 && sprintf('%0d', $1) || undef;

    %meta;
}

#/ Updates the meta data for the given file.
#/ @param string $file    UNIX path to a song file
#/ @param hash %meta    meta data
sub update($%) {
    my ($file, %meta) = @_;

    Soma::Song::isMp3($file) 
        or die "Only MP3s can be updated `$file`";

    require MP3::Tag;
    my $mp3 = MP3::Tag->new($file);
    my @tags = $mp3->get_tags();

    my $remove_tag = sub {
        return if !grep $_[0] eq $_, @tags;
        $mp3->{$_[0]}->remove_tag() or die $!;
    };

    for my $v (qw(ID3v1 ID3v2)) {
        $remove_tag->($v);
        $mp3->new_tag($v) or die $!;
        my $sub = "_write_$v";
        my $ref = \&$sub;
        $ref->($mp3->{$v}, %meta);
    }

    $mp3->close();
}


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ Writes an ID3v1 meta tag.
#/ @param object $tag    an MP3::Tag::ID3v1
#/ @param hash %meta    meta data
sub _write_ID3v1($%) {
    my ($tag, %meta) = @_;
    my @keys = qw(title track album artist year genre);
    for (@keys) { 
        next unless $meta{$_};
        $tag->$_($meta{$_}) or die "$_ -- $!" 
    }
    $tag->write_tag() or die $!;
}

#/ Writes an ID3v2 meta tag.
#/ @param object $tag    an MP3::Tag::ID3v2
#/ @param hash %meta    meta data
sub _write_ID3v2($%) {
    my ($tag, %meta) = @_;

    my %map = qw(TIT2 title TRCK track TALB album 
                 TCOM artist TCON genre TYER year);

    while (my ($f, $_) = each %map) { 
        next unless $meta{$_};
        $tag->add_frame($f, $meta{$_}) or die "$_ -- $!";
    }
    $tag->write_tag() or die $!;
}

1;
