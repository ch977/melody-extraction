function [S] = salifunc(f,magni)
%   salifunc Computes salience function ,a representation of pitch salience over time. The
%   peaks of this function form the F0 candidates for the main melody
%

% parameter of salinece function
Nh=20;                                %Nh :num of harmonics considered
num_peaks=length(f);                 %number of peaks found : I
alpha1=0.8;                 % the harmonic weighting parameter
beta=1;                                             %magnitude compression parameter

gamma=40;                                           %maximum allowed difference (in dB)

% magnitude threshold function 
a_M=max(magni);                                     %highest spectral peak
e_a=zeros(num_peaks,1);
for i =1:num_peaks
    if 20*log10(a_M/magni(i))<gamma
        e_a(i)=1;
    end
end

%weighting function g(b,h,f) 
% define the weight given to peak p(i),when it is considered as the h-th
% harmonic of bin b
function [g] =weight(b,h,f,alpha1)
    delta=abs(f2bin(f/h)-b)/10;
    if abs(delta) <=1
        g=(alpha1^(h-1))*cos(delta*pi/2).^2;
    else
        g=0;
    end
end
%frequency Hz transformed to bin
function [B]=f2bin(f)
    B=floor(120*log2(f/55)+1);
end

%salience function 
%covers a pitch range of nearly five octaves from 55Hz to 1.76kHZ,600 bins
S=zeros(1,600);
for b=1:600   
    for i=1:num_peaks
        for h=1:Nh
            S(b)=S(b)+e_a(i)*weight(b,h,f(i),alpha1)*magni(i)^beta;
        end
    end
end
            
end
