import pandas as pd
"""
Need to account for:
-duplicate subject IDs
"""
#reading csv files from each table
psych_1 = pd.read_csv("psych_1.csv")
psych_2 = pd.read_csv("psych_2.csv")
psych_3 = pd.read_csv("psych_3.csv")
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
combined = pd.merge(psych_1, psych_2, how='outer', on=psych_1.columns[0])
#combining 1 and 2 and 3
combined = pd.merge(combined, psych_3, how='outer', on=psych_1.columns[0])
#reading the list of subjects that we care about
n = pd.read_excel("NFB analysis subjects 7.5.19.xlsx")
#filtering out subjects that we don't care about
filtered = pd.merge(n, combined, how='left', on=n.columns[0])
#replace blank values or ones that contain ! or ~ with -9999
filtered.replace(to_replace=r'.*!+.*', value="-9999", regex=True, inplace=True)
filtered.replace(to_replace=r'.*~+.*', value="-9999", regex=True, inplace=True)
filtered.fillna('-9999', inplace=True)
print(filtered)
#output excel file with one combined, filtered table
filtered.to_excel("filtered.xlsx")
