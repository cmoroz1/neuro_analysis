import pandas as pd
from scipy import stats
#reading csv files from each table
psych_1 = pd.read_csv("psych_1.csv")
psych_2 = pd.read_csv("psych_2.csv")
psych_3 = pd.read_csv("psych_3.csv")
#The csv files are modified such that they all have the same name for the subject ID column.
#This is required for pd.merge() to work properly.
subject_id_column = psych_1.columns[0]
"""
#code used for checking whether there are duplicate columns
for i in psych_1.columns:
    if i in psych_2.columns:
        print(i)
    if i in psych_3.columns:
        print(i)
for i in psych_2.columns:
    if i in psych_3.columns:
        print(i)
"""
#combining 1 and 2
combined = pd.merge(psych_1, psych_2, how='outer', on=subject_id_column)
#combining 1 and 2 and 3
combined = pd.merge(combined, psych_3, how='outer', on=subject_id_column)
#reading the list of subjects that we care about
n = pd.read_excel("NFB analysis subjects 7.5.19.xlsx")
#read trials csv files
trials = pd.read_csv("DMN_NF_stats.csv")
#merge trials into the n subjects file
n = pd.merge(n, trials, how='outer', on=subject_id_column)
#reading and adding in 90_stats file
ninety = pd.read_csv("DMN_NF_90_stats.csv")
n = pd.merge(n, ninety, how='outer', on=subject_id_column)
#filtering out subjects that we don't care about
filtered = pd.merge(n, combined, how='left', on=subject_id_column)
#replace blank values or ones that contain ! or ~ with -9999
filtered.replace(to_replace=r'.*!+.*', value=float('NaN'), regex=True, inplace=True)
filtered.replace(to_replace=r'.*~+.*', value=float('NaN'), regex=True, inplace=True)
filtered.fillna(float('NaN'), inplace=True)

#running correlations on DMN_NF_2ndHalf, DMN_NF_UP_2ndHalf, DMN_NF_DN_2ndHalf
#first on clinical_status=0
dropped = filtered.loc[filtered['Clinical_Status'] == 0].dropna()
print("Clinical_Status=0")
for i in range(10, len(dropped.columns)):
    rho, pval = stats.spearmanr(dropped.DMN_NF_2ndHalf,dropped[dropped.columns[i]])
    if pval <= 0.05:
        print("DMN_NF_2ndHalf with", dropped.columns[i], "rho =", rho, "p =", pval)
for i in range(10, len(dropped.columns)):
    rho, pval = stats.spearmanr(dropped.DMN_NF_UP_2ndHalf,dropped[dropped.columns[i]])
    if pval <= 0.05:
        print("DMN_NF_UP_2ndHalf with", dropped.columns[i], "rho =", rho, "p =", pval)
for i in range(10, len(dropped.columns)):
    rho, pval = stats.spearmanr(dropped.DMN_NF_DN_2ndHalf,dropped[dropped.columns[i]])
    if pval <= 0.05:
        print("DMN_NF_DN_2ndHalf with", dropped.columns[i], "rho =", rho, "p =", pval)
#next on clinical_status=1
dropped = filtered.loc[filtered['Clinical_Status'] == 1].dropna()
print("Clinical_Status=1")
for i in range(10, len(dropped.columns)):
    rho, pval = stats.spearmanr(dropped.DMN_NF_2ndHalf,dropped[dropped.columns[i]])
    if pval <= 0.05:
        print("DMN_NF_2ndHalf with", dropped.columns[i], "rho =", rho, "p =", pval)
for i in range(10, len(dropped.columns)):
    rho, pval = stats.spearmanr(dropped.DMN_NF_UP_2ndHalf,dropped[dropped.columns[i]])
    if pval <= 0.05:
        print("DMN_NF_UP_2ndHalf with", dropped.columns[i], "rho =", rho, "p =", pval)
for i in range(10, len(dropped.columns)):
    rho, pval = stats.spearmanr(dropped.DMN_NF_DN_2ndHalf,dropped[dropped.columns[i]])
    if pval <= 0.05:
        print("DMN_NF_DN_2ndHalf with", dropped.columns[i], "rho =", rho, "p =", pval)
#output excel file with one combined, filtered, added table (but without order indicator)
filtered.to_excel("added.xlsx")
