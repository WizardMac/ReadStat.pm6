use v6;

use NativeCall;
use ReadStat::Common;

unit class ReadStat::LabelSet is repr('CPointer') is export;

sub readstat_label_double_value(ReadStat::LabelSet, num64, Str) is native(LIB) {...}
sub readstat_label_int32_value(ReadStat::LabelSet, int32, Str) is native(LIB) {...}
sub readstat_label_string_value(ReadStat::LabelSet, Str, Str) is native(LIB) {...}
sub readstat_label_tagged_value(ReadStat::LabelSet, int8, Str) is native(LIB) {...}

multi method label-value(Int:D $value, Str $label) {
    readstat_label_int32_value(self, $value, $label);
}
multi method label-value(Numeric:D $value, Str $label) {
    readstat_label_double_value(self, $value.Num, $label);
}
multi method label-value(Str:D $value, Str $label) {
    readstat_label_double_value(self, $value, $label);
}

method label-tagged-value(Int:D $value, Str $label) {
    readstat_label_tagged_value(self, $value, $label);
}
