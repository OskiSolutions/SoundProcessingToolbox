%Skrypt obs³uguj¹cy g³ówny interfejs graficzny u¿ytkownika
function varargout = filegui(varargin)
% FILEGUI MATLAB code for filegui.fig
%      FILEGUI, by itself, creates a new FILEGUI or raises the existing
%      singleton*.
%
%      H = FILEGUI returns the handle to a new FILEGUI or the handle to
%      the existing singleton*.
%
%      FILEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILEGUI.M with the given input arguments.
%
%      FILEGUI('Property','Value',...) creates a new FILEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filegui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filegui

% Last Modified by GUIDE v2.5 21-May-2017 12:39:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filegui_OpeningFcn, ...
                   'gui_OutputFcn',  @filegui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before filegui is made visible.
function filegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filegui (see VARARGIN)

% Choose default command line output for filegui
handles.output = hObject;

%Dodanie œcie¿ek podfolderów pakietu do obs³ugi przez MATLAB
path(path,'Functions Options GUIs');
path(path,'Functions Scripts');

%Inicjacja zmiennych globalnych zawieraj¹cych wska¿niki do wykresów wynikowych
handles.mainplot = 0;
handles.fstplot = 0;
handles.sndplot = 0;
handles.trdplot = 0;

%Inicjacja zmiennych globalnych zawieraj¹cych domyœlne dane ogólnych opcji analizy 
handles.time = 1;
handles.overlap = 0;
handles.format = 0;
handles.channel = 1;

%Inicjacja zmiennych globalnych zawieraj¹cych domyœlne struktury
%zawieraj¹ce opcje narzêdzi do wyznaczania cech dŸwiêku
arr{1}=1;
arr{2}=0;
handles.firstopts = arr;
handles.secondopts = arr;
handles.thirdopts = arr;

%Inicjacja zmiennych globalnych zawieraj¹cych opcje nagrywania sygna³u
handles.recmin = 0;
handles.recsec = 10;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filegui wait for user response (see UIRESUME)
% uiwait(handles.guifigure);


% --- Outputs from this function are returned to the command line.
function varargout = filegui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Pobranie zmiennych globalnych
Time = handles.time; %Rozmiar okna analizy
mode = handles.mode; %Tryb analizy(sygna³ z pliku czy z mikrofonu)

firstopts = handles.firstopts; %Struktura zawieraj¹ce dane dla pierwszego narzêdzia
secondopts = handles.secondopts; %Struktura zawieraj¹ce dane dla drugiego narzêdzia
thirdopts = handles.thirdopts; %Struktura zawieraj¹ce dane dla trzeciego narzêdzia

H1 = handles.fstplot; %WskaŸnik do wykresu przedstawiaj¹cego wyniki dzia³ania pierwszego narzêdzia
H2 = handles.sndplot; %WskaŸnik do wykresu przedstawiaj¹cego wyniki dzia³ania drugiego narzêdzia
H3 = handles.trdplot; %WskaŸnik do wykresu przedstawiaj¹cego wyniki dzia³ania trzeciego narzêdzia

%Usuniêcie nieu¿uwanych wykresów
if (firstopts{1} == 1 && H1 ~= 0)
     delete(H1);
end
if (secondopts{1} == 1 && H2 ~= 0)
     delete(H2);
end
if (thirdopts{1} == 1 && H3 ~= 0)
     delete(H3);
end

istime = handles.format; %Zmienna okreœlaj¹ca format argumentów funkcji (l. próbek lub czas)

if mode == 1 %Jeœli sygna³ jest pobierany z pliku, to warunek jest spe³niony
    overlap = handles.overlap; %Pobranie wspó³czynnika nak³adania sygna³u

    filelist = handles.filelist; %Pobranie struktury zawieraj¹cej informacje o plikach Ÿród³owych
    sz = size(filelist); 

    filesum = sz(1);

    %Który kana³ pliku stereo ma byæ analizowany (je¿eli analizowaæ ma byæ wiêcej ni¿ jeden plik, to zawsze anlizowany jest kana³ lewy)
    if filesum ~= 1 %Je¿eli analizowany ma byæ wiêcej ni¿ jeden plik, to warunek jest spe³niony
        chsnchnl = 1;
    else
        chsnchnl = handles.channel;
    end

    [S,S1,S2,S3,Hp,H1,H2,H3] = analisys(filelist,firstopts,secondopts,thirdopts,istime,chsnchnl,Time,overlap,handles); %Wywo³anie funkcji analizy sygna³u pobieranego z pliku
    handles.signal = S; %Zapisanie przebiegu czasowego analizowanego sygna³u do zmiennej globalnej
    handles.fstsig = S1; %Zapisanie wyników dzia³ania pierwszego narzêdzia do zmiennej globalnej
    handles.sndsig = S2; %Zapisanie wyników dzia³ania drugiego narzêdzia do zmiennej globalnej
    handles.trdsig = S3; %Zapisanie wyników dzia³ania trzeciego narzêdzia do zmiennej globalnej
    
    handles.mainplot = Hp; %Zapisanie wska¿nika do wykresu prezentuj¹cego przebieg czasowy analizowanego sygna³u do zmiennej globalnej
    handles.fstplot = H1; %Zapisanie wska¿nika do wykresu prezentuj¹cego wyniki dzia³ania pierwszego narzêdzia do zmiennej globalnej
    handles.sndplot = H2; %Zapisanie wska¿nika do wykresu prezentuj¹cego wyniki dzia³ania drugiego narzêdzia do zmiennej globalnej
    handles.trdplot = H3; %Zapisanie wska¿nika do wykresu prezentuj¹cego wyniki dzia³ania trzeciego narzêdzia do zmiennej globalnej
else
    set(handles.progress_slider,'Enable','on'); %Odblokowanie paska postêpu
    rectime = (handles.recmin*60) + handles.recsec; %Obliczenie czasu nagrywania
    lpscnt = floor((rectime*8000)/(8000*Time)); %Obliczenie liczby wykonywanych cykli analizy nagrywanego sygna³u
    
    [S,S1,S2,S3,Hp,H1,H2,H3] = recordanalisys(firstopts,secondopts,thirdopts,Time,lpscnt,istime,handles); %Wywo³anie funkcji analizy sygna³u pobieranego z mikrofonu
    handles.signal = S; %Zapisanie przebiegu czasowego analizowanego sygna³u do zmiennej globalnej
    handles.fstsig = S1; %Zapisanie wyników dzia³ania pierwszego narzêdzia do zmiennej globalnej
    handles.sndsig = S2; %Zapisanie wyników dzia³ania drugiego narzêdzia do zmiennej globalnej
    handles.trdsig = S3; %Zapisanie wyników dzia³ania trzeciego narzêdzia do zmiennej globalnej
    
    handles.mainplot = Hp; %Zapisanie wska¿nika do wykresu prezentuj¹cego przebieg czasowy analizowanego sygna³u do zmiennej globalnej
    handles.fstplot = H1; %Zapisanie wska¿nika do wykresu prezentuj¹cego wyniki dzia³ania pierwszego narzêdzia do zmiennej globalnej
    handles.sndplot = H2; %Zapisanie wska¿nika do wykresu prezentuj¹cego wyniki dzia³ania drugiego narzêdzia do zmiennej globalnej
    handles.trdplot = H3; %Zapisanie wska¿nika do wykresu prezentuj¹cego wyniki dzia³ania trzeciego narzêdzia do zmiennej globalnej
end

guidata(hObject, handles);

% --- Executes on slider movement.
function progress_slider_Callback(hObject, eventdata, handles)
% hObject    handle to progress_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Wyrównanie pozycji przesuniêtego paska
val = round(get(hObject,'Value')); %zmienna "val", pobierana na podstawie pozycji przesuniêtego paska, stanowi numer wybranego fragmentu
set(handles.progress_slider,'Value',val);
set(handles.counteredit,'String',num2str(val));

mode = handles.mode; %Pobranie wspó³czynnika trybu analizy
istime = handles.format; %Pobranie wspó³czynnika formatu argumentów uprzednio analizowanego sygna³u

signal = handles.signal; %Pobranie przebiegu czasowego uprzednio analizowanego sygna³u

