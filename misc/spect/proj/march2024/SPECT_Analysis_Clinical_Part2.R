attach(Loadings_Parameters) #attach file with all loading parameters 
#next, more clean up
Loadings_Parameters <-data.frame(Loadings_Parameters) #unlist the whole file so that analysis is easier
#read specific rows and columns to make a specific two variables for HC and SCZ from the loading means worksheet

library(readxl) #load readxl package
#create variables for controls and patients from loading parameters
HC_Loading_Parameters<-read_excel("/Users/amrithah/Desktop/Loadings_Parameters.xlsx", sheet = "HC_Loading_Parameters") #healthy control loading parameters
#remove extra column in the beginning that somehow showed up
HC_Loading_Parameters <- HC_Loading_Parameters[ -c(1,1) ] #removed!
SCZ_Loading_Parameters<-read_excel("/Users/amrithah/Desktop/Loadings_Parameters.xlsx", sheet = "SZ_Loading_Parameters" ) #scz loading parameters

#transpose variables for regression set up as the dependent variable with the loading parameters
HC_transp <-t(HC_Loading_Parameters) #healthy control transpose
SZ_transp <-t(SCZ_Loading_Parameters) #now the patients
#mean of 53 components for HC and SCZ

#now load mean parameter values as variables
HC_mean<-read_excel("/Users/amrithah/Desktop/Loadings_Means_Values.xlsx", sheet = "Mean Loading Parameters Plot", "B1:B54") #average loading parameters for each control subject
SZ_mean<-read_excel("/Users/amrithah/Desktop/Loadings_Means_Values.xlsx", sheet = "Mean Loading Parameters Plot", "C1:C54") #average loading parameters for each patient subject
################################
t.test(HC_mean,SCZ_mean) #do t-test comparing the two groups initially

###setting up regression models for clinical variables##
#use tidyr to clean up data
library(tidyr)
attach(schiz_8_31_23_dx_classes_symptoms) #attach scz clinical dataset from David
attach(healthy_8_31_23_symptom_checklist) #attach healthy control dataset from David
HC_clinical<-read_excel("/Users/amrithah/Desktop/healthy_8_31_23_symptom_checklist.xls") # load clinical variables
SZ_clinical<-read_excel("/Users/amrithah/Desktop/schiz_8_31_23_dx_classes_symptoms.xls") # load clinical variables
#Lots of missing data in both datasets so...know which ones have complete cases

#define demographic variables
hc_age <-read_excel("/Users/amrithah/Desktop/healthy_8_31_23_symptom_checklist.xls", sheet = "healthy clinical", "E1:E77") # load age
hc_sex<-read_excel("/Users/amrithah/Desktop/healthy_8_31_23_symptom_checklist.xls", sheet = "healthy clinical", "D1:D77") # load sex variable


#same for patients
sz_age <-read_excel("/Users/amrithah/Desktop/schiz_8_31_23_dx_classes_symptoms.xls", sheet = "sz clinical", "D1:D138") #load age
sz_sex <-read_excel("/Users/amrithah/Desktop/schiz_8_31_23_dx_classes_symptoms.xls", sheet = "sz clinical", "F1:F138") #load sex variable


#now, remove any missing stuff
sz_age <-na.omit(sz_age) #remove any missing data from age
hc_age <-na.omit(hc_age) #remove any missing data from age
#unlist variables for readability
sz_age <-unlist(sz_age)
hc_age <-unlist(hc_age)
sz_sex<-unlist(sz_sex)
hc_sex<-unlist(hc_sex)

#first set of regression models starting with patient dataå
#first set of linear models: let's start with looking at age, sex, BSC_item 68 x against patients loading matrices
Y1 <- SZ_transp #list all loading parameters for patients
Y1 <-data.matrix(Y1)
model1 <- aov(Y1 ~ sz_age + sz_sex+ BSC_68_Experiencing_periods_of_troubled_breathing_or_feeling_smothered + BSC_100_Having_dark_thoughts_ones_that_may_involve_suicidal_or_homicidal_thoughts, data=SZ_clinical, na.action=na.omit)
summary.aov(model1) #view model output

#second model - looking at more social cognition variables now 
Y2 <-SZ_transp
#clean out all NAs in dataset
Y2 <-na.omit(SZ_transp) #loading parameters for patients
Y2 <-data.matrix(Y2)
model2 <- aov(Y2 ~ sz_age + sz_sex + LDS_64_I_am_teased_by_others + BSC_75_Avoiding_conflict + GSC_A_104_Being_in_an_inappropriate_mood_for_a_given_situation_laughing_at_sad_events + `GSC_A_31_Fearing_going_crazy_or_doing_something_out-of-control`, data=SZ_clinical, na.action=na.omit)
summary.aov(model2)

