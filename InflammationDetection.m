function varargout = InflammationDetection(varargin)
% INFLAMMATIONDETECTION MATLAB code for InflammationDetection.fig
%      INFLAMMATIONDETECTION, by itself, creates a new INFLAMMATIONDETECTION or raises the existing
%      singleton*.
%
%      H = INFLAMMATIONDETECTION returns the handle to a new INFLAMMATIONDETECTION or the handle to
%      the existing singleton*.
%
%      INFLAMMATIONDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFLAMMATIONDETECTION.M with the given input arguments.
%
%      INFLAMMATIONDETECTION('Property','Value',...) creates a new INFLAMMATIONDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InflammationDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InflammationDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InflammationDetection

% Last Modified by GUIDE v2.5 25-May-2017 11:07:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InflammationDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @InflammationDetection_OutputFcn, ...
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


% --- Executes just before InflammationDetection is made visible.
function InflammationDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InflammationDetection (see VARARGIN)

gui=getappdata(0,'gui')
handles.imag=getappdata(gui,'image');
handles.table=getappdata(gui,'table');

[handles.picture, handles.min, handles.maks]=removeHeader(handles.table); 
[handles.temp_max, handles.sizeof_max, handles.avg_temp_max]=highTemp(handles.picture,handles.imag,1.5);
[handles.avg_temp_high, handles.avg_temp]=avgTemp(handles.temp_max, handles.picture,1.5);

set(handles.thresh_value,'String', strcat('Temperature >= ',strcat(num2str(handles.maks-1.5-273.15)),'°C'));

set(handles.max,'String', strcat(num2str(handles.maks-273.15),'°C'));

set(handles.avg,'String', strcat(num2str(handles.avg_temp-273.15),'°C'));

set(handles.Area,'String', strcat(num2str(handles.sizeof_max),'px'));

set(handles.Avg_max,'String',strcat(num2str(handles.avg_temp_max-273.15),'°C'));
    

axes(handles.axes1);
imshow(handles.imag)

axes(handles.axes2);
imshow(handles.temp_max)


% Choose default command line output for InflammationDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InflammationDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InflammationDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider1 movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider1
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider1
handles.threshold=get(hObject,'value')*(handles.maks-handles.min-5);
set(handles.thresh_value,'String', strcat('Temperature >= ',num2str(handles.maks-handles.threshold-273.15)));
Threshold_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [temp_max, handles.sizeof_max, handles.avg_temp_max]=highTemp(handles.picture,handles.imag,handles.threshold);
     [handles.avg_temp_high, handles.avg_temp]=avgTemp(temp_max, handles.picture,handles.threshold);
     axes(handles.axes2);
     imshow(temp_max)
    set(handles.Area,'String', strcat(num2str(handles.sizeof_max),'px'));
    set(handles.Avg_max,'String', strcat(num2str(handles.avg_temp_max-273.15),'°C'));
    


% --- Executes on button press in Canny.
function Canny_Callback(hObject, eventdata, handles)
% hObject    handle to Canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bw,~]=edge(im2bw(handles.imag),'canny');
axes(handles.axes2)
imshow(bw)


% --- Executes on button press in inflammation.
function inflammation_Callback(hObject, eventdata, handles)
% hObject    handle to inflammation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2)
imshow(handles.temp_max)
