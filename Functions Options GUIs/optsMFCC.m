function varargout = guidetemplate0(varargin)
% GUIDETEMPLATE0 MATLAB code for guidetemplate0.fig
%      GUIDETEMPLATE0, by itself, creates a new GUIDETEMPLATE0 or raises the existing
%      singleton*.
%
%      H = GUIDETEMPLATE0 returns the handle to a new GUIDETEMPLATE0 or the handle to
%      the existing singleton*.
%
%      GUIDETEMPLATE0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDETEMPLATE0.M with the given input arguments.
%
%      GUIDETEMPLATE0('Property','Value',...) creates a new GUIDETEMPLATE0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guidetemplate0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guidetemplate0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2006 The MathWorks, Inc.

% Edit the above text to modify the response to help guidetemplate0

% Last Modified by GUIDE v2.5 29-Nov-2016 21:54:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guidetemplate0_OpeningFcn, ...
                   'gui_OutputFcn',  @guidetemplate0_OutputFcn, ...
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


% --- Executes just before guidetemplate0 is made visible.
function guidetemplate0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guidetemplate0 (see VARARGIN)

% Choose default command line output for guidetemplate0
%handles.output = hObject;
prevopts = varargin{1};

if ~isequal(numel(prevopts{1,1}), 1)
    set(handles.filecheckbox,'Value',prevopts{1}{2});
    set(handles.param1edit,'String',prevopts{1}{3});
    set(handles.param2edit,'String',prevopts{1}{4});
    set(handles.param3edit,'String',prevopts{1}{5});
    set(handles.param4edit,'String',prevopts{1}{6});
    set(handles.param5edit,'String',prevopts{1}{7});
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guidetemplate0 wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guidetemplate0_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
opts{1} = 3;
opts{2} = get(handles.filecheckbox,'Value');
tmp = get(handles.param1edit,'String');
opts{3} = str2double(tmp);
tmp = get(handles.param2edit,'String');
opts{4} = str2double(tmp);
tmp = get(handles.param3edit,'String');
opts{5} = str2double(tmp);
tmp = get(handles.param4edit,'String');
opts{6} = str2double(tmp);
tmp = get(handles.param5edit,'String');
opts{7} = str2double(tmp);
varargout{1} = opts;
delete(handles.figure1);

% --- Executes on button press in readybutton.
function readybutton_Callback(hObject, eventdata, handles)
% hObject    handle to readybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = get(handles.param1edit,'String');
Noc = str2double(tmp);
tmp = get(handles.param2edit,'String');
Ws = str2double(tmp);
tmp = get(handles.param3edit,'String');
Ovr = str2double(tmp);
tmp = get(handles.param5edit,'String');
Nof = str2double(tmp);

if (Noc >= Nof)
    errordlg('Liczba wspó³czynników musi byæ mniejsza ni¿ liczba filtrów!');
elseif (Ovr >= Ws)
    errordlg('Rozmiar nak³adania musi byæ mniejszy ni¿ rozmiar okna!');
else
    close(handles.figure1);
end


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



function param4edit_Callback(hObject, eventdata, handles)
% hObject    handle to param4edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param4edit as text
%        str2double(get(hObject,'String')) returns contents of param4edit as a double


% --- Executes during object creation, after setting all properties.
function param4edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param4edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param5edit_Callback(hObject, eventdata, handles)
% hObject    handle to param5edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param5edit as text
%        str2double(get(hObject,'String')) returns contents of param5edit as a double


% --- Executes during object creation, after setting all properties.
function param5edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param5edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param6edit_Callback(hObject, eventdata, handles)
% hObject    handle to param6edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param6edit as text
%        str2double(get(hObject,'String')) returns contents of param6edit as a double


% --- Executes during object creation, after setting all properties.
function param6edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param6edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on button press in filecheckbox.
function filecheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to filecheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filecheckbox
