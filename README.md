# Supplemental Code and Data for our FusionInspector Paper

Included here are the supplemental code and data used for analyses and generating figures in our paper:

"Targeted in silico characterization of fusion transcripts in tumor and normal tissues via FusionInspector" (2022) by Brian J. Haas, Alexander Dobin, Mahmoud Ghandi, Anne Van Arsdale, Timothy Tickle, James T. Robinson, Riaz Gillani, Simon Kasif, and Aviv Regev

The structure of this work can be divided into the following order:

- (A) Initial STAR-Fusion scan of TCGA and GTEx for fusion transcripts:  TCGA (10,133 samples) and GTEx (8375 samples) are first analyzed using STAR-Fusion and recurrent fusion transcripts are identified across tumor and normal samples.


- (B) FusionInspector exploration of recurrent fusions: FusionInspector is used to further examine a subset of samples including 628 TCGA and 530 GTEx identified as having occurrences of recurrent fusions of interest. FusionInspector captures sequence and expression features for each of these fusion instances among smaples, and we use those attributes to generate clusters of fusions having similar features. Interestingly, we find a cluster (C4) of fusions that is heavily enriched for known cancer fusions (found in the COSMIC fusion database). We also find smaller clusters that have features consistent with low levels of cis- or trans-splicing from highly expresed fusion partners or likely biological or experimental artifacts.

- (C) Targeted screening of select C4 fusions: We selected a subset of 231 fusion gene pairs with at least one occurrence in C4, at least three occurrences overall, and with at least 30% of those occurrences found in clusters containing other COSMIC fusions. This was further supplemented with 5 additional COSMIC fusions not found in C4, giving a total of 236 fusions. Using FusionInspector in its screening modality, we targeted 2764 TCGA and 1009 GTEx samples expected to have occurrences of these 236 fusions, and each sample was screened with this exact same set of 236 fusion genes given as a panel. This yielded thousands of newly characterized occurrences of these fusions via FusionInspector. To predict which fusion clusters individual fusion isoforms correspond to from (B), we built and trained a random forest classifier using the fusion features and cluster lables from (B) and applied this classifier to fusions identified here in (C) - allowing us to classify individual instances as COSMIC-like, artifact-like, or other cateogory. From these predictions, we were able to glean more insights into the general characteristics of these 236 fusion pairs, allowing us to better prioritize newly identified fusions as COSMIC-like or to discount others as more enriched in artifact-like features. We identify examples of understudied fusions that may deserve more attention in future studies of fusion transcripts in tumor and normal tissues.


- (D) Application of FusionInspector to all 1366 TARGET pediatric cancer RNA-seq samples (1233 participants). STAR-Fusion was first used to identify candidate fusions and FusionInspector was run subsequenetly to in silico validate and further characterize fusion transcripts. Here we find again that COSMIC fusions (albeit including fusions specific to pediatric cancer samples) are enriched among a single cluster with attributes matching to the earlier defined C4 fusion cluster. We further investigate recurrent fusions represented within that cluster and identify additional novel fusion candidates potentially relevant to pediatric cancers.

 
    
# Supplemental Data

- Initial STAR-Fusion predictions for TCGA and GTEx (from (A) above):
  - [data/TCGA_n_GTEx.STAR-Fusion.v1.7.sample_list](data/TCGA_n_GTEx.STAR-Fusion.v1.7.sample_list) : lists of samples targeted
  - [data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.decorated.tsv.gz](data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.decorated.tsv.gz) : STAR-Fusion isoform predictions
  - [data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.stats.tsv.gz](data/TCGA_n_GTEx.STAR-Fusion.v1.7.fusion_preds.stats.tsv.gz) : summary counts of occurrences in tumor or normal samples and tumor enrichment log(T/N).

- FusionInspector analysis of recurrent fusions in 628 TCGA and 530 GTEx (from (B) above):
  - [data/FusionInspector.v2.4.0.examine_recurrents.sample_list](data/FusionInspector.v2.4.0.examine_recurrents.sample_list) : list of samples targeted
  - [data/FusionInspector.v2.4.0.examine_recurrents.tsv.gz](data/FusionInspector.v2.4.0.examine_recurrents.tsv.gz) : FusionInspector predictions, annotated for UMAP coordinates, fusion cluster identity, and fusion cluster annotation

