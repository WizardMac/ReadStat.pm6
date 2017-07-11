use v6;

use NativeCall;
use ReadStat::Common;
need ReadStat::LabelSet;

unit class ReadStat::Variable is repr('CPointer') is export;

sub readstat_variable_get_index(ReadStat::Variable) returns int32 is native(LIB) {...}
sub readstat_variable_get_index_after_skipping(ReadStat::Variable) returns int32 is native(LIB) {...}
sub readstat_variable_get_name(ReadStat::Variable) returns Str is native(LIB) {...}
sub readstat_variable_get_label(ReadStat::Variable) returns Str is native(LIB) {...}
sub readstat_variable_get_format(ReadStat::Variable) returns Str is native(LIB) {...}
sub readstat_variable_get_type(ReadStat::Variable) returns int32 is native(LIB) {...}
sub readstat_variable_get_storage_width(ReadStat::Variable) returns size_t is native(LIB) {...}
sub readstat_variable_get_display_width(ReadStat::Variable) returns int32 is native(LIB) {...}
sub readstat_variable_get_measure(ReadStat::Variable) returns int32 is native(LIB) {...}
sub readstat_variable_get_alignment(ReadStat::Variable) returns int32 is native(LIB) {...}

sub readstat_variable_set_label(ReadStat::Variable, Str) is native(LIB) {...}
sub readstat_variable_set_format(ReadStat::Variable, Str) is native(LIB) {...}
sub readstat_variable_set_label_set(ReadStat::Variable, ReadStat::LabelSet) is native(LIB) {...}
sub readstat_variable_set_measure(ReadStat::Variable, int32) is native(LIB) {...}
sub readstat_variable_set_alignment(ReadStat::Variable, int32) is native(LIB) {...}
sub readstat_variable_set_display_width(ReadStat::Variable, int32) is native(LIB) {...}

method index() returns UInt { readstat_variable_get_index(self) }
method index-after-skipping() returns UInt { readstat_variable_get_index_after_skipping(self) }
method name() returns Str { readstat_variable_get_name(self) }

method label() returns Str { readstat_variable_get_label(self) }
method set-label(Str $new-label) { readstat_variable_set_label(self, $new-label) }

method format() returns Str { readstat_variable_get_label(self) }
method set-format(Str $new-format) { readstat_variable_set_format(self, $new-format) }

method value-type() returns ValueType { readstat_variable_get_type(self) }
method storage-width() returns UInt { readstat_variable_get_storage_width(self) }

method display-width() returns UInt { readstat_variable_get_display_width(self) }
method set-display-width(UInt $new-width) { readstat_variable_set_display_width(self, $new-width) }

method measure() returns Measure { Measure(readstat_variable_get_measure(self)) }
method set-measure(Measure $new-measure) { readstat_variable_set_measure(self, $new-measure) }

method alignment() returns Alignment { Alignment(readstat_variable_get_alignment(self)) }
method set-alignment(Alignment $new-alignment) { readstat_variable_set_alignment(self, $new-alignment) }

method set-label-set(ReadStat::LabelSet $label-set) { readstat_variable_set_label_set(self, $label-set) }
