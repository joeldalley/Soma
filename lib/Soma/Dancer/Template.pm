
#/ Soma Dancer template object.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

use stern;
package Soma::Dancer::Template;

use Exporter 'import';
our @EXPORT_OK = qw(render);

use Soma::File;
use Soma::Const;

my %cache;


#///////////////////////////////////////////////////////////////
#/ Interface ///////////////////////////////////////////////////

#/ @param string $file    a template file name
#/ @param hashref [optional] $repl    placeholder/value pairs
sub render {
    my ($file, $repl) = (shift, shift || {});

    #/ load
    exists $cache{$file} or do {
        my $path = Soma::Const::Dancer::TMPL_DIR . "/$file";
        $cache{$file} = Soma::File::read($path);
    };

    #/ replace
    my $text = $cache{$file};
    while (my ($k, $v) = each %$repl) {
        $text =~ s/$k/$v/g;
    }

    $text;
}

1;
