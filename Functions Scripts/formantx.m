%Wyszukiwanie czestotliwosci formantowych za pomoca predykcji liniowej
%autor: l.laszko@ita.wat.edu.pl 
%2015
 function S_FormantFreq = formantx(s, fs, NoF)

win=hamming(length(s));

%modyfikacja sygna³u okem Hamminga
S_win_normal=s.*win;

%filtracja wstêpna
preemph =[1 0.63];
S_win=filter(1,preemph,S_win_normal);

%wyznaczanie wspó³czynników LPC 
nLPC=2*NoF+2; %choc ogolna zasada to 2*liczba formantow + 2
S_win_LPC=lpc(S_win,nLPC)';
   
%%trajektorie formantow
%NoF - analizowana liczba cz. formantowych  
S_FormantFreq=zeros(1,NoF);

S_win_LPC_Roots=roots(S_win_LPC)';
%wybranie tych  0 Hz  < begunow < fs/2
S_Proper_Roots=angle(S_win_LPC_Roots(imag(S_win_LPC_Roots) > 0.01));
S_FormantTemp = sort((S_Proper_Roots*fs)/(2*pi));
try
S_FormantFreq(1,:)=S_FormantTemp(1:NoF);
catch
%jest zbyt malo F, zakladam ze nie ma F1
S_FormantFreq(1,end:-1:length(S_FormantTemp))=S_FormantTemp(end:-1:1);
end