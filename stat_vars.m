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

DMN_NF = mean(nanmean(NPEP_grand_linear(:,:,:),2),3);

DMN_NF_1stHalf = mean(nanmean(NPEP_grand_linear(:,1:6,:),2),3);

DMN_NF_2ndHalf = mean(nanmean(NPEP_grand_linear(:,7:12,:),2),3);

DMN_NF_UP=nanmean(NPEP_grand_linear(:,1:12,1),2);

DMN_NF_UP_1stHalf=nanmean(NPEP_grand_linear(:,1:6,1),2);

DMN_NF_UP_2ndHalf=nanmean(NPEP_grand_linear(:,7:12,1),2);

DMN_NF_DN=nanmean(NPEP_grand_linear(:,1:12,2),2);

DMN_NF_DN_1stHalf=nanmean(NPEP_grand_linear(:,1:6,2),2);

DMN_NF_DN_2ndHalf=nanmean(NPEP_grand_linear(:,7:12,2),2);

DMN_NF_learning = mean(nanmean(NPEP_grand_linear(:,7:12,:),2),3) - mean(nanmean(NPEP_grand_linear(:,1:6,:),2),3);

DMN_NF_UP_learning = nanmean(NPEP_grand_linear(:,7:12,1),2) - nanmean(NPEP_grand_linear(:,1:6,1),2);

DMN_NF_DN_learning = nanmean(NPEP_grand_linear(:,7:12,2),2) - nanmean(NPEP_grand_linear(:,1:6,2),2);

combined = [transpose(ids), transpose(group), transpose(sex), transpose(age), DMN_NF, DMN_NF_1stHalf, DMN_NF_2ndHalf, DMN_NF_UP, DMN_NF_UP_1stHalf,...
            DMN_NF_UP_2ndHalf, DMN_NF_DN, DMN_NF_DN_1stHalf, DMN_NF_DN_2ndHalf,...
            DMN_NF_learning, DMN_NF_UP_learning, DMN_NF_DN_learning];

var_names = {'Subj_ID','Group_Num','Sex','Age','DMN_NF','DMN_NF_1stHalf','DMN_NF_2ndHalf','DMN_NF_UP','DMN_NF_UP_1stHalf',...
             'DMN_NF_UP_2ndHalf','DMN_NF_DN','DMN_NF_DN_1stHalf','DMN_NF_DN_2ndHalf',...
             'DMN_NF_learning','DMN_NF_UP_learning','DMN_NF_DN_learning'};
         
T = array2table(combined, 'VariableNames', var_names);
writetable(T,'DMN_NF_stats.csv','Delimiter',',');

%% Testing normallity of data
% test(1) = adtest(DMN_NF);
% test(2) = adtest(DMN_NF_1stHalf);
% test(3) = adtest(DMN_NF_2ndHalf);
% test(4) = adtest(DMN_NF_UP);             % Not normally distributed
% test(5) = adtest(DMN_NF_UP_1stHalf);
% test(6) = adtest(DMN_NF_UP_2ndHalf);     % Not normally distributed
% test(7) = adtest(DMN_NF_DN);
% test(8) = adtest(DMN_NF_DN_1stHalf);
% test(9) = adtest(DMN_NF_DN_2ndHalf);     % Not normally distributed
% test(10) = adtest(DMN_NF_learning);
% test(11) = adtest(DMN_NF_UP_learning);
% test(12) = adtest(DMN_NF_DN_learning);

