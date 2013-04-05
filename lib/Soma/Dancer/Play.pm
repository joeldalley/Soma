
#/ Handles Dancer route /play.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

use stern;
package Soma::Dancer::Play;

use Soma::Dancer::Template 'render';
use Soma::Capsule::Load;
use URI::Escape;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @param string $query   a search query
#/ @return string    html
sub searchHtml($) {
    my $query = shift;
    my $unescaped = uri_unescape($query);
    my $head = "Play Search `$unescaped`";
    my $url = "/json/search/$query";
    _render(_replace($head, $url, $query));
}

#/ @param string $mode    play route mode
#/ @param string $id    play route id
#/ @return string    html for page (or undef for bad id)
sub modalHtml($$) {
    my ($mode, $id) = @_;
    my $head = _heading($mode, $id);
    my $url = _json_url($mode, $id);
    _render(_replace($head, $url));
}


#///////////////////////////////////////////////////////////////
#/ Internal use ////////////////////////////////////////////////

#/ @param hashref    placeholder/value pairs
#/ @return string    play page html
sub _render($) {
    my $replace = shift;
    return render('page-open.html', $replace)
         . render('play.html', $replace)
         . render('page-close.html');
}

#/ @param string $head    heading
#/ @param string $url    json url
#/ @param string [optional] $query    search query
#/ @return hashref    placeholder/value pairs
sub _replace($$;$) {
    my ($head, $url, $query) = (shift, shift, shift || '');

    #/ javacsript true/false
    my $isRand = $url eq '/json/song/random'
               ? 'true' : 'false';

    return {
        QUERY     => $query,
        HEADING   => $head,
        RANDOMIZE => $isRand,
        JSON_URL  => $url,
    };
}

#/ @param string $mode    play route mode
#/ @param string $id    play route id
#/ @return string    a url (undef for invalid mode)
sub _json_url($$) {
    my ($mode, $id) = @_;

    if ($mode eq 'song') {
        return '/json/song/random' if $id eq 'random';
        return "/json/song/$id";
    }

    return "/json/album/$id" if $mode eq 'album';
    return "/json/artist/$id" if $mode eq 'artist';

    warn "Invalid mode `$mode`";
    undef;
}

#/ @param string $mode    play route mode
#/ @param string $id    play route id
#/ @return string    a heading (undef for invalid mode)
sub _heading($$) {
    my ($mode, $id) = @_;

    if ($mode eq 'song') {
        return 'Play Random Song' if $id eq 'random';
        return 'Play Song';
    }

    return 'Play Album' if $mode eq 'album';
    return 'Play All From Artist' if $mode eq 'artist';

    warn "Invalid mode `$mode`";
    undef;
}

1;
