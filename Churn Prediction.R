energysupplier <- read.csv("~/Documents/Groningen/RUG/Methods/Assignment 1/data assignment 1.csv")
summary(energysupplier)
str(energysupplier)
library(ggplot2)
library(reshape2)
library(tidyr)
library(ggpubr)
library(vcd)
library(tidyverse)
library(dplyr)

### DESCRIPTIVES------------------------------------------------------------------
hist(energysupplier$Age)
hist(energysupplier$Income)
hist(log(energysupplier$Income))##increase of 1€ in monthly income might not make sense, in percentages? 
hist(energysupplier$Relation_length)
hist(energysupplier$Contract_length) ##large number of 0, binary?  
hist(energysupplier$Home_age, col = "aliceblue", main = "Home Age Histogram", xlab = "Home Age (in years)") ##(0-50.50-100,>100)? 
hist(energysupplier$Electricity_usage)
hist(energysupplier$Gas_usage)

#####
datalong <- melt(energysupplier)
ggplot(datalong, aes(x = variable, y = value)) +            # Applying ggplot function
  geom_boxplot() + facet_wrap(facets = ~variable, scales = 'free')
#####
boxplot(log(energysupplier$Age), log(energysupplier$Income), log(energysupplier$Relation_length), log(energysupplier$Contract_length), log(energysupplier$Home_age), log(energysupplier$Electricity_usage), log(energysupplier$Gas_usage), main = "boxplots", at = c(1,2,3,4,5,6,7), names = c("Age","Income","R.length","C.length", "H.age","E.usage","G.usage"), las = 2, notch = TRUE, space = 0.10)
boxplot(energysupplier$Age)  
boxplot(energysupplier$Income) ##huge jump in income, yearly income for outliers, divide by 12. 
boxplot(energysupplier$Relation_length)## Check relation between relation length and age. Outliers coincide with older customers
ggplot(energysupplier, aes(Age, Relation_length))+
  geom_smooth() + theme_bw()

boxplot(energysupplier$Home_age) ##Check relation between home age and home label
boxplot(energysupplier$Home_age~energysupplier$Home_label)
boxplot(energysupplier$Electricity_usage)
boxplot(energysupplier$Gas_usage)## Relation between electricity and gas usage 

##DATA CLEANING---------------------------------------------------------------------
outE <- boxplot.stats(energysupplier$Electricity_usage)$out
sort(outE, decreasing = FALSE)#jump at 8610

outG <- boxplot.stats(energysupplier$Gas_usage)$out
sort(outG, decreasing = FALSE)#10000 mark 

energysupplier <- energysupplier %>% 
  mutate(Income = ifelse(Income > 50000, 
                         Income/12, 
                         Income))

energysupplier <- energysupplier%>%
  mutate(Electricity_usage = ifelse(Electricity_usage >= 8610,
                                    Electricity_usage/10,
                                    Electricity_usage))

energysupplier <- energysupplier%>%
  mutate(Gas_usage = ifelse(Gas_usage >= 10000, 
                            Gas_usage/10, 
                            Gas_usage))

##DATA CREATION AND FORMAT--------------------------------------------
energysupplier$logincome <- log(energysupplier$Income)

energysupplier$contract <- ifelse(energysupplier$Contract_length > 0,
                                  1,0)

energysupplier$home.age <- ifelse(energysupplier$Home_age<=50, 
                                  "0-50",
                                  ifelse(energysupplier$Home_age>50 & energysupplier$Home_age <= 100, 
                                         "50-100", 
                                         ifelse(energysupplier$Home_age>100,
                                                ">100", 0)))

energysupplier$Gender <- as.factor(energysupplier$Gender)
energysupplier$Start_channel <- as.factor(energysupplier$Start_channel)
energysupplier$Email_list <- as.factor(energysupplier$Email_list)
energysupplier$Home_label <- as.factor(energysupplier$Home_label)
energysupplier$Province <- as.factor(energysupplier$Province)
energysupplier$contract <- as.factor(energysupplier$contract)
energysupplier$home.age <- as.factor(energysupplier$home.age)

