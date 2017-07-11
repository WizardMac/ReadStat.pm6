use v6;

use Test;
use lib 'lib';
use ReadStat;

sub data-handler(Buf $data) returns Int {
    return $data.elems;
}

my $writer = ReadStat::Writer.new;
ok $writer;

is $writer.set-file-label("My data set"), ReadStat::Error::no-error;
is $writer.set-file-timestamp(DateTime.now), ReadStat::Error::no-error;
is $writer.set-compression(ReadStat::Compress::compress-none), ReadStat::Error::no-error;

my $label-set = $writer.add-label-set(ReadStat::ValueType::int32-type, "labels");
ok $label-set;
$label-set.label-value(10, "Something");

my $var = $writer.add-variable("Var1", ReadStat::ValueType::int32-type, 0);
ok $var;
$var.set-label("My first variable");
$var.set-format("F8.2");
$var.set-label-set($label-set);
$var.set-measure(ReadStat::Measure::ordinal);
$var.set-alignment(ReadStat::Alignment::center);
$var.set-display-width(10);

is $writer.set-fweight-variable($var), ReadStat::Error::no-error;

$writer.add-note("Hello there");

is $writer.set-data-writer(&data-handler), ReadStat::Error::no-error;

is $writer.begin-writing(1, :dta), ReadStat::Error::no-error;
is $writer.begin-row, ReadStat::Error::no-error;
is $writer.insert-value($var, 12), ReadStat::Error::no-error;
is $writer.end-row, ReadStat::Error::no-error;
is $writer.end-writing, ReadStat::Error::no-error;

done-testing;
