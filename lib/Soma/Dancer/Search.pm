
#/ Handles Dancer route /search.
#/ @author Joel Dalley
#/ @version 2013/Mar/30

use stern;
package Soma::Dancer::Search;

use Soma::Dancer::Template 'render';
use Soma::Capsule::Iterator;
use URI::Escape;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @param string    a search query
#/ @return string    html
sub html($) {
    my $query = uri_unescape(shift);

    my $replace = {
        HEADING => "Search `$query`",
        ESCAPED => uri_escape($query),
        QUERY => $query
        };

    return render('page-open.html', $replace)
         . render('play-search-button.html', $replace)
         . _results($query)
         . render('page-close.html');
}


#///////////////////////////////////////////////////////////////
#/ Internal use ////////////////////////////////////////////////

#/ @param string    a search query
#/ @return string    result rows html
sub _results($) {
    my $iter = Soma::Capsule::Iterator::search(shift);

    my $html = '';
    while (my $cap = $iter->()) {
        my $replace = {
            SONG_URL    => '/play/song/' . $cap->song()->id(),
            SONG_TITLE  => $cap->song()->field('title'),
            TRACK       => $cap->song()->field('track'),
            ALBUM_URL   => '/play/album/' . $cap->album()->id(),
            ALBUM_NAME  => $cap->album()->field('name'),
            ARTIST_URL  => '/play/artist/' . $cap->artist()->id(),
            ARTIST_NAME => $cap->artist()->field('name')
            };
        $html .= render('search-result-row.html', $replace);
    }

    $html;
}

1;
