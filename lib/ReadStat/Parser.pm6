use v6;

use NativeCall;
use ReadStat::Common;
need ReadStat::Variable;
need ReadStat::Value;

unit class ReadStat::Parser is repr('CPointer') is export;

sub readstat_parser_init() returns ReadStat::Parser is native(LIB) {...}
sub readstat_parser_free(ReadStat::Parser) is native(LIB) {...}
sub readstat_parse_sav(ReadStat::Parser, Str, Pointer) returns int32 is native(LIB) {...};
sub readstat_parse_por(ReadStat::Parser, Str, Pointer) returns int32 is native(LIB) {...};
sub readstat_parse_dta(ReadStat::Parser, Str, Pointer) returns int32 is native(LIB) {...};

sub readstat_set_file_character_encoding(ReadStat::Parser, Str) returns int32 is native(LIB) {...};
sub readstat_set_handler_character_encoding(ReadStat::Parser, Str) returns int32 is native(LIB) {...};
sub readstat_set_row_limit(ReadStat::Parser, long) returns int32 is native(LIB) {...};
sub readstat_set_metadata_handler(ReadStat::Parser,
    &callback (Str, Str, int64, long, Pointer --> int32)) is native(LIB) {...}
sub readstat_set_info_handler(ReadStat::Parser,
    &callback (int32, int32, Pointer --> int32)) is native(LIB) {...}
sub readstat_set_note_handler(ReadStat::Parser,
    &callback (int32, Str, Pointer --> int32)) is native(LIB) {...}
sub readstat_set_variable_handler(ReadStat::Parser,
    &callback (int32, ReadStat::Variable, Str, Pointer --> int32)) is native(LIB) {...}
sub readstat_set_value_handler(ReadStat::Parser,
    &callback (int32, ReadStat::Variable, Pointer, uint64, Pointer --> int32)) is native(LIB) {...}
sub readstat_set_value_label_handler(ReadStat::Parser,
    &callback (Str, Pointer, uint64, Str, Pointer --> int32)) is native(LIB) {...}
sub readstat_set_error_handler(ReadStat::Parser, &callback (Str, Pointer)) is native(LIB) {...}

method new() {
    readstat_parser_init()
}

method set-file-character-encoding(Str:D $encoding) returns ReadStat::Error {
    ReadStat::Error(readstat_set_file_character_encoding(self, $encoding))
}

method set-handler-character-encoding(Str:D $encoding) returns ReadStat::Error {
    ReadStat::Error(readstat_set_handler_character_encoding(self, $encoding))
}

method set-row-limit(UInt:D $row-limit) returns ReadStat::Error {
    ReadStat::Error(readstat_set_row_limit(self, $row-limit))
}

method set-metadata-handler(&callback:(Str $file-name, Str $orig-encoding, DateTime $date-time, Int $file-format --> Bool)) {
    my $cb = sub (Str $fl, Str $oe, int64 $ts, long $ff, Pointer $blah) returns int32 {
        Int(!&callback($fl, $oe, DateTime.new($ts), $ff))
    };
    readstat_set_metadata_handler(self, $cb)
}

method set-info-handler(&callback:(UInt $rows, UInt $cols --> Bool)) {
    my $cb = sub (int32 $r, int32 $c, Pointer $blah) returns int32 {
        Int(!&callback($r, $c))
    };
    readstat_set_info_handler(self, $cb)
}

method set-variable-handler(&callback:(ReadStat::Variable $variable, Str $value-labels --> Bool)) {
    my $cb = sub (int32 $idx, ReadStat::Variable $v, Str $vl, Pointer $blah) returns int32 {
        Int(!&callback($v, $vl))
    };
    readstat_set_variable_handler(self, $cb);
}

method set-value-handler(&callback:(Int $obs, ReadStat::Variable $variable, ReadStat::Value $value --> Bool)) {
    my $cb = sub (int32 $idx, ReadStat::Variable $v, Pointer $val1, uint64 $val2, Pointer $blah) returns int32 {
        my $value = ReadStat::Value.new(val1 => $val1, val2 => $val2);
        Int(!&callback($idx, $v, $value))
    };
    readstat_set_value_handler(self, $cb);
}

method set-value-label-handler(&callback:(Str, ReadStat::Value, Str --> Bool)) {
    my $cb = sub (Str $val_labels, Pointer $val1, uint64 $val2, Str $label, Pointer $blah) returns int32 {
        my $value = ReadStat::Value.new(val1 => $val1, val2 => $val2);
        Int(!&callback($val_labels, $value, $label))
    };
    readstat_set_value_label_handler(self, $cb);
}

method set-error-handler(&callback:(Str)) {
    my $cb = sub (Str $string, Pointer $ctx) {
        &callback($string);
    };
    readstat_set_error_handler(self, $cb);
}

method set-note-handler(&callback:(Int, Str --> Bool)) {
    my $cb = sub (int32 $index, Str $string) {
        Int(!&callback($index, $string));
    };
    readstat_set_note_handler(self, $cb);
}

multi method parse(Str:D $file, :$sav) returns ReadStat::Error {
    ReadStat::Error(readstat_parse_sav(self, $file, Pointer))
}

multi method parse(Str:D $file, :$por) returns ReadStat::Error {
    ReadStat::Error(readstat_parse_por(self, $file, Pointer))
}

multi method parse(Str:D $file, :$dta) returns ReadStat::Error {
    ReadStat::Error(readstat_parse_dta(self, $file, Pointer))
}

method DESTROY() {
    readstat_parser_free(self)
}

