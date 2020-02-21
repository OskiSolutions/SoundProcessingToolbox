%wyszukiwanie czestotliwosci formantowych za pomoca predykcji liniowej
%autor: l.laszko@ita.wat.edu.pl 
%2015
function [formants]=formant2 (s, fs, nLPC, nFfreq)

N = length(s);
%applying hamming window
S_win_normal=s.*hamming(N);

%preemphasis filtering
preemph =[1 0.63];
S_win_pre=filter(1,preemph,S_win_normal);

%computing LPC
%nLPC=8; %choc ogolna zasada to 2*liczba formantow + 2
S_win_LPC=lpc(S_win_pre,nLPC);
   
%%obliczenia formantow
%wyznaczenie miejsc zerowych wielomianu o wsp lpc
S_win_LPC_Roots=roots(S_win_LPC);

%pozostawienie dodatnich wartosci
S_win_LPC_Roots_positive=S_win_LPC_Roots(imag(S_win_LPC_Roots)>=0);
%wyznaczenie katow (w rad) pomiedzy osia rzeczywista a MZ
S_roots_angle=atan2(imag(S_win_LPC_Roots_positive),real(S_win_LPC_Roots_positive));
%konwersja do Hz i uporzadkowanie 
[S_FormantFreq, Freq_ind] = sort (S_roots_angle.*(fs/(2*pi)));
%odleglosci pomiedzy znalezionymi cz.form
Freq_bandwidth = -1/2*(fs/(2*pi))*log(abs(S_win_LPC_Roots_positive(Freq_ind)));

%czestotliwosci form. sa nie mniejszy niz 90 Hz 
%a odleglosci pomiedzy kolejnymi jest nie wieksza niz 400 Hz
formants=zeros(1,nFfreq);
nn = 1;
for kk = 1:nFfreq
    if (S_FormantFreq(kk) > 90 && Freq_bandwidth(kk) <400)
        formants(nn) = S_FormantFreq(kk);
        nn = nn+1;
    end
end
