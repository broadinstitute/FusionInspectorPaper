#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "usage: $0 consolidated_edgren_predictions.dat\n\n";

my $input_file = $ARGV[0] or die $usage;

main: {

    open(my $fh, $input_file) or die $!;

    my %fusion_to_prog;
    my %prognames;

    while(<$fh>) {
        chomp;
        my @x = split(/\t/);
        my $sample_name = $x[0];
        my $progname = $x[1];
        my $fusion_name = $x[2];

        $prognames{$progname}++;
        
        my $alt_fusion_name = "$sample_name|$fusion_name";
        $fusion_to_prog{$alt_fusion_name}->{$progname}++;
        
    }
        
    ## generate report
    my @prognames = sort keys %prognames;

    print "\t" . join("\t", @prognames) . "\n";

    my @final_fusions = sort keys %fusion_to_prog; 
    
    foreach my $fusion (@final_fusions) {
        
        my @vals = ($fusion);
        foreach my $progname (@prognames) {
            my $found = (exists $fusion_to_prog{$fusion}->{$progname}) ? 1 : 0;
            push (@vals, $found);
        }

        print join("\t", @vals) . "\n";
    }

    exit(0);
    
}
