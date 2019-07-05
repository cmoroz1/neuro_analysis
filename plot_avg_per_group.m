clc; clear;
load('NPEP_v3.mat') % called SUB & NP_data & ClinicalStatus

% Produce Fig. 1C (a graphical representation for visual inspection and validation of the approach for modelling neurofeedback regulation performance) 
covered=1; coveredTrialOrders{1}=[];
for s=1:length(SUB)
    
    % prepare subject's Trial Order string
    clear triOrd trialOrder; triOrd=char(SUB(s).trialOrder);
    subTrialOrder=[]; for e=1:24; subTrialOrder=[subTrialOrder '            ' triOrd(e,:)]; end
        
    % check if subject's trial order matches any of the covered trial orders
    match=0; coveredTrialOrders{covered}=[];
    for cvrd=1:covered
        if ~isempty(coveredTrialOrders{cvrd})
            
            % prepare current Trial Order string
            clear triOrd trialOrder; triOrd=char(coveredTrialOrders{cvrd});
            curTrialOrder=[]; for e=1:24; curTrialOrder=[curTrialOrder '            ' triOrd(e,:)]; end
            
            % compare subject and current trial orders
            if strcmp(subTrialOrder,curTrialOrder)
                match=1;
                break; 
            end
        end
    end
    
    if match==0
        ref_sub=s;
        coveredTrialOrders{covered}       = SUB(ref_sub).trialOrder;
        subs_withSameTrialOrders{covered} = [ref_sub];
        clear SxT_ClinicalStatus % Subject x Trial Clinical Status
        for sub = ref_sub+1:length(SUB)
            if sum(strcmp(cellstr(SUB(ref_sub).trialOrder), cellstr(SUB(sub).trialOrder)))==24
                subs_withSameTrialOrders{covered} = [subs_withSameTrialOrders{covered} sub];
                if ClinicalStatus(sub)==1; SxT_ClinicalStatus(sub)=1; elseif ClinicalStatus(sub)==0; SxT_ClinicalStatus(sub)=2; end
            end
        end
    
    figure; 
    
    % Colour background 
    % (colour-selection optimized for discriminability across protanope and deuteranope colourblindness,
    % according to http://jfly.iam.u-tokyo.ac.jp/color/index.html and 
    % https://nl.mathworks.com/matlabcentral/fileexchange/24497-rgb-triple-of-color-name--version-2 )
    p=1; % position
    for T=1:12
        if strcmp(char(SUB(ref_sub).trialOrder(2*T-1)),'Focus'); 
            L = SUB(ref_sub).trial(T).length;
            patch([p p+L+1 p+L+1 p], [0 0 180*[1 1]], [1.0000    0.7500    0.7930]); % Pink
            p = p + L+1;       
        elseif strcmp(char(SUB(ref_sub).trialOrder(2*T-1)),'Wander'); 
            L = SUB(ref_sub).trial(T).length;
            patch([p p+L+1 p+L+1 p], [0 0 180*[1 1]], [0.5938    0.9833    0.5938]); % PaleGreen
            p = p + L+1;       
        else display(SUB(ref_sub).trialOrder(2*T-1))
             display(T)
             display(ref_sub)
        end
    end
        
    % Plot data
    hold on;
    xlabel('time (scanning volumes)', 'FontSize', 16);
    ylabel('neurofeedback display (angular position)', 'FontSize', 16);
    xlim([0 length(mean(NP_data( SxT_ClinicalStatus>=1,:)))])
    ylim([0 180 ])
    
    SUB( subs_withSameTrialOrders{covered}(1) ).NP_linear = [];
    for t=1:12
        SUB( subs_withSameTrialOrders{covered}(1) ).NP_linear = [SUB( subs_withSameTrialOrders{covered}(1) ).NP_linear SUB( subs_withSameTrialOrders{covered}(1) ).trial(t).ideal_NP_linear];
    end
    
    plot(SUB( subs_withSameTrialOrders{covered}(1) ).NP_linear, 'Color', [1 1 0], 'LineWidth', 1.5); % Yellow
    plot(mean(NP_data( SxT_ClinicalStatus==1,:) ), 'Color', [0.8008    0.5195    0.2461], 'LineStyle',':', 'LineWidth', 2); %LightBrown~"Peru" 
    plot(mean(NP_data( SxT_ClinicalStatus==2,:) ), 'Color', [0 0 1], 'LineStyle', '--', 'LineWidth', 1); %Blue
    plot(mean(NP_data( SxT_ClinicalStatus>=1,:)), 'k', 'LineWidth', 1); % Black
    title({'Modelling target NFB regulation performance', '(yellow ~ target; dotted brown ~ healthy ; dashed blue ~ pathological ; black ~ entire sample  )'});
    hold off;
    grid
    covered=covered+1;
    
    end
    
end