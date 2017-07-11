use v6;

use lib 'lib';
use Test;
use ReadStat;

sub metadata-handler(Str $file-label, Str $orig-encoding, DateTime $timestamp, Int $file-format) returns Bool {
    return True;
}

sub info-handler(UInt $rows, UInt $cols) returns Bool {
    ok $rows > 0;
    ok $cols > 0;
    return True;
}

sub note-handler(Int $index, Str $note) returns Bool {
    return True;
}

sub variable-handler(ReadStat::Variable $variable, Str $val-labels) returns Bool {
    ok $variable.index ~~ Int;
    ok $variable.index.defined;

    ok $variable.index-after-skipping ~~ Int;

    ok $variable.name ~~ Str;
    ok $variable.name.defined;

    ok $variable.label ~~ Str;
    ok $variable.format ~~ Str;

    ok $variable.storage-width ~~ UInt;
    ok $variable.display-width ~~ UInt;
    ok $variable.measure ~~ ReadStat::Measure;
    ok $variable.alignment ~~ ReadStat::Alignment;
    return True;
}

sub value-handler(Int $obs, ReadStat::Variable $variable, ReadStat::Value $value) returns Bool {
    ok $value.type ~~ ReadStat::ValueType;
    ok $value.value.defined;
    ok $value.is-missing($variable, :by-definition).defined;
    ok $value.is-missing(:system).defined;
    ok $value.is-missing(:tagged).defined;
    return True;
}

my $reader = ReadStat::Parser.new;
ok $reader;

$reader.set-file-character-encoding("ASCII");
$reader.set-handler-character-encoding("UTF-8");
$reader.set-row-limit(1);
$reader.set-metadata-handler(&metadata-handler);
$reader.set-note-handler(&note-handler);
$reader.set-info-handler(&info-handler);
$reader.set-variable-handler(&variable-handler);
$reader.set-value-handler(&value-handler);
is $reader.parse("/Users/emiller/Downloads/216data.sav", :sav), ReadStat::Error::no-error;

done-testing;
