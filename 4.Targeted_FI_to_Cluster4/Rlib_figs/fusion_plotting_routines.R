addSmallLegend <- function(myPlot, pointSize = 1.5, textSize = 5, spaceLegend = 0.3) {

    # original settings: pointSize = 0.5, textSize = 3, spaceLegend = 0.1

    ## from: https://stackoverflow.com/questions/52297978/decrease-overal-legend-size-elements-and-text

    myPlot +
        guides(shape = guide_legend(override.aes = list(size = pointSize)),
               color = guide_legend(override.aes = list(size = pointSize))) +
        theme(legend.title = element_text(size = textSize),
              legend.text  = element_text(size = textSize),
              legend.key.size = unit(spaceLegend, "lines"))
}



plot_cosmic_like_cluster_fraction = function(fusion_list) {

    cosmic_cluster_like_fraction_plot = fusion_annot_class_stats_gathered %>%
        filter(fusion_name %in% fusion_list) %>%
        mutate(frac_fusions = ifelse(frac_fusions > 0, frac_fusions, NA) ) %>%
        ggplot(aes(x=fusion_name, y=cluster_annot_type, fill=frac_fusions)) +
        geom_tile() +
    theme_bw() +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
        theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
        ylab("Cluster Type") +
        theme(axis.text.y = element_text(size=rel(0.7)))  +
        scale_fill_continuous(high = "#132B43", low = "#56B1F7", na.value="white")

    return(cosmic_cluster_like_fraction_plot)
}


plot_frame_effect_fractions = function(fusion_list) {

    frame_effect_fractions_plot = orig_STARF_fusion_preds %>%
        filter(fusion_name %in% fusion_list) %>%
        filter(is_primary) %>%
        group_by(fusion_name, PROT_FUSION_TYPE) %>%
        tally() %>%
        mutate(frac=prop.table(n)) %>%
        #complete(PROT_FUSION_TYPE = c('INFRAME', 'INCL_NONCODING', 'FRAMESHIFT'), fill=list(n=0, frac=0.0))  %>%
        ggplot(aes(x=fusion_name, y=PROT_FUSION_TYPE, fill=frac)) +
        geom_tile() +
        theme_bw() +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
        theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
        ylab("Coding Effect") +
        theme(axis.text.y = element_text(size=rel(0.7))) +
        scale_fill_continuous(high = "#132B43", low = "#56B1F7", na.value="white")

    return(frame_effect_fractions_plot)

}


plot_fusion_structure_types = function(fusion_list) {

    fusion_structure_types_plot = orig_STARF_fusion_preds %>% filter(fusion_name %in% fusion_list) %>%
        select(fusion_name, structure_type) %>% unique() %>%
       ggplot(aes(x=fusion_name, y=0, fill=structure_type)) + geom_tile() +
       theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
          axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()
          )

    return(fusion_structure_types_plot)

}


plot_tcga_sample_fractions = function(fusion_list) {

    tcga_type_fractions = orig_STARF_fusion_preds %>% filter(fusion_name %in% fusion_list) %>%
        filter(data_class == "TCGA" & tumor_or_normal == "tumor") %>%
        filter(is_primary) %>%
        group_by(fusion_name, tissue_type) %>%
        tally(name='tissue_count') %>%
        group_by(fusion_name) %>%
        mutate(tissue_fraction = tissue_count / sum(tissue_count)) %>% select(-tissue_count)



    ## ensure all ranked fusions are represented.
    ranked_fusions_table = data.frame(fusion_name=factor(fusion_list, levels=fusion_list), dummy=T)

    tcga_type_fractions = full_join(tcga_type_fractions, ranked_fusions_table, by='fusion_name') %>%
        select(-dummy)

    tcga_type_fractions_plot = tcga_type_fractions %>%
        ggplot(aes(x=fusion_name, y=tissue_type, fill=tissue_fraction)) + geom_tile() +
    theme_bw() +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
        theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
        theme(axis.text.y = element_text(size=rel(0.7))) +  scale_fill_continuous(high = "#132B43", low = "#56B1F7") +
        ylab("TCGA")

    return(tcga_type_fractions_plot)

}


