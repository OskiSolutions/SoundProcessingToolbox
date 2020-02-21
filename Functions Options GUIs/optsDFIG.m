function varargout = optsDFIG(varargin)
% OPTSDFIG MATLAB code for optsDFIG.fig
%      OPTSDFIG, by itself, creates a new OPTSDFIG or raises the existing
%      singleton*.
%
%      H = OPTSDFIG returns the handle to a new OPTSDFIG or the handle to
%      the existing singleton*.
%
%      OPTSDFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTSDFIG.M with the given input arguments.
%
%      OPTSDFIG('Property','Value',...) creates a new OPTSDFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optsDFIG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optsDFIG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optsDFIG

% Last Modified by GUIDE v2.5 03-Dec-2016 19:18:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optsDFIG_OpeningFcn, ...
                   'gui_OutputFcn',  @optsDFIG_OutputFcn, ...
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


% --- Executes just before optsDFIG is made visible.
function optsDFIG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optsDFIG (see VARARGIN)

% Choose default command line output for optsDFIG
%handles.output = hObject;
prevopts = varargin{1};

if ~isequal(numel(prevopts{1,1}), 1)
    set(handles.filecheckbox,'Value',prevopts{1}{2});
    set(handles.typepopupmenu,'Value',prevopts{1}{3});
    set(handles.param1edit,'String',prevopts{1}{4});
    set(handles.param2edit,'String',prevopts{1}{5});
    set(handles.param3edit,'String',prevopts{1}{6});
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes optsDFIG wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = optsDFIG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
opts{1} = 5;
opts{2} = get(handles.filecheckbox,'Value');
opts{3} = get(handles.typepopupmenu,'Value');
tmp = get(handles.param1edit,'String');
opts{4} = str2double(tmp);
tmp = get(handles.param2edit,'String');
opts{5} = str2double(tmp);
tmp = get(handles.param3edit,'String');
opts{6} = str2double(tmp);
varargout{1} = opts;
delete(handles.figure1);


function param1edit_Callback(hObject, eventdata, handles)
% hObject    handle to param1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param1edit as text
%        str2double(get(hObject,'String')) returns contents of param1edit as a double


% --- Executes during object creation, after setting all properties.
function param1edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param2edit_Callback(hObject, eventdata, handles)
% hObject    handle to param2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param2edit as text
%        str2double(get(hObject,'String')) returns contents of param2edit as a double


% --- Executes during object creation, after setting all properties.
function param2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filecheckbox.
function filecheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to filecheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filecheckbox


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
% The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on button press in readybutton.
function readybutton_Callback(hObject, eventdata, handles)
% hObject    handle to readybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);



function param3edit_Callback(hObject, eventdata, handles)
% hObject    handle to param3edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param3edit as text
%        str2double(get(hObject,'String')) returns contents of param3edit as a double


% --- Executes during object creation, after setting all properties.
function param3edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param3edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typepopupmenu.
function typepopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to typepopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns typepopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typepopupmenu
tmp = get(hObject,'Value');

switch tmp
    case 1
        set(handles.param3text,'Enable','off');
        set(handles.param3edit,'Enable','off');
        
        set(handles.param2edit,'String','0.1');
    case 2
        set(handles.param3text,'Enable','off');
        set(handles.param3edit,'Enable','off');
        
        set(handles.param2edit,'String','0.9');
    case 3
        set(handles.param3text,'Enable','on');
        set(handles.param3edit,'Enable','on');
        
        set(handles.param2edit,'String','0.2');
        set(handles.param3edit,'String','0.8');
    otherwise
end

% --- Executes during object creation, after setting all properties.
function typepopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typepopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
