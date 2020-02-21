function varargout = Formant(varargin)
% FORMANT MATLAB code for Formant.fig
%      FORMANT, by itself, creates a new FORMANT or raises the existing
%      singleton*.
%
%      H = FORMANT returns the handle to a new FORMANT or the handle to
%      the existing singleton*.
%
%      FORMANT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORMANT.M with the given input arguments.
%
%      FORMANT('Property','Value',...) creates a new FORMANT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Formant_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Formant_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Formant

% Last Modified by GUIDE v2.5 18-Dec-2016 23:36:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Formant_OpeningFcn, ...
                   'gui_OutputFcn',  @Formant_OutputFcn, ...
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


% --- Executes just before Formant is made visible.
function Formant_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Formant (see VARARGIN)

% Choose default command line output for Formant
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Formant wait for user response (see UIRESUME)
% uiwait(handles.guifigure);


% --- Outputs from this function are returned to the command line.
function varargout = Formant_OutputFcn(hObject, eventdata, handles) 
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
lpc = handles.lpc;
fs = handles.fs;
lsnr = handles.lsnr;
smplnr = handles.smplnr;

[S_FormantFreq,t]=formedit(lpc,lsnr,fs,smplnr);

figure;

plot(t,S_FormantFreq(:,1),'r')
hold on
title('trajektorie formantow')
xlabel ('Czas')
ylabel ('czestotliwosc')
hold on
plot(t,S_FormantFreq(:,2),'b')
plot(t,S_FormantFreq(:,3),'g')
% plot(t,S_FormantFreq(:,4),'k*')
%plot(t,S_FormantFreq(:,5),'y*')
grid on

handles.FormantFreq = S_FormantFreq;
handles.TFrag = t;
set(handles.rangestext,'Enable','on');
set(handles.firstfreqedit,'Enable','on');
set(handles.secondfreqedit,'Enable','on');
set(handles.thirdfreqedit,'Enable','on');
set(handles.searchbutton,'Enable','on');
guidata(hObject, handles);

% --- Executes on button press in filebutton.
function filebutton_Callback(hObject, eventdata, handles)
% hObject    handle to filebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath] = uigetfile({'*.txt'}, 'Wybierz plik z wynikami analizy formantów...');

if filename ~= 0
    file = [filepath filename];
    set(handles.filetext,'String',filename);
    set(handles.guifigure,'Name',['Formant: ' file]);
    
    fileID = fopen(file,'r');
    line = fgets(fileID);
    line = fgets(fileID);
    splited = strsplit(line);
    NoF = str2double(splited{3});
    handles.fs = str2double(splited{5});
    handles.samples = str2double(splited{6});
    
%     smplnr = str2double(splited{3});
%     lpcnr = str2double(splited{6});
%     lsnr = str2double(splited{8});
    
%     handles.fs = fs;
%     handles.lsnr = lsnr;
%     handles.smplnr = smplnr;
    
    line = fgets(fileID);
    
    line = fgets(fileID);
    arr = [];
    while ischar(line)
        tmp = [];
        splited = strsplit(line);
        %tmp = [str2double(splited{3}) str2double(splited{4})];
        for c = 1:NoF
            disp(splited);
            tmp = [tmp,str2double(splited{c+2})];
        end
        arr = [arr;tmp];
        line = fgets(fileID);
    end

    fclose(fileID);
    
    set(handles.rangestext,'Enable','on');
    set(handles.firstfreqedit,'Enable','on');
    set(handles.secondfreqedit,'Enable','on');
    set(handles.thirdfreqedit,'Enable','on');
    set(handles.searchbutton,'Enable','on');
    handles.formants = arr;
    disp(arr);
    guidata(hObject, handles);
end


% --- Executes on button press in searchbutton.
function searchbutton_Callback(hObject, eventdata, handles)
% hObject    handle to searchbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FormantFreq = handles.formants;
fs = handles.fs;
samples = handles.samples;
TFrag = linspace(0,samples/fs,length(FormantFreq(:,1)));
fr1 = get(handles.firstfreqedit,'String');
fr2 = get(handles.secondfreqedit,'String');
fr3 = get(handles.thirdfreqedit,'String');
[~,y] = codes(FormantFreq,TFrag,str2double(fr1),str2double(fr2),str2double(fr3));
disp(y);

function secondfreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to secondfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondfreqedit as text
%        str2double(get(hObject,'String')) returns contents of secondfreqedit as a double


% --- Executes during object creation, after setting all properties.
function secondfreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thirdfreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to thirdfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thirdfreqedit as text
%        str2double(get(hObject,'String')) returns contents of thirdfreqedit as a double


% --- Executes during object creation, after setting all properties.
function thirdfreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thirdfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function firstfreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to firstfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstfreqedit as text
%        str2double(get(hObject,'String')) returns contents of firstfreqedit as a double


% --- Executes during object creation, after setting all properties.
function firstfreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
