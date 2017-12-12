function varargout = LegSymmetryAnalysis(varargin)
% LEGSYMMETRYANALYSIS MATLAB code for LegSymmetryAnalysis.fig
%      LEGSYMMETRYANALYSIS, by itself, creates a new LEGSYMMETRYANALYSIS or raises the existing
%      singleton*.
%
%      H = LEGSYMMETRYANALYSIS returns the handle to a new LEGSYMMETRYANALYSIS or the handle to
%      the existing singleton*.
%
%      LEGSYMMETRYANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEGSYMMETRYANALYSIS.M with the given input arguments.
%
%      LEGSYMMETRYANALYSIS('Property','Value',...) creates a new LEGSYMMETRYANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LegSymmetryAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LegSymmetryAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LegSymmetryAnalysis

% Last Modified by GUIDE v2.5 25-May-2017 11:27:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LegSymmetryAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @LegSymmetryAnalysis_OutputFcn, ...
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





% --- Executes just before LegSymmetryAnalysis is made visible.
function LegSymmetryAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LegSymmetryAnalysis (see VARARGIN)

% Choose default command line output for LegSymmetryAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes LegSymmetryAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.tempDiff = 15;
handles.thresh_comparator = 2;
handles.backgroundDiff = 5;
gui=getappdata(0,'gui')
handles.imag=getappdata(gui,'image');
handles.table=getappdata(gui,'table');
handles.minTemp = min(handles.table(handles.table>0));
[handles.firstLeg, handles.secondLeg] = divideLegs(handles.table, handles.backgroundDiff, handles.minTemp);
[handles.registeredLeg, handles.tform] = imageRegistration(handles.firstLeg, handles.secondLeg);
axes(handles.axes2);
imshow(handles.imag)
comparator_Callback(hObject, eventdata, handles);


% --- Outputs from this function are returned to the command line.
function varargout = LegSymmetryAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.thresh_comparator=get(hObject,'value')*handles.tempDiff;
set(handles.thresh_value,'String', strcat('Temperature difference >= ',num2str(handles.thresh_comparator)));
comparator_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in comparator.
function comparator_Callback(hObject, eventdata, handles)
% hObject    handle to comparator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles   structure with handles and user data (see GUIDATA)
    [differenceImage, leftPix, rightPix, handles.tempDiff] = calcDifference(handles.firstLeg, handles.secondLeg, handles.registeredLeg, handles.imag, handles.thresh_comparator, handles.tform, handles.backgroundDiff, handles.minTemp);
    axes(handles.axes1);
    imshow(differenceImage);
    set(handles.AreaLeft,'String', strcat(num2str(leftPix),' px'));
    set(handles.AreaRight,'String', strcat(num2str(rightPix),' px'));
    % Update handles structure
    guidata(hObject, handles);