- FusionInspector targeted screening of a panel of 236 prioritized fusions across 2764 TCGA and 1009 GTEx samples (from (C) above):
  - [data/FusionInspector.v2.4.0.C4_targeted_fusions.sample_list](data/FusionInspector.v2.4.0.C4_targeted_fusions.sample_list) : list of samples targeted
  - [data/FusionInspector.v2.4.0.C4_targeted_fusions.tsv.gz](data/FusionInspector.v2.4.0.C4_targeted_fusions.tsv.gz)


- STAR-Fusion predictions and FusionInspector in silico validations for TARGET pediatric cancer fusions (from (D) above):
    - [data/TARGETdb.sample_info.tsv](data/TARGETdb.sample_info.tsv) : list of samples targeted including sample metadata
    - [data/STAR-Fusion.v1.10.0.TARGETdb.tsv.gz](data/STAR-Fusion.v1.10.0.TARGETdb.tsv.gz) : STAR-Fusion fusion predictions
    - [data/FusionInspector.v2.4.0.TARGET.tsv.gz](data/FusionInspector.v2.4.0.TARGET.tsv.gz) : FusionInspector fusion in silico validations
    - [dataFusionInspector.v2.4.0.TARGET.decorated.tsv.gz](FusionInspector.v2.4.0.TARGET.decorated.tsv.gz) : FusionInspector fusion results decorated with sample metadata, umap coordinates, and various fusion annotations.
    
    
# Supplemental Code

- [0.Decorate_input_files/Decorate_input_files.Rmd](0.Decorate_input_files/Decorate_input_files.Rmd) : Preprocessing of the TCGA & GTEx STAR-Fusion predictions to include annotations (additional columns) to faclitate downstream data analyses.

- [1.Examine_TCGA_n_GTEx_StarF1.7/STAR-Fusion_v1.7_TCGA_n_GTEx.Rmd](1.Examine_TCGA_n_GTEx_StarF1.7/STAR-Fusion_v1.7_TCGA_n_GTEx.Rmd) : Analysis of the preponderance of fusions in TCGA tumor/normal and GTEx normal samples from the STAR-Fusion survey in (A) above.
  - yields Figure 4 and Figure S4
  
- [1.Examine_TCGA_n_GTEx_StarF1.7/Tumor_vs_Normal_Fusion_Expression.Rmd](1.Examine_TCGA_n_GTEx_StarF1.7/Tumor_vs_Normal_Fusion_Expression.Rmd) : fusions found in more than 3 tumor and more than 3 normal samples are tested for differences in fusion expression value (FFPM) using t-tests and Wilcoxon rank sum tests, generating output: [data/TCGA_n_GTEx.STAR-Fusion.v1.7.tumor_normal_fusion_expression_comparison_stats.tsv.gz](data/TCGA_n_GTEx.STAR-Fusion.v1.7.tumor_normal_fusion_expression_comparison_stats.tsv.gz)

- [2.Scaling_n_Clustering_Fusions/Scaling_and_Clustering_Fusions.Rmd](2.Scaling_n_Clustering_Fusions/Scaling_and_Clustering_Fusions.Rmd) : demonstration of the workflow used to scale fusion attributes, define fusion clusters, and analyze the COSMIC fusion content of those clusters.

- [3.Annotate_Leiden_Fusion_Clusters/3.1.Examine_Leiden_Res_Cosmic_Enrichment](3.Annotate_Leiden_Fusion_Clusters/AnnotateLeidenClusters.Rmd) : Examines clusters of fusions derived from (B) above, annotates the clusters according to COSMIC-like, artifact-like, or other, and explores characteristics of C4 and COSMIC fusions enriched in C4.
  - yields Figure 5 and S6
  