#relationship between age and loading parameters and GSC scores
Y3<-SZ_transp
model3<-aov(Y3 ~ sz_age + sz_sex + GSC_A_Score, data=SZ_clinical, na.action = na.omit)
summary.aov(model3)

#now do the same with clinical variables

#same model but in controls
Y4 <- HC_transp #list all loading parameters for patients
Y4 <-data.matrix(Y4)
model4 <- aov(Y4 ~ hc_age + hc_sex + BSC_75_Avoiding_conflict + GSC_A_104_Being_in_an_inappropriate_mood_for_a_given_situation_laughing_at_sad_events + `GSC_A_31_Fearing_going_crazy_or_doing_something_out-of-control`, data=HC_clinical, na.action=na.omit)
summary.aov(model4) #view model output

Y5 <- HC_transp #list all loading parameters for patients
Y5 <-data.matrix(Y5)
model5 <- aov(Y5 ~ hc_age + hc_sex+ BSC_68_Experiencing_periods_of_troubled_breathing_or_feeling_smothered + BSC_100_Having_dark_thoughts_ones_that_may_involve_suicidal_or_homicidal_thoughts, data=HC_clinical, na.action=na.omit)
summary.aov(model5) #view model output

###now look specifically at positive and negative symptoms in patient group, and cluster models as such ####

#looking at perceptual abnormalities and relationships with clustered symptoms **USE THIS MODEL IN THE PAPER AS THE FIRST MODEL**
Y6 <- SZ_transp
Y6 <-data.matrix(Y6)
GSC_A_98_Hearing_voices_or_sounds_that_are_not_real <-na.omit(GSC_A_98_Hearing_voices_or_sounds_that_are_not_real)
model6 <-aov(Y6 ~ sz_age + sz_sex + GSC_A_98_Hearing_voices_or_sounds_that_are_not_real + LDS_76_I_have_an_unusual_sensitivity_to_certain_smells + LDS_77_I_have_an_unusual_sensitivity_to_light, data=SZ_clinical, na.action=na.omit)
summary.aov(model6)

#looking at clustered symptoms
#looking at hallucinations/delusions symptoms 
Y7 <- SZ_transp
Y7 <-data.matrix(Y7)
model7 <-aov(Y7 ~sz_age + sz_sex + GSC_A_98_Hearing_voices_or_sounds_that_are_not_real + LDS_76_I_have_an_unusual_sensitivity_to_certain_smells + LDS_77_I_have_an_unusual_sensitivity_to_light + age:LDS_77_I_have_an_unusual_sensitivity_to_light + age:GSC_A_98_Hearing_voices_or_sounds_that_are_not_real + age:LDS_76_I_have_an_unusual_sensitivity_to_certain_smells, data=SZ_clinical, na.action=na.omit)
summary.aov(model7)

#looking at simpler model **USE THIS MODEL IN THE PAPER AS THE SECOND MODEL*** using the SZ_mean FNC
Y8 <- SZ_mean
Y8 <-data.matrix(Y8)
#rename variables for brevity
GSC_A_98_Hearing_Voices <-GSC_A_98_Hearing_voices_or_sounds_that_are_not_real
GSC_A_99_Disjointed_Thoughts<-GSC_A_99_Experiencing_periods_of_time_where_your_thoughts_or_speech_were_disjointed_or_didnt_make_sense_to_you_or_others
model8 <-aov(Y8 ~sz_age + sz_sex + GSC_A_98_Hearing_Voices + GSC_A_99_Disjointed_Thoughts, data = SZ_clinical, na.action=na.omit)
summary.aov(model8)

### run a similar model in healthy controls and see what changes come up
Y9 <- HC_transp
Y9 <-data.matrix(Y9)
#rename variables for brevity
model9 <-aov(Y9 ~ hc_age + hc_sex + GSC_A_98_Hearing_voices_or_sounds_that_are_not_real + GSC_A_99_Experiencing_periods_of_time_where_your_thoughts_or_speech_were_disjointed_or_didnt_make_sense_to_you_or_others, data = HC_clinical, na.action=na.omit)
summary.aov(model9)

#use broom to tidy up the regressions and export into excel for the sz model
library(broom)
library(broom.mixed)
results_model8_clean_mean <-unlist(summary.aov(model8)) #generate model 8 summary
write.csv(results_model8_clean_mean, "results_model8_clean_mean.csv") #write initial results to .csv file

#same for healthy controls
library(broom)
library(broom.mixed)
results_model9_clean <-unlist(results_model9_clean)
results_model9_clean <-summary.aov(model9) #generate model 9 summary
write.csv(results_model9_clean, "results_model9_clean.csv") #write initial results to .csv file