%Sprawdzenie czy zmienna rzeczywiœcie posiada przebieg uprzednio analizowanego sygna³u
if length(signal) ~= 1 %Jeœli zmienna nie jest pusta, to warunek jest pusty
    S1 = handles.fstsig; %Pobranie wyników dzia³ania pierwszego narzêdzia uprzednio analizowanego sygna³u
    S2 = handles.sndsig; %Pobranie wyników dzia³ania drugiego narzêdzia uprzednio analizowanego sygna³u
    S3 = handles.trdsig; %Pobranie wyników dzia³ania trzeciego narzêdzia uprzednio analizowanego sygna³u
    window = handles.time; %Pobranie wspó³czynnika rozmiaru okna analizy
    
    if mode == 1 %Jeœli sygna³ jest pobierany z pliku, to warunek jest spe³niony
        filelist = handles.filelist;
        Fs = filelist{1,3};
    else
        Fs = 8000;
    end
    
    if istime == 1 %Jeœli wybranym formatem analizy jest czas, to warunek jest spe³niony 
        frmt = Fs;
        xlbl = 'Czas';
    else
        frmt = 1;
        xlbl = 'Czêstotliwoœæ';
    end
    
    firstopts = handles.firstopts; %Pobranie struktury zawieraj¹cej dane dla pierwszego narzêdzia
    secondopts = handles.secondopts; %Pobranie struktury zawieraj¹cej dane dla drugiego narzêdzia
    thirdopts = handles.thirdopts; %Pobranie struktury zawieraj¹cej dane dla trzeciego narzêdzia

    %Pobranie wybranego fragmentu przebiegu
    mn = (val*Fs*window) + 1;
    mx = (val*Fs*window) + 4*(Fs*window);
    S = signal(mn:mx);
    
    %Narysowanie pobranego przebiegu
    subplot(5,1,2);
    Lin = linspace((((val*Fs*window) - 4*(Fs*window)) + 1)/frmt,(val*Fs*window)/frmt,4*(Fs*window));
    plot(Lin,S);
    xlabel(xlbl);
    ylabel('Amplituda');
    axis([(((val*Fs*window) - 4*(Fs*window)) + 1)/frmt (val*Fs*window)/frmt -1 1]);
    vline(((val*Fs*window) - 3*(Fs*window))/frmt);
    vline(((val*Fs*window)- 2*(Fs*window))/frmt);
    vline(((val*Fs*window) - 1*(Fs*window))/frmt);

    %Narysowanie wyników dzia³ania pierwszego narzêdzia dla wybranego fragmentu uprzednio analizowanego sygna³u 
    if (firstopts{1} ~= 1)
        roof = max(max(S1));
        switch firstopts{1}
            case 2
                S = S1(mn:mx);
                subplot(5,1,3);
                Lin = linspace((((val*Fs*window) - 4*(Fs*window)) + 1),(val*Fs*window),4*(Fs*window));

                plot(Lin,S);
                xlabel('Czêstotliwoœæ');
                ylabel('');
                axis([(((val*Fs*window) - 4*(Fs*window)) + 1) (val*Fs*window) 0 roof]);
                vline(((val*Fs*window) - 3*(Fs*window)));
                vline(((val*Fs*window)- 2*(Fs*window)));
                vline(((val*Fs*window) - 1*(Fs*window)));
            case 3
                str = get(handles.countertext,'String');
                lgt = str2double(str(3:end));
                lgt = length(S1)/(lgt+4);
                
                mn = (val*lgt)+ 1;
                mx = (val*lgt)+ 4*(lgt);
                
                S = S1(:,mn:mx);
                
                subplot(5,1,3);
                
                surface(S);
            case 4
                str = get(handles.countertext,'String');
                lgt = str2double(str(3:end));
                lgt = length(S1)/(lgt+4);
                
                mn = (val*lgt)+ 1;
                mx = (val*lgt)+ 4*(lgt);
                
                S = S1(:,mn:mx);
                
                subplot(5,1,3);
                
                surface(S);
                
            case 5
                S = S1(mn:mx);
                subplot(5,1,3);

                Lin = linspace((((val*Fs*window) - 4*(Fs*window)) + 1)/frmt,(val*Fs*window)/frmt,4*(Fs*window));
                    
                plot(Lin,S);
                xlabel(xlbl);
                ylabel('Amplituda');
                axis([(((val*Fs*window) - 4*(Fs*window)) + 1)/frmt (val*Fs*window)/frmt -roof roof]);
                vline(((val*Fs*window) - 3*(Fs*window))/frmt);
                vline(((val*Fs*window)- 2*(Fs*window))/frmt);
                vline(((val*Fs*window) - 1*(Fs*window))/frmt);
            case 6
                mn = (val*firstopts{3})+ 1;
                mx = (val*firstopts{3})+ 4*(firstopts{3});
                Lin = linspace((firstopts{3}*val)-(firstopts{3}*4)+1,firstopts{3}*val,4*firstopts{3});
                S = S1(mn:mx);
                subplot(5,1,3);
                plot(Lin,S);
                xlabel('Wspó³czynnik');
                ylabel('Wartoœæ');
                axis([(firstopts{3}*val)-(firstopts{3}*4)+1 firstopts{3}*val -5 5 ]);
                vline((firstopts{3}*val) - 3*firstopts{3});
                vline((firstopts{3}*val) - 2*firstopts{3});
                vline((firstopts{3}*val) - firstopts{3});
            case 7
                mn = val + 1;
                mx = val + 5; 
                S = S1(:,mn:mx);
                Lin = linspace(((Fs*window*val)-4*(Fs*window))/frmt,(Fs*window*val)/frmt,5);

                subplot(5,1,3);
                plot(Lin,S(1,:),'r');
                xlabel(xlbl);
                ylabel('Czêstotliwoœæ');
                hold on;
                axis([((Fs*window*val)-4*(Fs*window))/frmt (Fs*window*val)/frmt 0 roof ]);
                plot(Lin,S(2,:),'b');
                plot(Lin,S(3,:),'g');
                hold off;

                vline(((Fs*window*val)-3*(Fs*window))/frmt);
                vline(((Fs*window*val)-2*(Fs*window))/frmt);
                vline(((Fs*window*val)-(Fs*window))/frmt);

            otherwise
        end
    end
    
    %Narysowanie wyników dzia³ania drugiego narzêdzia dla wybranego fragmentu uprzednio analizowanego sygna³u 
    if (secondopts{1} ~= 1)
        roof = max(max(S2));
        switch secondopts{1}
            case 2
                mn = (val*Fs*window) + 1;
                mx = (val*Fs*window) + 4*(Fs*window);
                S = S2(mn:mx);
                subplot(5,1,4);
                Lin = linspace((((val*Fs*window) - 4*(Fs*window)) + 1),(val*Fs*window),4*(Fs*window));
                plot(Lin,S);
                xlabel('Czêstotliwoœæ');
                ylabel('');
                axis([(((val*Fs*window) - 4*(Fs*window)) + 1) (val*Fs*window) 0 roof]);
                vline(((val*Fs*window) - 3*(Fs*window)));
                vline(((val*Fs*window)- 2*(Fs*window)));
                vline(((val*Fs*window) - 1*(Fs*window)));
            case 3
            case 4
            case 5
                S = S2(mn:mx);
                subplot(5,1,4);

                Lin = linspace((((val*Fs*window) - 4*(Fs*window)) + 1)/frmt,(val*Fs*window)/frmt,4*(Fs*window));

                plot(Lin,S);
                xlabel(xlbl);
                ylabel('Amplituda');
                axis([(((val*Fs*window) - 4*(Fs*window)) + 1)/frmt (val*Fs*window)/frmt -roof roof]);
                vline(((val*Fs*window) - 3*(Fs*window))/frmt);
                vline(((val*Fs*window)- 2*(Fs*window))/frmt);
                vline(((val*Fs*window) - 1*(Fs*window))/frmt);
            case 6
                mn = (val*secondopts{3})+ 1;
                mx = (val*secondopts{3})+ 4*(secondopts{3});
                Lin = linspace((secondopts{3}*val)-(secondopts{3}*4)+1,secondopts{3}*val,4*secondopts{3});
                S = S2(mn:mx);
                subplot(5,1,4);
                plot(Lin,S);
                xlabel('Wspó³czynnik');
                ylabel('Wartoœæ');
                axis([(secondopts{3}*val)-(secondopts{3}*4)+1 secondopts{3}*val -5 5 ]);
                vline((secondopts{3}*val) - 3*secondopts{3});
                vline((secondopts{3}*val) - 2*secondopts{3});
                vline((secondopts{3}*val) - secondopts{3});
            case 7
                mn = val + 1;
                mx = val + 5; 
                S = S2(:,mn:mx);
                Lin = linspace(((Fs*window*val)-4*(Fs*window))/frmt,(Fs*window*val)/frmt,5);

                subplot(5,1,4);
                plot(Lin,S(1,:),'r');
                xlabel(xlbl);
                ylabel('Czêstotliwoœæ');
                hold on;
                axis([((Fs*window*val)-4*(Fs*window))/frmt (Fs*window*val)/frmt 0 roof ]);
                plot(Lin,S(2,:),'b');
                plot(Lin,S(3,:),'g');
                hold off;

                vline(((Fs*window*val)-3*(Fs*window))/frmt);
                vline(((Fs*window*val)-2*(Fs*window))/frmt);
                vline(((Fs*window*val)-(Fs*window))/frmt);

            otherwise
        end
    end

    %Narysowanie wyników dzia³ania trzeciego narzêdzia dla wybranego fragmentu uprzednio analizowanego sygna³u 
    if (thirdopts{1} ~= 1)
        roof = max(max(S3));
        switch thirdopts{1}
            case 2
                mn = (val*Fs*window) + 1;
                mx = (val*Fs*window) + 4*(Fs*window);
                S = S3(mn:mx);
                subplot(5,1,5);
                Lin = linspace((((val*Fs*window) - 4*(Fs*window)) + 1)/frmt,(val*Fs*window)/frmt,4*(Fs*window));
                plot(Lin,S);
                xlabel('Czêstotliwoœæ');
                ylabel('');
                axis([(((val*Fs*window) - 4*(Fs*window)) + 1)/frmt (val*Fs*window)/frmt 0 roof]);
                vline(((val*Fs*window) - 3*(Fs*window))/frmt);
                vline(((val*Fs*window)- 2*(Fs*window))/frmt);
                vline(((val*Fs*window) - 1*(Fs*window))/frmt);
            case 3
            case 4
            case 5
                S = S3(mn:mx);
                subplot(5,1,5);
                Lin = linspace((((val*Fs*window) - 4*(Fs*window)) + 1)/frmt,(val*Fs*window)/frmt,4*(Fs*window));
                plot(Lin,S);
                xlabel(xlbl);
                ylabel('Amplituda');
                axis([(((val*Fs*window) - 4*(Fs*window)) + 1)/frmt (val*Fs*window)/frmt -roof roof]);
                vline(((val*Fs*window) - 3*(Fs*window))/frmt);
                vline(((val*Fs*window)- 2*(Fs*window))/frmt);
                vline(((val*Fs*window) - 1*(Fs*window))/frmt);
            case 6
                mn = (val*thirdopts{3})+ 1;
                mx = (val*thirdopts{3})+ 4*(thirdopts{3});
                Lin = linspace((thirdopts{3}*val)-(thirdopts{3}*4)+1,thirdopts{3}*val,4*thirdopts{3});
                S = S3(mn:mx);
                subplot(5,1,5);
                plot(Lin,S);
                xlabel('Wspó³czynnik');
                ylabel('Wartoœæ');
                axis([(thirdopts{3}*val)-(thirdopts{3}*4)+1 thirdopts{3}*val -5 5 ]);
                vline((thirdopts{3}*val) - 3*thirdopts{3});
                vline((thirdopts{3}*val) - 2*thirdopts{3});
                vline((thirdopts{3}*val) - thirdopts{3});
            case 7
                mn = val + 1;
                mx = val + 5; 
                S = S3(:,mn:mx);
                Lin = linspace(((Fs*window*val)-4*(Fs*window))/frmt,(Fs*window*val)/frmt,5);
                subplot(5,1,5);
                plot(Lin,S(1,:),'r');
                xlabel(xlbl);
                ylabel('Czêstotliwoœæ');
                hold on;
                axis([((Fs*window*val)-4*(Fs*window))/frmt (Fs*window*val)/frmt 0 roof ]);
                plot(Lin,S(2,:),'b');
                plot(Lin,S(3,:),'g');
                hold off;

                vline(((Fs*window*val)-3*(Fs*window))/frmt);
                vline(((Fs*window*val)-2*(Fs*window))/frmt);
                vline(((Fs*window*val)-(Fs*window))/frmt);

            otherwise
        end
    end
