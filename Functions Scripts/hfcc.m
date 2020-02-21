%Wyznaczanie wspó³czynników HFCC (Human-Factor Cepstral Coefficients) dla sygna³u jednowymirowego (x)
%autor: l.laszko@ita.wat.edu.pl 
%2015
function [H,FbHfcc] = hfcc (x, Noc, Ws, Ovr, Nfft, Fs, Nof)

%parametry wejœciowe
%x      - sygna³
%Noc    - liczba wyznaczanych wspó³czynników na fragment .....(dft. 20).....
%Ws     - rozmiar okna .....(dft. 512)..... 
%Ovr    - rozmiar nak³adania .....(dft. Ws/2 = 256)..... 
%Fs     - czêstotliwoœæ próbkowania wprowadzonego sygna³u .....(dft. 22050).....
%Nfft   - liczba wspó³czynników FFT .....(dft. 1024).....
%Nof    - liczba filtrów w banku filtrów.....(dft. 30).....

%parametry wyjœciowe:
%M      - macierz wspó³czynników HFCC
%FbMfcc - macierz banku filtrów

if(nargin<1),
    error ('Brak sygna³u do wyznaczenia wspó³czynników HFCC!');     
end

if size(x,1)>1 && size(x,2)>1
   error('Wprowadzony sygna³ nie jest wektorem jednowymiarowym');
end

if (nargin<2 || isempty(Noc)),
    Noc=20;
end
if (nargin<3 || isempty(Ws)),
    Ws=512; 
end
if (nargin<4 || isempty(Ovr)),
    Ovr=Ws/2; 
end
if (nargin<5 || isempty(Nfft)),
    Nfft=1024; 
end
if (nargin<6 || isempty(Fs)),
    Fs=11025; 
    
end
if (nargin<7 || isempty(Nof)),
    Nof=30; 
end

if (Noc >= Nof)
    error ('Liczba wspó³czynników musi byæ mniejsza ni¿ liczba filtrów!');
end
if (Ovr >= Ws)
    error ('Rozmiar nak³adania musi byæ mniejszy ni¿ rozmiar okna!');
end

fRange=[100 4600];

MinF=fRange(1);
MaxF=fRange(2);

%funkcja zmiany skali na melow¹
mel=inline('2595*log10(1+f/700)');
melInv=inline('700*(10.^(m/2595)-1)');

%funkcja wyznaczania pasma ERB
ERB=inline('3*(6.23*(f/1000).^2 + 93.39*(f/1000) + 28.52)');

Nfft2=floor(Nfft/2);
Step=Ws-Ovr;

%%%
%%1. Podzia³ wprowadzonego sygna³u x
%%%

xLp=length(x);

%obliczenie rozmiaru macierzy
nCols=floor(xLp/Step);
nRows=Ws;

%uzpe³nienie sygna³u zerami
x=[x ; zeros((nRows+Step*(nCols-1)-xLp),1)];

%przgotowanie nak³adania
indCols=1:Step:nCols*Step;
indRows=0:nRows-1;

indColsMat=repmat(indCols,nRows,1);
indRowsMat=repmat(indRows(:),1,nCols);

indRowCol=indColsMat+indRowsMat;

%podzia³ sygna³u
X=x(indRowCol);

%wyg³adzanie sygna³u za pomoc¹ okna
X=X.*repmat(hamming(nRows),1,nCols);

%%%
%2. Wyznaczenie wartoœci bezwzglêdnej transformaty Fourier'a
%%%

Y=fft(X,Nfft);
Y=abs(Y(1:Nfft2,:));

%%%
%3. Utwo¿enie banku filtru
%%%

MelMinf=mel(MinF);
MelMaxf=mel(MaxF);

CfreqMel=linspace(MelMinf,MelMaxf,Nof);
Cfreq=melInv(CfreqMel);

%wyznaczenie macierzy banku filtrów
ktSec=[1:Nfft2]*Fs/Nfft;
FbHfcc=zeros(Nof,Nfft2);

%przygotowanie macierzy czêstotliwoœci
kAid=repmat(ktSec,Nof-2,1);

%przygotowanie macierzy czêstotliwoœci œrodkowych
Lfreq=Cfreq(2:Nof-1)-0.5*ERB(Cfreq(2:Nof-1));
Hfreq=Cfreq(2:Nof-1)+0.5*ERB(Cfreq(2:Nof-1));
mAidLow=repmat(Lfreq',1,Nfft2);
mAidMid=repmat(Cfreq(2:Nof-1)',1,Nfft2);
mAidHigh=repmat(Hfreq',1,Nfft2);

%wyznaczenie indeksów elementów macierzy spe³niaj¹cych poni¿sze kryteria: 
[indML,indKL]=find(kAid<mAidMid & kAid>=mAidLow);
[indMH,indKH]=find(kAid<mAidHigh & kAid>=mAidMid);

%zmiana adresacji kwadratowej na liniow¹
indAidL=sub2ind(size(FbHfcc), indML, indKL);
indAidH=sub2ind(size(FbHfcc), indMH, indKH);

%za³adowanie macierzy banku filtrów
FbHfcc(indAidL)=(ktSec(indKL)'-mAidLow(indML))./(mAidMid(indML)-mAidLow(indML));
FbHfcc(indAidH)=(ktSec(indKH)'-mAidHigh(indMH))./(mAidMid(indMH)-mAidHigh(indMH));

%%%
%4. Filtracja
%%%

Xs=FbHfcc*Y;

%smiana skali na logarytmiczn¹
XsLog=log10(Xs);

%%%
%5. Odwrócenie transformaty za pomoc¹ DCT
%%%

%unikniêcie za ma³ych liczb
H=dct(max(XsLog,eps));

%pobranie wymaganej iloœci rzêdów macie¿y HFCC
H=H(1:(Noc+1),:);

%usuniêcie niepotrzebnych wspó³czynników
H=H(2:end,:);

end