- [3.Annotate_Leiden_Fusion_Clusters/3.1.Examine_Leiden_Res_Cosmic_Enrichment/ExamineLeidenResolutionCosmicEnrichment.Rmd](3.Annotate_Leiden_Fusion_Clusters/3.1.Examine_Leiden_Res_Cosmic_Enrichment/ExamineLeidenResolutionCosmicEnrichment.Rmd) : Exploration of Leiden resolution parameter on fusion clustering and COSMIC fusion enrichments.
  - yields Figure S19
  
- [4.Targeted_FI_to_Cluster4/C4_targeted_FI.Rmd](4.Targeted_FI_to_Cluster4/C4_targeted_FI.Rmd) : Examines characteristics of the 236 fusion genes based on occurrences identified in (D) above.
   - running 'make_Figures.Rmd' after the above yields Figures 6 and S7
   
- [5.Individual_Fusions_of_Interest](5.Individual_Fusions_of_Interest) : Includes explorations of specific gene fusions, as detailed below.
  - [5.Individual_Fusions_of_Interest/Variety_of_indiv_fusions.Rmd](5.Individual_Fusions_of_Interest/Variety_of_indiv_fusions.Rmd) : includes studies of TMPRSS2--ERG, FGFR3--TACC3, CCAT1--CASC8, VCL--ADK, PVT1--MYC, BCR--ABL1, VTI1A--TCF7L2, CELA3A--CPA2, SSX-SS18, TFG--GPR128 and yields corresponding supplementary figures.
  - [5.Individual_Fusions_of_Interest/COL1A1--FN1.Rmd](5.Individual_Fusions_of_Interest/COL1A1--FN1.Rmd) : COL1A1--FN1 in CAFs, yields Figure S3
  - [5.Individual_Fusions_of_Interest/EML4--ALK.Rmd](5.Individual_Fusions_of_Interest/EML4--ALK.Rmd) : EML4--ALK, yields Figure 3a
  - [5.Individual_Fusions_of_Interest/FSIP1--RP11-624L4.1.Rmd](5.Individual_Fusions_of_Interest/FSIP1--RP11-624L4.1.Rmd) : FSIP1--RP11-624L4.1, yields Figure S17
  - [5.Individual_Fusions_of_Interest/KANSL1--ARL17.Rmd](5.Individual_Fusions_of_Interest/KANSL1--ARL17.Rmd) : KANSL1--ARL17, yields Figure S11
  - [5.Individual_Fusions_of_Interest/KRT13--KRT4.Rmd](5.Individual_Fusions_of_Interest/KRT13--KRT4.Rmd) : KRT13--KRT4, yields Figure 3b

- [6.Benchmarking](6.Benchmarking/) : Benchmarking results for breast cancer cell lines.  See README.md for details.

- [7. Analysis of TARGET pediatric cancer fusions]
    - [7.TARGET_cancer_db_FI_application/TARGET_fusion_analysis.Rmd](7.TARGET_cancer_db_FI_application/TARGET_fusion_analysis.Rmd) : overview of pediatric cancer fusions identified via STAR-Fusion and FusionInspector, with a focus on exploring which COSMIC fusions were found and their distribution among the pediatric cancer types. Yields Figure S15.
    - [7.TARGET_cancer_db_FI_application/7.0.ClusterTargetFusions/cluster_TARGETdb_fusions.Rmd](7.TARGET_cancer_db_FI_application/7.0.ClusterTargetFusions/cluster_TARGETdb_fusions.Rmd) : Clustering of TARGET pediatric cancer fusion variants according to FusionInspector attributes.
    - [7.TARGET_cancer_db_FI_application/7.1.DecorateTargetFusions/DecorateTargetFusions.Rmd](7.TARGET_cancer_db_FI_application/7.1.DecorateTargetFusions/DecorateTargetFusions.Rmd) : coded used to decorate the FusionInspector fusions with the annotations and meta data.
    - [7.2.ExamineClusteredTARGETdbFusions/Examine_Clustered_TARGETdb_Fusions.Rmd](7.2.ExamineClusteredTARGETdbFusions/Examine_Clustered_TARGETdb_Fusions.Rmd) : analysis of TARGET pediatric cancer fusion clusters, including COSMIC fusion content and enrichment. Yields Figures 7, 8, and S16.
     


