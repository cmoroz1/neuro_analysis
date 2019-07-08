%% Hypothesis testing: Is there any evidence of DMN NF association w/ age?

if lillietest(age) ~= 0
    display('Age is not normally distributed!');
end

% Preliminary testing
[r_control, p_control] = corr(DMN_NF_2ndHalf(ClinicalStatus==1),age(ClinicalStatus==1)','type','Spearman');
% r = -0.4232, p = 0.0020

[r_path, p_path] = corr(DMN_NF_2ndHalf(ClinicalStatus==0),age(ClinicalStatus==0)','type','Spearman');
% r = -0.0967, p = 0.4361

% Preliminary investigation shows DMN NF regulation correlates negatively
% with age in non-pathological subjects. Now to plot it...

figure; hold on;
scatter(age(ClinicalStatus==1)',DMN_NF_2ndHalf(ClinicalStatus==1),'o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0.8008 0.5195 0.2461]);
x = age(ClinicalStatus==1)'; y = DMN_NF_2ndHalf(ClinicalStatus==1);
coeffs = polyfit(x,y,1); fittedX = linspace(min(x),max(x),200); fittedY = polyval(coeffs, fittedX); plot(fittedX, fittedY, 'm-','Color',[0.8008 0.5195 0.2461],'LineStyle',':','LineWidth',2); %Brown
scatter(age(ClinicalStatus==0)',DMN_NF_2ndHalf(ClinicalStatus==0),'x','MarkerFaceColor', [0 0 1],'MarkerEdgeColor', [0 0 1])
x=age(ClinicalStatus==0)'; y=DMN_NF_2ndHalf(ClinicalStatus==0);
coeffs = polyfit(x, y, 1); fittedX = linspace(min(x), max(x), 200); fittedY = polyval(coeffs, fittedX); plot(fittedX, fittedY, 'm-', 'Color', [0 0 1], 'LineStyle', '--', 'LineWidth', 1); %Blue
x=age'; y=DMN_NF_2ndHalf(ClinicalStatus~=999); % all subjects
coeffs = polyfit(x, y, 1); fittedX = linspace(min(x), max(x), 200); fittedY = polyval(coeffs, fittedX); plot(fittedX, fittedY, 'm-', 'LineWidth', 1, 'Color','k'); 
xlabel('Age in years');
ylabel('DMN NF overall regulation score');
title({'DMN NF regulation performance decreases with age', 'only in psychiatrically healthy young adults', '(black~sample; dotted brown~control; dashed blue~pathological)'});hold off;
grid