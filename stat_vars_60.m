%% Computing meaningful statistics from NPEP_grand_linear
clc; clear;
load('NPEP_v3.mat');  % called SUB & NP_data & ClinicalStatus
load('corr_val.mat'); % called NPEP_grand_linear

% Creates list of ids and trialOrders where index corresponds to same subj
for i = 1:length(SUB)
    ids(i) = convertCharsToStrings(SUB(i).id);
    if strcmp(SUB(i).sex, 'MALE')
        sex(i) = 0;
    else
        sex(i) = 1;
    end
    age(i) = str2num(SUB(i).age);
    trialOrders(i) = convertCharsToStrings(strjoin(SUB(i).trialOrder));
end

% Creates a list of unique trialOrders to assign subj into groups
index = 1;
key(index) = trialOrders(1);
for i = 1:length(SUB)
    curr_subj = trialOrders(i);
    found = 0;
    for j = 1:index
        if strcmp(curr_subj, key(j))
            found = 1;
        end
    end
    if found == 0
        index = index + 1;
        key(index) = trialOrders(i);
    end
end

% Assigns subj into groups based on trialOrder
for i = 1:length(SUB)
    for j = 1:length(key)
        if strcmp(trialOrders(i),key(j))
            group(i) = j;
            continue;
        end
    end
end

% The 3rd, 6th, 7th, and 10th trials are 60 sec (30 tr) trials
DMN_NF_60_UP = nanmean(NPEP_grand_linear(:,[3,6,7,10],1),2);
DMN_NF_60_DN = nanmean(NPEP_grand_linear(:,[3,6,7,10],2),2);

combined = [transpose(ids), ClinicalStatus, DMN_NF_60_UP, DMN_NF_60_DN];

var_names = {'Subj_ID','Clinical_Status','DMN_NF_60_UP','DMN_NF_60_DN'};

T = array2table(combined, 'VariableNames', var_names);
writetable(T,'DMN_NF_60_stats.csv','Delimiter',',');
