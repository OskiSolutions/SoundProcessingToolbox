function varargout = optsFFT(varargin)
% optsFFT MATLAB code for optsFFT.fig
%      optsFFT, by itself, creates a new optsFFT or raises the existing
%      singleton*.
%
%      H = optsFFT returns the handle to a new optsFFT or the handle to
%      the existing singleton*.
%
%      optsFFT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in optsFFT.M with the given input arguments.
%
%      optsFFT('Property','Value',...) creates a new optsFFT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optsFFT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optsFFT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optsFFT

% Last Modified by GUIDE v2.5 28-Nov-2016 12:56:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optsFFT_OpeningFcn, ...
                   'gui_OutputFcn',  @optsFFT_OutputFcn, ...
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


% --- Executes just before optsFFT is made visible.
function optsFFT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optsFFT (see VARARGIN)

% Choose default command line output for optsFFT
%handles.output = hObject;
prevopts = varargin{1};

if ~isequal(numel(prevopts{1,1}), 1)
    set(handles.filecheckbox,'Value',prevopts{1}{2});
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes optsFFT wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = optsFFT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
opts{1} = 2;
opts{2} = get(handles.filecheckbox,'Value');
varargout{1} = opts;
delete(handles.figure1);

% --- Executes on button press in readybutton.
function readybutton_Callback(hObject, eventdata, handles)
% hObject    handle to readybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on selection change in answerpopupmenu.
function answerpopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to answerpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns answerpopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from answerpopupmenu


% --- Executes during object creation, after setting all properties.
function answerpopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to answerpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
