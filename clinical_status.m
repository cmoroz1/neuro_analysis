clear;
clc;

load('diagnosis_data.mat'); % called diagnosis_data
load('NPEP.mat');           % called SUB
SUB_diagnosis = diagnosis_data;

try  for line=1:1061; if strcmp(SUB_diagnosis{2}(line), "#CODE:  #DESC:  #SPEC:"); for col=2:2; SUB_diagnosis{col}(line)=[]; end; end; end; catch; end 
try  for line=1:1061; if strcmp(SUB_diagnosis{2}(line), "#CODE:300.4  #DESC:Dysthymic Disorder  #SPEC:Current"); for col=2:2; SUB_diagnosis{col}(line)=[]; end; end; end; catch; end

for nfb_sub=1:length(SUB(:,1)
    for line=1:length(SUB_diagnosis(1,:))
        if strfind(SUB_diagnosis(1,line),  SUB(nfb_sub).id)>0    
            disp(line + " " + nfb_sub);
        end
    end
end
%             for col=1:12
%                 if strfind(SUB_diagnosis{col}{line}, 'No Diagnosis or Condition on Axis I')>0;
%                     SUB(nfb_sub).status=1; % HC ~ Healthy Control
%                     %display([SUB(nfb_sub).id '=?=' SUB_diagnosis{1}{line}]) % uncomment for quality control
%                     break
%                 else
%                     SUB(nfb_sub).status=0; % SP ~ some pathology
%                     %% uncomment below for quality control
%                     % display([SUB_diagnosis{1}{line} '    ' SUB_diagnosis{2}{line} '    ' SUB_diagnosis{3}{line} ' ' SUB_diagnosis{4}{line} ' ' SUB_diagnosis{5}{line} ' ' ...
%                     % SUB_diagnosis{6}{line} ' ' SUB_diagnosis{7}{line} ' ' SUB_diagnosis{8}{line} ' ' SUB_diagnosis{9}{line} ' ' SUB_diagnosis{10}{line} ' ' ... 
%                     % SUB_diagnosis{11}{line} ' ' SUB_diagnosis{12}{line}])
%                 end
%             end
%         end
%     end
% end
% for nfb_sub=1:length(SUB); 
%     if ~isempty(SUB(nfb_sub).status); ClinicalStatus(nfb_sub,:)=SUB(nfb_sub).status; 
%     else ClinicalStatus(nfb_sub,:)=999;  
%     end 
% end
% % Delete the four unclassified subjects that have missing diagnostic data
% SUB(ClinicalStatus==999)=[] ;    ClinicalStatus(ClinicalStatus==999)=[] ;  