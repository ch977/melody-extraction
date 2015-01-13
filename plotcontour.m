function []=plotcontour(contour)
mat=cell2mat(contour);

ground=importdata('example1REF.txt');
subplot(121);
scatter(ground(:,1),ground(:,2),'.','r')
subplot(122);
scatter(mat(:,1),mat(:,2),'.','g');  %no single point
end