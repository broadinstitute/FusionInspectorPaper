#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my %data;

# restrict to the top isoform per call
open(my $fh, "edgren.combined.tsv") or die $!;
while(<$fh>) {
    chomp;
    my ($sample, $prog, $fusion, $J, $S) = split(/\t/);
    
    my $fusion_struct = { 'sample' => $sample,
                              'prog' => $prog,
                              'fusion' => $fusion,
                              'J' => $J,
                              'S' => $S,
                              'sum' => $J + $S,
    };


    push (@{$data{$sample}->{$prog}->{$fusion}}, $fusion_struct);
}




my %fusion_prog_renaming = ('nFuse' => "nFuse-v0.2.1",
                            "STARSEQR" => "STARSEQR-v0.6.7",
                            "SOAP-fuse" => "SOAP-fuse v1.2.6",
                            "TrinityFusion-UC" => "TrinityFusion-UC-v0.2.0",
                            "ChimeraScan" => "ChimeraScan-v0.4.5",
                            "TrinityFusion-D" => "TrinityFusion-D-v0.2.0",
                            "FusionHunter" => "FusionHunter-v1.4",
                            "Arriba" => "Arriba-v1.1.0",
                            "ARRIBA_hc" => "ARRIBA_hc-v1.1.0",
                            "TopHat-Fusion" => "TopHat-Fusion v2.0.10-v2.0.10",
                            "STAR_FUSION_v1.5" => "STAR-Fusion-v1.5",
                            "FUSION_CATCHER_V0994e" => "FusionCatcher-v0994e",
                            "ChimPipe" => "ChimPipe-v0.9.5",
                            "TrinityFusion-C" => "TrinityFusion-C v0.2.0",
                            "PIZZLY" => "Pizzly-v0.37.3",
                            "MapSplice" => "MapSplice-v2.2.0",
                            "FUSIONCATCHER_v1.10_June192019" => "FusionCatcher-v1.10",
                            "JAFFA-Assembly" => "JAFFA-Assembly-v1.0.6",
                            "deFuse" => "deFuse-v0.6.1",
                            "EricScript" => "EricScript-v0.5.3",
                            "STAR_FUSION_1.9.1" => "STAR-Fusion-v1.9.1",
                            "InFusion" => "InFusion-3be2ecb2a113",
                            "JAFFA-Hybrid" => "JAFFA-Hybrid0-v1.0.6",
                            "PRADA" => "PRADA-v1.2",
                            "nFuse" => "nFuse-v0.2.1",
                            "STARSEQR" => "STARSEQR-v0.6.7",
                            "SOAP-fuse" => "SOAP-fuse-v1.26",
                            "TrinityFusion-UC" => "TrinityFusion-UC-v0.2.0",
                            "ChimeraScan" => "ChimeraScan-v0.4.5",
                            "TrinityFusion-D" => "TrinityFusion-D-v0.2.0",
    );



# print header:
print join("\t", "Sample", "Tool", "Fusion_isoform", "Split_reads", "Spanning_frags") . "\n";

foreach my $sample (sort keys %data) {

    foreach my $prog (sort {lc($a) cmp lc($b)} keys %{$data{$sample}}) {
        
        my @fusions;
        foreach my $fusion (sort keys %{$data{$sample}->{$prog}}) {
            
            my @candidates = @{$data{$sample}->{$prog}->{$fusion}};
            @candidates = reverse sort {$a->{sum}<=>$b->{sum}
                                        ||
                                            $a->{J} <=> $b->{J} } @candidates;
            
            my $top_candidate = shift @candidates;
            push (@fusions, $top_candidate);
        }
        
        @fusions = reverse sort {$a->{sum}<=>$b->{sum}
                                 ||
                                     $a->{J} <=> $b->{J} } @fusions;
        
        foreach my $fusion (@fusions) {
            my $sample = $fusion->{sample};
            my $prog = $fusion->{prog};
            if (exists $fusion_prog_renaming{$prog}) {
                $prog = $fusion_prog_renaming{$prog};
            }
            my $fusion_name = $fusion->{fusion};
            my $J = $fusion->{J};
            my $S = $fusion->{S};


            print join("\t", $sample, $prog, $fusion_name, $J, $S) . "\n";
            
        }

    }
}


exit(0);

