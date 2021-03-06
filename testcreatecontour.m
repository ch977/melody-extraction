%  T= 0:0.001:2;
% X = chirp(T,100,1,200,'q');
% [S,F,T,P]=spectrogram(X,128,120,128,1E3); 
% title('Quadratic Chirp');
% %%
% tic;
% han_win=hann(2048);
% [Sf,F,T,P]=spectrogram(e,han_win,1920,8192,44100);
% toc;
% P1=P(1:4000,:);



 F1=F(1:(length(F)-1)/16);
% 
P1=P(1:8192/32,:)*1e5;  %0- 1378Hz 
 nFrame=size(P1,2);
 S=zeros(nFrame,600);
%plot(F1,P1(:,2400));
%  [sp,idxp] = findpeaks(P1(:,1),'MinPeakHeight',0.22); 


tic;
for i=1:nFrame
   % tic;
    [sp,idxp] = findpeaks(P1(:,i),'MinPeakHeight',0.22); 
   % toc;
    %disp('salifunc..................');
    %tic;
    S(i,:)=salifunc(F1(idxp),P1(idxp,i));
    %toc;
end
 toc;
%%
nFrame=size(P1,2);
 S=zeros(nFrame,600);
  [sp,idxp] = findpeaks(P1(:,8420),'MinPeakHeight',0.22); 
  S(8420,:)=salifunc(F1(idxp),P1(idxp,8420));
