library(data.table)
library(BuenColors)
library(BSgenome.Hsapiens.UCSC.hg19)
library(Gviz)
library(ggrepel)
library(gglabeller)
library(ggplot2)
library(GGally)
library(dplyr)
library(stringr)

sz <- 1.5
width=3
locustheme <-  theme(plot.title = element_text(size=sz*4,hjust = 0.50,face="bold"),
                     text=element_text(size=sz*4),
                     axis.title.x = element_blank(),
                     axis.text.x = element_blank(),
                     axis.ticks.x = element_blank(),
                     legend.position = c(.05, .9),
                     legend.justification = c("left", "top"),
                     legend.box.just = "left",
                     legend.margin = margin(1, 1, 1, 1),
                     legend.direction = "horizontal",
                     legend.key.size = unit(width/30, "in"),
                     legend.text = element_text(size=sz*2),
                     legend.title = element_text(face="bold",size=sz*2))

###################################################################################################
# CCND3
rsid <- "rs9349205"
trait <- "RBC_COUNT"
locuszoom <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs9349205/final_locuslist.",trait,".txt"))

# Tag the two causal variants identified from finemapping
locuszoom$sentinel <- ifelse(locuszoom$RSQR ==1 | 
                               locuszoom$SNP =="rs112233623", "yes", "no")

p1 <- ggplot(locuszoom,aes(POS/(10^6),-log10(PVAL))) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="-log10(P-value)") + 
  geom_point(data=subset(locuszoom,sentinel=="yes"),
             aes(x=POS/(10^6),y=-log10(PVAL)),
             fill="yellow",shape=21,size=sz)+
  geom_label_repel(data = subset(locuszoom, sentinel=="yes"),
    aes(label = paste(SNP,RSQR,sep=" - ")),
    size = sz,
    force=TRUE,
    nudge_x = 0.75) 

dir="/Users/erikbao/Dropbox (MIT)/HMS/Sankaran Lab/ATACSeq_GWAS/Examples/CCND3/RBC_COUNT"
ggsave("rs9349205_locusplot.pdf", plot = p1, device = NULL, path = dir,
       scale = 1, width = width, height=width*1/2, units = "in",
       dpi = 300, limitsize = TRUE)

################################################################################################
####Conditional Locus plot (conditioning on rs9349205)
rsid <- "rs112233623"
trait <- "RBC_COUNT"
conditional <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs9349205/conditional_sumstats.rs9349205.",trait,".txt")) %>% arrange(PVAL)
rsqre <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs112233623/locuszoom_ld.",trait,".txt"))
conditional <- merge(conditional, rsqre, by.x="SNP", by.y="snp1")
conditional$sentinel <- ifelse(conditional$rsquare ==1 | 
                                 conditional$SNP =="rs9349205", "yes", "no")

conditional<-ggplot(conditional,aes(POS/(10^6),-log10(PVAL))) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="-log10(P-value)") + 
  geom_point(data=subset(conditional,sentinel=="yes"),
             aes(x=POS/(10^6),y=-log10(PVAL)),
             fill="yellow",shape=21,size=sz)+
  geom_label_repel(data = subset(conditional, sentinel=="yes"),
                   aes(label = paste(SNP,RSQR,sep=" - ")),
                   size = sz,
                   force=TRUE,
                   nudge_x = 0.75,
                   nudge_y=0) 

dir="/Users/erikbao/Dropbox (MIT)/HMS/Sankaran Lab/ATACSeq_GWAS/Examples/CCND3/RBC_COUNT"
width=3
ggsave("rs9349205_conditional_locusplot.pdf", plot = conditional, device = NULL, path = dir,
       scale = 1, width = width, height=width*1/2, units = "in",
       dpi = 300, limitsize = TRUE)

# ggmatrix(list(p1,p2),nrow=1,ncol=2,
#          xAxisLabels = c("CCND3 Locus", "CCND3 Locus Conditioned on rs9349205"),
#          legend=c(1,1)) +
#   theme(plot.title = element_text(hjust = 0.5))