end

% --- Executes during object creation, after setting all properties.
function progress_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progress_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function counteredit_Callback(hObject, eventdata, handles)
% hObject    handle to counteredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of counteredit as text
%        str2double(get(hObject,'String')) returns contents of counteredit as a double


% --- Executes during object creation, after setting all properties.
function counteredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to counteredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%//////////////////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////////////////
%//////////////////////Menu Bar Callback Functions/////////////////////////
%//////////////////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////////////////

% --------------------------------------------------------------------
%Wywo³ania pozycji w menu: "Analiza 1"->"Opcje"
function firstoptns_menu_Callback(hObject, eventdata, handles)
% hObject    handle to firstoptns_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prevopts=handles.firstopts;
tmp=prevopts{1};
%Wywo³anie interfejsu graficznego odpowiadaj¹cego wybranemu narzêdziowi,
%s³u¿¹cego do jego konfiguracji
switch tmp
    case 2
        opts = optsFFT({prevopts});
    case 3
        opts = optsMFCC({prevopts});
    case 4
        opts = optsHFCC({prevopts});
    case 5
        opts = optsDFIG({prevopts});
    case 6
        opts = optsLPC({prevopts});
    case 7
        opts = optsFRMT({prevopts});
    otherwise
        disp('Error');
end
handles.firstopts = opts;
guidata(hObject, handles);

% --------------------------------------------------------------------
%Wywo³ania pozycji w menu: "Analiza 2"->"Opcje"
function secondoptns_menu_Callback(hObject, eventdata, handles)
% hObject    handle to secondoptns_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prevopts=handles.secondopts;
tmp=prevopts{1};
%Wywo³anie interfejsu graficznego odpowiadaj¹cego wybranemu narzêdziowi,
%s³u¿¹cego do jego konfiguracji
switch tmp
    case 2
        opts = optsFFT({prevopts});
    case 3
        opts = optsMFCC({prevopts});
    case 4
        opts = optsHFCC({prevopts});
    case 5
        opts = optsDFIG({prevopts});
    case 6
        opts = optsLPC({prevopts});
    case 7
        opts = optsFRMT({prevopts});
    otherwise
        disp('Error');
end
handles.secondopts = opts;
guidata(hObject, handles);

% --------------------------------------------------------------------
%Wywo³ania pozycji w menu: "Analiza 3"->"Opcje"
function thirdoptns_menu_Callback(hObject, eventdata, handles)
% hObject    handle to thirdoptns_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prevopts=handles.thirdopts;
tmp=prevopts{1};
%Wywo³anie interfejsu graficznego odpowiadaj¹cego wybranemu narzêdziowi,
%s³u¿¹cego do jego konfiguracji
switch tmp
    case 2
        opts = optsFFT({prevopts});
    case 3
        opts = optsMFCC({prevopts});
    case 4
        opts = optsHFCC({prevopts});
    case 5
        opts = optsDFIG({prevopts});
    case 6
        opts = optsLPC({prevopts});
    case 7
        opts = optsFRMT({prevopts});
    otherwise
        disp('Error');
end
handles.thirdopts = opts;
guidata(hObject, handles);

% --------------------------------------------------------------------
%Wywo³ania pozycji w menu: "Sygna³"->"Wczytaj plik"
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mode = 1;
[musicname,musicpath] = uigetfile({'*.wav';'*.mp3';'*.ogg'}, 'Wybierz plik dŸwiêkowy...');
filelist = cell(1,4);

