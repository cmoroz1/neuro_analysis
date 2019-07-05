import pandas as pd
"""
Need to account for:
-duplicate subject IDs
"""
#reading csv files from each table
psych_1 = pd.read_csv("psych_1.csv")
psych_2 = pd.read_csv("psych_2.csv")
psych_3 = pd.read_csv("psych_3.csv")
print(psych_1.columns)
print(psych_2.columns)
print(psych_3.columns)
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
#combining 1 and 3
combined = pd.merge(psych_1, psych_3, how='outer', on=psych_1.columns[0])
#combining 1 and 3 and 2
combined = pd.merge(psych_3, psych_2, how='outer', on=psych_1.columns[0])
#reading the list of subjects that we care about
n = pd.read_excel("NFB analysis subjects 7.5.19.xlsx")
#filtering out subjects that we don't care about
filtered = pd.merge(n, combined, how='left', on=n.columns[0])
#print(filtered)
#filtered.to_excel("test.xlsx")
