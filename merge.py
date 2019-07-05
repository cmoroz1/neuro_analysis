import pandas as pd
import pprint
#from numpy import genfromtxt
#p1 = genfromtxt('/Users/Conrad/research/neuro_analysis/psych_1.csv', delimiter=',')
p1 = pd.read_csv("/Users/Conrad/research/neuro_analysis/psych_1.csv")
p3 = pd.read_csv("/Users/Conrad/research/neuro_analysis/psych_3.csv")
#print(p1)
#print(p3)
all = pd.merge(p1, p3, how='outer', on=p1.columns[0])
rel = pd.read_excel("/Users/Conrad/research/neuro_analysis/NFB_analysis_subjects_7.1.19.xlsx")
print(rel)
print(rel.columns)
need = pd.merge(rel, all, how='left', on=p1.columns[0])
print(need)
need.to_excel("test.xlsx")
"""
print(all)
print(len(p1.columns))
print(len(p3.columns))
print(len(all.columns))
all.to_excel("test.xlsx")
"""