if musicname ~= 0
    file = [musicpath musicname];
    filelist{1,1} = musicname;
    set(handles.filetext,'String',musicname);
    set(handles.guifigure,'Name',['Analizer: ' file]);
    info = audioinfo(file);
    Fs = info.SampleRate;
    Ls = info.TotalSamples;
    Time = Ls/Fs;
    filelist{1,2} = file;
    filelist{1,3} = Fs;
    filelist{1,4} = Ls;
    set(handles.freqtext,'String',['Czêstotliwoœæ: ' num2str(Fs) 'Hz']);
    set(handles.samplestext,'String',['Liczba próbek: ' num2str(Ls)]);
    set(handles.timetext,'String',['Czas trwania sygna³u: ' num2str(Time) 's']);
    
    set(handles.file_menu,'Checked','on');
    set(handles.micro_menu,'Checked','off');
    set(handles.single_menu,'Checked','off');
    set(handles.multi_menu,'Checked','off');
    
    set(handles.overloop_opt1_menu,'Checked','on');
    set(handles.overloop_opt2_menu,'Checked','off');
    set(handles.overloop_opt3_menu,'Checked','off');
    set(handles.overloop_opt4_menu,'Checked','off');
    set(handles.overloop_opt5_menu,'Checked','off');
    set(handles.overloop_opt6_menu,'Checked','off');
    
    set(handles.overloop_opt1_menu,'Enable','on');
    set(handles.overloop_opt2_menu,'Enable','on');
    set(handles.overloop_opt3_menu,'Enable','on');
    set(handles.overloop_opt4_menu,'Enable','on');
    set(handles.overloop_opt5_menu,'Enable','on');
    set(handles.overloop_opt6_menu,'Enable','on');
    
    set(handles.window_opt1_menu,'Checked','off');
    set(handles.window_opt2_menu,'Checked','off');
    set(handles.window_opt3_menu,'Checked','off');
    set(handles.window_opt4_menu,'Checked','off');
    set(handles.window_opt5_menu,'Checked','off');
    set(handles.window_opt6_menu,'Checked','off');
    set(handles.window_opt7_menu,'Checked','off');
    
    if Time < 0.025
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','off');
        set(handles.window_opt6_menu,'Enable','off');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt7_menu,'Checked','on');
        window = 0.01;
    elseif Time < 0.05
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','off');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt6_menu,'Checked','on');
        window = 0.025;
    elseif Time < 0.01
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt5_menu,'Checked','on');
        window = 0.5;
    elseif Time < 0.25
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt4_menu,'Checked','on');
        window = 0.1;
    elseif Time < 0.5
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt3_menu,'Checked','on');
        window = 0.25;
    elseif Time < 1
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','on');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt2_menu,'Checked','on');
        window = 0.5;
    else
        set(handles.window_opt1_menu,'Enable','on');
        set(handles.window_opt2_menu,'Enable','on');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt1_menu,'Checked','on');
        window = 1;
    end
    
    handles.time = window;
    handles.signal = 0;
    
    steps = floor(Ls/(Fs * window));
        
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.counteredit,'String','0');
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider,'Value',0);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
    
    NumCs = info.NumChannels;
    if NumCs == 1
        set(handles.left_channel_menu,'Checked','off');
        set(handles.right_channel_menu,'Checked','off');
        set(handles.left_channel_menu,'Enable','off');
        set(handles.right_channel_menu,'Enable','off');
        set(handles.mono_channel_menu,'Enable','on');
        set(handles.mono_channel_menu,'Checked','on');
    else
        set(handles.mono_channel_menu,'Checked','off');
        set(handles.mono_channel_menu,'Enable','off');
        set(handles.left_channel_menu,'Enable','on');
        set(handles.right_channel_menu,'Enable','on');
        set(handles.left_channel_menu,'Checked','on');
    end
    set(handles.startbutton,'Enable','on');
    set(handles.progress_slider,'Enable','on');
    set(handles.recoptspanel,'Visible','off');
    
    
    Hp = handles.mainplot;
    H1 = handles.fstplot;
    H2 = handles.sndplot;
    H3 = handles.trdplot;

    if Hp ~= 0
         delete(Hp);
    end
    if H1 ~= 0
         delete(H1);
    end
    if H2 ~= 0
         delete(H2);
    end
    if H3 ~= 0
         delete(H3);
    end
    
    handles.mainplot = 0;
    handles.fstplot = 0;
    handles.sndplot = 0;
    handles.trdplot = 0;
    
    handles.channel = 1;
    handles.file = file;
    handles.filelist = filelist;
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function micro_menu_Callback(hObject, eventdata, handles)
% hObject    handle to micro_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mode = 2;
set(handles.filetext,'String','Mikrofon');
set(handles.freqtext,'String','Czêstotliwoœæ: 8000');
set(handles.samplestext,'String','Liczba próbek: ');
set(handles.timetext,'String','Czas trwania sygna³u: ');

set(handles.micro_menu,'Checked','on');
set(handles.file_menu,'Checked','off');
set(handles.single_menu,'Checked','off');
set(handles.multi_menu,'Checked','off');
    
set(handles.overloop_opt1_menu,'Checked','off');
set(handles.overloop_opt2_menu,'Checked','off');
set(handles.overloop_opt3_menu,'Checked','off');
set(handles.overloop_opt4_menu,'Checked','off');
set(handles.overloop_opt5_menu,'Checked','off');
set(handles.overloop_opt6_menu,'Checked','off');
    
set(handles.overloop_opt1_menu,'Enable','off');
set(handles.overloop_opt2_menu,'Enable','off');
set(handles.overloop_opt3_menu,'Enable','off');
set(handles.overloop_opt4_menu,'Enable','off');
set(handles.overloop_opt5_menu,'Enable','off');
set(handles.overloop_opt6_menu,'Enable','off');

set(handles.window_opt1_menu,'Checked','off');
set(handles.window_opt2_menu,'Checked','off');
set(handles.window_opt3_menu,'Checked','off');
set(handles.window_opt4_menu,'Checked','off');
set(handles.window_opt5_menu,'Checked','off');
set(handles.window_opt6_menu,'Checked','off');
set(handles.window_opt7_menu,'Checked','off');

set(handles.window_opt1_menu,'Enable','on');
set(handles.window_opt2_menu,'Enable','on');
set(handles.window_opt3_menu,'Enable','on');
set(handles.window_opt4_menu,'Enable','on');
set(handles.window_opt5_menu,'Enable','on');
set(handles.window_opt6_menu,'Enable','on');
set(handles.window_opt7_menu,'Enable','on');
set(handles.window_opt1_menu,'Checked','on');
window = 1;

handles.time = window;
handles.signal = 0;

set(handles.left_channel_menu,'Checked','off');
set(handles.right_channel_menu,'Checked','off');
set(handles.left_channel_menu,'Enable','off');
set(handles.right_channel_menu,'Enable','off');
set(handles.mono_channel_menu,'Enable','on');
set(handles.mono_channel_menu,'Checked','on');

set(handles.counteredit,'Enable','off');
set(handles.countertext,'String','\ 0');
set(handles.counteredit,'String','0');
set(handles.progress_slider,'Enable','off');
set(handles.recoptspanel,'Visible','on');

set(handles.startbutton,'Enable','on');

guidata(hObject, handles);

% --------------------------------------------------------------------
function single_menu_Callback(hObject, eventdata, handles)
% hObject    handle to single_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir('', 'Wybierz folder z plikami dŸwiêkowymi...');
 
