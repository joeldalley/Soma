
#/ Handles Dancer route /.
#/ @author Joel Dalley
#/ @version 2013/Apr/01

use stern;
package Soma::Dancer::Home;

use Soma::Const;
use Soma::Dancer::Template 'render';


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

sub html() {
    my $replace = _replace();
    return render('page-open.html', $replace)
         . render('home.html', $replace)
         . render('page-close.html');
}


#///////////////////////////////////////////////////////////////
#/ Internal use ////////////////////////////////////////////////

#/ @return hashref    placeholder/value pairs
sub _replace() {
    my $count = Soma::Const::Dancer::COVERS_COUNT;
    return {
        QUERY    => '',
        HEADING  => 'Welcome to Soma',
        JSON_URL => "/json/covers/$count"
    }
}

1;
