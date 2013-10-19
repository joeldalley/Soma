use stern;
use context;

#/ Compile check project all .pl and .pm files.
#/
#/ @author Joel Dalley
#/ @version 2013/Apr/05

use File::DirWalk;
use Soma::Const;

my $lib_dir = Soma::Const::SOMA_DIR . '/lib';

#/ check files
my $walker = File::DirWalk->new;

$walker->onFile(sub {
    my $file = shift;
    if (is_perl($file)) {
        my $res = `perl -I$lib_dir -c $file 2>&1`;
        die $res unless $res =~ /syntax OK$/o;
    }
    File::DirWalk::SUCCESS;
});

$walker->walk(Soma::Const::SOMA_DIR);


#/ @param string $file    file path
#/ @return int    1 for true, or 0 for false
sub is_perl {
    my $file = shift;
    $file =~ /\.(pl|pm)$/
    && $file !~ /\.svn/
    && 1 || 0;
}