if folder ~= 0
    filelist = dir(folder);
    num = length(filelist);
    Time = 1;
    
    n=1;
    filearr = cell(num-2,4);
    for i = 1:num-2
        name = filelist(i+2).name;
           
        if strfind(name,'.wav');
            filearr{n,1} = name;
            filearr{n,2} = [folder '\' name];
            info = audioinfo([folder '\' name]);
            filearr{n,3} = info.SampleRate;
            filearr{n,4} = info.TotalSamples;
            tm = info.TotalSamples/info.SampleRate;
            if tm < Time
                Time = tm;
            end
            n=n+1;
        end
        
        if strfind(name,'.mp3');
            filearr{n,1} = name;
            filearr{n,2} = [folder '\' name];
            info = audioinfo([folder '\' name]);
            filearr{n,3} = info.SampleRate;
            filearr{n,4} = info.TotalSamples;
            tm = info.TotalSamples/info.SampleRate;
            if tm < Time
                Time = tm;
            end
            n=n+1;
        end
        
        if strfind(name,'.ogg');
            filearr{n,1} = name;
            filearr{n,2} = [folder '\' name];
            info = audioinfo([folder '\' name]);
            filearr{n,3} = info.SampleRate;
            filearr{n,4} = info.TotalSamples;
            tm = info.TotalSamples/info.SampleRate;
            if tm < Time
                Time = tm;
            end
            n=n+1;
        end
    end
    filearr = filearr(1:(n-1),:);
    disp(filearr);
    
    set(handles.guifigure,'Name',['Analizer - ' folder]);
    
    set(handles.file_menu,'Checked','off');
    set(handles.micro_menu,'Checked','off');
    set(handles.single_menu,'Checked','on');
    set(handles.multi_menu,'Checked','off');
    
    set(handles.overloop_opt1_menu,'Checked','off');
    set(handles.overloop_opt2_menu,'Checked','off');
    set(handles.overloop_opt3_menu,'Checked','off');
    set(handles.overloop_opt4_menu,'Checked','off');
    set(handles.overloop_opt5_menu,'Checked','off');
    set(handles.overloop_opt6_menu,'Checked','off');
    
    set(handles.overloop_opt1_menu,'Enable','off');
    set(handles.overloop_opt2_menu,'Enable','off');
    set(handles.overloop_opt3_menu,'Enable','off');
    set(handles.overloop_opt4_menu,'Enable','off');
    set(handles.overloop_opt5_menu,'Enable','off');
    set(handles.overloop_opt6_menu,'Enable','off');
   
    set(handles.window_opt1_menu,'Checked','off');
    set(handles.window_opt2_menu,'Checked','off');
    set(handles.window_opt3_menu,'Checked','off');
    set(handles.window_opt4_menu,'Checked','off');
    set(handles.window_opt5_menu,'Checked','off');
    set(handles.window_opt6_menu,'Checked','off');
    set(handles.window_opt7_menu,'Checked','off');
    
    if Time < 0.025
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','off');
        set(handles.window_opt6_menu,'Enable','off');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt7_menu,'Checked','on');
        window = 0.01;
    elseif Time < 0.05
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','off');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt6_menu,'Checked','on');
        window = 0.025;
    elseif Time < 0.01
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt5_menu,'Checked','on');
        window = 0.5;
    elseif Time < 0.25
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt4_menu,'Checked','on');
        window = 0.1;
    elseif Time < 0.5
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt3_menu,'Checked','on');
        window = 0.25;
    elseif Time < 1
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','on');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt2_menu,'Checked','on');
        window = 0.5;
    else
        set(handles.window_opt1_menu,'Enable','on');
        set(handles.window_opt2_menu,'Enable','on');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt1_menu,'Checked','on');
        window = 1;
    end
    
    handles.time = window;
    
    set(handles.counteredit,'Enable','off');
    set(handles.countertext,'String','\ 0');
    set(handles.counteredit,'String','0');
    set(handles.progress_slider,'Enable','off');
    
%     steps = floor(Ls/(Fs * window));
%         
%     set(handles.countertext,'String',['\ ' num2str(steps)]);
%     set(handles.counteredit,'String','0');
%     set(handles.progress_slider,'Max',steps);
%     set(handles.progress_slider,'Value',0);
%     set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
    
    set(handles.left_channel_menu,'Checked','off');
    set(handles.right_channel_menu,'Checked','off');
    set(handles.left_channel_menu,'Enable','off');
    set(handles.right_channel_menu,'Enable','off');
    set(handles.mono_channel_menu,'Enable','on');
    set(handles.mono_channel_menu,'Checked','on');

%     NumCs = info.NumChannels;
%     if NumCs == 1
%         set(handles.left_channel_menu,'Checked','off');
%         set(handles.right_channel_menu,'Checked','off');
%         set(handles.left_channel_menu,'Enable','off');
%         set(handles.right_channel_menu,'Enable','off');
%         set(handles.mono_channel_menu,'Enable','on');
%         set(handles.mono_channel_menu,'Checked','on');
%     else
%         set(handles.mono_channel_menu,'Checked','off');
%         set(handles.mono_channel_menu,'Enable','off');
%         set(handles.left_channel_menu,'Enable','on');
%         set(handles.right_channel_menu,'Enable','on');
%         set(handles.left_channel_menu,'Checked','on');
%     end

    set(handles.progress_slider,'Enable','off');
    set(handles.recoptspanel,'Visible','off');
    
    Hp = handles.mainplot;
    H1 = handles.fstplot;
    H2 = handles.sndplot;
    H3 = handles.trdplot;

    if Hp ~= 0
         delete(Hp);
    end
    if H1 ~= 0
         delete(H1);
    end
    if H2 ~= 0
         delete(H2);
    end
    if H3 ~= 0
         delete(H3);
    end
    
    handles.mainplot = 0;
    handles.fstplot = 0;
    handles.sndplot = 0;
    handles.trdplot = 0;
    
    handles.channel = 1;
    handles.mode = 1;
    
    tmp = strsplit(folder,'\');
    fldname = tmp{end};
    set(handles.filetext,'String',['Folder: ' fldname ' | Liczba plików: ' num2str(n-1)]);
    set(handles.startbutton,'Enable','on');
    handles.filelist = filearr;
    handles.signal = 0;
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function multi_menu_Callback(hObject, eventdata, handles)
% hObject    handle to multi_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir('', 'Wybierz folder z plikami dŸwiêkowymi...');
 
if folder ~= 0
    filelist = dir(folder);
    num = length(filelist);
    
    n=1;
    filearr = cell(num-2,4);
    for i = 1:num-2
        name = filelist(i+2).name;
           
        if strfind(name,'.wav');
            filearr{n,1} = name;
            filearr{n,2} = [folder '\' name];
            info = audioinfo([folder '\' name]);
            filearr{n,3} = info.SampleRate;
            filearr{n,4} = info.TotalSamples;
            n=n+1;
        end
        
        if strfind(name,'.mp3');
            filearr{n,1} = name;
            filearr{n,2} = [folder '\' name];
            info = audioinfo([folder '\' name]);
            filearr{n,3} = info.SampleRate;
            filearr{n,4} = info.TotalSamples;
            n=n+1;
        end
        
        if strfind(name,'.ogg');
            filearr{n,1} = name;
            filearr{n,2} = [folder '\' name];
            info = audioinfo([folder '\' name]);
            filearr{n,3} = info.SampleRate;
            filearr{n,4} = info.TotalSamples;
            n=n+1;
        end
    end
    filearr = filearr(1:(n-1),:);
    disp(filearr);
    
    tmp = strsplit(folder,'\');
    fldname = tmp{end};
    set(handles.filetext,'String',['Folder: ' fldname ' | Liczba plików: ' num2str(n-1)]);
    handles.filelist = filearr;
    guidata(hObject, handles);
    
    concat_sound=zeros(sum(cell2mat(filearr(:,4)),1),1);
    cs_fs=filearr{1,3};
    index = 0;
    disp(length(concat_sound));
    
    for i=1:n-1,
        tmp = audioread(filearr{i,2});
        disp(length(tmp));
        concat_sound((index+1):index+length(tmp),1) = tmp;
        index = index + length(tmp);
        disp(index);
    end
    audiowrite([folder '.wav'],concat_sound,cs_fs);
  
    filearr = cell(1,4);
    filearr{1,1} = [fldname '.wav'];
    filearr{1,2} = [folder '.wav'];
    filearr{1,3} = cs_fs;
    filearr{1,4} = length(concat_sound);
    Time = length(concat_sound)/cs_fs;

    set(handles.file_menu,'Checked','off');
    set(handles.micro_menu,'Checked','off');
    set(handles.single_menu,'Checked','off');
    set(handles.multi_menu,'Checked','on');
        
    set(handles.overloop_opt1_menu,'Checked','on');
    set(handles.overloop_opt2_menu,'Checked','off');
    set(handles.overloop_opt3_menu,'Checked','off');
    set(handles.overloop_opt4_menu,'Checked','off');
    set(handles.overloop_opt5_menu,'Checked','off');
    set(handles.overloop_opt6_menu,'Checked','off');
    
    set(handles.overloop_opt1_menu,'Enable','on');
    set(handles.overloop_opt2_menu,'Enable','on');
    set(handles.overloop_opt3_menu,'Enable','on');
    set(handles.overloop_opt4_menu,'Enable','on');
    set(handles.overloop_opt5_menu,'Enable','on');
    set(handles.overloop_opt6_menu,'Enable','on');

    set(handles.window_opt1_menu,'Checked','off');
    set(handles.window_opt2_menu,'Checked','off');
    set(handles.window_opt3_menu,'Checked','off');
    set(handles.window_opt4_menu,'Checked','off');
    set(handles.window_opt5_menu,'Checked','off');
    set(handles.window_opt6_menu,'Checked','off');
    set(handles.window_opt7_menu,'Checked','off');
    
    if Time < 0.025
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','off');
        set(handles.window_opt6_menu,'Enable','off');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt7_menu,'Checked','on');
        window = 0.01;
    elseif Time < 0.05
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','off');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt6_menu,'Checked','on');
        window = 0.025;
    elseif Time < 0.01
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','off');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt5_menu,'Checked','on');
        window = 0.5;
    elseif Time < 0.25
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','off');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt4_menu,'Checked','on');
        window = 0.1;
    elseif Time < 0.5
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','off');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt3_menu,'Checked','on');
        window = 0.25;
    elseif Time < 1
        set(handles.window_opt1_menu,'Enable','off');
        set(handles.window_opt2_menu,'Enable','on');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt2_menu,'Checked','on');
        window = 0.5;
    else
        set(handles.window_opt1_menu,'Enable','on');
        set(handles.window_opt2_menu,'Enable','on');
        set(handles.window_opt3_menu,'Enable','on');
        set(handles.window_opt4_menu,'Enable','on');
        set(handles.window_opt5_menu,'Enable','on');
        set(handles.window_opt6_menu,'Enable','on');
        set(handles.window_opt7_menu,'Enable','on');
        set(handles.window_opt1_menu,'Checked','on');
        window = 1;
    end
    
    handles.time = window;
    
    steps = floor(length(concat_sound)/(cs_fs * window));
        
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.counteredit,'String','0');
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider,'Value',0);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
    
    set(handles.left_channel_menu,'Checked','off');
    set(handles.right_channel_menu,'Checked','off');
    set(handles.left_channel_menu,'Enable','off');
    set(handles.right_channel_menu,'Enable','off');
    set(handles.mono_channel_menu,'Enable','on');
    set(handles.mono_channel_menu,'Checked','on');
    
    set(handles.progress_slider,'Enable','on');
    set(handles.recoptspanel,'Visible','off');    
    
    Hp = handles.mainplot;
    H1 = handles.fstplot;
    H2 = handles.sndplot;
    H3 = handles.trdplot;

    if Hp ~= 0
         delete(Hp);
    end
    if H1 ~= 0
         delete(H1);
    end
    if H2 ~= 0
         delete(H2);
    end
    if H3 ~= 0
         delete(H3);
    end
    
    handles.mainplot = 0;
    handles.fstplot = 0;
    handles.sndplot = 0;
    handles.trdplot = 0;
    
    handles.channel = 1;
    handles.mode = 1;



handles.filelist = filearr;
handles.signal = 0;
set(handles.guifigure,'Name',['Analizer - ' [folder '.wav']]);
set(handles.freqtext,'String',['Czêstotliwoœæ: ' num2str(filearr{1,3}) ' Hz']);
set(handles.samplestext,'String',['Liczba próbek: ' num2str(filearr{1,4})]);
set(handles.timetext,'String',['Czas trwania sygna³u: ' num2str(Time) ' s']);
set(handles.filetext,'String',[fldname '.wav']);
set(handles.startbutton,'Enable','on');

guidata(hObject, handles);
end

% --------------------------------------------------------------------
function fst_null_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_null_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstoptns_menu,'Enable','off');
set(handles.fst_null_menu,'Checked','on');
set(handles.fst_fft_menu,'Checked','off');
set(handles.fst_mfcc_menu,'Checked','off');
set(handles.fst_hfcc_menu,'Checked','off');
set(handles.fst_filtr_menu,'Checked','off');
set(handles.fst_lpc_menu,'Checked','off');
set(handles.fst_formant_menu,'Checked','off');
set(handles.firsttext,'String','Wykres 1');
arr{1}=1;
arr{2}=0;
handles.firstopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function fst_fft_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_fft_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstoptns_menu,'Enable','on');
set(handles.fst_null_menu,'Checked','off');
set(handles.fst_fft_menu,'Checked','on');
set(handles.fst_mfcc_menu,'Checked','off');
set(handles.fst_hfcc_menu,'Checked','off');
set(handles.fst_filtr_menu,'Checked','off');
set(handles.fst_lpc_menu,'Checked','off');
set(handles.fst_formant_menu,'Checked','off');
set(handles.firsttext,'String','FFT');
arr{1} = 2;
arr{2} = 0;
arr{3} = 2;
handles.firstopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function fst_mfcc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_hfcc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstoptns_menu,'Enable','on');
set(handles.fst_null_menu,'Checked','off');
set(handles.fst_fft_menu,'Checked','off');
set(handles.fst_mfcc_menu,'Checked','on');
set(handles.fst_hfcc_menu,'Checked','off');
set(handles.fst_filtr_menu,'Checked','off');
set(handles.fst_lpc_menu,'Checked','off');
set(handles.fst_formant_menu,'Checked','off');
set(handles.firsttext,'String','MFCC');
arr{1} = 3;
arr{2} = 0;
arr{3} = 20;
arr{4} = 512;
arr{5} = 256;
arr{6} = 1024;
arr{7} = 30;
handles.firstopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function fst_hfcc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_hfcc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstoptns_menu,'Enable','on');
set(handles.fst_null_menu,'Checked','off');
set(handles.fst_fft_menu,'Checked','off');
set(handles.fst_mfcc_menu,'Checked','off');
set(handles.fst_hfcc_menu,'Checked','on');
set(handles.fst_filtr_menu,'Checked','off');
set(handles.fst_lpc_menu,'Checked','off');
set(handles.fst_formant_menu,'Checked','off');
set(handles.firsttext,'String','HFCC');
arr{1} = 4;
arr{2} = 0;
arr{3} = 20;
arr{4} = 512;
arr{5} = 256;
arr{6} = 1024;
arr{7} = 30;
handles.firstopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function fst_filtr_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_filtr_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstoptns_menu,'Enable','on');
set(handles.fst_null_menu,'Checked','off');
set(handles.fst_fft_menu,'Checked','off');
set(handles.fst_mfcc_menu,'Checked','off');
set(handles.fst_hfcc_menu,'Checked','off');
set(handles.fst_filtr_menu,'Checked','on');
set(handles.fst_lpc_menu,'Checked','off');
set(handles.fst_formant_menu,'Checked','off');
set(handles.firsttext,'String','FILTR');
arr{1} = 5;
arr{2} = 0;
arr{3} = 1;
arr{4} = 4;
arr{5} = 0.1;
arr{6} = 0.8;
handles.firstopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function fst_lpc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_lpc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstoptns_menu,'Enable','on');
set(handles.fst_null_menu,'Checked','off');
set(handles.fst_fft_menu,'Checked','off');
set(handles.fst_mfcc_menu,'Checked','off');
set(handles.fst_hfcc_menu,'Checked','off');
set(handles.fst_filtr_menu,'Checked','off');
set(handles.fst_lpc_menu,'Checked','on');
set(handles.fst_formant_menu,'Checked','off');
set(handles.firsttext,'String','LPC');
arr{1} = 6;
arr{2} = 0;
arr{3} = 10;
handles.firstopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function fst_formant_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_formant_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstoptns_menu,'Enable','on');
set(handles.fst_null_menu,'Checked','off');
set(handles.fst_fft_menu,'Checked','off');
set(handles.fst_mfcc_menu,'Checked','off');
set(handles.fst_hfcc_menu,'Checked','off');
set(handles.fst_filtr_menu,'Checked','off');
set(handles.fst_lpc_menu,'Checked','off');
set(handles.fst_formant_menu,'Checked','on');
set(handles.firsttext,'String','FORMANT');
arr{1} = 7;
arr{2} = 0;
arr{3} = 3;
arr{4} = 1;
handles.firstopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function snd_null_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_null_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.secondoptns_menu,'Enable','off');
set(handles.snd_null_menu,'Checked','on');
set(handles.snd_fft_menu,'Checked','off');
set(handles.snd_mfcc_menu,'Checked','off');
set(handles.snd_hfcc_menu,'Checked','off');
set(handles.snd_filtr_menu,'Checked','off');
set(handles.snd_lpc_menu,'Checked','off');
set(handles.snd_formant_menu,'Checked','off');
set(handles.secondtext,'String','Wykres 2');
arr{1}=1;
arr{2}=0;
handles.secondopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function snd_fft_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_fft_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.secondoptns_menu,'Enable','on');
set(handles.snd_null_menu,'Checked','off');
set(handles.snd_fft_menu,'Checked','on');
set(handles.snd_mfcc_menu,'Checked','off');
set(handles.snd_hfcc_menu,'Checked','off');
set(handles.snd_filtr_menu,'Checked','off');
set(handles.snd_lpc_menu,'Checked','off');
set(handles.snd_formant_menu,'Checked','off');
set(handles.secondtext,'String','FFT');
arr{1} = 2;
arr{2} = 0;
arr{3} = 2;
handles.secondopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function snd_mfcc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_hfcc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.secondoptns_menu,'Enable','on');
set(handles.snd_null_menu,'Checked','off');
set(handles.snd_fft_menu,'Checked','off');
set(handles.snd_mfcc_menu,'Checked','on');
set(handles.snd_hfcc_menu,'Checked','off');
set(handles.snd_filtr_menu,'Checked','off');
set(handles.snd_lpc_menu,'Checked','off');
set(handles.snd_formant_menu,'Checked','off');
set(handles.secondtext,'String','MFCC');
arr{1} = 3;
arr{2} = 0;
arr{3} = 20;
arr{4} = 512;
arr{5} = 256;
arr{6} = 1024;
arr{7} = 30;
handles.secondopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function snd_hfcc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_hfcc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.secondoptns_menu,'Enable','on');
set(handles.snd_null_menu,'Checked','off');
set(handles.snd_fft_menu,'Checked','off');
set(handles.snd_mfcc_menu,'Checked','off');
set(handles.snd_hfcc_menu,'Checked','on');
set(handles.snd_filtr_menu,'Checked','off');
set(handles.snd_lpc_menu,'Checked','off');
set(handles.snd_formant_menu,'Checked','off');
set(handles.secondtext,'String','HFCC');
arr{1} = 4;
arr{2} = 0;
arr{3} = 20;
arr{4} = 512;
arr{5} = 256;
arr{6} = 1024;
arr{7} = 30;
handles.secondopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function snd_filtr_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_filtr_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.secondoptns_menu,'Enable','on');
set(handles.snd_null_menu,'Checked','off');
set(handles.snd_fft_menu,'Checked','off');
set(handles.snd_mfcc_menu,'Checked','off');
set(handles.snd_hfcc_menu,'Checked','off');
set(handles.snd_filtr_menu,'Checked','on');
set(handles.snd_lpc_menu,'Checked','off');
set(handles.snd_formant_menu,'Checked','off');
set(handles.secondtext,'String','FILTR');
arr{1} = 5;
arr{2} = 0;
arr{3} = 1;
arr{4} = 4;
arr{5} = 0.1;
arr{6} = 0.8;
handles.secondopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function snd_lpc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_lpc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.secondoptns_menu,'Enable','on');
set(handles.snd_null_menu,'Checked','off');
set(handles.snd_fft_menu,'Checked','off');
set(handles.snd_mfcc_menu,'Checked','off');
set(handles.snd_hfcc_menu,'Checked','off');
set(handles.snd_filtr_menu,'Checked','off');
set(handles.snd_lpc_menu,'Checked','on');
set(handles.snd_formant_menu,'Checked','off');
set(handles.secondtext,'String','LPC');
arr{1} = 6;
arr{2} = 0;
arr{3} = 10;
handles.secondopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function snd_formant_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_formant_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.secondoptns_menu,'Enable','on');
set(handles.snd_null_menu,'Checked','off');
set(handles.snd_fft_menu,'Checked','off');
set(handles.snd_mfcc_menu,'Checked','off');
set(handles.snd_hfcc_menu,'Checked','off');
set(handles.snd_filtr_menu,'Checked','off');
set(handles.snd_lpc_menu,'Checked','off');
set(handles.snd_formant_menu,'Checked','on');
set(handles.secondtext,'String','FORMANT');
arr{1} = 7;
arr{2} = 0;
arr{3} = 3;
arr{4} = 1;
handles.secondopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function trd_null_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_null_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thirdoptns_menu,'Enable','off');
set(handles.trd_null_menu,'Checked','on');
set(handles.trd_fft_menu,'Checked','off');
set(handles.trd_mfcc_menu,'Checked','off');
set(handles.trd_hfcc_menu,'Checked','off');
set(handles.trd_filtr_menu,'Checked','off');
set(handles.trd_lpc_menu,'Checked','off');
set(handles.trd_formant_menu,'Checked','off');
set(handles.thirdtext,'String','Wykres 3');
arr{1}=1;
arr{2}=0;
handles.thirdopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function trd_fft_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_fft_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thirdoptns_menu,'Enable','on');
set(handles.trd_null_menu,'Checked','off');
set(handles.trd_fft_menu,'Checked','on');
set(handles.trd_mfcc_menu,'Checked','off');
set(handles.trd_hfcc_menu,'Checked','off');
set(handles.trd_filtr_menu,'Checked','off');
set(handles.trd_lpc_menu,'Checked','off');
set(handles.trd_formant_menu,'Checked','off');
set(handles.thirdtext,'String','FFT');
arr{1} = 2;
arr{2} = 0;
arr{3} = 2;
handles.thirdopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function trd_mfcc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_hfcc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thirdoptns_menu,'Enable','on');
set(handles.trd_null_menu,'Checked','off');
set(handles.trd_fft_menu,'Checked','off');
set(handles.trd_mfcc_menu,'Checked','on');
set(handles.trd_hfcc_menu,'Checked','off');
set(handles.trd_filtr_menu,'Checked','off');
set(handles.trd_lpc_menu,'Checked','off');
set(handles.trd_formant_menu,'Checked','off');
set(handles.thirdtext,'String','MFCC');
arr{1} = 3;
arr{2} = 0;
arr{3} = 20;
arr{4} = 512;
arr{5} = 256;
arr{6} = 1024;
arr{7} = 30;
handles.thirdopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function trd_hfcc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_hfcc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thirdoptns_menu,'Enable','on');
set(handles.trd_null_menu,'Checked','off');
set(handles.trd_fft_menu,'Checked','off');
set(handles.trd_mfcc_menu,'Checked','off');
set(handles.trd_hfcc_menu,'Checked','on');
set(handles.trd_filtr_menu,'Checked','off');
set(handles.trd_lpc_menu,'Checked','off');
set(handles.trd_formant_menu,'Checked','off');
set(handles.thirdtext,'String','HFCC');
arr{1} = 4;
arr{2} = 0;
arr{3} = 20;
arr{4} = 512;
arr{5} = 256;
arr{6} = 1024;
arr{7} = 30;
handles.thirdopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function trd_filtr_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_filtr_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thirdoptns_menu,'Enable','on');
set(handles.trd_null_menu,'Checked','off');
set(handles.trd_fft_menu,'Checked','off');
set(handles.trd_mfcc_menu,'Checked','off');
set(handles.trd_hfcc_menu,'Checked','off');
set(handles.trd_filtr_menu,'Checked','on');
set(handles.trd_lpc_menu,'Checked','off');
set(handles.trd_formant_menu,'Checked','off');
set(handles.thirdtext,'String','FILTR');
arr{1} = 5;
arr{2} = 0;
arr{3} = 1;
arr{4} = 4;
arr{5} = 0.1;
arr{6} = 0.8;
handles.thirdopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function trd_lpc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_lpc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thirdoptns_menu,'Enable','on');
set(handles.trd_null_menu,'Checked','off');
set(handles.trd_fft_menu,'Checked','off');
set(handles.trd_mfcc_menu,'Checked','off');
set(handles.trd_hfcc_menu,'Checked','off');
set(handles.trd_filtr_menu,'Checked','off');
set(handles.trd_lpc_menu,'Checked','on');
set(handles.trd_formant_menu,'Checked','off');
set(handles.thirdtext,'String','LPC');
arr{1} = 6;
arr{2} = 0;
arr{3} = 10;
handles.thirdopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function trd_formant_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_formant_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thirdoptns_menu,'Enable','on');
set(handles.trd_null_menu,'Checked','off');
set(handles.trd_fft_menu,'Checked','off');
set(handles.trd_mfcc_menu,'Checked','off');
set(handles.trd_hfcc_menu,'Checked','off');
set(handles.trd_filtr_menu,'Checked','off');
set(handles.trd_lpc_menu,'Checked','off');
set(handles.trd_formant_menu,'Checked','on');
set(handles.thirdtext,'String','FORMANT');
arr{1} = 7;
arr{2} = 0;
arr{3} = 3;
arr{4} = 1;
handles.thirdopts = arr;
guidata(hObject, handles);

