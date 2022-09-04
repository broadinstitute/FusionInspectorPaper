


annotate_leiden_clusters = function(fusion_data) {


    cosmic_peak_enriched_cluster = 4
    expr_microH_RT_artifact_clusters =  c(47,20,41,15)
    high_FAR_microH_bioinf_artifact_clusters = c(57,56,60)

    fusion_data = fusion_data %>%

        mutate(fusion_cluster_att = ifelse(leiden %in% cosmic_like_clusters,
                                           "cosmic-like", "NA")) %>%
        mutate(fusion_cluster_att = ifelse(leiden %in% expr_microH_RT_artifact_clusters, "expr_microH_RT_artifact?", fusion_cluster_att)) %>%
        mutate(fusion_cluster_att = ifelse(leiden %in% high_FAR_microH_bioinf_artifact_clusters, "high_FAR_microH_bioinf_artifact?", fusion_cluster_att)) %>%
        mutate(fusion_cluster_att = ifelse(leiden == cosmic_peak_enriched_cluster, "cosmic-peak-enriched", fusion_cluster_att))


    return(fusion_data)
}

