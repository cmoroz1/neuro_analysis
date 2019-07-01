clear;
clc;

load('diagnosis_data.mat'); % called diagnosis_data
load('NPEP.mat');           % called SUB
SUB_diagnosis = diagnosis_data;

try  for line=1:1061; if strcmp(SUB_diagnosis{2}(line), "#CODE:  #DESC:  #SPEC:"); for col=2:2; SUB_diagnosis{col}(line)=[]; end; end; end; catch; end 
try  for line=1:1061; if strcmp(SUB_diagnosis{2}(line), "#CODE:300.4  #DESC:Dysthymic Disorder  #SPEC:Current"); for col=2:2; SUB_diagnosis{col}(line)=[]; end; end; end; catch; end

for nfb_sub = 1:length(SUB)
    for line = 1:length(SUB_diagnosis(:,1))
        if contains(SUB_diagnosis{line,1}, SUB(nfb_sub).id)
            disp(nfb_sub + " " + line);
            
            if strfind(SUB_diagnosis{line,2}, 'No Diagnosis or Condition on Axis I') > 0
                SUB(nfb_sub).status = 1; % HC ~ Healthy Control
            else
                SUB(nfb_sub).status = 0; % SP ~ Some Pathology
            end
            
        end
    end
end


% for nfb_sub=1:length(SUB); 
%     if ~isempty(SUB(nfb_sub).status); ClinicalStatus(nfb_sub,:)=SUB(nfb_sub).status; 
%     else ClinicalStatus(nfb_sub,:)=999;  
%     end 
% end
% % Delete the four unclassified subjects that have missing diagnostic data
% SUB(ClinicalStatus==999)=[] ;    ClinicalStatus(ClinicalStatus==999)=[] ;  