########################################################################################################
################################################################################################
# 2 Conditional Locus plot (conditioning on rs9349205 AND rs112233623)
rsid <- "rs112233623"
trait <- "RBC_COUNT"
conditional <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs112233623/conditional_sumstats.2covars.rs112233623.",trait,".txt")) %>% arrange(PVAL)
rsqre <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs112233623/locuszoom_ld.",trait,".txt"))
conditional <- merge(conditional, rsqre, by.x="SNP", by.y="snp1")
conditional$sentinel <- ifelse(conditional$rsquare ==1 | 
                                 conditional$SNP =="rs9349205"| 
                                 conditional$SNP =="rs1319012" |
                                 conditional$SNP =="rs66934106" |
                                 conditional$SNP =="rs113788088", "yes", "no")

ggplot(conditional,aes(POS/(10^6),-log10(PVAL))) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="-log10(P-value)") + 
  geom_point(data=subset(conditional,sentinel=="yes"),
             aes(x=POS/(10^6),y=-log10(PVAL)),
             fill="yellow",shape=21,size=sz)+
  geom_label_repel(data = subset(conditional, sentinel=="yes"),
                   aes(label = paste(SNP,RSQR,sep=" - ")),
                   size = sz,
                   force=TRUE,
                   nudge_x = 0.75,
                   nudge_y=0) 

####################################################################################################################
#### 3 Conditional Locus plot (conditioning on rs9349205 AND rs112233623 AND rs113788088)
rsid <- "rs112233623"
trait <- "RBC_COUNT"
conditional <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs112233623/conditional_sumstats.3covars.rs112233623.",trait,".txt")) %>% arrange(PVAL)
rsqre <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs112233623/locuszoom_ld.",trait,".txt"))
conditional <- merge(conditional, rsqre, by.x="SNP", by.y="snp1")
conditional$sentinel <- ifelse(conditional$rsquare ==1 | 
                                 conditional$SNP =="rs9349205"| 
                                 conditional$SNP =="rs1319012" |
                                 conditional$SNP =="rs66934106" |
                                 conditional$SNP =="rs113788088" |
                                 conditional$SNP =="rs10947997", "yes", "no")

ggplot(conditional,aes(POS/(10^6),-log10(PVAL))) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="-log10(P-value)") + 
  geom_point(data=subset(conditional,sentinel=="yes"),
             aes(x=POS/(10^6),y=-log10(PVAL)),
             fill="yellow",shape=21,size=sz)+
  geom_label_repel(data = subset(conditional, sentinel=="yes"),
                   aes(label = paste(SNP,RSQR,sep=" - ")),
                   size = sz,
                   force=TRUE,
                   nudge_x = 0.75,
                   nudge_y=0) 

####################################################################################################################
#### 4 Conditional Locus plot (conditioning on rs9349205 AND rs112233623 AND rs113788088 AND rs10947997)
rsid <- "rs112233623"
trait <- "RBC_COUNT"
conditional <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs112233623/conditional_sumstats.4covars.rs112233623.",trait,".txt")) %>% arrange(PVAL)
rsqre <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs112233623/locuszoom_ld.",trait,".txt"))
conditional <- merge(conditional, rsqre, by.x="SNP", by.y="snp1")
conditional$sentinel <- ifelse(conditional$rsquare ==1 | 
                                 conditional$SNP =="rs9349205"| 
                                 conditional$SNP =="rs1319012" |
                                 conditional$SNP =="rs66934106" |
                                 conditional$SNP =="rs113788088" |
                                 conditional$SNP =="rs10947997", "yes", "no")

ggplot(conditional,aes(POS/(10^6),-log10(PVAL))) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="-log10(P-value)") + 
  geom_point(data=subset(conditional,sentinel=="yes"),
             aes(x=POS/(10^6),y=-log10(PVAL)),
             fill="yellow",shape=21,size=sz)+
  geom_label_repel(data = subset(conditional, sentinel=="yes"),
                   aes(label = paste(SNP,RSQR,sep=" - ")),
                   size = sz,
                   force=TRUE,
                   nudge_x = 0.75,
                   nudge_y=0) 