#compute cross correlations of variables to check if they are highly related to each other
#remove NAs
GSC_A_98_Hearing_voices_or_sounds_that_are_not_real <-na.omit(GSC_A_98_Hearing_voices_or_sounds_that_are_not_real)
LDS_76_I_have_an_unusual_sensitivity_to_certain_smells <-na.omit(LDS_76_I_have_an_unusual_sensitivity_to_certain_smells)
LDS_77_I_have_an_unusual_sensitivity_to_light <-na.omit(LDS_77_I_have_an_unusual_sensitivity_to_light)
#now run the cross correlations on the pairs and plot for each pair and plot them as well with Pearson correlations

library("ggpubr") #use this package to plot the variables with each other 
library("ggcorrplot") #use this to visualize correlation matrix
library("corrplot")

ggscatter(schiz_8_31_23_dx_classes_symptoms, x = "GSC_A_98_Hearing_voices_or_sounds_that_are_not_real", y = "LDS_76_I_have_an_unusual_sensitivity_to_certain_smells", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "GSC_A_98", ylab = "LDS_76")

#make a correlation matrix of all three variables and set up variables
correlations_matrix <- cbind(GSC_A_98_Hearing_voices_or_sounds_that_are_not_real, LDS_76_I_have_an_unusual_sensitivity_to_certain_smells, LDS_77_I_have_an_unusual_sensitivity_to_light)
correlations_matrix<-na.omit(correlations_matrix) #remove NA's 
correlations_matrix <- cor(correlations_matrix, method = c("pearson"))
correlations_matrix <-as.table(correlations_matrix)
correlations_matrix

ggcorrplot(cor(correlations_matrix)) #correlation matrix 1; make sure to zoom into figure to see values
ggcorrplot(correlations_matrix,
           hc.order = TRUE,
           type = "full",
           lab = TRUE)

##
correlations_matrix2 <- cbind(GSC_A_98_Hearing_voices_or_sounds_that_are_not_real, GSC_A_Score)
correlations_matrix2<-na.omit(correlations_matrix2) #remove NA's 
correlations_matrix2 <- cor(correlations_matrix2, method = c("pearson"))
correlations_matrix2 <-as.table(correlations_matrix2)
correlations_matrix2

#now plot this in a correlation matrix
ggcorrplot(cor(correlations_matrix2)) #correlation matrix 1; make sure to zoom into figure to see values
ggcorrplot(correlations_matrix2,
           hc.order = TRUE,
           type = "full",
           lab = TRUE)

#####

correlations_matrix3 <- cbind(GSC_A_98_Hearing_voices_or_sounds_that_are_not_real, GSC_A_Score, GSC_A_100_Feeling_socially_isolated_or_withdrawn, GSC_A_105_Having_a_marked_lack_of_initiative, GSC_A_102_Behaving_peculiarly, `GSC_A_11_Having_periods_of_a_very_high_self-esteem_or_grandiose_thinking`)
correlations_matrix3<-na.omit(correlations_matrix3) #remove NA's 
correlations_matrix3 <- cor(correlations_matrix3, method = c("pearson"))
correlations_matrix3 <-as.table(correlations_matrix3)
correlations_matrix3

#now plot this in a correlation matrix
ggcorrplot(cor(correlations_matrix3)) #correlation matrix 1; make sure to zoom into figure to see values
ggcorrplot(correlations_matrix3,
           hc.order = TRUE,
           type = "full",
           lab = TRUE)


ccf(GSC_A_98_Hearing_voices_or_sounds_that_are_not_real, LDS_76_I_have_an_unusual_sensitivity_to_certain_smells) #pair 1
print(ccf(GSC_A_98_Hearing_voices_or_sounds_that_are_not_real, LDS_76_I_have_an_unusual_sensitivity_to_certain_smells) #pair 1
)# see results

ccf(LDS_77_I_have_an_unusual_sensitivity_to_light, LDS_76_I_have_an_unusual_sensitivity_to_certain_smells) #pair 2
print(ccf(LDS_77_I_have_an_unusual_sensitivity_to_light, LDS_76_I_have_an_unusual_sensitivity_to_certain_smells))
#see results

ccf(LDS_77_I_have_an_unusual_sensitivity_to_light, GSC_A_98_Hearing_voices_or_sounds_that_are_not_real) #pair 3
print(ccf(LDS_77_I_have_an_unusual_sensitivity_to_light, GSC_A_98_Hearing_voices_or_sounds_that_are_not_real) #pair 3
)
#see results

library("ggpubr")
ggscatter(schiz_8_31_23_dx_classes_symptoms, x = "LDS_77_I_have_an_unusual_sensitivity_to_light", y = "GSC_A_98_Hearing_voices_or_sounds_that_are_not_real", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "LDS_77", ylab = "GSC_A_98")

ggscatter(schiz_8_31_23_dx_classes_symptoms, x = "LDS_77_I_have_an_unusual_sensitivity_to_light", y = "LDS_76_I_have_an_unusual_sensitivity_to_certain_smells", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "LDS_77", ylab = "LDS_76")
