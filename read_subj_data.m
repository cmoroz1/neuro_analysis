% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % NOTE: To run the analysis you need to download the NFB repository. 
% % when repeating the analysis we simply use: 
clear; clc;
% load('NPEP.mat','SUB', 'SUB_diagnosis') % and ignore the rest of this section
% % Alternatively, uncoment the commented subsection starting three lines below.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ DATA from Rockland open-source repository folder structure tsv files
fileID=fopen('../Data/output/participants_test.tsv','r');
SUB_info=textscan(fileID,'%s %s %s %s');
fclose(fileID);
% read data from each subject
nfb_sub=1;
for s=2:length(SUB_info{1})
    % Example pathname for reading subj info off the G-RAID
%     if isfolder("/Volumes/G-RAID/Projects/NKI-Neurofeedback-BIDS/downloadedBIDS_cleaned_6.24.19/sub-" + SUB_info{1}{s})
%         if ~isfile("/Volumes/G-RAID/Projects/NKI-Neurofeedback-BIDS/downloadedBIDS_cleaned_6.24.19/sub-" + SUB_info{1}{s} + "/ses-NFB3/func/sub-" + SUB_info{1}{s} + "_ses-NFB3_task-DMNTRACKINGTEST_events.tsv")
%             disp(SUB_info{1}{s} + " is missing events.tsv file")
%         end
%     end
%     if isfile("/Volumes/G-RAID/Projects/NKI-Neurofeedback-BIDS/downloadedBIDS_cleaned_6.24.19/sub-" + SUB_info{1}{s} + "/ses-NFB3/func/sub-" + SUB_info{1}{s} + "_ses-NFB3_task-DMNTRACKINGTEST_events.tsv")
%         fileID=fopen("/Volumes/G-RAID/Projects/NKI-Neurofeedback-BIDS/downloadedBIDS_cleaned_6.24.19/sub-" + SUB_info{1}{s} + "/ses-NFB3/func/sub-" + SUB_info{1}{s} + "_ses-NFB3_task-DMNTRACKINGTEST_events.tsv",'r');            
%         %fileID=fopen("/Users/Chris/Desktop/BIDS_TEST/Data/output/sub-A00028185/ses-NFB3/func/sub-A00028185_ses-NFB3_task-DMNTRACKINGTEST_events.tsv",'r');    
%         SUB_NFB=textscan(fileID,'%s %s %s %s %s %s %s %s','delimiter',{'\t'});
%         SUB(nfb_sub).id           = SUB_info{1}{s};
%         SUB(nfb_sub).age          = SUB_info{2}{s};
%         SUB(nfb_sub).sex          = SUB_info{3}{s};
%         SUB(nfb_sub).handedness   = SUB_info{4}{s};
%         SUB(nfb_sub).data         = SUB_NFB{8}; % ~ 8th column
%         SUB(nfb_sub).instruction  = SUB_NFB{5}; % ~ 5th column
%         SUB(nfb_sub).left_text    = SUB_NFB{3}; % ~ 3rd column
%         SUB(nfb_sub).right_text   = SUB_NFB{4}; % ~ 4th column
% 
%         nfb_sub = nfb_sub + 1;
      if isfile("/Users/mac637-jbj-100/Desktop/Neurofeedback/BIDS_TEST/Data/output/sub-" + SUB_info{1}{s} + "/ses-NFB3/func/sub-" + SUB_info{1}{s} + "_ses-NFB3_task-DMNTRACKINGTEST_events.tsv")
        fileID=fopen("/Users/mac637-jbj-100/Desktop/Neurofeedback/BIDS_TEST/Data/output/sub-" + SUB_info{1}{s} + "/ses-NFB3/func/sub-" + SUB_info{1}{s} + "_ses-NFB3_task-DMNTRACKINGTEST_events.tsv",'r');            
        SUB_NFB=textscan(fileID,'%s %s %s %s %s %s %s %s','delimiter',{'\t'});
        SUB(nfb_sub).id           = SUB_info{1}{s};
        SUB(nfb_sub).age          = SUB_info{2}{s};
        SUB(nfb_sub).sex          = SUB_info{3}{s};
        SUB(nfb_sub).handedness   = SUB_info{4}{s};
        SUB(nfb_sub).data         = SUB_NFB{8}; % ~ 8th column
        SUB(nfb_sub).instruction  = SUB_NFB{5}; % ~ 5th column
        SUB(nfb_sub).left_text    = SUB_NFB{3}; % ~ 3rd column
        SUB(nfb_sub).right_text   = SUB_NFB{4}; % ~ 4th column

        nfb_sub = nfb_sub + 1;
      else
        % Example path name for a neurofeedback.csv file
        %/Users/Chris/Desktop/Test/A00034854/A00034854neurofeedback.csv
        if isfile("/Users/Chris/Desktop/Test/A00034854/" + SUB_info{1}{s} + "neurofeedback.csv")
            fileID=fopen("/Users/Chris/Desktop/Test/A00034854/" + SUB_info{1}{s} + "neurofeedback.csv");
            SUB_NFB=textscan(fileID,'%s %s %s %s %s %s %s %s %s %s','delimiter',{','});
            SUB(nfb_sub).id =           SUB_info{1}{s};
            SUB(nfb_sub).age =          SUB_info{2}{s};
            SUB(nfb_sub).sex =          SUB_info{3}{s};
            SUB(nfb_sub).handedness =   SUB_info{4}{s};
            SUB(nfb_sub).data =         SUB_NFB{10};
            SUB(nfb_sub).instruction =  SUB_NFB{6};
            SUB(nfb_sub).left_text =    SUB_NFB{4};
            SUB(nfb_sub).right_text =   SUB_NFB{5};
            
            nfb_sub = nfb_sub + 1;
        end
    end
end

clear SUB_info;
save NPEP.mat SUB