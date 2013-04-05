
#/ Dancer routes.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

package Soma::Dancer;
use Dancer ':syntax';
our $VERSION = '0.1';

use Soma::Dancer::Params;
use Soma::Dancer::Settings;


get '/' => sub {
    require Soma::Dancer::Home;
    Soma::Dancer::Home::html();
};

get '/search/:query' => sub {
    require Soma::Dancer::Search;
    Soma::Dancer::Search::html(QUERY);
};

get '/play/search/:query' => sub {
    require Soma::Dancer::Play;
    Soma::Dancer::Play::searchHtml(QUERY);
};

get '/play/:mode/:id' => sub {
    require Soma::Dancer::Play;
    Soma::Dancer::Play::modalHtml(MODE, ID)
    || redirect '/404.html';
};

get '/audio/:songid' => sub {
    require Soma::Dancer::Audio;
    my @params = Soma::Dancer::Audio::paramsFor(SONG_ID);
    @params ? send_file(@params) : undef;
};

get '/cover/:albumid' => sub {
    require Soma::Dancer::Cover;
    my @params = Soma::Dancer::Cover::paramsFor(ALBUM_ID);
    send_file(@params);
};

get '/json/covers/:count' => sub {
    require Soma::Dancer::Json;
    Soma::Dancer::Json::covers(COUNT);
};

get '/json/search/:query' => sub {
    require Soma::Dancer::Json;
    Soma::Dancer::Json::search(QUERY);
};

get '/json/:mode/:id' => sub {
    require Soma::Dancer::Json;
    Soma::Dancer::Json::modal(MODE, ID);
};

true;
