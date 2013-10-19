
#/ Pathing.
#/ @author Joel Dalley
#/ @version 2013/Oct/05

package context;

use File::Basename;
use Cwd 'abs_path';

#/ one directory up from here
use constant PROJ_DIR => dirname(dirname(abs_path __FILE__));

#/ this directory
use lib PROJ_DIR . '/lib';

1;