% --------------------------------------------------------------------
function overloop_opt1_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overloop_opt1_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.overloop_opt1_menu,'Checked','on');
set(handles.overloop_opt2_menu,'Checked','off');
set(handles.overloop_opt3_menu,'Checked','off');
set(handles.overloop_opt4_menu,'Checked','off');
set(handles.overloop_opt5_menu,'Checked','off');
set(handles.overloop_opt6_menu,'Checked','off');
handles.overlap = 0;
guidata(hObject, handles);

% --------------------------------------------------------------------
function overloop_opt2_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overloop_opt2_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.overloop_opt1_menu,'Checked','off');
set(handles.overloop_opt2_menu,'Checked','on');
set(handles.overloop_opt3_menu,'Checked','off');
set(handles.overloop_opt4_menu,'Checked','off');
set(handles.overloop_opt5_menu,'Checked','off');
set(handles.overloop_opt6_menu,'Checked','off');
handles.overlap = 0.1;
guidata(hObject, handles);

% --------------------------------------------------------------------
function overloop_opt3_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overloop_opt3_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.overloop_opt1_menu,'Checked','off');
set(handles.overloop_opt2_menu,'Checked','off');
set(handles.overloop_opt3_menu,'Checked','on');
set(handles.overloop_opt4_menu,'Checked','off');
set(handles.overloop_opt5_menu,'Checked','off');
set(handles.overloop_opt6_menu,'Checked','off');
handles.overlap = 0.2;
guidata(hObject, handles);

