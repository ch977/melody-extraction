function [pm,pstd,contms,contTs,contsastd,lencont,vibrato]=contourcharacter(contset)
%define a set of contour characteristics which will be used to guide the
%system in selecting melody contours
%input:contour set,cell type

contN=size(contset,1);     
pm=zeros(contN,1);     %pitch mean 
pstd = zeros(contN,1);        %standard deviation of the contour pitch
contms=zeros(contN,1);        %mean salience of all peaks comprising the contour
contTs=zeros(contN,1);        %sum of the salience of all peaks
contsastd=zeros(contN,1);    %standard deviation of the salience of all peaks
lencont=zeros(contN,1);     %length of contour
vibrato=zeros(contN,1);     %whether the contour has vibrato or not

%fs1=357;  %contset{i} every frame corresponding to 2.8ms,so fs=357Hz; 
fs1=100;  %if 10 ms,fs=100hz
N1=256;      %N FFT ,N should be appropriate with the length of contset
for i=1:contN
    pm(i)=mean(contset{i}(:,2));
    pstd(i)=std(contset{i}(:,2));
    contms(i) = mean(contset{i}(:,3));
    contTs(i) = sum(contset{i}(:,3));
    contsastd(i) = std(contset{i}(:,3));
    lencont(i) = size(contset{i},1);
    
    Y=fft(contset{i}(:,2)-pm(i),N1);     %apply the FFT to the contours pitch trajectory (after subtracting the mean)
    Y_hz=abs((Y/N1)*fs1);
   % [sp,idxp] = findpeaks(Y_hz,'MinPeakHeight',10);  %idxp:ki
    [p,id] = findpeaks(Y_hz); 
    ism=ismember([5:8],id);
    vibrato(i)=sum(ism);
end
    
    






