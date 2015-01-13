%
[y,fs1]=wavread('D:\My Documents\Music\exp\melodyExt\example1.wav');
fs=44100;

%equal loudness filter
[a1,b1,a2,b2]=equalloudfilt(fs);
c=filter(b1,a1,y);
e=filter(b2,a2,c);   %equal loudness filter output

window_L=2048;                              %46.4ms  the window length,M
fft_L=8192;                                         %FFT length N
hop_size=128;                                       %2.9ms ,the hop size H
nFrame=floor((length(e)-window_L)/hop_size);  % num of frames
h1=window('hanning',window_L);

S=zeros(nFrame,600);
for i=0: nFrame-1
   %short time fourier transform
    x=e(i*hop_size+1 :i*hop_size+window_L);
    [tfr,t,f]=tfrstft(x,1:window_L,fft_L);
    
    tfr_p=tfr(1:length(f)/4,:);  %0-11025Hz
    tfr_p=sum(tfr_p,2);
    mag_sp=abs(tfr_p);    %magnitude spectrum
    x_f=f(1:length(f)/4)*fs;  %actual frequency
    plot(x_f,mag_sp);
    xlabel('frequency f');
    ylabel('magnitude spectrum');
    axis xy;
    hold on;
    
    % spectral peaks pi are selected by finding all the local maxima ki of
    % the magnitude spectrum
    [sp,idxp] = findpeaks(mag_sp,'MinPeakHeight',10);  %idxp:ki
    id_f=(idxp/fft_L)*fs;
    plot(id_f,sp,'ro');
    peak=[idxp,sp];  %peaks that large than 10
    close;
    
    %use phase to calculate the peak's instantaneous frequency and
    %amplitude,provide a more accurate estimate
    pha_sp=angle(tfr_p);   %phase spectrum
    k=idxp;
    ph=pha_sp(k)-pha_sp(k-1)-2*pi*hop_size*k/fft_L;
    
  %  ??principal argument function which maps phase to -pi--pi range
 %   PH=...
        
delt_k=PH*fft_L/(2*pi*hop_size);
insFreq=(k+delt_k)*fs/fft_L;
k_han=fft_L*delt_k/window_L;
Win_han=0.5*sinc((window_L/fft_L)*pi*k_han)/(1-(window_L*k_han/fft_L).^2);
insMag =0.5*mag_sp(k)/Win_han;

% salience function computation
S(i+1,:)= salifunc(insFreq,insMag);

end

%filter out non-salient peaks and creating contours
%
contSet=filterPeak_createcontour(S); %contour set
%pitch contour characterisation
[pitchmean,pitchstd,contms,contTs,contsastd,lencont,vibrato]=contourcharacter(contSet);
%melody selection
melodycont=melodyselection(contSet,pitchstd,contms,contTs,vibrato,nFrame);
%display melody
plot(melodycont);