% --------------------------------------------------------------------
function overloop_opt4_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overloop_opt4_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.overloop_opt1_menu,'Checked','off');
set(handles.overloop_opt2_menu,'Checked','off');
set(handles.overloop_opt3_menu,'Checked','off');
set(handles.overloop_opt4_menu,'Checked','on');
set(handles.overloop_opt5_menu,'Checked','off');
set(handles.overloop_opt6_menu,'Checked','off');
handles.overlap = 0.3;
guidata(hObject, handles);

% --------------------------------------------------------------------
function overloop_opt5_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overloop_opt5_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.overloop_opt1_menu,'Checked','off');
set(handles.overloop_opt2_menu,'Checked','off');
set(handles.overloop_opt3_menu,'Checked','off');
set(handles.overloop_opt4_menu,'Checked','off');
set(handles.overloop_opt5_menu,'Checked','on');
set(handles.overloop_opt6_menu,'Checked','off');
handles.overlap = 0.4;
guidata(hObject, handles);

% --------------------------------------------------------------------
function overloop_opt6_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overloop_opt6_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.overloop_opt1_menu,'Checked','off');
set(handles.overloop_opt2_menu,'Checked','off');
set(handles.overloop_opt3_menu,'Checked','off');
set(handles.overloop_opt4_menu,'Checked','off');
set(handles.overloop_opt5_menu,'Checked','off');
set(handles.overloop_opt6_menu,'Checked','on');
handles.overlap = 0.5;
guidata(hObject, handles);

