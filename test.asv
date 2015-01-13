%
tic;
disp('read music file......');
[y,fs1]=wavread('D:\My Documents\Music\exp\melodyExt\example1.wav');
fs=44100;

%equal loudness filter
disp('equal loudness filter');
[a1,b1,a2,b2]=equalloudfilt(fs);   %
c=filter(b1,a1,y);   %   IIR filter
e=filter(b2,a2,c);   %  add a 2nd order high pass filter

tic;
disp('short fourier transform......');
win_L=2048;                              %46.4ms  the window length,M
fft_L=8192;                                         %FFT length N
hop=128;                                       %2.9ms ,the hop size H
hop1=441;       %10ms,mirex encourage the size for counting results
han_win=hann(2048);
[Sf,F,T,P]=spectrogram(e,han_win,win_L-hop1,fft_L,fs);
 F1=F(1:(length(F)-1)/16);
 P1=P(1:8192/32,:)*1e5;  %0- 1378Hz 
toc;

 tic;
 disp('salience function.......')
  nFrame=size(P1,2);
 S=zeros(nFrame,600);
for i=1:nFrame
    [sp,idxp] = findpeaks(P1(:,i),'MinPeakHeight',0.22); 
    S(i,:)=salifunc(F1(idxp),P1(idxp,i));
end
toc;
 
% for i=0: nFrame-1
%     %short time fourier transform
%     tic;
%     disp('short time fourier transform');
%     x=e(i*hop_size+1 :i*hop_size+window_L);   % a frame
%     [tfr,t,f]=tfrstft(x,1:window_L,fft_L);   %tfr:8192*2048,every row correspondings to a frequency
%     %f:-0.5-0.5
%     tfr_p=tfr(1:length(f)/8,:);  %0-5512Hz
%     tfr_p=sum(tfr_p,2);
%     mag_sp=abs(tfr_p);    %magnitude spectrum
%     %x_f=f(1:length(f)/8)*fs;  %actual frequency
%     toc;  %0.4s
%     
%     tic;
%     % spectral peaks pi are selected by finding all the local maxima ki of
%     % the magnitude spectrum
%     disp('find peaks');
%     [sp,idxp] = findpeaks(mag_sp,'MinPeakHeight',10);  %idxp:ki
%     id_f=(idxp/fft_L)*fs;
%     peak=[idxp,sp];  %peaks that large than 10
%     toc;    %0.001s
%     %use phase to calculate the peak's instantaneous frequency and
%     %amplitude,provide a more accurate estimate
%     %{
%     pha_sp=angle(tfr_p);   %phase spectrum
%     k=idxp;
%     ph=pha_sp(k)-pha_sp(k-1)-2*pi*hop_size*k/fft_L;
%     
%     %  ??principal argument function which maps phase to -pi--pi range
%     %   PH=...
%     
%     delt_k=PH*fft_L/(2*pi*hop_size);
%     insFreq=(k+delt_k)*fs/fft_L;
%     k_han=fft_L*delt_k/window_L;
%     Win_han=0.5*sinc((window_L/fft_L)*pi*k_han)/(1-(window_L*k_han/fft_L).^2);
%     insMag =0.5*mag_sp(k)/Win_han;
%     %}
%     % salience function computation
%     tic;
%     S(i+1,:)=salifunc(x_f(idxp),mag_sp(idxp));    %0.34s
%    toc;
%     % S(i+1,:)= salifunc(insFreq,insMag);
% end
% toc;

%filter out non-salient peaks and creating contours
disp('filter peaks and create contours...........');
tic;
contourSet=filterPeak_createcontour(S); %contour set
%plotcontour(contourSet);   
%save cntourSet in contourSet
%pitch contour characterisation
toc;
%%
disp('contour character................');
tic;
[pitchmean,pitchstd,contms,contTs,contsastd,lencont,vibrato]=contourcharacter(contourSet);
%save results in character.mat
toc;

%melody selection
disp('select melody contours...........');
tic;
[contmat,contSet2]=melodyselection(contourSet,pitchstd,contms,contTs,vibrato,nFrame);
%display melody
plotmat(contmat);
toc;