####################################################################################################################
#####################
#Plot log10(BF) for FM variants
region<-37
FM_region <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/",trait,"/output/region",region,".snp"))
FM_region$POS <- str_split_fixed(str_split_fixed(FM_region$snp,":",2)[,2],"_",2)[,1]
FM_region$POS <- as.integer(as.character(FM_region$POS))
FM_region <- merge(locuszoom,FM_region,by="POS")
FM_region <- subset(FM_region,snp_log10bf > -Inf)
FM_region$sentinel <- ifelse(FM_region$RSQR ==1 | 
                               FM_region$SNP =="rs112233623", "yes", "no")

fm <- ggplot(subset(FM_region,snp_log10bf > -Inf),aes(POS/(10^6),snp_log10bf)) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="log10(Bayes factor)") + 
  geom_point(data=subset(FM_region,sentinel=="yes"),
             aes(x=POS/(10^6),y=snp_log10bf),
             fill="yellow",shape=21,size=sz)+
  geom_label_repel(data = subset(FM_region, sentinel=="yes"),
                   aes(label = paste(SNP,RSQR,sep=" - ")),
                   size = sz,
                   force=TRUE,
                   nudge_x = 0.75,
                   nudge_y=0) 

dir="/Users/erikbao/Dropbox (MIT)/HMS/Sankaran Lab/ATACSeq_GWAS/Examples/CCND3/RBC_COUNT"
width=3
ggsave("rs9349205_fm_bfs.pdf", plot = fm, device = NULL, path = dir,
       scale = 1, width = width, height=width*1/2, units = "in",
       dpi = 300, limitsize = TRUE)

####################################################################################################################
# Hard called LD finemap results
trait <- "RBC_COUNT"
hardcallregion<-36
FM_hardcall_region <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/",trait,"/hardcalloutput/region",hardcallregion,".snp"))
FM_hardcall_region$POS <- str_split_fixed(str_split_fixed(FM_hardcall_region$snp,":",2)[,2],"_",2)[,1]
FM_hardcall_region$POS <- as.integer(as.character(FM_hardcall_region$POS))
FM_hardcall_region <- merge(locuszoom,FM_hardcall_region,by="POS")
FM_hardcall_region[FM_hardcall_region$snp_log10bf < 0,"snp_log10bf"] <- 0 
#FM_hardcall_region <- subset(FM_hardcall_region,snp_log10bf > -Inf)
FM_hardcall_region$sentinel <- ifelse(FM_hardcall_region$RSQR ==1 | 
                                        FM_hardcall_region$SNP =="rs112233623", "yes", "no")

# Plot FM log10bf with hard called variants labeled
hardcall <- ggplot(subset(FM_hardcall_region,snp_log10bf > -Inf),aes(POS/(10^6),snp_log10bf)) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="log10(Bayes factor)") + 
  geom_point(data=subset(FM_hardcall_region,sentinel=="yes"),
             aes(x=POS/(10^6),y=snp_log10bf),
             fill="yellow",shape=21,size=sz)+
  geom_label_repel(data = subset(FM_hardcall_region, sentinel=="yes"),
                   aes(label = paste(SNP,RSQR,sep=" - ")),
                   size = sz,
                   force=TRUE,
                   nudge_x = 0.5,
                   nudge_y=1.0) 

dir="/Users/erikbao/Dropbox (MIT)/HMS/Sankaran Lab/ATACSeq_GWAS/Examples/CCND3/RBC_COUNT"
width=3
ggsave("rs9349205_hardcall_fm_bfs.pdf", plot = hardcall, device = NULL, path = dir,
       scale = 1, width = width, height=width*1/2, units = "in",
       dpi = 300, limitsize = TRUE)


hardcall <- ggplot(subset(FM_hardcall_region,snp_log10bf > -Inf),aes(POS/(10^6),snp_log10bf)) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)  +
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="log10(Bayes factor)") + 
  geom_point(data=subset(FM_hardcall_region,sentinel=="yes"),
             aes(x=POS/(10^6),y=snp_log10bf),
             fill="yellow",shape=21,size=sz)

dir="/Volumes/broad_sankaranlab/ebao/singlecell_bloodtraits/figures/Figure2/CCND3_RBC_COUNT/"
height=3
width=5
cowplot::ggsave("rs9349205_hardcall_fm_bfs.png", plot = hardcall, device = NULL, path = dir,
       scale = 1, width = width, height=height, units = "in",
       dpi = 300, limitsize = TRUE)