% --------------------------------------------------------------------
function window_opt1_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_opt1_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode = handles.mode;

set(handles.window_opt1_menu,'Checked','on');
set(handles.window_opt2_menu,'Checked','off');
set(handles.window_opt3_menu,'Checked','off');
set(handles.window_opt4_menu,'Checked','off');
set(handles.window_opt5_menu,'Checked','off');
set(handles.window_opt6_menu,'Checked','off');
set(handles.window_opt7_menu,'Checked','off');
window = 1;
handles.time = window;

if mode == 1
    file = handles.filelist;
    Fs = file{1,3};
    Ls = file{1,4};

    steps = floor(Ls/(Fs * window));
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function window_opt2_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_opt2_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode = handles.mode;

set(handles.window_opt1_menu,'Checked','off');
set(handles.window_opt2_menu,'Checked','on');
set(handles.window_opt3_menu,'Checked','off');
set(handles.window_opt4_menu,'Checked','off');
set(handles.window_opt5_menu,'Checked','off');
set(handles.window_opt6_menu,'Checked','off');
set(handles.window_opt7_menu,'Checked','off');
window = 0.5;
handles.time = window;

if mode == 1
    file = handles.filelist;
    Fs = file{1,3};
    Ls = file{1,4};

    steps = floor(Ls/(Fs * window));
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function window_opt3_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_opt3_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode = handles.mode;

set(handles.window_opt1_menu,'Checked','off');
set(handles.window_opt2_menu,'Checked','off');
set(handles.window_opt3_menu,'Checked','on');
set(handles.window_opt4_menu,'Checked','off');
set(handles.window_opt5_menu,'Checked','off');
set(handles.window_opt6_menu,'Checked','off');
set(handles.window_opt7_menu,'Checked','off');
window = 0.25;
handles.time = window;

if mode == 1
    file = handles.filelist;
    Fs = file{1,3};
    Ls = file{1,4};

    steps = floor(Ls/(Fs * window));
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function window_opt4_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_opt4_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode = handles.mode;

set(handles.window_opt1_menu,'Checked','off');
set(handles.window_opt2_menu,'Checked','off');
set(handles.window_opt3_menu,'Checked','off');
set(handles.window_opt4_menu,'Checked','on');
set(handles.window_opt5_menu,'Checked','off');
set(handles.window_opt6_menu,'Checked','off');
set(handles.window_opt7_menu,'Checked','off');
window = 0.1;
handles.time = window;

if mode == 1
    file = handles.filelist;
    Fs = file{1,3};
    Ls = file{1,4};

    steps = floor(Ls/(Fs * window));
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function window_opt5_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_opt5_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode = handles.mode;

set(handles.window_opt1_menu,'Checked','off');
set(handles.window_opt2_menu,'Checked','off');
set(handles.window_opt3_menu,'Checked','off');
set(handles.window_opt4_menu,'Checked','off');
set(handles.window_opt5_menu,'Checked','on');
set(handles.window_opt6_menu,'Checked','off');
set(handles.window_opt7_menu,'Checked','off');
window = 0.05;

handles.time = window;

if mode == 1
    file = handles.filelist;
    Fs = file{1,3};
    Ls = file{1,4};

    steps = floor(Ls/(Fs * window));
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function window_opt6_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_opt6_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode = handles.mode;

set(handles.window_opt1_menu,'Checked','off');
set(handles.window_opt2_menu,'Checked','off');
set(handles.window_opt3_menu,'Checked','off');
set(handles.window_opt4_menu,'Checked','off');
set(handles.window_opt5_menu,'Checked','off');
set(handles.window_opt6_menu,'Checked','on');
set(handles.window_opt7_menu,'Checked','off');
window = 0.025;

handles.time = window;

if mode == 1
    file = handles.filelist;
    Fs = file{1,3};
    Ls = file{1,4};

    steps = floor(Ls/(Fs * window));
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function window_opt7_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_opt7_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode = handles.mode;

set(handles.window_opt1_menu,'Checked','off');
set(handles.window_opt2_menu,'Checked','off');
set(handles.window_opt3_menu,'Checked','off');
set(handles.window_opt4_menu,'Checked','off');
set(handles.window_opt5_menu,'Checked','off');
set(handles.window_opt6_menu,'Checked','off');
set(handles.window_opt7_menu,'Checked','on');
window = 0.01;

if mode == 1
    
    file = handles.filelist;
    Fs = file{1,3};
    Ls = file{1,4};    
    handles.time = window;
    steps = floor(Ls/(Fs * window));
    set(handles.countertext,'String',['\ ' num2str(steps)]);
    set(handles.progress_slider,'Max',steps);
    set(handles.progress_slider, 'SliderStep', [1/steps ,  1/steps]);

end

guidata(hObject, handles);

% --------------------------------------------------------------------
function format_opt1_menu_Callback(hObject, eventdata, handles)
% hObject    handle to format_opt1_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.format_opt1_menu,'Checked','on');
set(handles.format_opt2_menu,'Checked','off');
handles.format = 0;
guidata(hObject, handles);

% --------------------------------------------------------------------
function format_opt2_menu_Callback(hObject, eventdata, handles)
% hObject    handle to format_opt2_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.format_opt1_menu,'Checked','off');
set(handles.format_opt2_menu,'Checked','on');
handles.format = 1;
guidata(hObject, handles);

% --------------------------------------------------------------------
function left_channel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to left_channel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.left_channel_menu,'Checked','on');
set(handles.right_channel_menu,'Checked','off');
handles.channel = 1;
guidata(hObject, handles);

% --------------------------------------------------------------------
function right_channel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to right_channel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.right_channel_menu,'Checked','on');
set(handles.left_channel_menu,'Checked','off');
handles.channel = 2;
guidata(hObject, handles);

%//////////////////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////////////////
%//////////////////Unused Menu Bar Callback Functions//////////////////////
%//////////////////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////////////////

% --------------------------------------------------------------------
function channel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to channel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mono_channel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to mono_channel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function signal_menu_Callback(hObject, eventdata, handles)
% hObject    handle to signal_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function opc_menu_Callback(hObject, eventdata, handles)
% hObject    handle to opc_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fst_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fst_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function snd_menu_Callback(hObject, eventdata, handles)
% hObject    handle to snd_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function trd_menu_Callback(hObject, eventdata, handles)
% hObject    handle to trd_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function window_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function folder_menu_Callback(hObject, eventdata, handles)
% hObject    handle to folder_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function overloop_manu_Callback(hObject, eventdata, handles)
% hObject    handle to overloop_manu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function format_menu_Callback(hObject, eventdata, handles)
% hObject    handle to format_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function recminedit_Callback(hObject, eventdata, handles)
% hObject    handle to recminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recminedit as text
%        str2double(get(hObject,'String')) returns contents of recminedit as a double
str = get(hObject,'String');
newmin = str2double(str);
if isfinite(newmin)  
    disp('woa!');
    if newmin <= 0
        newmin = 0;
    end 
    set(handles.recminedit,'String',num2str(newmin));
    handles.recmin = newmin; 
else
    set(handles.recminedit,'String',handles.recmin);
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function recminedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function recsecedit_Callback(hObject, eventdata, handles)
% hObject    handle to recsecedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recsecedit as text
%        str2double(get(hObject,'String')) returns contents of recsecedit as a double
str = get(hObject,'String');
newsec = str2double(str);
if ~isnan(newsec)  
    if newsec > 59
        newsec = 59;
    elseif newsec < 1
        newsec = 1;
    end 
    set(handles.recsecedit,'String',num2str(newsec));
    handles.recsec = newsec; 
else
    set(handles.recsecedit,'String',handles.recsec);
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function recsecedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recsecedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
