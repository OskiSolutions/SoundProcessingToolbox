%wyszukiwanie czestotliwosci formantowych za pomoca predykcji liniowej
%autor: l.laszko@ita.wat.edu.pl 
%2015

%clear
%clc
%close all
 function [S_FormantFreq,t]=formedit (S_win_LPC,lf,fs,n)
 S_win_LPC = S_win_LPC';  
   
%%trajektorie formantow
%S_win_LPC_Roots=zeros(N/winsize,nLPC);
%NoF - analizowana liczba cz. formantowych  
NoF=3;
S_FormantFreq=zeros(lf,NoF);
%S_win_LPC_Roots=zeros(1,winsize+1);
for i=1:(lf-1),
    S_win_LPC_Roots=roots(S_win_LPC(:,i))';
    %wybranie tych  0 Hz  < begunow < fs/2
    S_Proper_Roots=angle(S_win_LPC_Roots(imag(S_win_LPC_Roots) > 0.01));
    S_FormantTemp = sort((S_Proper_Roots*fs)/(2*pi));
    try
    S_FormantFreq(i,:)=S_FormantTemp(1:NoF);
    catch
    %jest zbyt malo F, zakladam ze nie ma F1
    S_FormantFreq(i,end:-1:length(S_FormantTemp))=S_FormantTemp(end:-1:1);
    end
end

disp(S_FormantFreq);
t=linspace(0,n/fs,lf);