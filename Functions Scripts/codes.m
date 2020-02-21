%poszukiwanie samoglosek na podstawie cz. formantowych
%autor: l.laszko@ita.wat.edu.pl 
%2015
function [formant_search,letters] = codes(frag,Tfrag,fr1,fr2,fr3)

fragment=round(frag);

nFrag=size(fragment,1);

%srednia czest form w pasku

%inicjalizacja macierz odniesienia dla cz. form. j.pl.
formant_base=zeros(6,7);
%interpretacja wartosci macierzy
% kod ascii symbolu samogloski F1L F1H  F2L  F2H  F3L  F3H
formant_base(1,:)=[uint16('i') 292 398 1836 2261 2349 2907];
formant_base(2,:)=[uint16('y') 369 473 1611 1910 2774 3092];
formant_base(3,:)=[uint16('e') 403 548 1329 1842 2337 2688];
formant_base(4,:)=[uint16('a') 496 619 1121 1435 2003 2670];
formant_base(5,:)=[uint16('o') 411 520 871 1295 2290 2617];
formant_base(6,:)=[uint16('u') 352 521 865 1059 2328 2739];

formant_search=zeros(7,nFrag+1);
%znane
formant_search(1:6,1)=formant_base (:,1);
%nieznane (hazard)
formant_search(7,1)=uint16('?');

%szansa trafienia (nagroda)
chance=[fr1 fr2 fr3];
%ryzyko falszywego trafienia (kara)
hazard=1/1000;%sum(chance); 

nBfo=3; %liczba analizowanych czestotliwosci formantowych
for bfo=1:nBfo,%start od 2, gdyz w 1 jest kod ascii znaku
  for ifo=1:nFrag,
    %dla i
    if(fragment(ifo,bfo)>formant_base(1,2+bfo)) && (fragment(ifo,bfo)<formant_base(1,2+bfo+1)),  
      formant_search(1,ifo+1)=formant_search(1,ifo+1)+chance(bfo); 
      %disp ('i')
    else
      formant_search(7,ifo+1)= formant_search(7,ifo+1)+hazard;
      %disp ('?')
    end
    %dla y 
    if(fragment(ifo,bfo)>formant_base(2,2+bfo)) && (fragment(ifo,bfo)<formant_base(2,2+bfo+1)),  
      formant_search(2,ifo+1)=formant_search(2,ifo+1)+chance(bfo);  
      %disp ('y')
    else
      formant_search(7,ifo+1)= formant_search(7,ifo+1)+hazard;
      %disp ('?')
    end
    %dla e
    if(fragment(ifo,bfo)>formant_base(3,2+bfo)) && (fragment(ifo,bfo)<formant_base(3,2+bfo+1)),  
      formant_search(3,ifo+1)=formant_search(3,ifo+1)+chance(bfo);  
      %disp ('e')
    else
      formant_search(7,ifo+1)= formant_search(7,ifo+1)+hazard;
      %disp ('?')
    end
    %dla a
    if(fragment(ifo,bfo)>formant_base(4,2+bfo)) && (fragment(ifo,bfo)<formant_base(4,2+bfo+1)),  
      formant_search(4,ifo+1)=formant_search(4,ifo+1)+chance(bfo); 
      %disp ('a')
    else
      formant_search(7,ifo+1)= formant_search(7,ifo+1)+hazard;
      %disp ('?')
    end
    %dla o
    if(fragment(ifo,bfo)>formant_base(5,2+bfo)) && (fragment(ifo,bfo)<formant_base(5,2+bfo+1)),  
      formant_search(5,ifo+1)=formant_search(5,ifo+1)+chance(bfo);
      %disp ('o')
    else
      formant_search(7,ifo+1)= formant_search(7,ifo+1)+hazard;
      %disp ('?')
    end
    %dla u
    if(fragment(ifo,bfo)>formant_base(6,2+bfo)) && (fragment(ifo,bfo)<formant_base(6,2+bfo+1)),  
      formant_search(6,ifo+1)=formant_search(6,ifo+1)+chance(bfo);  
     % disp ('u')
    else
     formant_search(7,ifo+1)= formant_search(7,ifo+1)+hazard;
      %disp ('?')
    end
  end
end

for n = 1:7
    res{n} = sum(formant_search(n,2:end));
end

figure,
imagesc(formant_search(:,2:end))
 text(repmat(1,6,1),[1:6],char(formant_base(1:6))','color','white')
disp(res);


figure
[a,b]=max(formant_search(:,2:end));
letters=char(formant_search(b,1)');
labels = cellstr(letters');
plot(Tfrag,frag)
hold on
text(Tfrag,frag(:,1), letters', 'fontsize',20)
xlim([0 Tfrag(end)]);
hold off
xlabel('Czas');
ylabel('Czêstotliwoœæ');

prehist = [0 0 0 0 0 0 0];

for i = 1:length(letters')
    switch letters(i)
        case 'a'
            prehist(1) = prehist(1)+1;
        case 'e'
            prehist(2) = prehist(2)+1;
        case 'i'
            prehist(3) = prehist(3)+1;
        case 'o'
            prehist(4) = prehist(4)+1;
        case 'u'
            prehist(5) = prehist(5)+1;
        case 'y'
            prehist(6) = prehist(6)+1;
        otherwise
            prehist(7) = prehist(7)+1;
    end
end          
     
disp(prehist);

figure
bar(prehist);
set(gca,'xticklabel',{'a','e','i','o','u','y','?'});
ylabel('Liczba przyporz¹dkowañ');