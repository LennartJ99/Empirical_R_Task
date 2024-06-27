###Basic Regression without Control Variables and Total Migration Differential Numbers
library(jtools)
simple.lm.tot1<-summ(lm(data=Combined_Data, DiffTotal2017~Election2017))

simple.lm.tot2<-summ(lm(data=Combined_Data, DiffTotal2018~Election2017))

simple.lm.tot3<-summ(lm(data=Combined_Data, DiffTotal2021~Election2021))

simple.lm.tot4<-summ(lm(data=Combined_Data, DiffTotal2022~Election2021))

print(simple.lm.tot1)
print(simple.lm.tot2)
print(simple.lm.tot3)
print(simple.lm.tot4)

###Basic Regression without Control Variables and Migration Differential in Percentage
simple.lm.per1<-Combined_Data%>%
  mutate(DiffTotal2017=DiffTotal2017/Total2016*100)
simple.lm.per.11<-summ(lm(data=simple.lm.per1,DiffTotal2017~Election2017))

simple.lm.per2<-Combined_Data%>%
  mutate(DiffTotal2018=DiffTotal2018/Total2016*100)
simple.lm.per.22<-summ(lm(data=simple.lm.per2,DiffTotal2018~Election2017))

simple.lm.per3<-Combined_Data%>%
  mutate(DiffTotal2021=DiffTotal2021/Total2020*100)
simple.lm.per.33<-summ(lm(data=simple.lm.per3,DiffTotal2021~Election2021))

simple.lm.per4<-Combined_Data%>%
  mutate(DiffTotal2022=DiffTotal2022/Total2020*100)
simple.lm.per.44<-summ(lm(data=simple.lm.per4,DiffTotal2022~Election2021))

print(simple.lm.per.11)
print(simple.lm.per.22)
print(simple.lm.per.33)
print(simple.lm.per.44)

###Basic Regression with Control Variables and Migration Differential as Total
allControl.lm.tot1<-summ(lm(data=Combined_Data, DiffTotal2017~Election2017+Big.City+East.Germany+Total2016+Unemployment2017+PurchasePower2017+KH2017))

allControl.lm.tot2<-summ(lm(data=Combined_Data, DiffTotal2018~Election2017+Big.City+East.Germany+Total2016+Unemployment2018+PurchasePower2018+KH2018))

allControl.lm.tot3<-summ(lm(data=Combined_Data, DiffTotal2021~Election2021+Big.City+East.Germany+Total2020+Unemployment2021+PurchasePower2021+KH2021))

allControl.lm.tot4<-summ(lm(data=Combined_Data, DiffTotal2022~Election2021+Big.City+East.Germany+Total2020+Unemployment2021+PurchasePower2021+KH2021))

print(allControl.lm.tot1)
print(allControl.lm.tot2)
print(allControl.lm.tot3)
print(allControl.lm.tot4)
###Basic Regression with Control Variables and Migration Differential as Percentage
allControl.lm.per111<-summ(lm(data=simple.lm.per1, DiffTotal2017~Election2017+Big.City+East.Germany+Total2016+Unemployment2017+PurchasePower2017+KH2017))

allControl.lm.per222<-summ(lm(data=simple.lm.per2, DiffTotal2018~Election2017+Big.City+East.Germany+Total2016+Unemployment2018+PurchasePower2018+KH2018))

allControl.lm.per333<-summ(lm(data=simple.lm.per3, DiffTotal2021~Election2021+Big.City+East.Germany+Total2020+Unemployment2021+PurchasePower2021+KH2021))

allControl.lm.per444<-summ(lm(data=simple.lm.per4, DiffTotal2022~Election2021+Big.City+East.Germany+Total2020+Unemployment2021+PurchasePower2021+KH2021))

print(allControl.lm.per111)
print(allControl.lm.per222)
print(allControl.lm.per333)
print(allControl.lm.per444)

###So far the Regression with percentage values seems to be more robust. While the regressions with Total values only have a 
###95% significance level in the first year, the regressions with percentage values have a 95% significance level in 3 out of 4 regressions,
###and a significance level of 85% in the 3rd regression. The R-squared values are also higher in the regressions with percentage values.

###Reverse Regression with percentage increase

simple.rev.lm.per1<-summ(lm(data=simple.lm.per1, Election2017~DiffTotal2017))
simple.rev.lm.per2<-summ(lm(data=simple.lm.per3, Election2021~DiffTotal2021))
simple.rev.lm.per3<-summ(lm(data=Combined_Data, Election2021~DiffTotal2021))
simple.rev.lm.per4<-summ(lm(data=Combined_Data, Election2021~DiffTotal2022))

print(simple.rev.lm.per1)
print(simple.rev.lm.per2)
print(simple.rev.lm.per3)
print(simple.rev.lm.per4)

###Reverse Regression with percentage increase and control variables
control.rev.lm.per1<-summ(lm(data=simple.lm.per1, Election2017~DiffTotal2017+Big.City+East.Germany+Total2016+Unemployment2017+PurchasePower2017+KH2017))

control.rev.lm.per2<-summ(lm(data=simple.lm.per3, Election2021~DiffTotal2021+Big.City+East.Germany+Total2020+Unemployment2021+PurchasePower2021+KH2021))


print(control.rev.lm.per1)
print(control.rev.lm.per2)

###Balancing Test

