library(dplyr)
library(ggplot2)
library(tidyr)
library(car)
library(lmtest)
setwd("C:/Users/hasib/Downloads/Question 5")
# Load income and election data
income_df <- read.csv("tulot2017.csv", stringsAsFactors = FALSE, fileEncoding = "Latin1")
election_df <- read.csv("ek2023.csv", stringsAsFactors = FALSE, fileEncoding = "Latin1")
head(income_df)
head(election_df)

colnames(income_df)
colnames(election_df)

#merge data on "Alue" or Municipality
merged_df <- full_join(income_df, election_df, by = "Alue")
merged_df

merged_df <- merged_df %>% filter(Alue != "KOKO MAA")
merged_df

#filter out missing values for analysis
analysis_df <- merged_df %>% filter(!is.na(Tulot) & !is.na(SDP))

analysis_df

#feature engineering

metropolitan_cities <- c("Helsinki", "Espoo", "Vaanta", "Kauniainen")

analysis_df <- analysis_df %>% 
  mutate(Metropolitan = ifelse(Alue %in% metropolitan_cities, "Metro", "Non-Metro"), 
         Income_Category = cut(Tulot, breaks = quantile(Tulot, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE), 
         labels = c("Low", "Medium", "High"), include.lowest = TRUE), 
         Left_Bloc = SDP + VAS + VIHR, Center_Bloc = KESK + KD, Right_Bloc = KOK + PS)

head(analysis_df)

#determine dominant parties
party_cols <- c("SDP", "PS", "KOK", "KESK", "VIHR", "VAS", "RKP") 
analysis_df$Dominant_Party <- apply(analysis_df[, party_cols], 1, function(row) names(which.max(row)))

str(party_cols)

#descriptive statistics 
summary(analysis_df$Tulot) 
table(analysis_df$Metropolitan) 
table(analysis_df$Income_Category) 
table(analysis_df$Dominant_Party)

#visualization
#scatterplot of Income vs Party support by metroplotan status
party_data <- analysis_df %>%
  select(Alue, Tulot, KOK, KESK, VIHR, PS, Metropolitan) %>%
  pivot_longer(cols = c("KOK", "KESK", "VIHR", "PS"), names_to = "Party", values_to = "Support")

ggplot(party_data, aes(x = Tulot, y = Support, color = Metropolitan)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm") +
  facet_wrap(~ Party, scales = "free_y") +
  labs(title = "Income vs Party Support by Metropolitan Status",
       x = "Average Income (€)",
       y = "Party Support (%)") +
  theme_bw()

#boxplot showing Income distribution by category
ggplot(analysis_df, aes(x = Income_Category, y = Tulot, fill = Income_Category)) +
  geom_boxplot() +
  labs(title = "Income Distribution by Income Category",
       x = "Income Category", y = "Average Income (€)") +
  theme_bw() +
  theme(legend.position = "none")

#which area has the outliers?: Kauniainen
analysis_df %>%
  arrange(desc(Tulot)) %>%
  select(Alue, Tulot) %>%
  head(10)

# Barplot: Mean party support by income category
party_means <- analysis_df %>%
  group_by(Income_Category) %>%
  summarise(across(all_of(c("KOK", "KESK", "VIHR", "PS", "SDP")), mean, na.rm = TRUE)) %>%
  pivot_longer(cols = -Income_Category, names_to = "Party", values_to = "Mean_Support")

ggplot(party_means, aes(x = Income_Category, y = Mean_Support, fill = Party)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Party Support by Income Category",
       x = "Income Category", y = "Support (%)") +
  theme_bw()

#statistical tests
#pearson correlation between income and party support
correlations <- sapply(party_cols, function(party) {
  cor.test(analysis_df$Tulot, analysis_df[[party]], use = "complete.obs")$estimate
})
print(correlations)

#t-test for income difference by metropolitan vs non-metropolitan
t_test_income <- t.test(Tulot ~ Metropolitan, data = analysis_df)
print(t_test_income)

#non-parametric test wilcoxon rank-sum
wilcox.test(Tulot ~ Metropolitan, data = analysis_df)

#Anova
dominant_counts <- table(analysis_df$Dominant_Party)
major_parties <- names(which(dominant_counts > 10))
anova_df <- filter(analysis_df, Dominant_Party %in% major_parties)
anova_result <- aov(Tulot ~ Dominant_Party, data = anova_df)
summary(anova_result)
if(summary(anova_result)[[1]][["Pr(>F)"]][1] < 0.05){
  print(TukeyHSD(anova_result))
}

#linear regression
#model 1
lm1 <- lm(KOK ~ Tulot, data = analysis_df)
summary(lm1)

#mode 2: adding metropolitan area as a covariate
lm2 <- lm(KOK ~ Tulot + Metropolitan, data = analysis_df)
summary(lm2)

#model comparison
anova(lm1, lm2)

#regression diagnostics for model 2
bptest(lm2)
shapiro.test(residuals(lm2))

#histogram of residuals
resid_vals <- residuals(lm2)
hist(resid_vals,
     breaks = 20,
     main = "Histogram of residuals",
     xlab = "Residuals")

#qq plot
qqnorm(resid_vals)
qqline(resid_vals, col = "red")

#residuals vs fitted plot
plot(lm2$fitted.values, resid_vals,
     xlab = "Fitted values",
     ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, col = "red")