plot_gtex_sample_fractions = function(fusion_list) {

    gtex_type_fractions = orig_STARF_fusion_preds %>% filter(fusion_name %in% fusion_list) %>%
        filter(data_class == "GTEx") %>%
        filter(is_primary) %>%
        group_by(fusion_name, tissue_type) %>%
        tally(name='tissue_count') %>%
        group_by(fusion_name) %>%
        mutate(tissue_fraction = tissue_count / sum(tissue_count)) %>%
        select(-tissue_count)


    ## ensure all ranked fusions are represented.
    ranked_fusions_table = data.frame(fusion_name=factor(fusion_list, levels=fusion_list), dummy=T)

    gtex_type_fractions = full_join(gtex_type_fractions, ranked_fusions_table, by='fusion_name') %>%
        select(-dummy)


    gtex_type_fractions_plot = gtex_type_fractions %>% filter(fusion_name %in% fusion_list) %>%
        ggplot(aes(x=fusion_name, y=tissue_type, fill=tissue_fraction)) + geom_tile() +
    theme_bw() +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
       theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
        theme(axis.text.y = element_text(size=rel(0.7))) + scale_fill_continuous(high = "#132B43", low = "#56B1F7") +
        ylab("GTEx")

  return(gtex_type_fractions_plot)

}


plot_IN_COSMIC_indicator = function(fusion_list) {

    plot_data = orig_STARF_fusion_preds %>% filter(fusion_name %in% fusion_list) %>%
        select(fusion_name, cosmic) %>% unique()

    cosmic_indication_plot = ggplot()

    if (nrow(plot_data) > 0) {

        cosmic_indication_plot = plot_data %>%
            mutate(in_cosmic = ifelse(cosmic, TRUE, NA)) %>%
            ggplot(aes(x=fusion_name, y=TRUE, fill=in_cosmic)) + geom_tile() +
            theme_bw() +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
            theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
            theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y=element_blank()) +
            scale_fill_manual(na.value="white", values="purple")
                                        #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=rel(0.5)))

    }


    return(cosmic_indication_plot)

}

plot_IN_SIGNIF_EXPR_indicator = function(fusion_list, max_w_p = 0.05, min_fold_change = 1.0) {


    data_to_plot = orig_STARF_tumor_normal_stats %>% filter(fusion_name %in% fusion_list) %>%
        select(fusion_name, w_p_BH, fold_change)


    signif_expr_indication_plot = ggplot()

    if (nrow(data_to_plot) > 0) {

        signif_expr_indication_plot = data_to_plot %>%
            mutate(signif_expr = ifelse( (! is.na(w_p_BH)) & w_p_BH < max_w_p & fold_change > min_fold_change, TRUE, NA)) %>%
            ggplot(aes(x=fusion_name, y=TRUE, fill=signif_expr)) + geom_tile() +
    theme_bw() +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
            theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
            theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y=element_blank()) +
            scale_fill_manual(na.value="white", values="orange")
        #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=rel(0.5)))
    }

    return(signif_expr_indication_plot)

}




