
#/ Expresses database object column/value pairs as an object.
#/ The reasons this is encapsulated, and not a bare hash are:
#/
#/ Note 'use fields' can't be employed here since the 
#/ fields an object may have aren't known at compile time.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/23

use stern;
package Soma::DbObject::DbData;

#/ @param arrayref $columns    table columns
#/ @param arrayref [optional] $values    column values
#/ @return object    a Soma::DbObject::DbData
sub new($$) {
    my ($columns, $values) = (shift, shift || []);

    my %data; @data{@$columns} = @$values;

    my $obj = sub {
        my ($field, $value) = @_;

        #/ special case: return a copy
        #/ of the object's column names
        return @$columns if $field eq 'cols';

        die "Invalid field `$field`" if !exists $data{$field};
        $data{$field} = $value if defined $value;
        $data{$field};
    };

    bless $obj, __PACKAGE__;
}

1;
