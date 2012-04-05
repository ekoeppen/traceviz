#!/usr/bin/perl

$interval = 0.01;
$sum = 0;
%threads = {};
%times = {};

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

for (keys %$threads) {
    printf("%s, ", $_);
}
printf("\n");

reset_times();
seek(FILE, 0, 0);
while (<FILE>) {
    ($time, $delta, $type, $a, $b, $c, $d, $e, $f, $prev) = split;
    $delta =~ s/[()+]//g;
    $prev =~ s/[",]//g;
    if ($delta > 0.0) {
#        printf("%s %s\n", $delta, $prev);
        $times->{$prev} += $delta;
    }
    $sum += $delta;
    if ($sum > $interval) {
#        printf("------------------------------------------------\n");
        for (keys %$threads) {
#            printf("%s: %f ", $_, $times->{$_});
            printf("%f, ", $times->{$_});
        }
#        printf("\n== %f ========================================\n", $sum);
        reset_times();
        printf("\n");
        $sum = 0;
    }
}
close(FILE);