plot_tumor_normal_logratio = function(fusion_list, remove_xlab=FALSE) {

    # convert to log for plotting
    data_to_plot_selected = orig_STARF_tumor_normal_stats %>%
        filter(fusion_name %in% fusion_list) %>%
        mutate(normal = log(normal+1), tumor = log(tumor+1)) %>%
        mutate(normal = -1 * normal) %>%
        gather(key=tumor_or_normal, value=sample_count, normal, tumor)

    max_logTN = max(abs(data_to_plot_selected$logTN))
    #message("max logTN: ", max_logTN)

    max_sample_count = max(data_to_plot_selected$sample_count)
    min_sample_count = min(data_to_plot_selected$sample_count)


    ## plot Tumor / Normal sample counts.
    p = data_to_plot_selected %>%
        ggplot(aes(x=fusion_name, y=sample_count, fill=tumor_or_normal)) + geom_col()

    ## plot logTN
    p = p + geom_col(data=data_to_plot_selected, aes(y=logTN), fill='gray', alpha=0.5)

    ## custom y axis
    break_labels = (c(1, 10, 100, 1000, 5000))
    break_positions = log(break_labels+1)

    top_n_bottom_labels = c(break_labels, 0, break_labels)
    top_n_bottom_break_positions = c(break_positions, 0, -1*break_positions)

    p = p + scale_y_continuous(breaks = top_n_bottom_break_positions, labels = top_n_bottom_labels) +
        theme(axis.text.y = element_text(size=rel(0.7))) +
        ylab("#samples")

    p = p + theme_bw() +
            theme(panel.border = element_blank(), panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

    if (remove_xlab) {
        p = p + theme(axis.title.x=element_blank(),
                      axis.text.x=element_blank() )

    } else {
        p = p + theme(axis.text.x = element_text(angle = 90,
                                                 vjust = 0.5,
                                                 hjust=1,
                                                 size=rel(0.5)))
    }

    return(p)
}



plot_ranked_fusions = function(fusion_list, title="gimme a title", remove_xlab = TRUE) {


  cosmic_cluster_like_fraction_plot = plot_cosmic_like_cluster_fraction(fusion_list)
  plot(cosmic_cluster_like_fraction_plot)


  # reading frame fusion effect
  frame_effect_fractions_plot = plot_frame_effect_fractions(fusion_list)
  plot(frame_effect_fractions_plot)

  # fusion structure annotations (ie. intra- vs inter- chromosomal, etc)
  fusion_structure_types_plot = plot_fusion_structure_types(fusion_list)
  plot(fusion_structure_types_plot)

  # tcga tissue type plot
  tcga_type_fractions_plot = plot_tcga_sample_fractions(fusion_list)
  plot(tcga_type_fractions_plot )

  # gtex tissue type plot

  gtex_type_fractions_plot = plot_gtex_sample_fractions(fusion_list)
  plot(gtex_type_fractions_plot)

  cosmic_indicator_plot = plot_IN_COSMIC_indicator(fusion_list)

  signif_expr_indicator_plot = plot_IN_SIGNIF_EXPR_indicator(fusion_list)


  # fusion T/N ranking plot
  p = plot_tumor_normal_logratio(fusion_list, remove_xlab)
  plot(p)


  # add small legends to each:
  cosmic_cluster_like_fraction_plot = addSmallLegend(cosmic_cluster_like_fraction_plot)
  frame_effect_fractions_plot = addSmallLegend(frame_effect_fractions_plot)
  fusion_structure_types_plot = addSmallLegend(fusion_structure_types_plot)
  tcga_type_fractions_plot = addSmallLegend(tcga_type_fractions_plot)
  gtex_type_fractions_plot = addSmallLegend(gtex_type_fractions_plot)
  cosmic_indicator_plot = addSmallLegend(cosmic_indicator_plot)
  signif_expr_indicator_plot = addSmallLegend(signif_expr_indicator_plot)
  p = addSmallLegend(p)



  # grid plot

  pg = plot_grid(cosmic_cluster_like_fraction_plot,
                 frame_effect_fractions_plot,
                 fusion_structure_types_plot,
                 tcga_type_fractions_plot,
                 gtex_type_fractions_plot,
                 cosmic_indicator_plot,
                 signif_expr_indicator_plot,
                 p,
                 nrow=8,
                 align='v',
                 axis='lr',
                 rel_heights = c(0.10, 0.07, 0.03, 0.25, 0.25, 0.03, 0.03, 0.2)
                 )

   return(pg)

}


batch_ranked_fusion_plots = function(fusion_list, num_show_per_plot=50, remove_xlab=FALSE, imgdir=NULL) {

    ## note, incoming fusion list should be sorted according to how they should be plotted.

  num_ranked_fusions = length(fusion_list)

  for (i in seq(1, num_ranked_fusions, num_show_per_plot)) {

    j = min(i+num_show_per_plot, num_ranked_fusions)
    fusions_want = fusion_list[i:j]
    #message("fusions want: ", fusions_want)
    title = paste0("fusion ranks: ", i, "-", j)
    pg = plot_ranked_fusions(fusions_want, title, remove_xlab)
    plot(pg)


    if (! is.null(imgdir)) {

        if (! dir.exists(imgdir)) {
            dir.create(imgdir)
        }

        png_filename = paste0(imgdir, "/fusions_ranked.", i, '-', j, ".plot.png")
        ggsave(png_filename, pg, width=8, height=12)

        pdf_filename = paste0(imgdir, "/fusions_ranked.", i, '-', j, ".plot.pdf")
        ggsave(pdf_filename, pg, width=8, height=12)


     }
  }

}

