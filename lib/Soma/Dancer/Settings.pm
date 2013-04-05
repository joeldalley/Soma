
#/ Project Dancer settings.
#/ @author Joel Dalley
#/ @version 2013/Mar/29

package Soma::Dancer::Settings;

use Soma::Const;
use Dancer::Config 'setting';

#/ I've moved these from the default locations
setting('envdir', Soma::Const::Dancer::ENV_DIR);
setting('confdir', Soma::Const::Dancer::CONF_DIR);

1;
