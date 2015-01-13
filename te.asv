
%%
x = linspace(0,1,1000);

base = 4*cos(2*pi*x);

Pos = [1 2 3 5 7 8]/10;
Hgt = [3 7 5 5 4 5];
Wdt = [1 3 3 4 2 3]/100;

for n = 1:length(Pos)
    Gauss(n,:) =  Hgt(n)*exp(-((x - Pos(n))/Wdt(n)).^2);
end

PeakSig = sum(Gauss)+base;
plot(x,Gauss,'--',x,PeakSig,x,base)
findpeaks(PeakSig,x,'MinPeakProminence',4,'Annotate','extents')

%%
%num=xlsread('shuju.xls');
%num=spec;
%x=num(:,1);
%y=num(:,2);
x=((1:1024)/8192)*44100;
x=x';
y=spec(1:1024);
plot(x,y);
hold on;
%[yp,idxp]=findpeaks(y);
idx=(idxp/8182)*44100;
[yp,idxp]=findpeaks(y,'MinPeakHeight',10);
plot(idx,yp,'ro')
%close;
%%
 b=[10 2 3 2 0 4 5 0 7 8];
 c=find(b>=3);
 out=[c;b(c)]';
 
  a=[1 2 3;4 5 6]';
 a1=a(a(:,2)>4);
 
 %%
 cell1=cell(4,1);
 cell1{1}=[1 2 3 4 ;5 5 8 9]';
 cell1{2}=[1,2,5;4 6 8]';
 cell1{3}=[1 5 6 9 5 3 6;3 5 6 7 8 96 7 ]';
 cell1{4}=[1 2 3 ;5 7 8 ]';
 
 pi=[];
 for i=1:4
     pi=[pi;i*ones(size(cell1{i},1),1) cell1{i}];
 end
 
 [value,id]=max(pi(:,3));
 delID=[2 3 4];
 pi([delID],:)=[];
 

 
 %%
 % Make some pretend data
% Each row is a data set
x = (0:5)';
y = [3 + 2*x,3.2 + 1.6*x,2.6 + 2.2*x] + 0.2*randn(6,3);
% Make design matrix
M = [x,x.^0];
% Solve for coefficients
C = M\y;
% Evaluate fits
yfit = M*C;
% Take average of fits
avgyfit = mean(yfit,2);
% See the results
plot(x,y,'x')
hold on
plot(x,yfit)
plot(x,avgyfit,'k','linewidth',2)
%%
 x= 0:10; 
y = sin(x); 
xi = 0:.25:10; 
yi = interp1(x,y,xi); 
%plot(x,y,'o',xi,yi)
plot(xi,yi,'or')
plot(x,y,'og')

%   test more than one function in a function script
% function [a,b,glo]=te(t)
% glo=1;
% a=f(t,glo);
% 
% b=he(a);
%     function y=f(x,glo)
%         y=x+10;
%         glo=glo+1;
%     end
%     function y=he(x)
%         y=x*2;
%     end
% 
% end
%%
f = [0 0.6 0.6 1];
m = [1 1 0 0];
[b,a] = yulewalk(8,f,m);
[h,w] = freqz(b,a,128);
plot(f,m,w/pi,abs(h),'--')
legend('Ideal','yulewalk Designed')
title('Comparison of Frequency Response Magnitudes')
%%
 sig=[fmconst(128,0.2);fmconst(128,0.4)]; tfr=tfrstft(sig);
   subplot(211); imagesc(abs(tfr));
   subplot(212); imagesc(angle(tfr));
   %%
   tic;
   x = 0;
for k = 2:100000
   x(k) = x(k-1) + 5;
end
toc;
%%
tic;
 x= zeros(1, 100000);
for k = 2:100000
   x(k) = x(k-1) + 5;
end
toc;