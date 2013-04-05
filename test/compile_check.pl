use stern;

#/ Compile check project all .pl and .pm files.
#/
#/ @author Joel Dalley
#/ @version 2013/Apr/05

use File::DirWalk;
use Soma::Const;

my $dir = Soma::Const::SOMA_DIR;
my $log = $dir . '/test/.compile.log';

#/ clear from last time
unlink $log;

#/ check files
my $walker = File::DirWalk->new();
$walker->onFile(\&callback);
$walker->walk($dir);

#/ analyze log
open F, '<', $log or die $!; my @log = <F>; close F;
for (@log) { die "ERROR: $_" if $_ !~ /syntax OK$/ }
print $_ for (join '', @log, "\nSUCCESS\n");


exit;


#/ @param string $file    file path
#/ @return int    File::DirWalk::SUCCESS
sub callback {
    my $file = shift;

    if (is_perl($file)) {
        #/ split into relative dir, file
        die "Relative dir not clear `$file`"
            unless $file =~ m{($dir/\w+)/(.*)$};

        #/ compile file, log result
        system "cd $1 && perl -c $2 >> $log 2>&1";
    }

    File::DirWalk::SUCCESS;
}

#/ @param string $file    file path
#/ @return int    1 for true, or 0 for false
sub is_perl {
    my $file = shift;
    $file =~ /\.(pl|pm)$/
    && $file !~ /\.svn/
    && 1 || 0;
}