####################################################################################################################
# UK10K LD finemap results

UK10Kregion<-36
FM_UK10K_region <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/",trait,"/UK10Koutput/region",UK10Kregion,".snp"))
FM_UK10K_region$POS <- str_split_fixed(str_split_fixed(FM_UK10K_region$snp,":",2)[,2],"_",2)[,1]
FM_UK10K_region$POS <- as.integer(as.character(FM_UK10K_region$POS))

#UK10K LD
locuszoom <- fread(paste0("/Volumes/broad_sankaranlab/ebao/FINEMAP/association_plots/rs9349205/final_locuslist.",trait,".ukid.txt"))

# Check if there are any SNPs with the same SNP ID (this would affect the merging)
locuszoom$SNP %>% duplicated %>% unique
FM_UK10K_region <- merge(locuszoom,FM_UK10K_region,by.x=c("SNP","POS"),by.y=c("snp","POS"))
FM_UK10K_region[FM_UK10K_region$snp_log10bf < 0,"snp_log10bf"] <- 0 
#FM_UK10K_region <- subset(FM_UK10K_region,snp_log10bf > -Inf)
FM_UK10K_region$sentinel <- ifelse(FM_UK10K_region$RSQR ==1 | 
                                     FM_UK10K_region$SNP =="6:41924998_C_T", "yes", "no")

# Plot FM log10bf with UK10K variants labeled
uk10k <- ggplot(subset(FM_UK10K_region,snp_log10bf > -Inf),aes(POS/(10^6),snp_log10bf)) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)+
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="log10(Bayes factor)") + 
  geom_point(data=subset(FM_UK10K_region,sentinel=="yes"),
             aes(x=POS/(10^6),y=snp_log10bf),
             fill="yellow",shape=21,size=sz)+
  geom_text_repel(data = subset(FM_UK10K_region, sentinel=="yes"),
                   aes(label = paste(SNP,"(PP = 0.0)",sep="\n")),
                   size = sz,
                   force=TRUE,
                  nudge_x = 0.5,
                  nudge_y=2.5)

locustheme <-  theme(plot.title = element_text(size=sz*4,hjust = 0.50,face="bold"),
                     text=element_text(size=sz*4),
                     axis.title.x = element_blank(),
                     axis.text.x = element_blank(),
                     axis.ticks.x = element_blank(),
                     axis.title.y = element_blank(),
                     axis.text.y = element_blank(),
                     axis.ticks.y = element_blank(),
                     legend.position = "none",
                     legend.justification = c("left", "top"),
                     legend.box.just = "left",
                     legend.margin = margin(1, 1, 1, 1),
                     legend.direction = "horizontal",
                     legend.key.size = unit(width/30, "in"),
                     legend.text = element_text(size=sz*2),
                     legend.title = element_text(face="bold",size=sz*2))

uk10k <- ggplot(subset(FM_UK10K_region,snp_log10bf > -Inf),aes(POS/(10^6),snp_log10bf)) + 
  geom_point(aes(fill=RSQR),shape=21,size=sz)+
  pretty_plot()+
  scale_y_continuous(expand = c(0.05, 0))+
  scale_fill_gradientn(colors = jdb_palette("solar_extra")[-1],name="R2") +
  guides(fill=guide_colorbar(title.vjust=0.75))+
  locustheme+
  labs(x="Position on Chromosome 6 (Mb)",y="log10(Bayes factor)") + 
  geom_point(data=subset(FM_UK10K_region,sentinel=="yes"),
             aes(x=POS/(10^6),y=snp_log10bf),
             fill="yellow",shape=21,size=sz)


dir="/Volumes/broad_sankaranlab/ebao/singlecell_bloodtraits/figures/Figure2/CCND3_RBC_COUNT/"
height=3
width=5
cowplot::ggsave("rs9349205_uk10k_fm_bfs.png", plot = uk10k, device = NULL, path = dir,
       scale = 1, width = width, height=height, units = "in",
       dpi = 300, limitsize = TRUE)
