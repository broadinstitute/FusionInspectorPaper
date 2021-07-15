


annotate_leiden_clusters = function(fusion_data) {


    cosmic_peak_enriched_cluster = 4
    cosmic_like_clusters = c(6, 39, 38, 23, 8, 54, 13, 46, 34, 21, 7, 26, 10, 12, 3, 18)
    expr_microH_RT_artifact_clusters =  c(47,20,41,15)
    high_FAR_microH_bioinf_artifact_clusters = c(57,56,60)
    high_counter_evidence_clusters = c(49,51)


    fusion_data = fusion_data %>%

        mutate(fusion_cluster_att = ifelse(leiden %in% cosmic_like_clusters,
                                           "cosmic-like", "NA")) %>%
        mutate(fusion_cluster_att = ifelse(leiden %in% expr_microH_RT_artifact_clusters, "expr_microH_RT_artifact?", fusion_cluster_att)) %>%
        mutate(fusion_cluster_att = ifelse(leiden %in% high_FAR_microH_bioinf_artifact_clusters, "high_FAR_microH_bioinf_artifact?", fusion_cluster_att)) %>%
        mutate(fusion_cluster_att = ifelse(leiden %in% high_counter_evidence_clusters, "high_counter_evidence", fusion_cluster_att)) %>%
        mutate(fusion_cluster_att = ifelse(leiden == cosmic_peak_enriched_cluster, "cosmic-peak-enriched", fusion_cluster_att))


    return(fusion_data)
}

