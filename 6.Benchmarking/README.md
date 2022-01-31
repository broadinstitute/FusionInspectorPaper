

# data

FusionInspector results incorporated with earlier benchmarking results from Haas et al. Genome Biology 2019

FusionInspector results for breast cancer cell lines screened available at: https://data.broadinstitute.org/Trinity/FusionInspector_Paper/FI_benchmarking/FI_panel_breastcancer_Edgren/


# analysis


Generate matrix of fusions found vs. methods applied.

```
./fusion_call_to_matrix.pl  edgren.combined.tsv > edgren.found.matrix
```

>for below, upsetR version to be installed is this custom version: https://github.com/brianjohnhaas/UpSetR

```
./plot_upsetR.R edgren.found.matrix  
```


See: FI_edgren_results.pdf

