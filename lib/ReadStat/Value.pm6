use v6;

use NativeCall;
need ReadStat::Variable;
need ReadStat::Common;

#`{{
    This file uses horrible calling convention hacks to pass structs by values.
    The readstat_value_t struct uses two eightbytes so pass them separately
    using a pointer (the .v field, a union) and a uint64 with everything else.
    Works on Sys V, not sure about Windows.
}}

unit class ReadStat::Value is export;
has Pointer $.val1;
has uint64 $.val2;

sub readstat_value_type(Pointer, uint64) returns int32 is native(ReadStat::LIB) {...}
sub readstat_string_value(Pointer, uint64) returns Str is native(ReadStat::LIB) {...}
sub readstat_double_value(Pointer, uint64) returns num64 is native(ReadStat::LIB) {...}
sub readstat_int32_value(Pointer, uint64) returns int32 is native(ReadStat::LIB) {...}

sub readstat_value_is_missing(Pointer, uint64, ReadStat::Variable) returns int32 is native(ReadStat::LIB) {...}
sub readstat_value_is_system_missing(Pointer, uint64) returns int32 is native(ReadStat::LIB) {...}
sub readstat_value_is_tagged_missing(Pointer, uint64) returns int32 is native(ReadStat::LIB) {...}
sub readstat_value_is_defined_missing(Pointer, uint64, ReadStat::Variable) returns int32 is native(ReadStat::LIB) {...}
sub readstat_value_tag(Pointer, uint64) returns int8 is native(ReadStat::LIB) {...}

method type() returns ReadStat::ValueType {
    ReadStat::ValueType(readstat_value_type($.val1, $.val2))
}

method tag() returns Int {
    readstat_value_tag($.val1, $.val2)
}

method value() {
    given self.type {
        when ReadStat::ValueType::string {
            readstat_string_value($.val1, $.val2)
        }
        when (ReadStat::ValueType::double
            | ReadStat::ValueType::float) {
            Num(readstat_double_value($.val1, $.val2))
        }
        when (ReadStat::ValueType::int32
            | ReadStat::ValueType::int16
            | ReadStat::ValueType::int8) {
            Int(readstat_int32_value($.val1, $.val2))
        }
    }
}

method is-missing(ReadStat::Variable $variable?, Bool :$by-definition?, Bool :$system?, Bool :$tagged?) returns Bool {
    if $by-definition.defined and !$variable.defined {
        die "Must provide variable to evaluate defined missing!";
    }
    if $system.defined and readstat_value_is_system_missing($.val1, $.val2) {
        return True
    }
    if $tagged.defined and readstat_value_is_tagged_missing($.val1, $.val2) {
        return True
    }
    if $by-definition.defined and readstat_value_is_defined_missing($.val1, $.val2, $variable) {
        return True
    }
    if !$by-definition.defined and !$system.defined and !$tagged.defined {
        return Bool(readstat_value_is_missing($.val1, $.val2, $variable))
    }
    return False
}
