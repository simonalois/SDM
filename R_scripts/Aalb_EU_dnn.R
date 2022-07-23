#skript for deep neural networks
#R version 3.5.1 (2018-07-02) -- "Feather Spray"
#Copyright (C) 2018 The R Foundation for Statistical Computing
#Platform: x86_64-w64-mingw32/x64 (64-bit)


#load librarys
library(reticulate)
library(keras)
library(tidyverse)
library(caret)
library(tensorflow)
library(PresenceAbsence)

##load datasets ####################################################################################
Aalb_df <- read.csv("c:/data/boku/sdm/modelling/data/Aalb_5km_sample.csv", sep=",", dec=".")
str(Aalb_df)

sum(Aalb_df$Aalb)/length(Aalb_df$Aalb)

#split datasets equal representation of 0/1 is preserved
Aalb_df <- Aalb_df[sample(nrow(Aalb_df)),]
index <- caret::createDataPartition(Aalb_df$Aalb, p=0.7, list=FALSE)

train <- Aalb_df[index,] 
test <- Aalb_df[-index,]
sum(train$Aalb)/length(train$Aalb) #-> 4% are occurences
sum(test$Aalb)/length(test$Aalb)

## train dataset
x_train <- train %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio07", "chelsa_bio10", "chelsa_gdd5", "chelsa_snowD", 
           "pawc_0070", "lucas_ph_cacl_0020", "lucas_cec_0020", "lucas_caco3_0020", "lucas_n_0020","lucas_k_0020",
           "twi", "asp", "slope")) 

#x_train model CST
x_train <- train %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07",
           "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020",
           "twi", "asp", "slope")) 

#x_train model CT
x_train <- train %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07",
           "twi", "asp", "slope")) 

#x_train model CS
x_train <- train %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07",
           "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020")) 

#x_train model ST
x_train <- train %>%
  select(c("pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020",
           "twi", "asp", "slope")) 


y_train <- keras::to_categorical(train$Aalb)



## test dataset
x_test <- test %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio07", "chelsa_bio10", "chelsa_gdd5", "chelsa_snowD", 
           "pawc_0070", "lucas_ph_cacl_0020", "lucas_cec_0020", "lucas_caco3_0020", "lucas_n_0020","lucas_k_0020",
           "twi", "asp", "slope")) 

#x_test model CTS
x_test <- test %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07",
           "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020",
           "twi", "asp", "slope")) 

#x_test model CT
x_test <- test %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07", 
           "twi", "asp", "slope")) 

#x_test model CS
x_test <- test %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio10", "chelsa_bio07",
           "pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020")) 

#x_test model ST
x_test <- test %>%
  select(c("pawc_0070", "lucas_ph_cacl_0020", "lucas_n_0020",
           "twi", "asp", "slope")) 


y_test <- keras::to_categorical(test$Aalb)

## calculate mean and standard deviation of dataset
Aalb_df_model <- rbind(x_test, x_train)
dim(Aalb_df_model)
#mean_Aalb_df <- apply(Aalb_df, 2, mean)
mean_Aalb_df <- apply(Aalb_df_model, 2, mean)
#mean_Aalb_df
mean_Aalb_df
#sd_Aalb_df<- apply(Aalb_df, 2, sd)
sd_Aalb_df<- apply(Aalb_df_model, 2, sd)
sd_Aalb_df

## scale dataset 
x_train <- scale(x_train, center=mean_Aalb_df, scale=sd_Aalb_df)
x_test <- scale(x_test, center=mean_Aalb_df, scale=sd_Aalb_df)


## define model
model <- keras_model_sequential() %>% 
  layer_dense(units = 168, activation = 'relu') %>% 
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 84, activation = 'relu') %>% 
  layer_dropout(rate = 0.3) %>% 
  layer_dense(units = 42, activation = 'relu') %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 2, activation = 'sigmoid')



model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = 'rmsprop',
  metrics = c('accuracy')
)

history <- model %>% fit(
  x_train, y_train, 
  epochs = 30, 
  batch_size = 20,
  validation_split = 0.2,
  view_metrics = getOption("keras.view_metrics",
                           default = "auto")
)

plot(history)

predictions_class <- model %>% predict_classes(x_test)
head(predictions_class)

