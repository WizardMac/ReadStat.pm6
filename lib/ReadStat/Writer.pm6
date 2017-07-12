use v6;

use NativeCall;
use ReadStat::Common;
need ReadStat::StringRef;
need ReadStat::Variable;

unit class ReadStat::Writer is repr('CPointer') is export;

sub readstat_writer_init() returns ReadStat::Writer is native(LIB) {...}
sub readstat_writer_free(ReadStat::Writer) is native(LIB) {...}
sub readstat_set_data_writer(ReadStat::Writer,
    &callback (CArray[uint8], size_t, Pointer --> ssize_t)) returns int32 is native(LIB) {...}
sub readstat_add_label_set(ReadStat::Writer, int32, Str) returns ReadStat::LabelSet is native(LIB) {...};

sub readstat_add_variable(ReadStat::Writer, Str, int32, size_t) returns ReadStat::Variable is native(LIB) {...}
sub readstat_get_variable(ReadStat::Writer, int32) returns ReadStat::Variable is native(LIB) {...}
sub readstat_add_note(ReadStat::Writer, Str) is native(LIB) {...}
sub readstat_add_string_ref(ReadStat::Writer, Str) returns ReadStat::StringRef is native(LIB) {...}
sub readstat_get_string_ref(ReadStat::Writer, int32) returns ReadStat::StringRef is native(LIB) {...}

sub readstat_writer_set_file_label(ReadStat::Writer, Str) returns int32 is native(LIB) {...}
sub readstat_writer_set_file_timestamp(ReadStat::Writer, int64) returns int32 is native(LIB) {...}
sub readstat_writer_set_fweight_variable(ReadStat::Writer, ReadStat::Variable) returns int32 is native(LIB) {...}

sub readstat_writer_set_file_format_version(ReadStat::Writer, long) returns int32 is native(LIB) {...}
# e.g. 104-118 for DTA; 5 or 8 for SAS Transport

sub readstat_writer_set_file_format_is_64bit(ReadStat::Writer, int32) returns int32 is native(LIB) {...} 
# applies only to SAS files; defaults to 1=true

sub readstat_writer_set_compression(ReadStat::Writer, int32) returns int32 is native(LIB) {...}
# applies only to SAS and SAV files

sub readstat_begin_writing_dta(ReadStat::Writer, Pointer, long) returns int32 is native(LIB) {...}
sub readstat_begin_writing_sav(ReadStat::Writer, Pointer, long) returns int32 is native(LIB) {...}
sub readstat_begin_writing_por(ReadStat::Writer, Pointer, long) returns int32 is native(LIB) {...}

sub readstat_begin_row(ReadStat::Writer) returns int32 is native(LIB) {...}
sub readstat_insert_int32_value(ReadStat::Writer, ReadStat::Variable, int32) returns int32 is native(LIB) {...}
sub readstat_insert_double_value(ReadStat::Writer, ReadStat::Variable, num64) returns int32 is native(LIB) {...}
sub readstat_insert_string_value(ReadStat::Writer, ReadStat::Variable, Str) returns int32 is native(LIB) {...}
sub readstat_insert_string_ref(ReadStat::Writer, ReadStat::Variable, ReadStat::StringRef) returns int32 is native(LIB) {...}
sub readstat_end_row(ReadStat::Writer) returns int32 is native(LIB) {...}

sub readstat_end_writing(ReadStat::Writer) returns int32 is native(LIB) {...}

method new() {
    readstat_writer_init()
}

method DESTROY() {
    readstat_writer_free(self)
}

method set-data-writer(&callback:(Buf --> Int)) returns ReadStat::Error {
    my $cb = sub (CArray[uint8] $data, size_t $length, Pointer $ctx) returns ssize_t {
        my $blob = Buf.allocate($length);
        $blob[$_] = $data[$_] for ^$length;
        &callback($blob);
    };
    ReadStat::Error(readstat_set_data_writer(self, $cb));
}

method add-label-set(ReadStat::ValueType $value-type, Str $name) returns ReadStat::LabelSet {
    readstat_add_label_set(self, $value-type, $name);
}

method add-variable(Str:D $name, ReadStat::ValueType $value-type, UInt $storage-width) returns ReadStat::Variable {
    readstat_add_variable(self, $name, $value-type, $storage-width);
}

method get-variable(Int:D $index) returns ReadStat::Variable {
    readstat_get_variable(self, $index);
}

method add-note(Str $note) {
    readstat_add_note(self, $note);
}

method add-string-ref(Str $string) returns ReadStat::StringRef {
    readstat_add_string_ref(self, $string);
}

method get-string-ref(Int $index) returns ReadStat::StringRef {
    readstat_get_string_ref(self, $index);
}

method set-file-label(Str $file-label) returns ReadStat::Error {
    ReadStat::Error(readstat_writer_set_file_label(self, $file-label));
}

method set-file-timestamp(Dateish:D $date) returns ReadStat::Error {
    ReadStat::Error(readstat_writer_set_file_timestamp(self, $date.posix))
}

method set-fweight-variable(ReadStat::Variable $variable) returns ReadStat::Error {
    ReadStat::Error(readstat_writer_set_fweight_variable(self, $variable))
}

method set-file-format-version(UInt $version) returns ReadStat::Error {
    ReadStat::Error(readstat_writer_set_file_format_version(self, $version))
}

method set-file-format-is64bit(Bool $is64bit) returns ReadStat::Error {
    ReadStat::Error(readstat_writer_set_file_format_is_64bit(self, $is64bit))
}

method set-compression(ReadStat::Compress $compression) returns ReadStat::Error {
    ReadStat::Error(readstat_writer_set_compression(self, $compression))
}

multi method begin-writing(UInt $rows, :$sav) returns ReadStat::Error {
    ReadStat::Error(readstat_begin_writing_sav(self, Pointer, $rows))
}

multi method begin-writing(UInt $rows, :$por) returns ReadStat::Error {
    ReadStat::Error(readstat_begin_writing_por(self, Pointer, $rows))
}

multi method begin-writing(UInt $rows, :$dta) returns ReadStat::Error {
    ReadStat::Error(readstat_begin_writing_dta(self, Pointer, $rows))
}

method begin-row() returns ReadStat::Error {
    ReadStat::Error(readstat_begin_row(self));
}

multi method insert-value(ReadStat::Variable $var, Int:D $value) returns ReadStat::Error {
    ReadStat::Error(readstat_insert_int32_value(self, $var, $value))
}

multi method insert-value(ReadStat::Variable $var, Numeric $value) returns ReadStat::Error {
    ReadStat::Error(readstat_insert_double_value(self, $var, $value.Num))
}

multi method insert-value(ReadStat::Variable $var, Str $value) returns ReadStat::Error {
    ReadStat::Error(readstat_insert_string_value(self, $var, $value))
}

method insert-string-ref(ReadStat::Variable $var, ReadStat::StringRef $ref) returns ReadStat::Error {
    ReadStat::Error(readstat_insert_string_ref(self, $var, $ref))
}

method end-row() returns ReadStat::Error {
    ReadStat::Error(readstat_end_row(self))
}

method end-writing() returns ReadStat::Error {
    ReadStat::Error(readstat_end_writing(self))
}
