%process exp results 
%remove the peaks whose pitch below 150bin

contSetm=cell2mat(contourSet);
contSetm_h=contSetm(contSetm(:,2)>150,:);
contSetm_m=contSetm_h(contSetm_h(:,2)<400,:);
figure;
subplot(121);
plotmat(contSetm_m);
%%
figure(2);
contmat_h=contmat(contmat(:,2)>150,:);
contmat_m=contmat_h(contmat_h(:,2)<400,:);

plotmat(contmat_m);

%compare with groundtruth