predictions_test <- model %>% predict(x_test)
head(predictions_test)
predictions_CTS <- as.data.frame(predictions_test)
predictions_CTS2 <- as.data.frame(predictions_test)
#predictions_CT <- as.data.frame(predictions_test)
#predictions_CS <- as.data.frame(predictions_test)
predictions_CS2 <- as.data.frame(predictions_test)
#predictions_ST <- as.data.frame(predictions_test)


setwd("C:/data/boku/sdm/modelling/graphics_EU_buf")
jpeg(file="Aalb_CT_observed_predicted_th05.jpg", width=600, height=450, pointsize=15)
plot(as.data.frame(as.factor(predictions_class)), as.factor(test$Aalb), xlab="predicted", ylab="observed", col=c("black", "gray"))
dev.off()

table(factor(predictions_class, levels=min(test$Aalb):max(test$Aalb)),factor(test$Aalb, 
                                                                             levels=min(test$Aalb):max(test$Aalb)))

#save model
setwd("C:/data/boku/sdm/r_stat/r_prj/dnn_EU_Aalb_buf")
save_model_hdf5(model, "Aalb_EU_buf_CTS.h5")
model <- load_model_hdf5("C:/data/boku/sdm/r_stat/r_prj/dnn_EU_Aalb_buf/Aalb_EU_buf_CTS.h5", custom_objects = NULL, compile = TRUE)


pre_abs_data <- as.data.frame(cbind(test$X,test$Aalb, predictions_test[,2]))

save(pre_abs_data, file="c:/data/boku/sdm/modelling/data/Aalb_EU_preabs_buf.Rdata")


setwd("C:/data/boku/sdm/modelling/graphics_EU_buf")
jpeg(file="Aalb_CTS_threshold.jpg", width=750, height=750, pointsize=15)
PresenceAbsence::error.threshold.plot(pre_abs_data, threshold= 101, which.model=1,  color = T, xlab="threshold", ylab="accuracy measures", main="DNN Abies alba")
dev.off()

PresenceAbsence::optimal.thresholds(pre_abs_data, threshold= 101, which.model=1)


###evalute model 
library(tidyverse)
library(lime)

class(model)
model_type.keras.engine.sequential.Sequential <- function(x, ...) {"classification"}

predict_model.keras.engine.sequential.Sequential <- function(x, newdata, type, ...) {
  pred <- predict_proba (object = x, x=as.matrix(newdata))
  data.frame (positive=pred)
}


#select 300 samples from test-dataset with 50/50 absent/present classification
test$pred_class <- predictions_class
head(test)
test_small <- as.data.frame(test %>% group_by(pred_class) %>% sample_n(150))


x_test_small <- test_small %>%
  select(c("chelsa_bio06", "chelsa_bio18", "chelsa_bio07", "chelsa_bio10", "chelsa_gdd5", "chelsa_snowD", 
           "pawc_0070", "lucas_ph_cacl_0020", "lucas_cec_0020", "lucas_caco3_0020", "lucas_n_0020","lucas_k_0020",
           "twi", "asp", "slope")) 
x_test_small <- scale(x_test_small, center=mean_Aalb_df, scale=sd_Aalb_df)


y_test_small <- keras::to_categorical(test_small$pred_class)

lime_prediction_ta <- lime::predict_model(x=model, newdata=x_test_small, type="raw") %>%
  tibble::as.tibble()

explainer <- lime::lime(x=as.tibble(x_train), model=model, bin_continuous = FALSE)

system.time (
  explanation <- lime::explain(
    x=as.tibble(x_test_small), 
    explainer=explainer, 
    n_labels=2, 
    n_features=10, 
    kernel_width=0.5))

#plot_features (explanation) +
#  labs (title = "LIME: Feature Importance Visualisation")
#  labeller= as_labeller(c('positive.1'= "not occuring", "positive.2" = "occuring"))

setwd("C:/data/boku/sdm/modelling/graphics_EU_buf")
jpeg(file="Aalb_all_feature_importance_heatmap.jpg", width=750, height=750, pointsize=15)
plot_explanations (explanation, labeller= as_labeller(c('positive.1'= "not occuring", "positive.2" = "occuring"))) +
  labs (title = "LIME Feature Importance Heatmap", subtitle = "subset of test dataset, n=300") + 
  theme(axis.text.y=element_text(size=18), plot.title=element_text(size=20), plot.subtitle=element_text(size=18), axis.title=element_text(size=16), 
        legend.text=element_text(size=16), legend.title=element_text(size=16), strip.text=element_text(size=20))
dev.off()