##BARCHART AND DESCRIPTIVES-----------------------------------------------

ggplot(energysupplier, aes(Churn, fill = as.factor(Gender))) + 
  geom_bar( position = "dodge",alpha = 0.50) +
  theme_bw() + labs(title = "Gender and Churn", x = "Churn", y = "Percentage" )

ggplot(energysupplier, aes(Churn, fill = as.factor(Start_channel))) + 
  geom_bar( position = "fill",alpha = 0.50) +
  theme_bw() + labs(title = "Start channel and Churn", x = "Churn", y = "Percentage" )

boxplot(energysupplier$Age~energysupplier$Churn)##younger people churn more? 

boxplot(energysupplier$Relation_length~energysupplier$Churn)##the longer the relationship less likely to churn 

boxplot(energysupplier$Electricity_usage~energysupplier$Churn)
boxplot(energysupplier$Gas_usage~energysupplier$Churn)

ggplot(energysupplier, aes(Age, Relation_length))+
  geom_smooth() + theme_bw()


ggplot(energysupplier, aes(Churn, fill = as.factor(Home_label))) + 
  geom_bar( position = "fill",alpha = 0.50) +
  theme_bw() + labs(title = "Home label and Churn", x = "Churn", y = "Percentage" )


ggplot(energysupplier, aes(Churn, fill = as.factor(Start_channel))) + 
  geom_bar( position = "fill",alpha = 0.50) +
  theme_bw() + labs(title = "Start channel and Churn", x = "Churn", y = "Percentage" )

cor.test(energysupplier$Income, energysupplier$Age, method = "pearson")
cor.test(energysupplier$Income, energysupplier$Province2, method = "pearson")

chisq.test(energysupplier$Gender, energysupplier$Churn)
chisq.test(energysupplier$Province, energysupplier$Churn)

LRconcept <- glm(Churn ~ + Age + log(Income) + Relation_length, family=binomial, data=energysupplier)
summary(LRconcept)

ggplot(energysupplier, aes(Churn)) + 
  geom_bar(aes(fill = Churn),alpha = 0.5) + 
  facet_wrap(~Gender + Home_label) +
  theme_bw() +
  labs(title = "Gender and Churn", x = "Churn", y = "Percentage" )

ggplot(energysupplier, aes(Age, Income))+
  geom_point(color = "cornflowerblue",
             alpha = .7,
             size = 1) + 
  geom_smooth() +theme_bw()

ggplot(energysupplier, aes(Customer_ID, log(Electricity_usage), color = "red")) +
  geom_line(aes(Customer_ID, log(Income), color = "blue"))

## Create a subset 

#Get a 75% estimation sample and 25% validation sample
set.seed(1234)
energysupplier$estimation.sample <-rbinom(nrow(energysupplier), 1, 0.75)

#Create a new dataframe with only the validation sample
validation.energy <- energysupplier[energysupplier$estimation.sample==0,]

#LOGISTIC REGRESSION----------------------------------------------------------------

LRS <- glm(Churn ~ Gender + Age + log(Income) + Relation_length + Province,  family = binomial,  data = energysupplier, subset = estimation.sample == 1)
summary(LRS)
AIC(LRS)
BIC(LRS)
exp(coef(LRS))

# Predict model 
predictions_model_S <- predict(LRS, type = "response", newdata=validation.energy)

# Fit criteria/Model validation

#Make the basis for the hit rate table
predicted_model_S <- ifelse(predictions_model_S>.5,1,0) #?check what does values mean!
hit_rate_modelS <- table(validation.energy$Churn, predicted_model_S, dnn= c("Observed", "Predicted"))

hit_rate_modelS

#Get the hit rate
(hit_rate_modelS[1,1]+hit_rate_modelS[2,2])/sum(hit_rate_modelS) #65.44 %

#Top decile lift
library(dplyr) 
decile_predicted_modelS <- ntile(predicted_model_S, 10)

decile_modelS <- table(validation.energy$Churn, decile_predicted_modelS, dnn= c("Observed", "Decile"))

decile_modelS

