
#/ A Soma::DbObject represents a row from a database table.
#/ It must have a primary key column called 'id' to work correctly.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::DbObject;

use Soma::Db;
use Soma::DbObject::DbData;

sub TABLE { 0 }
sub DATA  { 1 }
sub PK    { 'id' }


#//////////////////////////////////////////////////////////////
#/ Object interface ///////////////////////////////////////////

#/ @param string $type    object type
#/ @param string $table    database table
#/ @param string $cols    table columns
#/ @param arrayref $vals    column values
#/ @return object    a Soma::DbObject 
sub new($$$$) {
    my ($type, $table, $cols, $vals) = @_;
    my $data = _newData($cols, $vals);
    bless [$table, $data], $type;
}

#/ @param object    a Soma::DbObject
#/ @return mixed    object's id
sub id($) { datum(shift, PK) }

#/ @param object $this    a Soma::DbObject
#/ @param string $field    data field name
#/ @param mixed [optional] $value    data field value (to set)
#/ @return mixed    data field value
sub datum($$;$) { 
    my ($this, $field, $value) = @_;
    $this->[DATA]->($field, $value);
}

#/ Same as datum(), except PK field is read-only
#/ @see datum();
sub datumReadOnlyPK(@) {
    my ($this, $field, $value) = @_;
    $value = undef if $field eq PK;
    datum($this, $field, $value);
}

#/ @param object $this    a Soma::DbObject
#/ @param coderef $gen    id generating subroutine
sub save($&) {
    my ($this, $gen) = @_;
    my $id = id($this);

    if (!$id) {
        die "Invalid id generator" if !ref $gen eq 'CODE';
        datum($this, PK, $gen->());

        my @cols = _cols($this);
        my @vals = map datum($this, $_), @cols;
        Db::insert(_table($this), \@cols, \@vals);
    }
    else {
        #/ columns & values for updating;
        #/ exclude primary key id column
        my @cols = grep {$_ ne PK} _cols($this);
        my @vals = map datum($this, $_), @cols;

        my @clauses = (PK.'=?');
        push @vals, id($this);
        Db::update(_table($this), \@cols, \@clauses, \@vals);
    }
}

#/ @param object $this    a Soma::DbObject
sub delete($) {
    my $this = shift;
    Db::delete(_table($this), [PK.'=?'], [id($this)]);
    $this->[DATA] = _newData([_cols($this)]);
}


#//////////////////////////////////////////////////////////////
#/ Internal use ///////////////////////////////////////////////

#/ @param object    a Soma::DbObject
#/ @return string    object's database table
sub _table($) { shift->[TABLE] }

#/ @param object    a Soma::DbObject
#/ @return array    object's database columns
sub _cols($) { shift->[DATA]->('cols') }

#/ @param arrayref $cols    table columns
#/ @param arrayref [optional] $values    column values
#/ @return object    a Soma::DbObject::DbData
sub _newData($;$) {
    my ($cols, $vals) = @_;
    Soma::DbObject::DbData::new($cols, $vals);
}

1;
