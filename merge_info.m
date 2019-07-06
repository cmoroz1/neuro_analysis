clc; clear;
load('NPEP_v3.mat') % called SUB & NP_data & ClinicalStatus
load('corr_val')    % called NPEP_grand_linear

% Creates list of ids and trialOrders where index corresponds to same subj
for i = 1:length(SUB)
    ids(i) = convertCharsToStrings(SUB(i).id);
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

combined_info = table(transpose(ids), transpose(trialOrders), transpose(group),...
             NPEP_grand_linear(:,1,1), NPEP_grand_linear(:,2,1),...
             NPEP_grand_linear(:,3,1), NPEP_grand_linear(:,4,1),...
             NPEP_grand_linear(:,5,1), NPEP_grand_linear(:,6,1),...
             NPEP_grand_linear(:,7,1), NPEP_grand_linear(:,8,1),...
             NPEP_grand_linear(:,9,1), NPEP_grand_linear(:,10,1),... 
             NPEP_grand_linear(:,11,1), NPEP_grand_linear(:,12,1),...
             NPEP_grand_linear(:,1,2), NPEP_grand_linear(:,2,2),...
             NPEP_grand_linear(:,3,2), NPEP_grand_linear(:,4,2),...
             NPEP_grand_linear(:,5,2), NPEP_grand_linear(:,6,2),...
             NPEP_grand_linear(:,7,2), NPEP_grand_linear(:,8,2),...
             NPEP_grand_linear(:,9,2), NPEP_grand_linear(:,10,2),...
             NPEP_grand_linear(:,11,2), NPEP_grand_linear(:,12,2));
writetable(combined_info,'subj_groups_and_corr.csv','Delimiter',',');
        