#Calculate the TDL
(decile_modelS[2,10] / (decile_modelS[1,10]+ decile_modelS[2,10])) / mean(validation.energy$Churn) #1.3

#Make lift curve
pred_modelS <- prediction(predicted_model_S, validation.energy$Churn)
perf_modelS <- performance(pred_modelS,"tpr","fpr")
plot(perf_modelS,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_modelS <- performance(pred_modelS,"auc")

#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc_modelS@y.values)*2-1 #0.31

##STEPWISE REGRESSION-----------------------------------------------------------------------------------
library(MASS)
full.logistic <- glm(Churn~., data = energysupplier, family = binomial, subset = estimation.sample==1)
null.logistic <- glm(Churn~0, data = energysupplier, family = binomial,subset = estimation.sample==1)

#####STEPWISE WITH AIC
Logistic.backward <- stepAIC(full.logistic, direction="backward", trace = TRUE)#AIC = 15190
logistic.forward <- stepAIC(null.logistic, direction="forward",
                            scope=list(lower=null.logistic, upper=full.logistic), trace = TRUE)#AIC = 15190
logistic.both <- stepAIC(full.logistic, direction="both", trace = TRUE)#AIC = 15190

##stepwise with AIC, all directions conclude in the same model (variables)

####STEPWISE WITH BIC 
bic.backward <- stepAIC(full.logistic, direction="backward", trace = TRUE,
                        k = log(sum((energysupplier$estimation.sample))))#AIC = 15280 
bic.forward <- stepAIC(null.logistic, direction = "forward",
                       scope = list(lower=null.logistic, upper=full.logistic), trace = TRUE,
                       k = log(sum((energysupplier$estimation.sample))))#AIC = 15280
bic.both <- stepAIC(full.logistic, direction = "both", trace = TRUE,
                    k = log(sum((energysupplier$estimation.sample))))#AIC = 15280

##stepwise with BIC, all direction conclude in same model (variables)

AIC.list <- AIC(Logistic.backward, logistic.forward,logistic.both,bic.backward, bic.forward, bic.both)
BIC.list <- BIC(Logistic.backward, logistic.forward,logistic.both,bic.backward, bic.forward, bic.both)
##BIC models have generally less degrees of freedom. 
#maybe try and plot models by degrees of freedom 

##STEPWISE ESTIMATION
#Estimate the model using only the estimation sample(DONE ABOVE)

#Get predictions for all observations
AIC.prediction <- predict(logistic.forward, type = "response", newdata= validation.energy)
AIC.predicted <- ifelse(AIC.prediction > 0.5, 1, 0)
BIC.prediction <- predict(bic.forward, type = "response", newdata= validation.energy)
BIC.predicted <- ifelse(BIC.prediction > 0.5, 1, 0)
### After this you can calculate the fit criteria on this validation sample

##FIT CRITERIA FOR STEPWISE 
#HIT RATE 
#Make the basis for the hit rate table
hit.rate.AIC <- table(validation.energy$Churn, AIC.predicted, dnn= c("Observed", "Predicted"))
hit.rate.BIC <- table(validation.energy$Churn, BIC.predicted, dnn = c("Observed", "Predicted"))

#Get the hit rate
(hit.rate.AIC[1,1]+hit.rate.AIC[2,2])/sum(hit.rate.AIC)##0.75
(hit.rate.BIC[1,1]+hit.rate.BIC[2,2])/sum(hit.rate.BIC)##0.74

#Top decile lift(Table)
decile.AIC <- ntile(AIC.prediction, 10)
decile.BIC <- ntile(BIC.prediction, 10)

decile.AIC.model <- table(validation.energy$Churn, decile.AIC, dnn= c("Observed", "Decile"))
decile.BIC.model <- table(validation.energy$Churn, decile.BIC,dnn= c("Observed", "Decile"))

#Calculate the TDL
(decile.AIC.model[2,10] / (decile.AIC.model[1,10]+ decile.AIC.model[2,10])) / 
  mean(as.numeric(validation.energy$Churn))##1.88
(decile.BIC.model[2,10] / (decile.BIC.model[1,10]+ decile.BIC.model[2,10])) / 
  mean(as.numeric(validation.energy$Churn))##1.88

##GINI
#Make lift curve
install.packages("ROCR")
library(ROCR)

AIC.p <- prediction(AIC.prediction, validation.energy$Churn)
AIC.performance <- performance(AIC.p,"tpr","fpr")
plot(AIC.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc.AIC <- performance(AIC.p,"auc")

BIC.p <- prediction(BIC.prediction, validation.energy$Churn)
BIC.performance <- performance(BIC.p,"tpr","fpr")
plot(BIC.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc.BIC <- performance(BIC.p,"auc")

#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc.AIC@y.values)*2-1##0.6655136
as.numeric(auc.BIC@y.values)*2-1##0.6583541

##AIC seems better in all except degrees of freedom 



# ESTIMATE A CART TREE ------------------------------------------------------------------------
# Tree model
library(rpart)
library(partykit)

cart.tree.1 <- rpart(Churn ~.- logincome-estimation.sample- as.numeric(contract),
                     data=energysupplier, method="class", subset=estimation.sample==1)

cart.tree.1.visual <- as.party(cart.tree.1)

plot(cart.tree.1.visual , type="simple", gp = gpar(fontsize = 10))


##changing CART standard settings 
newsettings1 <- rpart.control(minsplit = 100, minbucket = 50, cp = 0.003, maxdepth = 30)
newsettings2 <- rpart.control(minsplit = 100, minbucket = 50, cp = 0.01, maxdepth = 30)

cart.tree.3 <- rpart(Churn ~.- logincome-estimation.sample- as.numeric(contract),
                     data=energysupplier, method="class", subset=estimation.sample==1, control = newsettings1)
cart.tree.4 <- rpart(Churn ~.- logincome-estimation.sample- as.numeric(contract),
                     data=energysupplier, method="class", subset=estimation.sample==1, control = newsettings2)
cart.tree.3.visual <- as.party(cart.tree.3)
cart.tree.4.visual <- as.party(cart.tree.4)
plot(cart.tree.3.visual , type="simple", gp = gpar(fontsize = 10))
plot(cart.tree.4.visual , type="simple", gp = gpar(fontsize = 10))

##Tree model predictions 
cart.predictions.1 <- predict(cart.tree.1, newdata= validation.energy, type ="prob")[,2]
cart.predicted.1 <- ifelse(cart.predictions.1>.5,1,0)
cart.predictions.3 <- predict(cart.tree.3, newdata= validation.energy, type ="prob")[,2]
cart.predicted.3 <- ifelse(cart.predictions.3>.5,1,0)
cart.predictions.4 <- predict(cart.tree.4, newdata= validation.energy, type ="prob")[,2]
cart.predicted.4 <- ifelse(cart.predictions.4>.5,1,0)

##hit rate CART tree 
hit.rate.tree.1 <- table(validation.energy$Churn, cart.predicted.1, dnn= c("Observed", "Predicted"))
(hit.rate.tree.1[1,1] + hit.rate.tree.1[2,2]) / sum(hit.rate.tree.1)## 0.715815
hit.rate.tree.3 <- table(validation.energy$Churn, cart.predicted.3, dnn= c("Observed", "Predicted"))
(hit.rate.tree.3[1,1] + hit.rate.tree.3[2,2]) / sum(hit.rate.tree.3)## 0.725106
hit.rate.tree.4 <- table(validation.energy$Churn, cart.predicted.4, dnn= c("Observed", "Predicted"))
(hit.rate.tree.4[1,1] + hit.rate.tree.4[2,2]) / sum(hit.rate.tree.4)## 0.715815

#Top decile lift
decile.tree.1 <- ntile(cart.predictions.1, 10)
decile.tree.3 <- ntile(cart.predictions.3, 10)
decile.tree.4 <- ntile(cart.predictions.4, 10)

decile.tree.table1<- table(validation.energy$Churn, decile.tree.1, dnn= c("Observed", "Decile"))
decile.tree.table3 <- table(validation.energy$Churn, decile.tree.3, dnn= c("Observed", "Decile"))
decile.tree.table4 <- table(validation.energy$Churn, decile.tree.4, dnn= c("Observed", "Decile"))

#Calculate the TDL
(decile.tree.table1[2,10] / (decile.tree.table1[1,10]+ decile.tree.table1[2,10])) / mean(as.numeric(validation.energy$Churn))##1.62461
(decile.tree.table3[2,10] / (decile.tree.table3[1,10]+ decile.tree.table3[2,10])) / mean(validation.energy$Churn)##1.723072
(decile.tree.table4[2,10] / (decile.tree.table4[1,10]+ decile.tree.table4[2,10])) / mean(validation.energy$Churn)##1.62461

#Make lift curve
install.packages("ROCR")
library(ROCR)

tree1.p <- prediction(cart.predictions.1, validation.energy$Churn)
tree3.p <- prediction(cart.predictions.3, validation.energy$Churn)
tree4.p <- prediction(cart.predictions.4, validation.energy$Churn)
tree1.performance <- performance(tree1.p,"tpr","fpr")
tree3.performance <- performance(tree3.p,"tpr","fpr")
tree4.performance <- performance(tree4.p,"tpr","fpr")

plot(tree1.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_tree1 <- performance(tree1.p,"auc")

plot(tree3.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_tree3 <- performance(tree3.p,"auc")

plot(tree4.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_tree4 <- performance(tree4.p,"auc")
#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc_tree1@y.values)*2-1##0.5075031
as.numeric(auc_tree3@y.values)*2-1##0.5493481
as.numeric(auc_tree4@y.values)*2-1##0.5075031


# BAGGING ------------------------------------------------------------------------
library(ipred)
library(caret)

baggingsettings <- rpart.control(minsplit = 2, cp = 0.0)
#Essentially these two arguments allow the individual trees to grow extremely deep, which leads to trees with high variance but low bias. Then when we apply bagging we're able to reduce the variance of the final model while keeping the bias low.

#estimate model with bagging
Bagging.tree1 <- bagging(Churn ~ Gender + Age+Income+Relation_length +Contract_length+Start_channel+
                           Email_list+Home_age+Home_label+Electricity_usage+
                           Gas_usage+Province, data=energysupplier, method="class", nbagg=25,
                         subset=estimation.sample==1, control=baggingsettings)
#Save predictions
predictions.bagging1 <- predict(Bagging.tree1, newdata=validation.energy, type ="response")
predicted.bagging1 <- ifelse(predictions.bagging1 > 0.5, 1, 0)

#calculate variable importance
pred.imp <- varImp(Bagging.tree1)
pred.imp

#You can also plot the results
library(RColorBrewer)
coul <- brewer.pal(9, "Greens")
par(mar=c(8,4,4,4))
barplot(pred.imp$Overall, main = "Variable Importance" ,las = 2, col = coul,
        names.arg=c("Age","Contract Length","Electricity Usage","Email List","Gas Usage", "Gender", "Home Age", 
                    "Home Label", "Income", "Province", "Relantion Length", "Start Channel"))

#HITRATE bagging tree 
hitrate.bagging <- table(validation.energy$Churn, predicted.bagging1, dnn= c("Observed", "Decile"))
(hitrate.bagging[1,1] + hitrate.bagging[2,2]) / sum(hitrate.bagging)##0.7358109

#Top decile lift

decile.predicted.bagging <- ntile(predictions.bagging1, 10)

decile.bagging <- table(validation.energy$Churn, decile.predicted.bagging, dnn= c("Observed", "Decile"))

decile.bagging

#Calculate the TDL
(decile.bagging[2,10] / (decile.bagging[1,10]+ decile.bagging[2,10])) / mean(validation.energy$Churn)##1.870763
##GINI
#Make lift curve
install.packages("ROCR")
library(ROCR)

bagging.p <- prediction(predictions.bagging1, validation.energy$Churn)
bagging.performance <- performance(bagging.p,"tpr","fpr")
plot(bagging.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_bagging <- performance(bagging.p,"auc")

#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc_bagging@y.values)*2-1##0.6170612


# BOOSTING----------------------------------------------------------------------------

library(gbm)
estimation.sample <- energysupplier[energysupplier$estimation.sample==1,]##no subset argument in gbm 

#Estimate the model
boost_tree1 <- gbm(Churn ~ Gender + Age+Income+Relation_length +Contract_length+as.factor(Start_channel)+
                     Email_list+Home_age+as.factor(Home_label)+Electricity_usage+
                     Gas_usage+as.factor(Province), data=estimation.sample, distribution = "bernoulli",
                   n.trees = 10000, shrinkage = 0.01, interaction.depth = 4)

#Get model output (summary also provides a graph)
boost_tree1
summary(boost_tree1, las = 2)

#Plot of Response variable with contract length variable
plot(boost_tree1,i="Contract_length") 
plot(boost_tree1,i="Electricity_usage")
plot(boost_tree1,i="Income")
plot(boost_tree1,i="Relation_length")
#Inverse relation with lstat variable

#Save predictions
predictions_boost1 <- predict(boost_tree1, newdata=validation.energy, n.trees = best.iter, type ="response")
predicted_boost1 <- ifelse(predictions_boost1 > 0.5, 1, 0)

#HITRATE boosting tree 
hitrate.boosting <- table(validation.energy$Churn, predicted_boost1, dnn= c("Observed", "Decile"))
(hitrate.boosting[1,1] + hitrate.boosting[2,2]) / sum(hitrate.boosting)##0.7580287

#Top decile lift

decile.predicted.boosting <- ntile(predictions_boost1, 10)

decile.boosting <- table(validation.energy$Churn, decile.predicted.boosting, dnn= c("Observed", "Decile"))

decile.boosting

#Calculate the TDL
(decile.boosting[2,10] / (decile.boosting[1,10]+ decile.boosting[2,10])) / mean(validation.energy$Churn)##1.895379

##GINI
#Make lift curve

boosting.p <- prediction(predictions_boost1, validation.energy$Churn)
boosting.performance <- performance(boosting.p,"tpr","fpr")
plot(boosting.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_boosting <- performance(boosting.p,"auc")

#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc_boosting@y.values)*2-1##0.6766217


##RANDOM FOREST------------------------------------------------------------------
library(randomForest)

Random_forest1 <- randomForest(as.factor(Churn) ~ .-estimation.sample-home.age-contract-logincome,
                               data=energysupplier, subset=estimation.sample==1, importance=TRUE)
Random_forest2 <-randomForest(as.factor(Churn) ~ .-estimation.sample-home.age-contract-logincome,
                              data=energysupplier, subset=estimation.sample==1,
                              ntree=500, mtry=3, nodesize=2, maxnodes=100, importance=TRUE)

varImpPlot(Random_forest1)
varImpPlot(Random_forest2)

predictions_forest1 <- predict(Random_forest1, newdata=validation.energy, type ="prob")[,2]
predicted_forest1 <- ifelse(predictions_forest1 > 0.5, 1, 0)

predictions_forest2 <- predict(Random_forest2, newdata=validation.energy, type ="prob")[,2]
predicted_forest2 <- ifelse(predictions_forest2 > 0.5, 1, 0)

varImpPlot(Random_forest1)
varImpPlot(Random_forest2)
#HITRATE random forest tree 
hitrate.forest <- table(validation.energy$Churn, predicted_forest1, dnn= c("Observed", "Decile"))
(hitrate.forest[1,1] + hitrate.forest[2,2]) / sum(hitrate.forest)##0.7560089

hitrate.forest2 <- table(validation.energy$Churn, predicted_forest2, dnn= c("Observed", "Decile"))
(hitrate.forest2[1,1] + hitrate.forest2[2,2]) / sum(hitrate.forest2)##0.7527772
#Top decile lift 1 

decile.predicted.forest <- ntile(predictions_forest1, 10)

decile.forest <- table(validation.energy$Churn, decile.predicted.forest, dnn= c("Observed", "Decile"))

decile.forest

#Calculate the TDL
(decile.forest[2,10] / (decile.forest[1,10]+ decile.forest[2,10])) / mean(validation.energy$Churn)##1.878969

#Top decile lift 2 

decile.predicted.forest2 <- ntile(predictions_forest2, 10)

decile.forest2 <- table(validation.energy$Churn, decile.predicted.forest2, dnn= c("Observed", "Decile"))

decile.forest2

#Calculate the TDL
(decile.forest2[2,10] / (decile.forest2[1,10]+ decile.forest2[2,10])) / mean(validation.energy$Churn)##1.887174

##GINI
#Make lift curve

forest.p <- prediction(predictions_forest1, validation.energy$Churn)
forest.performance <- performance(forest.p,"tpr","fpr")
plot(forest.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_forest <- performance(forest.p,"auc")

#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc_forest@y.values)*2-1##0.6583853

#Make lift curve 2

forest.p2 <- prediction(predictions_forest2, validation.energy$Churn)
forest.performance2 <- performance(forest.p2,"tpr","fpr")
plot(forest.performance2,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_forest2 <- performance(forest.p2,"auc")

#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc_forest2@y.values)*2-1##0.6565384

##SVM----------------------------------------------------------------------------
library(e1071)

svm_1 <- svm(Churn ~ Gender + Age+Income+Relation_length +Contract_length+Start_channel+
               Email_list+Home_age+Home_label+Electricity_usage+
               Gas_usage+Province, data = energysupplier, subset=energysupplier$estimation.sample==1,
             type = 'C-classification', probability = TRUE,
             kernel = 'linear')

plot(svm_1, energysupplier, Contract_length~Electricity_usage)
## Here we cna see that much like the other models, probability of churn decreases the longer contract length is 
#and probability to churn is higher the more electricity you use.

#Get predictions
predictions_svm1 <- predict(svm_1, newdata=validation.energy, probability=TRUE)
predictions_svm1 <- attr(predictions_svm1,"probabilities")[,1]
predicted_svm1 <- ifelse(predictions_svm1>.5,1,0)
#HITRATE SVM 
hitrate.svm1 <- table(validation.energy$Churn, predicted_svm1, dnn= c("Observed", "Decile"))
(hitrate.svm1[1,1] + hitrate.svm1[2,2]) / sum(hitrate.svm1)##0.7075338

#Top decile lift 1 

decile.predicted.svm <- ntile(predictions_svm1, 10)

decile.svm <- table(validation.energy$Churn, decile.predicted.svm, dnn= c("Observed", "Decile"))

decile.svm

#Calculate the TDL
(decile.svm[2,10] / (decile.svm[1,10]+ decile.svm[2,10])) / mean(validation.energy$Churn)##1.813328

##GINI
#Make lift curve

svm1.p <- prediction(predictions_svm1, validation.energy$Churn)
svm1.performance <- performance(svm1.p,"tpr","fpr")
plot(svm1.performance,xlab="Cumulative % of observations",ylab="Cumulative % of positive cases",xlim=c(0,1),ylim=c(0,1),xaxs="i",yaxs="i")
abline(0,1, col="red")
auc_svm1 <- performance(svm1.p,"auc")

#The Gini is related to the "Area under the Curve" (AUC), namely by: Gini = AUC*2 - 1
#So to get the Gini we do:
as.numeric(auc_svm1@y.values)*2-1##0.5755623


#Same models, other functions
svm_2 <- svm(Churn ~ Income + Relation_length, 
             data = Churn,
             type = 'C-classification', probability = TRUE,
             kernel = 'polynomial')
plot(svm_2, Churn, Income~Relation_length)

#Change the functional form
svm_3 <- svm(Churn ~ Income + Relation_length, 
             data = Churn, 
             type = 'C-classification', probability = TRUE,
             kernel = 'radial')
plot(svm_3, Churn, Income~Relation_length)

#Sigmoid
svm_4 <- svm(Churn ~ Income + Relation_length, 
             data = Churn,
             type = 'C-classification',
             probability = TRUE,
             kernel = 'sigmoid')
plot(svm_4, Churn, Income~Relation)
