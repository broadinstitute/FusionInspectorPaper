# Supplemental Code and Data for our FusionInspector Paper

Included here are the supplemental code and data used for analyses and generating figures in our paper:

"Targeted in silico characterization of fusion transcripts in tumor and normal tissues via FusionInspector" (2021) by Brian J. Haas, Alexander Dobin, Mahmoud Ghandi, Anne Van Arsdale, Timothy Tickle, James T. Robinson, Riaz Gillani, Simon Kasif, and Aviv Regev

The structure of this work can be divided into the following order:

- (A) Initial STAR-Fusion scan of TCGA and GTEx for fusion transcripts:  TCGA (10,133 samples) and GTEx (8375 samples) are first analyzed using STAR-Fusion and recurrent fusion transcripts are identified across tumor and normal samples.

- (B) We benchmarked FusionInspector using two modes: (1) as a post-process to running STAR-Fusion, and so only STAR-Fusion predictions were analyzed, and (2) providing fusion predictions from any of over 20 different prediction methods. This analysis was incorporated into our [Fusion Benchmarking Toolkit](https://github.com/fusiontranscripts/FusionBenchmarking) and inputs and FusionInspector outputs are provided [here](https://data.broadinstitute.org/Trinity/FusionInspector_Paper/FI_benchmarking/). Overall, FusionInspector is demonstrated to perform well and improves upon the overall accuracy of STAR-Fusion by retaining sensitivity while improving on specificity (FusionInspector cannot in this mode identify new fusions not first identified by STAR-Fusion).  FusionInspector also performs at high accuracy when given target fusions accumulated from numerous prediction methods, and in this mode can validate fusions not initially called by STAR-Fusion.

- (C) FusionInspector exploration of recurrent fusions: FusionInspector is used to further examine a subset of samples including 628 TCGA and 530 GTEx identified as having occurrences of recurrent fusions of interest. FusionInspector captures sequence and expression features for each of these fusion instances among smaples, and we use those attributes to generate clusters of fusions having similar features. Interestingly, we find a cluster (C4) of fusions that is heavily enriched for known cancer fusions (found in the COSMIC fusion database). We also find smaller clusters that have features consistent with low levels of cis- or trans-splicing from highly expresed fusion partners or likely biological or experimental artifacts.

- (D) Targeted screening of select C4 fusions: We selected a subset of 231 fusion gene pairs with at least one occurrence in C4, at least three occurrences overall, and with at least 30% of those occurrences found in clusters containing other COSMIC fusions. This was further supplemented with 5 additional COSMIC fusions not found in C4, giving a total of 236 fusions. Using FusionInspector in its screening modality, we targeted 2764 TCGA and 1009 GTEx samples expected to have occurrences of these 236 fusions, and each sample was screened with this exact same set of 236 fusion genes given as a panel. This yielded thousands of newly characterized occurrences of these fusions via FusionInspector. To predict which fusion clusters individual fusion isoforms correspond to from (B), we built and trained a random forest classifier using the fusion features and cluster lables from (B) and applied this classifier to fusions identified here in (C) - allowing us to classify individual instances as COSMIC-like, artifact-like, or other cateogory. From these predictions, we were able to glean more insights into the general characteristics of these 236 fusion pairs, allowing us to better prioritize newly identified fusions as COSMIC-like or to discount others as more enriched in artifact-like features. We identify examples of understudied fusions that may deserve more attention in future studies of fusion transcripts in tumor and normal tissues.

# Supplemental Data

- Initial STAR-Fusion predictions for TCGA and GTEx (from (A) above):
  - [data/TCGA_n_GTEx.STAR-Fusion.v1.7.sample_list](data/TCGA_n_GTEx.STAR-Fusion.v1.7.sample_list) : lists of samples targeted
  - [data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.decorated.tsv.gz](data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.decorated.tsv.gz) : STAR-Fusion isoform predictions
  - [data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.stats.tsv.gz](data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.stats.tsv.gz) : summary counts of occurrences in tumor or normal samples and tumor enrichment log(T/N).

- FusionInspector analysis of recurrent fusions in 628 TCGA and 530 GTEx (from (C) above):
  - [data/FusionInspector.v2.4.0.examine_recurrents.sample_list](data/FusionInspector.v2.4.0.examine_recurrents.sample_list) : list of samples targeted
  - [data/FusionInspector.v2.4.0.examine_recurrents.tsv.gz](data/FusionInspector.v2.4.0.examine_recurrents.tsv.gz) : FusionInspector predictions, annotated for UMAP coordinates, fusion cluster identity, and fusion cluster annotation

- FusionInspector targeted screening of a panel of 236 prioritized fusions across 2764 TCGA and 1009 GTEx samples
  - [data/FusionInspector.v2.4.0.C4_targeted_fusions.sample_list](data/FusionInspector.v2.4.0.C4_targeted_fusions.sample_list) : list of samples targeted
  - [data/FusionInspector.v2.4.0.C4_targeted_fusions.tsv.gz](data/FusionInspector.v2.4.0.C4_targeted_fusions.tsv.gz)

# Supplemental Code

- [0.Decorate_input_files/Decorate_input_files.Rmd](0.Decorate_input_files/Decorate_input_files.Rmd) : Preprocessing of the STAR-Fusion predictions to include annotations (additional columns) to faclitate downstream data analyses.

- [1.Examine_TCGA_n_GTEx_StarF1.7/STAR-Fusion_v1.7_TCGA_n_GTEx.Rmd](1.Examine_TCGA_n_GTEx_StarF1.7/STAR-Fusion_v1.7_TCGA_n_GTEx.Rmd) : Analysis of the preponderance of fusions in TCGA tumor/normal and GTEx normal samples from the STAR-Fusion survey in (A) above.
  - yields Figure 4 and Figure S4
  
- [1.Examine_TCGA_n_GTEx_StarF1.7/Tumor_vs_Normal_Fusion_Expression.Rmd](1.Examine_TCGA_n_GTEx_StarF1.7/Tumor_vs_Normal_Fusion_Expression.Rmd) : fusions found in more than 3 tumor and more than 3 normal samples are tested for differences in fusion expression value (FFPM) using t-tests and Wilcoxon rank sum tests, generating output: [data/TCGA_n_GTEx.STAR-Fusion.v1.7.tumor_normal_fusion_expression_comparison_stats.tsv.gz](data/TCGA_n_GTEx.STAR-Fusion.v1.7.tumor_normal_fusion_expression_comparison_stats.tsv.gz)

- [2.Scaling_n_Clustering_Fusions/Scaling_and_Clustering_Fusions.Rmd](2.Scaling_n_Clustering_Fusions/Scaling_and_Clustering_Fusions.Rmd) : demonstration of the workflow used to scale fusion attributes, define fusion clusters, and analyze the COSMIC fusion content of those clusters.



