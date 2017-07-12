use v6;

use Test;
use lib 'lib';
use ReadStat;

sub data-handler(Buf $data) returns Int {
    return $data.elems;
}

my $writer = ReadStat::Writer.new;
ok $writer;

is $writer.set-file-label("My data set"), ReadStat::Error::none;
is $writer.set-file-timestamp(DateTime.now), ReadStat::Error::none;
is $writer.set-compression(ReadStat::Compress::none), ReadStat::Error::none;

my $label-set = $writer.add-label-set(ReadStat::ValueType::int32, "labels");
ok $label-set;
$label-set.label-value(10, "Something");

my $var = $writer.add-variable("Var1", ReadStat::ValueType::int32, 0);
ok $var;
$var.set-label("My first variable");
$var.set-format("F8.2");
$var.set-label-set($label-set);
$var.set-measure(ReadStat::Measure::ordinal);
$var.set-alignment(ReadStat::Alignment::center);
$var.set-display-width(10);

is $writer.set-fweight-variable($var), ReadStat::Error::none;

$writer.add-note("Hello there");

is $writer.set-data-writer(&data-handler), ReadStat::Error::none;

is $writer.begin-writing(1, :dta), ReadStat::Error::none;
is $writer.begin-row, ReadStat::Error::none;
is $writer.insert-value($var, 12), ReadStat::Error::none;
is $writer.end-row, ReadStat::Error::none;
is $writer.end-writing, ReadStat::Error::none;

done-testing;
