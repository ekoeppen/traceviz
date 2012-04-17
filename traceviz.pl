#!/usr/bin/perl

$interval = 0.01;
$sum = 0;
%threads = {};
%times = {};
$total = 0;

sub reset_times {
    for (keys %$threads) {
        $times->{$_} = 0.0;
    }
}

open(FILE, "<", $ARGV[0]);
while (<FILE>) {
    ($time, $delta, $type, $a, $b, $c, $d, $e, $f, $prev) = split;
    $prev =~ s/[",]//g;
    $threads->{$prev} = 1;
}

printf("%s", "Time");
for (keys %$threads) {
    printf(", %s", $_);
}
printf("\n");

reset_times();
seek(FILE, 0, 0);
while (<FILE>) {
    ($time, $delta, $type, $a, $b, $c, $d, $e, $f, $prev) = split;
    $delta =~ s/[()+]//g;
    $prev =~ s/[",]//g;
    if ($delta > 0.0) {
        $times->{$prev} += $delta;
    }
    $sum += $delta;
    $total += $delta;
    if ($sum > $interval) {
        printf("%f", $total);
        for (keys %$threads) {
            printf(", %f", $times->{$_});
        }
        reset_times();
        printf("\n");
        $sum = 0;
    }
}
close(FILE);
