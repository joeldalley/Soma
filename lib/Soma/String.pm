
#/ Project string utilities.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/26

use stern;
package Soma::String;


#//////////////////////////////////////////////////////////////
#/ Interface //////////////////////////////////////////////////

#/ @param string $string    a string
#/ @return    a flattened string
sub flatten($) {
    my $string = shift;
    return undef unless $string;

    #/ reduce to simple alphabet
    my @string = split //, $string;
    for (@string) { /[a-z0-9\[\]\(\)]/io or $_ = '_' }

    #/ clean up
    $string = join '', @string;
    $string =~ s/_+/_/g;
    $string =~ s/^_//;
    $string =~ s/_$//;

    $string;
}

1;
