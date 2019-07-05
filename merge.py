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
#read trials csv files
trials = pd.read_csv("test.csv")
added = pd.merge(filtered, trials, how='outer', on=psych_1.columns[0])
#output excel file with one combined, filtered, added table (but without order indicator)
added.to_excel("added.xlsx")
"""
ids = [SUB.id]
test = table(ids, NPEP_grand_linear(:,1,1), NPEP_grand_linear(:,2,1), NPEP_grand_linear(:,3,1), NPEP_grand_linear(:,4,1), NPEP_grand_linear(:,5,1), NPEP_grand_linear(:,6,1), NPEP_grand_linear(:,7,1), NPEP_grand_linear(:,8,1), NPEP_grand_linear(:,9,1), NPEP_grand_linear(:,10,1), NPEP_grand_linear(:,11,1), NPEP_grand_linear(:,12,1), NPEP_grand_linear(:,1,2), NPEP_grand_linear(:,2,2), NPEP_grand_linear(:,3,2), NPEP_grand_linear(:,4,2), NPEP_grand_linear(:,5,2), NPEP_grand_linear(:,6,2), NPEP_grand_linear(:,7,2), NPEP_grand_linear(:,8,2), NPEP_grand_linear(:,9,2), NPEP_grand_linear(:,10,2), NPEP_grand_linear(:,11,2), NPEP_grand_linear(:,12,2))
writetable(test,'test.csv','Delimiter',',')
"""