%% Computing & Removing Outliers
% Identify outliers in NF-regulation performance and learning (up-regulation, down-regulation or overall regulation).
% Outliers are identified according to the Grubbs test, recursively across all variables, until there are no more outliers left in any variable.
 while ~isempty(find(isoutlier(age(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF_UP(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF_DN(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF_2ndHalf(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF_UP_2ndHalf(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF_DN_2ndHalf(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF_learning(ClinicalStatus~=999),'grubbs')==1)) || ... 
    ~isempty(find(isoutlier(DMN_NF_UP_learning(ClinicalStatus~=999),'grubbs')==1)) || ...
    ~isempty(find(isoutlier(DMN_NF_DN_learning(ClinicalStatus~=999),'grubbs')==1));
 
    while ~isempty(find(isoutlier(age(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(age(ClinicalStatus~=999),'grubbs')==1)
        reduced=age(ClinicalStatus~=999); value=reduced(i)
        for v = 1:length(value)
            real_index=find(age==value(v)); display(real_index)    
            ClinicalStatus(find(age==value(v)))=999;
        end
    end
    while ~isempty(find(isoutlier(DMN_NF(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF(ClinicalStatus~=999); value=reduced(i)
        for v = 1:length(value)
            real_index=find(DMN_NF==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF==value(v)))=999;
        end
    end
    while ~isempty(find(isoutlier(DMN_NF_UP(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_UP(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_UP(ClinicalStatus~=999); value=reduced(i); 
        for v = 1:length(value)
            real_index=find(DMN_NF_UP==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_UP==value(v)))=999;
        end
    end
    
    while ~isempty(find(isoutlier(DMN_NF_DN(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_DN(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_DN(ClinicalStatus~=999); value=reduced(i);
        for v = 1:length(value)
            real_index=find(DMN_NF_DN==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_DN==value(v)))=999;
        end
    end
    while ~isempty(find(isoutlier(DMN_NF_2ndHalf(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_2ndHalf(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_2ndHalf(ClinicalStatus~=999); value=reduced(i)
        for v = 1:length(value)
            real_index=find(DMN_NF_2ndHalf==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_2ndHalf==value(v)))=999;
        end
    end
    while ~isempty(find(isoutlier(DMN_NF_UP_2ndHalf(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_UP_2ndHalf(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_UP_2ndHalf(ClinicalStatus~=999); value=reduced(i); 
        for v = 1:length(value)
            real_index=find(DMN_NF_UP_2ndHalf==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_UP_2ndHalf==value(v)))=999;
        end
    end
    
    while ~isempty(find(isoutlier(DMN_NF_DN_2ndHalf(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_DN_2ndHalf(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_DN_2ndHalf(ClinicalStatus~=999); value=reduced(i);
        for v = 1:length(value)
            real_index=find(DMN_NF_DN_2ndHalf==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_DN_2ndHalf==value(v)))=999;
        end
    end
    
    while ~isempty(find(isoutlier(DMN_NF_learning(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_learning(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_learning(ClinicalStatus~=999); value=reduced(i)
        for v = 1:length(value)
            real_index=find(DMN_NF_learning==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_learning==value(v)))=999;
        end
    end
    
    while ~isempty(find(isoutlier(DMN_NF_UP_learning(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_UP_learning(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_UP_learning(ClinicalStatus~=999); value=reduced(i)
        for v = 1:length(value)
            real_index=find(DMN_NF_UP_learning==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_UP_learning==value(v)))=999;
        end
    end
    
    while ~isempty(find(isoutlier(DMN_NF_DN_learning(ClinicalStatus~=999),'grubbs')==1)); 
        i=find(isoutlier(DMN_NF_DN_learning(ClinicalStatus~=999),'grubbs')==1)
        reduced=DMN_NF_DN_learning(ClinicalStatus~=999); value=reduced(i)
        for v = 1:length(value)
            real_index=find(DMN_NF_DN_learning==value(v)); display(real_index)    
            ClinicalStatus(find(DMN_NF_DN_learning==value(v)))=999;
        end
    end
end
outliers=find(ClinicalStatus==999)

% No outliers have been identified.
 
% Clean variables from outliers (redundant in this case, however maintained for robustness in case of modifications)
 DMN_NF(ClinicalStatus==999)=[];             DMN_NF_1stHalf(ClinicalStatus==999)=[];        DMN_NF_2ndHalf(ClinicalStatus==999)=[]; 
 DMN_NF_UP(ClinicalStatus==999)=[];          DMN_NF_UP_1stHalf(ClinicalStatus==999)=[];     DMN_NF_UP_2ndHalf(ClinicalStatus==999)=[]; 
 DMN_NF_DN(ClinicalStatus==999)=[];          DMN_NF_DN_1stHalf(ClinicalStatus==999)=[];     DMN_NF_DN_2ndHalf(ClinicalStatus==999)=[]; 
 DMN_NF_learning(ClinicalStatus==999)=[];    DMN_NF_UP_learning(ClinicalStatus==999)=[];    DMN_NF_DN_learning(ClinicalStatus==999)=[];
 age(ClinicalStatus==999)=[]; ClinicalStatus(ClinicalStatus==999)=[]; 
 
 whos ClinicalStatus  age sex dexterity DMN_NF DMN_NF_1stHalf DMN_NF_2ndHalf DMN_NF_UP DMN_NF_UP_1stHalf DMN_NF_UP_2ndHalf ...
     DMN_NF_DN DMN_NF_DN_1stHalf DMN_NF_DN_2ndHalf DMN_NF_learning DMN_NF_UP_learning DMN_NF_DN_learning
 
%% Summary statistics

%1st half session
%   DMN UP-REGULATION
%       Entire Sample
sample_mean_DMN_NF_UP_1stHalf  = mean(DMN_NF_UP_1stHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_UP_1stHalf    =  std(DMN_NF_UP_1stHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_UP_1stHalf = mean(DMN_NF_UP_1stHalf(ClinicalStatus==1));
control_sd_DMN_NF_UP_1stHalf   =  std(DMN_NF_UP_1stHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_UP_1stHalf    = mean(DMN_NF_UP_1stHalf(ClinicalStatus==0));
path_sd_DMN_NF_UP_1stHalf      =  std(DMN_NF_UP_1stHalf(ClinicalStatus==0));
%   DMN DOWN-REGULATION
%       Entire Sample
sample_mean_DMN_NF_DN_1stHalf  = mean(DMN_NF_DN_1stHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_DN_1stHalf    =  std(DMN_NF_DN_1stHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_DN_1stHalf = mean(DMN_NF_DN_1stHalf(ClinicalStatus==1));
control_sd_DMN_NF_DN_1stHalf   =  std(DMN_NF_DN_1stHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_DN_1stHalf    = mean(DMN_NF_DN_1stHalf(ClinicalStatus==0));
path_sd_DMN_NF_DN_1stHalf      =  std(DMN_NF_DN_1stHalf(ClinicalStatus==0));
%   DMN OVERALL REGULATION
%       Entire Sample
sample_mean_DMN_NF_1stHalf  = mean(DMN_NF_1stHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_1stHalf    =  std(DMN_NF_1stHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_1stHalf = mean(DMN_NF_1stHalf(ClinicalStatus==1));
control_sd_DMN_NF_1stHalf   =  std(DMN_NF_1stHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_1stHalf    = mean(DMN_NF_1stHalf(ClinicalStatus==0));
path_sd_DMN_NF_1stHalf      =  std(DMN_NF_1stHalf(ClinicalStatus==0));

%2nd half session
%   DMN UP-REGULATION
%       Entire Sample
sample_mean_DMN_NF_UP_2ndHalf  = mean(DMN_NF_UP_2ndHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_UP_2ndHalf    =  std(DMN_NF_UP_2ndHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_UP_2ndHalf = mean(DMN_NF_UP_2ndHalf(ClinicalStatus==1));
control_sd_DMN_NF_UP_2ndHalf   =  std(DMN_NF_UP_2ndHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_UP_2ndHalf    = mean(DMN_NF_UP_2ndHalf(ClinicalStatus==0));
path_sd_DMN_NF_UP_2ndHalf      =  std(DMN_NF_UP_2ndHalf(ClinicalStatus==0));
%   DMN DOWN-REGULATION
%       Entire Sample
sample_mean_DMN_NF_DN_2ndHalf  = mean(DMN_NF_DN_2ndHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_DN_2ndHalf    =  std(DMN_NF_DN_2ndHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_DN_2ndHalf = mean(DMN_NF_DN_2ndHalf(ClinicalStatus==1));
control_sd_DMN_NF_DN_2ndHalf   =  std(DMN_NF_DN_2ndHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_DN_2ndHalf    = mean(DMN_NF_DN_2ndHalf(ClinicalStatus==0));
path_sd_DMN_NF_DN_2ndHalf      =  std(DMN_NF_DN_2ndHalf(ClinicalStatus==0));
%   DMN OVERALL REGULATION
%       Entire Sample
sample_mean_DMN_NF_2ndHalf  = mean(DMN_NF_2ndHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_2ndHalf    =  std(DMN_NF_2ndHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_2ndHalf = mean(DMN_NF_2ndHalf(ClinicalStatus==1));
control_sd_DMN_NF_2ndHalf   =  std(DMN_NF_2ndHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_2ndHalf    = mean(DMN_NF_2ndHalf(ClinicalStatus==0));
path_sd_DMN_NF_2ndHalf      =  std(DMN_NF_2ndHalf(ClinicalStatus==0));

%Entire Session
%   DMN UP-REGULATION
%       Entire Sample
sample_mean_DMN_NF_UP  = mean(DMN_NF_UP(ClinicalStatus~=999));
sample_sd_DMN_NF_UP    =  std(DMN_NF_UP(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_UP = mean(DMN_NF_UP(ClinicalStatus==1));
control_sd_DMN_NF_UP   =  std(DMN_NF_UP(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_UP    = mean(DMN_NF_UP(ClinicalStatus==0));
path_sd_DMN_NF_UP      =  std(DMN_NF_UP(ClinicalStatus==0));
%   DMN DOWN-REGULATION
%       Entire Sample
sample_mean_DMN_NF_DN  = mean(DMN_NF_DN(ClinicalStatus~=999));
sample_sd_DMN_NF_DN    =  std(DMN_NF_DN(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_DN = mean(DMN_NF_DN(ClinicalStatus==1));
control_sd_DMN_NF_DN   =  std(DMN_NF_DN(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_DN    = mean(DMN_NF_DN(ClinicalStatus==0));
path_sd_DMN_NF_DN      =  std(DMN_NF_DN(ClinicalStatus==0));
%   DMN OVERALL REGULATION
%       Entire Sample
sample_mean_DMN_NF  = mean(DMN_NF(ClinicalStatus~=999));
sample_sd_DMN_NF    =  std(DMN_NF(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF = mean(DMN_NF(ClinicalStatus==1));
control_sd_DMN_NF   =  std(DMN_NF(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF    = mean(DMN_NF(ClinicalStatus==0));
path_sd_DMN_NF      =  std(DMN_NF(ClinicalStatus==0));

%Learning Score
%   DMN UP-REGULATION
%       Entire Sample
sample_mean_DMN_NF_UP_learning  = mean(DMN_NF_UP_2ndHalf(ClinicalStatus~=999) - DMN_NF_UP_1stHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_UP_learning    =  std(DMN_NF_UP_2ndHalf(ClinicalStatus~=999) - DMN_NF_UP_1stHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_UP_learning = mean(DMN_NF_UP_2ndHalf(ClinicalStatus==1) - DMN_NF_UP_1stHalf(ClinicalStatus==1));
control_sd_DMN_NF_UP_learning   =  std(DMN_NF_UP_2ndHalf(ClinicalStatus==1) - DMN_NF_UP_1stHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_UP_learning    = mean(DMN_NF_UP_2ndHalf(ClinicalStatus==0) - DMN_NF_UP_1stHalf(ClinicalStatus==0));
path_sd_DMN_NF_UP_learning      =  std(DMN_NF_UP_2ndHalf(ClinicalStatus==0) - DMN_NF_UP_1stHalf(ClinicalStatus==0));
%   DMN DOWN-REGULATION
%       Entire Sample
sample_mean_DMN_NF_DN_learning  = mean(DMN_NF_DN_2ndHalf(ClinicalStatus~=999) - DMN_NF_DN_1stHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_DN_learning    =  std(DMN_NF_DN_2ndHalf(ClinicalStatus~=999) - DMN_NF_DN_1stHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_DN_learning = mean(DMN_NF_DN_2ndHalf(ClinicalStatus==1) - DMN_NF_DN_1stHalf(ClinicalStatus==1));
control_sd_DMN_NF_DN_learning   =  std(DMN_NF_DN_2ndHalf(ClinicalStatus==1) - DMN_NF_DN_1stHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_DN_learning    = mean(DMN_NF_DN_2ndHalf(ClinicalStatus==0) - DMN_NF_DN_1stHalf(ClinicalStatus==0));
path_sd_DMN_NF_DN_learning      =  std(DMN_NF_DN_2ndHalf(ClinicalStatus==0) - DMN_NF_DN_1stHalf(ClinicalStatus==0));
%   DMN OVERALL REGULATION
%       Entire Sample
sample_mean_DMN_NF_learning  = mean(DMN_NF_2ndHalf(ClinicalStatus~=999) - DMN_NF_1stHalf(ClinicalStatus~=999));
sample_sd_DMN_NF_learning    =  std(DMN_NF_2ndHalf(ClinicalStatus~=999) - DMN_NF_1stHalf(ClinicalStatus~=999));
%       Control
control_mean_DMN_NF_learning = mean(DMN_NF_2ndHalf(ClinicalStatus==1) - DMN_NF_1stHalf(ClinicalStatus==1));
control_sd_DMN_NF_learning   =  std(DMN_NF_2ndHalf(ClinicalStatus==1) - DMN_NF_1stHalf(ClinicalStatus==1));
%       Pathological
path_mean_DMN_NF_learning    = mean(DMN_NF_2ndHalf(ClinicalStatus==0) - DMN_NF_1stHalf(ClinicalStatus==0));
path_sd_DMN_NF_learning      =  std(DMN_NF_2ndHalf(ClinicalStatus==0) - DMN_NF_1stHalf(ClinicalStatus==0));

%% Plotting bar graphs of DMN regulation
% 118 subjects, 51 control, 67 pathological

% Neurofeedback Performance Scores
figure;
E = [ sample_sd_DMN_NF_UP_2ndHalf/sqrt(118) control_sd_DMN_NF_UP_2ndHalf/sqrt(51) path_sd_DMN_NF_UP_2ndHalf/sqrt(67);...
      sample_sd_DMN_NF_DN_2ndHalf/sqrt(118) control_sd_DMN_NF_DN_2ndHalf/sqrt(51) path_sd_DMN_NF_DN_2ndHalf/sqrt(67);...
      sample_sd_DMN_NF_2ndHalf/sqrt(118)    control_sd_DMN_NF_2ndHalf/sqrt(51)    path_sd_DMN_NF_2ndHalf/sqrt(67)];
  
Y = [ sample_mean_DMN_NF_UP_2ndHalf control_mean_DMN_NF_UP_2ndHalf path_mean_DMN_NF_UP_2ndHalf;...
      sample_mean_DMN_NF_DN_2ndHalf control_mean_DMN_NF_DN_2ndHalf path_mean_DMN_NF_DN_2ndHalf;...
      sample_mean_DMN_NF_2ndHalf    control_mean_DMN_NF_2ndHalf    path_mean_DMN_NF_2ndHalf];

clr = [0 0 0; 0.8008 0.5195 0.2461; 0 0 1];
colormap(clr);

barwitherr(E,Y);
title('Neurofeedback Performance Scores');
legend('Full Sample','Control','Pathological');
xticks([1 2 3]);
xticklabels({'up-regulation','down-regulation','overall regulation'});
ylabel('NF performance score');
grid;

% Neurofeedback learning score
figure;
E = [ sample_sd_DMN_NF_UP_learning/sqrt(118) control_sd_DMN_NF_UP_learning/sqrt(51) path_sd_DMN_NF_UP_learning/sqrt(67);...
      sample_sd_DMN_NF_DN_learning/sqrt(118) control_sd_DMN_NF_DN_learning/sqrt(51) path_sd_DMN_NF_DN_learning/sqrt(67);...
      sample_sd_DMN_NF_learning/sqrt(118)    control_sd_DMN_NF_learning/sqrt(51)    path_sd_DMN_NF_learning/sqrt(67)];
  
Y = [ sample_mean_DMN_NF_UP_learning control_mean_DMN_NF_UP_learning path_mean_DMN_NF_UP_learning;...
      sample_mean_DMN_NF_DN_learning control_mean_DMN_NF_DN_learning path_mean_DMN_NF_DN_learning;...
      sample_mean_DMN_NF_learning    control_mean_DMN_NF_learning    path_mean_DMN_NF_learning];
  
clr = [0 0 0; 0.8008 0.5195 0.2461; 0 0 1];
colormap(clr);

BwE = barwitherr(E,Y);
title('Neurofeedback Learning Scores');
legend('Full Sample','Control','Pathological');
xticks([1 2 3]);
xticklabels({'up-regulation','down-regulation','overall regulation'});
ylabel('NF learning score');
grid;