


fusion_brkpt_expression_homology_plotter = function(fusion_name, fusion_preds_tsv, microhomologies_tsv) {

    fusion_preds = read.table(fusion_preds_tsv, header=T, row.names=NULL, sep="\t", stringsAsFactors=F, com='')
    colnames(fusion_preds) = str_replace(colnames(fusion_preds), "^X\\.", "")


    if ('fusion_name' %in% colnames(fusion_preds) ) {
        fusion_preds = fusion_preds %>% rename(FusionName = fusion_name)
    }

    if ('sample_name' %in% colnames(fusion_preds) ) {
        fusion_preds = fusion_preds %>% rename(sample = sample_name)
    }

    ## add splice type info for consenus vs. non-consensus dinucleotides

    fusion_preds = fusion_preds %>% mutate(SpliceDinuc=ifelse(LeftBreakDinuc %in% c("GT", "GC") & RightBreakDinuc == "AG", "Consensus", "Non"))

    grouped_fusion_preds = split(x=fusion_preds, f=fusion_preds$FusionName)
    fusion_names = names(grouped_fusion_preds)


    ## parse microhomolgy data
    microhomologies = read.table(microhomologies_tsv, header=T, row.names=NULL, sep="\t", stringsAsFactors=F)
    grouped_microhomologies = split(x=microhomologies, f=microhomologies$contig)


    fusion_preds_data = grouped_fusion_preds[[fusion_name]]
    fusion_pair_microhomologies = grouped_microhomologies[[fusion_name]]

    all_brkpt_plot_ffpm = breakpoint_plot(fusion_preds_data, fusion_pair_microhomologies,
                                      title=paste0(fusion_name, " FFPM"), "FFPM")


    return(all_brkpt_plot_ffpm)

}


