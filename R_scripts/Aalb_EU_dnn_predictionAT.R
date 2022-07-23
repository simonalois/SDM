###load libraries
library(rgdal)
library(raster)
library(sp)
library(sf)

#Rasterfunktionen 
rasterTmpFile()   #zeigt pfad für temporären speicher an
showTmpFiles()    #zeit inhalt des temporären speicher an
removeTmpFiles(h=0.01) #löscht temporären speicher

setwd("c:/data/boku/sdm/gis/shp")
boundingbox.shp <- readOGR(".", "boundingbox_at_west")
boundingbox.shp <- spTransform(boundingbox.shp, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#transform to homolosine
igh='+proj=igh +lat_0=0 +lon_0=0 +datum=WGS84 +units=m +no_defs'
boundingbox_igh <- st_as_sf(boundingbox.shp)
boundingbox_igh <- st_transform(boundingbox_igh, igh)
#transform to 3035
laea_3035 = "+init=epsg:3035 +proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
boundingbox_laea <- st_as_sf(boundingbox_igh)
boundingbox_laea <- st_transform(boundingbox_laea, 3035)
boundingbox_laea

#topographic data with CRS=3035, 25x25m raster (smallest raster, reproject all raster to this resolution)
asp <- raster("d:/dgm_copernicus/aspect/E40N20_aspect.tif")
asp_trans <- raster::calc(asp, function(x){-1*cos(x*(pi/180)) +1}) 
plot(asp_trans)
slope  <- raster("d:/dgm_copernicus/slope/E40N20_slope.tif")
topo_data <- stack(asp_trans, slope)
topo_west<- crop(topo_data, extent(boundingbox_laea))
writeRaster(topo_west, filename="d:/raster_stack_west_at/topo_west.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
writeRaster(dgm25_west_limit, filename="d:/raster_stack_west_at/dgm25_west_limit.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
topo_west  <- raster::stack("d:/raster_stack_west_at/topo_west.tif")
topo_west
plot(topo_west)

dgm25 <- raster("d:/dgm_copernicus/unzip/unzip/eu_dem_v11_E40N20.tif")
dgm25_west<- crop(dgm25, extent(boundingbox_laea))
dgm25_west <- raster::extend(dgm25_west, y=extent(4278625,4631825,2570925,2787125), value=NA)
dgm25_west_limit <- raster::calc(dgm25_west, function(x){x[x>2300]<-NA; return(x)})
dgm25_west_limit <- raster::crop(dgm25_west_limit, extent(4278625,4629950,2570925,2787125))
plot(dgm25_west_limit)


#climate data
chelsa_bio06 <- raster("d:/chelsa_clim/CHELSA_bio6_1981-2010_V.2.1.tif")
chelsa_bio10 <- raster("d:/chelsa_clim/CHELSA_bio10_1981-2010_V.2.1.tif")
chelsa_bio18 <- raster("d:/chelsa_clim/CHELSA_bio18_1981-2010_V.2.1.tif")
chelsa_bio07 <- raster("d:/chelsa_clim/CHELSA_bio7_1981-2010_V.2.1.tif")
#chelsa_gdd5 <- raster("d:/chelsa_clim/CHELSA_gdd_5_1979-2013.tif")

chelsa_data <- stack(chelsa_bio06, chelsa_bio18, chelsa_bio10, chelsa_bio07)
clim_west <- crop(chelsa_data, extent(boundingbox.shp))
plot(clim_west)
clim_west_repro <- raster::projectRaster(clim_west, topo_west, crs=laea_3035)
#writeRaster(clim_west_repro, filename="d:/raster_stack_west_at/clim_west_repro.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)

#soil data
lucas_ph_cacl_0020 <- raster("d:/esdb/ph_CaCl.tif")
lucas_n_0020 <- raster("d:/esdb/N.tif")

#ph_0515 <- raster("d:/soilgrid/texture/phh2o05015.tif")
#cec_0515 <- raster("d:/soilgrid/texture/cec05015.tif")
#n_0515 <- raster("d:/soilgrid/texture/nitrogen05015.tif")

soil_luca_data <- stack(lucas_ph_cacl_0020, lucas_n_0020)
soil_luca_west<- crop(soil_luca_data, extent(boundingbox_laea))
plot(soil_luca_west)
soil_luca_west_repro <- raster::projectRaster(soil_luca_west, topo_west, crs=laea_3035)
writeRaster(soil_luca_west_repro, filename="d:/raster_stack_west_at/soil_luca_west_repro.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
soil_luca_west_repro <- raster::stack("d:/raster_stack_west_at/soil_luca_west_repro.tif")
plot(soil_luca_west_repro)

##pawc 
pawc0070 <- raster("d:/esdb/geotiff/STU_EU_TAWC_sum.tif",format="GTiff") 
pawc0070_west <- crop(pawc0070, extent(boundingbox_laea))
crs(pawc0070_west) <- laea_3035
pawc0070_west_repro <- raster::projectRaster(pawc0070_west, topo_west, crs=laea_3035)
writeRaster(pawc_0070_west_repro, filename="d:/raster_stack_west_at/pawc0070_west_repro.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
pawc_0070_west_repro <- raster("d:/raster_stack_west_at/pawc0070_west_repro.tif")


##twi
twi <- raster("d:/dgm_copernicus/twi/dgm200_twi.tif") 
twi_west <- crop(twi, extent(boundingbox_laea))
twi_west_repro <- raster::projectRaster(twi_west, topo_west, crs=laea_3035)
writeRaster(twi_west_repro, filename="d:/raster_stack_west_at/twi_west_repro.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
twi_west_repro <- raster("d:/raster_stack_west_at/twi_west_repro.tif")

##stack all raster 

pred_stack_CTS <- stack(clim_west_repro, pawc_0070_west_repro, soil_luca_west_repro, twi_west_repro, topo_west)
names(pred_stack_CTS) <- c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07", "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020", "twi", "asp", "slope")
#writeRaster(pred_stack_CTS, filename="d:/raster_stack_west_at/pred_stack_CTS.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
#pred_stack_CTS <- raster::stack("d:/raster_stack_west_at/pred_stack_CTS.tif")
pred_stack_CTS

#scale to 27 025 * 8 = 216 200
pred_stack_CTS  <- raster::extend(pred_stack_CTS , y=extent(4278625,4629950,2570925,2787125), value=NA)
pred_stack_CTS  <- raster::crop(pred_stack_CTS , extent(4278625,4629950,2570925,2787125))
writeRaster(pred_stack_CTS , filename="d:/raster_stack_west_at/pred_stack_CTS.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
#pred_stack_CTS<- raster::stack("d:/raster_stack_west_at/pred_stack_CTS.tif")
#names(pred_stack_CTS) <- c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_gdd5", "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020", "twi", "asp", "slope")
pred_stack_CTS


mean_Aalb_df
sd_Aalb_df

chelsa_bio06_scale <- raster::scale(pred_stack_CTS$chelsa_bio06, center=mean_Aalb_df[1], scale=sd_Aalb_df[1])
chelsa_bio18_scale <- raster::scale(pred_stack_CTS$chelsa_bio18, center=mean_Aalb_df[2], scale=sd_Aalb_df[2])
chelsa_bio10_scale <- raster::scale(pred_stack_CTS$chelsa_bio10, center=mean_Aalb_df[3], scale=sd_Aalb_df[3])
#chelsa_gdd5_scale <- raster::scale(pred_stack_CTS$chelsa_gdd5, center=mean_Aalb_org_df[4], scale=sd_Aalb_org_df[4])
chelsa_bio07_scale <- raster::scale(pred_stack_CTS$chelsa_bio07, center=mean_Aalb_df[4], scale=sd_Aalb_df[4])
pawc_0070_scale <- raster::scale(pred_stack_CTS$pawc_0070, center=mean_Aalb_df[5], scale=sd_Aalb_df[5])
lucas_ph_cacl_0020_scale <- raster::scale(pred_stack_CTS$lucas_ph_cacl_0020, center=mean_Aalb_df[6], scale=sd_Aalb_df[6])
lucas_n_0020_scale <- raster::scale(pred_stack_CTS$lucas_n_0020, center=mean_Aalb_df[7], scale=sd_Aalb_df[7])
twi_scale <- raster::scale(pred_stack_CTS$twi, center=mean_Aalb_df[8], scale=sd_Aalb_df[8])
asp_scale <- raster::scale(pred_stack_CTS$asp, center=mean_Aalb_df[9], scale=sd_Aalb_df[9])
slope_scale <- raster::scale(pred_stack_CTS$slope, center=mean_Aalb_df[10], scale=sd_Aalb_df[10])

pred_scale_stack_CTS <- stack(chelsa_bio06_scale, chelsa_bio18_scale ,chelsa_bio10_scale, chelsa_bio07_scale, pawc_0070_scale, 
                              lucas_ph_cacl_0020_scale, lucas_n_0020_scale, twi_scale, asp_scale, slope_scale)
names(pred_scale_stack_CTS) <- c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07", "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020", "twi", "asp", "slope")
pred_scale_stack_CTS
writeRaster(pred_scale_stack_CTS, filename="d:/raster_stack_west_at/pred_scale_buf_Aalb_stack_CTS.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
#pred_scale_org_stack_CTS<- raster::stack("d:/raster_stack_west_at/pred_scale_org_Aalb_stack_CTS.tif")
#names(pred_scale_org_stack_CTS) <- c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_gdd5", "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020", "twi", "asp", "slope")
#pred_scale_org_stack_CTS

#load rasterstack
pred_scale_stack_CTS<- raster::stack("d:/raster_stack_west_at/pred_scale_buf_Aalb_stack_CTS.tif")
names(pred_scale_bal_stack_CTS) <- c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07", "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020", "twi", "asp", "slope")
pred_scale_bal_stack_CTS

pred_scale_stack_CT <- raster::dropLayer(pred_scale_stack_CTS, c(5,6,7))
pred_scale_stack_CT 
writeRaster(pred_scale_stack_CT  , filename="d:/raster_stack_west_at/pred_scale_buf_Aalb_stack_CT.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
pred_scale_stack_CT <- raster::stack("d:/raster_stack_west_at/pred_scale_org_Aalb_stack_CT.tif")
names(pred_scale_stack_CT ) <- c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07", "twi", "asp", "slope")
pred_scale_stack_CT 

###################################################################################################################################
###predict dnn
library(reticulate)
library(keras)
library(tidyverse)
library(caret)
library(tensorflow)
library(rgdal)
library(GSIF)
library(parallel)
ctrl <- list(nthreads=2)
cl <- makeCluster(4)


###define functions for prediction of probability with DNN
#split of raster, predict for tiles, merge tiles 
obj <- rgdal::GDALinfo("d:/raster_stack_west_at/pred_scale_buf_Aalb_stack_CTS.tif")
tile.list <- getSpatialTiles(obj, block.x=27025, limit.bbox=FALSE, return.SpatialPolygons=TRUE)
tile.tbl <- getSpatialTiles(obj, block.x=27025, limit.bbox=FALSE, return.SpatialPolygons=FALSE)
plot(tile.list)
#plot(boundingbox_laea, add=T)

tile.tbl$ID <- as.character(1:nrow(tile.tbl))
head(tile.tbl)

out.path<-("d:/r_raster/prediction_prop_tile")

#load dnn model
#model <- load_model_hdf5("C:/data/boku/sdm/r_stat/r_prj/dnn_EU_Aalb/Aalb_EU_org_CTS.h5", custom_objects = NULL, compile = TRUE)

#function for prediction on tiles
predFunProbTA_tiles <- function(i,tile.tbl){
  out.tif = paste0(out.path,"/T_", tile.tbl[i,"ID"],".tif")
  m <- readGDAL("d:/raster_stack_west_at/pred_scale_buf_Aalb_stack_CT.tif", 
                offset=unlist(tile.tbl[i,c("offset.y","offset.x")]),
                region.dim=unlist(tile.tbl[i,c("region.dim.y","region.dim.x")]),
                output.dim=unlist(tile.tbl[i,c("region.dim.y","region.dim.x")]))
  m <- stack(m)
  names(m) <- c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07", "twi", "asp", "slope")
  m_matrix <- as.matrix(m)
  m_extent <- raster::extent(m)
  m_crs <- crs(m)
  m_dim <- dim(m)
  m_pred <- model %>% predict_proba(m_matrix)
  m_pred2 <- (m_pred[,2]*100)
  m_pred_matrix <- matrix(m_pred2, m_dim[2], m_dim[1], byrow=TRUE)
  m_raster <- raster(m_pred_matrix, xmn=m_extent[1], xmx=m_extent[2], ymn=m_extent[3], ymx=m_extent[4], crs=m_crs)
  writeRaster(m_raster, filename=out.tif, datatype="INT1U", fromat="GTiff", overwrite=TRUE)  
}

#run prediction
for(i in 1:nrow(tile.tbl)){predFunProbTA_tiles(i,tile.tbl)}
#for(i in 1:2){predFunProbTA_tiles(i,tile.tbl)}

#mosaic raster
t.list <- list.files("d:/r_raster/prediction_prop_tile", pattern="tif", full.names = TRUE)
t.list

rast.list <- list()
for(i in 1:length(t.list)) {rast.list[[i]] <- raster(t.list[i])}

raster.mosaic <- do.call(merge, c(rast.list, overlap=FALSE))

#set NA values
dgm25_west_limit <- raster("d:/raster_stack_west_at/dgm25_west_limit.tif")
raster.mosaic <- raster::mask(raster.mosaic, mask=dgm25_west_limit)
plot(raster.mosaic)

writeRaster(raster.mosaic, filename="d:/r_raster/predict_buf_Aalb_EU_CT.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)





####compare raster with and without soil information
predict_buf_Aalb_EU_CTS <- raster("d:/r_raster/predict_buf_Aalb_EU_CTS.tif")
predict_buf_Aalb_EU_CT <- raster("d:/r_raster/predict_buf_Aalb_EU_CT.tif")

Aalb_EU_buf_CT_dif_CTS <- predict_buf_Aalb_EU_CTS - predict_buf_Aalb_EU_CT
plot(Aalb_EU_buf_CT_dif_CTS)
#Aalb_EU_bal_CT_dif_CTS <- raster::overlay(Aalb_EU_bal_CT_dif_CTS,predict_Aalb_EU_CTS,fun=function(x,y){x[y<=25]<-NA; return(x)})

writeRaster(Aalb_EU_buf_CT_dif_CTS, filename="d:/r_raster/Aalb_EU_buf_CT_dif_CTS.tif", options="INTERLEAVE=BAND", format="GTiff", overwrite=TRUE)
