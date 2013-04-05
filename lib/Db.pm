
#/ Db is a simple DBI wrapper.
#/
#/ Because of the use of "LIMIT", this package assumes your database
#/ is something like MySQL or SQLite, which supports that clause.
#/ 
#/ @author Joel Dalley
#/ @version 2013/Mar/21

use stern;
package Db;

use DBI;

#/ DBI::db, DSN string
our ($db, $DSN); 


#////////////////////////////////////////////////////
#/ Interface ////////////////////////////////////////

#/ @param scalar $table    A database table
#/ @param arrayref $columns    Column names to select
#/ @param arrayref $clauses    Where clauses
#/ @param arrayref $values    Column values
#/ @param hashref $opts    Select options
#/ @return coderef    a subroutine that returns the next result row
sub iterator($$;$$$) {
    my ($table, $columns) = (shift, shift);
    my ($clauses, $values, $opts) = (shift || [], shift || [], shift || {});

    my $query = selectQuery($table, $columns, $clauses, $opts);
    my $sth = execute($query, $values);

    sub {
        my $res = $sth->fetchrow_arrayref();
        $sth->finish() if not defined $res;
        $res;
    };
}

#/ @param scalar $table    A database table
#/ @param arrayref $clauses    Where clauses
#/ @param arrayref $values    Column values
#/ @return scalar    the number of rows matching the where clauses
sub count($;$$) {
    my ($table, $clauses, $values) = (shift, shift || [], shift || []);
    my $iter = getIterator($table, ['COUNT(*)'], $clauses, $values);
    int $iter->()->[0];
}

#/ @param scalar $table    A database table
#/ @param arrayref $columns    Column names to insert data into
#/ @param arrayref $values    Column values
sub insert($;$$) {
    my ($table, $columns, $values) = (shift, shift || [], shift || []);
    execute(insertQuery($table, $columns), $values);
}

#/ @param scalar $table    A database table
#/ @param arrayref $columns    Column names to update
#/ @param arrayref $clauses    Where clauses
#/ @param arrayref $values    Column values
sub update($$$$) {
    my ($table, $columns, $clauses, $values) = @_;
    execute(updateQuery($table, $columns, $clauses), $values);
}

#/ @param scalar $table    A database table
#/ @param arrayref $clauses    Where clauses
sub delete($$$) {
    my ($table, $clauses, $values) = @_;
    execute(deleteQuery($table, $clauses), $values);
}


#////////////////////////////////////////////////////
#/ Query constructors ///////////////////////////////


#/ @param scalar $table    A database table
#/ @param arrayref $columns    Column names
#/ @param arrayref $clauses    Where clauses
#/ @param hashref [optional] $opts    Select options
#/ @return scalar    Select query SQL
sub selectQuery($$$;$) {
    my ($table, $columns, $clauses) = (shift, shift, shift);
    my $opts = shift || {};

    my $select = join ',', @$columns;
    my $where = join ' AND ', @$clauses;
    my $query = 'SELECT ' . $select  . ' FROM ' . $table;
    $query .=  ' WHERE ' . $where if $where;

    $query .= ' ORDER BY ' . $opts->{'order'} if $opts->{'order'};
    $query .= ' GROUP BY ' . $opts->{'group'} if $opts->{'group'};
    if ($opts->{'start'} || $opts->{'limit'}) {
        $query .= ' LIMIT ';
        $query .= $opts->{'start'} . ',' if $opts->{'start'};
        $query .= $opts->{'limit'} if $opts->{'limit'};
    }

    $query;
}

#/ @param scalar $table    A database table
#/ @param arrayref $columns    Column names to insert values for
#/ @return scalar    Insert query SQL
sub insertQuery($$) {
    my ($table, $columns) = @_;
    my $inserts = join ',', @$columns;
    my $params = join ',', map {'?'} @$columns;
    'INSERT INTO ' . $table . '(' . $inserts . ') VALUES(' . $params . ')';
}

#/ @param scalar $table    A database table
#/ @param arrayref $columns    Column names to update
#/ @param arrayref $clauses    Column names for the where clauses
#/ @return scalar    Update query SQL
sub updateQuery($$$) {
    my ($table, $columns, $clauses) = @_;
    my $updates = join ',', map {$_ . '=?'} @$columns;
    my $where = join ' AND ', @$clauses;
    'UPDATE ' . $table . ' SET ' . $updates . ' WHERE ' . $where;
}

#/ @param scalar $table    A database table
#/ @param arrayref $clauses    where clauses
#/ @return scalar    Delete query SQL
sub deleteQuery($$) {
    my ($table, $clauses) = @_;
    'DELETE FROM ' . $table . ' WHERE ' . (join ' AND ', @$clauses);
}


#////////////////////////////////////////////////////
#/ Internal use /////////////////////////////////////


#/ @return object    a DBI::db
sub get() {
    ref($db) eq 'DBI::db' or do {
        $db = DBI->connect($DSN);
    };
    $db;
}

#/ @param scalar $query    SQL query
#/ @param arrayref $values    bind parameter values
#/ @return object    a DBI::st
sub execute($$) {
    my ($query, $values) = @_;
    my $sth = get()->prepare($query) or die $!;
    $sth->execute(@$values) or do {
        require Carp;
        Carp::confess($@);
    };
    $sth;
}

1;
