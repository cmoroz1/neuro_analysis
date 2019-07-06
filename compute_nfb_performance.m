clc; clear;
load('NPEP_v2.mat'); % called SUB & ClinicalStatus

% build trial data structure 
t_start=    [15 32  79 111 128 175 207 239 286 303 335 382]-1;
t_end=      [29 76 108 125 172 204 236 283 300 332 379 396];
% note: the  2nd, 5th, 8th and 11th trials are always the long 90 second trials
for s=1:length(SUB)
    SUB(s).trialOrder=[];
    for t=1:12
        
        SUB(s).trial(t).num = t;                                          % ~ 1-12
        SUB(s).trial(t).type = SUB(s).instruction(t_start(t)+1);      % ~ Focus / Wander
        SUB(s).trial(t).length = (t_end(t)-t_start(t));                   % ~ 30 / 60 / 90
        SUB(s).trial(t).start = t_start(t);                               % ~ c 
        SUB(s).trial(t).end = t_end(t);                                   % ~ c [29 76 108 125 172 204 236 283 300 332 379 396]
        SUB(s).trial(t).display_polarity = [SUB(s).left_text{t_start(t)}, '-', SUB(s).right_text{t_start(t)}]; % ~ Wandering-Focused / Focused_Wandering  
        SUB(s).trial(t).data = SUB(s).data(t_start(t):t_end(t));  % ~ [ . . . ] 
        
        % data from entire trial
        t_dat=[];       for scan=1:length(SUB(s).trial(t).data); t_dat=[t_dat, str2num(SUB(s).trial(t).data{scan})]; end
        % data from first 7 scans of trial
        t_start_dat=[]; for scan=1:7; t_start_dat=[t_start_dat, str2num(SUB(s).trial(t).data{scan})]; end
        
        % data from last 7 scans of trial
        t_end_dat=[];   for scan=(length(SUB(s).trial(t).data)-6):length(SUB(s).trial(t).data); t_end_dat=[t_end_dat, str2num(SUB(s).trial(t).data{scan})]; end
        
        
        % depending on "display polarity", we create an appropriate optimal regressor (for the "needle angle" data)
        if strcmp(SUB(s).trial(t).type, 'Focus') && strcmp(SUB(s).trial(t).display_polarity, 'Wandering-Focused')
            SUB(s).trial(t).ideal_NP_dummy = -ones(1,SUB(s).trial(t).length+1);    % prepare values for regression with dummy values to assess learning
            SUB(s).trial(t).ideal_NP_linear = (90:-1:90-(SUB(s).trial(t).length));   % prepare values for regression with optimal linear regressor values to assess learning
            DMN=2; % 2 ~ DMN down-regulation   
            
        elseif strcmp(SUB(s).trial(t).type, 'Focus') && strcmp(SUB(s).trial(t).display_polarity, 'Focused-Wandering')
            SUB(s).trial(t).ideal_NP_dummy = ones(1,SUB(s).trial(t).length+1);   % prepare values for regression with dummy values to assess learning
            SUB(s).trial(t).ideal_NP_linear = (90:90+(SUB(s).trial(t).length));% prepare values for regression with optimal linear regressor values to assess learning 
            DMN=2; % 2 ~ DMN down-regulation
    
        elseif strcmp(SUB(s).trial(t).type, 'Wander') && strcmp(SUB(s).trial(t).display_polarity, 'Wandering-Focused')
            SUB(s).trial(t).ideal_NP_dummy = ones(1,SUB(s).trial(t).length+1);   % prepare values for regression with dummy values to assess learning
            SUB(s).trial(t).ideal_NP_linear = (90:90+(SUB(s).trial(t).length));% prepare values for regression with optimal linear regressor values to assess learning 
            DMN=1; % 1 ~ DMN up-regulation
    
            
        elseif strcmp(SUB(s).trial(t).type, 'Wander') && strcmp(SUB(s).trial(t).display_polarity, 'Focused-Wandering')            
            SUB(s).trial(t).ideal_NP_dummy = -ones(1,SUB(s).trial(t).length+1);   % prepare values for regression with dummy values to assess learning
            SUB(s).trial(t).ideal_NP_linear = (90:-1:90-(SUB(s).trial(t).length));  % prepare values for regression with optimal linear regressor values to assess learning
            DMN=1; % 1 ~ DMN up-regulation
        
        else display(['Warning: SUB ' num2str(s) ' trial ' num2str(t)]); % issue warning if unexpected trial observed
        end
    
        % compute NP coefficient for each trial of each subject and group by direction of regulation
        NPEP_grand_linear(s,t,DMN)=corr(str2double(SUB(s).trial(t).data), SUB(s).trial(t).ideal_NP_linear');       
        
        % log trial order of each subject
        SUB(s).trialOrder=[ SUB(s).trialOrder   SUB(s).trial(t).type   SUB(s).trial(t).display_polarity ];
    end
          
    % concatenate trials for plotting
    SUB(s).NP_data=[];   for t=1:12;  SUB(s).NP_data  =[SUB(s).NP_data   str2double(SUB(s).trial(t).data)']; end
    NP_data(s,:)=SUB(s).NP_data;
    
    % code age, sex and dexterity for ease of use
    age(s) = str2double(SUB(s).age);
    if strcmp(SUB(s).sex,'FEMALE'); sex(s)=1; elseif strcmp(SUB(s).sex,'MALE'); sex(s)=0; end
    if strcmp(SUB(s).handedness,'RIGHT'); dexterity(s)=1; elseif strcmp(SUB(s).handedness,'LEFT'); dexterity(s)=0; end
   
end
% replace missing entries with NaN to enable accurate computations of means later on
NPEP_grand_linear(NPEP_grand_linear==0)=NaN;

save NPEP_v3.mat SUB NP_data ClinicalStatus
save corr_val NPEP_grand_linear