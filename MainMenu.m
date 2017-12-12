function varargout = MainMenu(varargin)
% MAINMENU MATLAB code for MainMenu.fig
%      MAINMENU, by itself, creates a new MAINMENU or raises the existing
%      singleton*.
%
%      H = MAINMENU returns the handle to a new MAINMENU or the handle to
%      the existing singleton*.
%
%      MAINMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINMENU.M with the given input arguments.
%
%      MAINMENU('Property','Value',...) creates a new MAINMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainMenu

% Last Modified by GUIDE v2.5 03-Jun-2017 00:08:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @MainMenu_OutputFcn, ...
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


% --- Executes just before MainMenu is made visible.
function MainMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainMenu (see VARARGIN)

% Choose default command line output for MainMenu
handles.output = hObject;

handles.imag='';
handles.thresh_comparator = 2;

axes(handles.axes1);
imshow(zeros(320,500))

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainMenu wait for user response (see UIRESUME)
% uiwait(handles.MainMenu);


% --- Outputs from this function are returned to the command line.
function varargout = MainMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
[filename, pathname] = uigetfile({'*.png';'*.bmp'},'File Selector');
 handles.myImage = strcat(pathname, filename);
    handles.table=dlmread(strcat(strrep(handles.myImage,'.png',''),'.txt'),' ');
    handles.imag=imread(handles.myImage);
    axes(handles.axes1);
    imshow(handles.imag);
 guidata(hObject,handles);
    
% gui=getappdata(0,'gui')
% image=getappdata(gui,'image');
% axes(handles.axes1);
% imshow(image);


% --- Executes on button press in symmetry.
function symmetry_Callback(hObject, eventdata, handles)
% hObject    handle to symmetry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0,'gui',gcf);
setappdata(gcf,'image',handles.imag);
setappdata(gcf,'table',handles.table);
guidata(hObject,handles);
 
LegSymmetryAnalysis;


% --- Executes on button press in Inflammation.
function Inflammation_Callback(hObject, eventdata, handles)
% hObject    handle to Inflammation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 setappdata(0,'gui',gcf);
 setappdata(gcf,'image',handles.imag);
 setappdata(gcf,'table',handles.table);
 guidata(hObject,handles);
 
 InflammationDetection;


% --- Executes on button press in Knee.
function Knee_Callback(hObject, eventdata, handles)
% hObject    handle to Knee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


 
 setappdata(0,'gui',gcf);
 setappdata(gcf,'image',handles.imag);
 setappdata(gcf,'table',handles.table);
 guidata(hObject,handles);
 
 KneeTemperatureAnalysis;


% --------------------------------------------------------------------
function report_generator_Callback(hObject, eventdata, handles)
% hObject    handle to report_generator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.imag)
     errordlg('You should select an image before creating report!','Image error');
else
    [picture, ~, maks]=removeHeader(handles.table); 
    [temp_max, sizeof_max, avg_temp_max]=highTemp(picture,handles.imag,1.5);
    [avg_temp_high, avg_temp]=avgTemp(temp_max, picture,1.5);
    [left,left_temp,right,right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

    imwrite(temp_max,'roiImageDummy.png');
    imwrite(left,'leftKneeSeg.png');
    imwrite(right,'rightKneeSeg.png');
    
    f=figure;
    set(f, 'Visible', 'off');
    histogram(hist_R,'Normalization','probability','BinMethod','fd')
    saveas(f, 'rightKneeHist.png');
    
    h=figure;
    set(h, 'Visible', 'off');
    histogram(hist_L,'Normalization','probability','BinMethod','fd')
    saveas(h, 'leftKneeHist.png');
    
    [N_R,~,~]=histcounts(hist_R,'BinMethod','fd');

    N_R=N_R/sum(N_R);

    [N_L,edges_L,~]=histcounts(hist_L,'BinMethod','fd');

    N_L=N_L/sum(N_L);

    H_L=0;
    H_R=0;

    for i=1:numel(N_L)
        if N_L(i)~=0
            H_L=H_L-N_L(i)*log2(N_L(i));
        end
    end

    for i=1:numel(N_R)
        if N_R(i)~=0
            H_R=H_R-N_R(i)*log2(N_R(i));
        end
    end
    H_L=num2str(H_L);
    H_R=num2str(H_R);

    [differenceImage] = imageRegistrator(handles.imag, handles.table,handles.thresh_comparator);
    imwrite(differenceImage,'legComparison.png');
    surname='Surname';
    name='Name';
    age='Age';
    report_generator('surname_name', surname, name, age, handles.myImage, maks, sizeof_max, avg_temp_max, avg_temp, avg_L, avg_R, H_L, H_R,handles.thresh_comparator);
end
