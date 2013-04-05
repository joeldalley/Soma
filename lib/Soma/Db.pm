
#/ Use Db, with soma project DSN specified.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/21

use stern;
package Soma::Db;

use Db;
use Soma::Const;

#/ define project DSN
defined $Db::DSN or $Db::DSN = Soma::Const::DSN;
