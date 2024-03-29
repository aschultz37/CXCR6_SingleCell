library(SCENIC)

setwd("/gpfs/home/acs9950/singlecell/2020-12-16/SCENIC/")

# Run commented code only if RDS does not exist.
# scenicOptions <- initializeScenic(org="mgi",
#                                   dbDir="resources/cisTarget_databases")
# motifAnnotations_mgi <- motifAnnotations
# scenicOptions <- initializeScenic(org="mgi",
#                                   dbDir="resources/cisTarget_databases")
# saveRDS(scenicOptions, file="resources/scenicOptions.Rds")

scenicOptions <- readRDS("resources/scenicOptions.Rds")

library(dplyr)
library(Seurat)
library(loomR)
library(SeuratDisk)
seurat_obj <- readRDS("../output/cxcr6_figs.rds")
# note that this causes an error if loom file already exists
# it will not overwrite the existing file and will halt execution
loom <- as.loom(seurat_obj)

library(SCopeLoomR)

# loom <- open_loom("2022-12-29.loom", mode="r+") # does not work even if file exists
exprMat <- get_dgem(loom)
cellInfo <- get_cell_annotation(loom)
close_loom(loom)

genesKept <- geneFiltering(exprMat, scenicOptions)
exprMat_filtered <- exprMat[genesKept, ]
runCorrelation(exprMat_filtered, scenicOptions)
exprMat_filtered_log <- log2(exprMat_filtered+1) 
try(runGenie3(exprMat_filtered_log, scenicOptions), silent=TRUE) # this fails
motifAnnotations_mgi <- motifAnnotations
runGenie3(exprMat_filtered_log, scenicOptions)

exprMat_log <- log2(exprMat+1)
scenicOptions@settings$dbs <- scenicOptions@settings$dbs["10kb"] # Toy run settings
scenicOptions <- runSCENIC_1_coexNetwork2modules(scenicOptions)
scenicOptions <- runSCENIC_2_createRegulons(scenicOptions, coexMethod=c("top5perTarget")) # Toy run settings
scenicOptions <- runSCENIC_3_scoreCells(scenicOptions, exprMat_log)

export2loom(scenicOptions, exprMat)

saveRDS(scenicOptions, file="int/scenicOptions.Rds") 
saveRDS(exprMat_log, file="int/exprMat_log.Rds")