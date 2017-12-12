function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 18-May-2017 14:15:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

axes(handles.axes1);
imshow(zeros(240,320));

axes(handles.axes2);
imshow(zeros(240,320));

axes(handles.axes5);
imshow(zeros(240,320));

axes(handles.axes4);
imshow(zeros(240,320));

handles.tempDiff = 15;
handles.thresh_comparator = 2;

handles.myImage='';
handles.OA_R='';
handles.OA_L='';


warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hObject,'javaframe');
jIcon=javax.swing.ImageIcon('C:\Users\Luka\Desktop\Završni\Program\fer_logo.jpg');
jframe.setFigureIcon(jIcon)

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.GUI);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonBrowse.
function pushbuttonBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.png';'*.bmp'},'File Selector');
 handles.myImage = strcat(pathname, filename);
    handles.table=dlmread(strcat(strrep(handles.myImage,'.png',''),'.txt'),' ');
    handles.imag=imread(handles.myImage);
 
    [handles.picture, handles.min, handles.maks]=removeHeader(handles.table); 
    [handles.temp_max, handles.sizeof_max, handles.avg_temp_max]=highTemp(handles.picture,handles.imag,1.5);
    [handles.avg_temp_high, handles.avg_temp]=avgTemp(handles.temp_max, handles.picture,1.5);
 
 axes(handles.axes1);
 imshow(handles.myImage);

% --- Executes on button press in pushbuttonStats.
function pushbuttonStats_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.myImage)
     errordlg('You should select a picture first!','Image error');
else
    handles.thresh_flag=1;
    handles.table=dlmread(strcat(strrep(handles.myImage,'.png',''),'.txt'),' ');
    handles.imag=imread(handles.myImage);


    set(handles.max,'String', strcat('Max temperature (°C): ',num2str(handles.maks-273.15)));

    set(handles.avg,'String', strcat('Average temperature (°C): ',num2str(handles.avg_temp-273.15)));

    set(handles.Area,'String', strcat('Area of higher temperature (px): ',num2str(handles.sizeof_max)));

    set(handles.Avg_max,'String', strcat('Average temperature of higher temperature area (°C): ',num2str(handles.avg_temp_max-273.15)));
    
    axes(handles.axes1)
    imshow(handles.temp_max)
    
end

guidata(hObject,handles);


% --- Executes on slider1 movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider1
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider1
handles.thresh_flag
if(handles.thresh_flag)
    handles.threshold=get(hObject,'value')*(handles.maks-handles.min-5);
    set(handles.thresh_value,'String', strcat('T >= ',num2str(handles.maks-handles.threshold-273.15)));
    Threshold_Callback(hObject, eventdata, handles);
else
   handles.firstEntry=1;
   handles.thresh_comparator=get(hObject,'value')*handles.tempDiff;
   set(handles.thresh_value,'String', strcat('dT = ',num2str(handles.thresh_comparator)));
   comparator_Callback(hObject, eventdata, handles);
end
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider1 controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Threshold.
function Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [temp_max, handles.sizeof_max, handles.avg_temp_max]=highTemp(handles.picture,handles.imag,handles.threshold);
     [handles.avg_temp_high, handles.avg_temp]=avgTemp(temp_max, handles.picture,handles.threshold);
     axes(handles.axes1);
     imshow(temp_max)

     
% --- Executes on button press in ShowOriginal.
function ShowOriginal_Callback(hObject, eventdata, handles)
% hObject    handle to ShowOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    axes(handles.axes1);
    imshow(handles.imag)
    

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Canny.
function Canny_Callback(hObject, eventdata, handles)
% hObject    handle to Canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[bw,~]=edge(im2bw(handles.imag),'canny');
axes(handles.axes2)
imshow(bw)


% --- Executes on button press in KneeSeg.
function KneeSeg_Callback(hObject, eventdata, handles)
% hObject    handle to KneeSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

axes(handles.axes4)
imshow(handles.left)

axes(handles.axes5)
imshow(handles.right)

set(handles.Left_leg,'String', strcat('Average temperature (°C): ',num2str(avg_L-273.15)));
set(handles.Right_leg,'String', strcat('Average temperature (°C): ',num2str(avg_R-273.15)));

axes(handles.axes2)
histogram(hist_R,'Normalization','probability','BinMethod','fd')
[N_R,~,~]=histcounts(hist_R,'BinMethod','fd');

N_R=N_R/sum(N_R);

axes(handles.axes1)
histogram(hist_L,'Normalization','probability','BinMethod','fd');
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
set(handles.Entropija_L,'String', strcat('H(L) = ',num2str(H_L)));
set(handles.Entropija_R,'String', strcat('H(R)= ',num2str(H_R)));

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Left.
function Left_Callback(hObject, eventdata, handles)
% hObject    handle to Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~handles.lijevo_desno)
    
    handles.y_L=handles.y_L-1;
    velicina=size(handles.right);

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_L-i)^2+(handles.y_L-j)^2)<=20)
                handles.right_patela(i,j,1)=0;
                handles.right_patela(i,j,2)=0;
                handles.right_patela(i,j,3)=0;
            else
                handles.right_patela(i,j,1)=handles.right(i,j,1);
                handles.right_patela(i,j,2)=handles.right(i,j,2);
                handles.right_patela(i,j,3)=handles.right(i,j,3);
            end
        end
    end
    axes(handles.axes5);
    imshow(handles.right_patela);
else
    
    velicina=size(handles.left);

    handles.y_R=handles.y_R-1;

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_R-i)^2+(handles.y_R-j)^2)<=20)
                handles.left_patela(i,j,1)=0;
                handles.left_patela(i,j,2)=0;
                handles.left_patela(i,j,3)=0;
            else
                handles.left_patela(i,j,1)=handles.left(i,j,1);
                handles.left_patela(i,j,2)=handles.left(i,j,2);
                handles.left_patela(i,j,3)=handles.left(i,j,3);
            end
        end
    end
    axes(handles.axes4);
    imshow(handles.left_patela);
end


% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Right.
function Right_Callback(hObject, eventdata, handles)
% hObject    handle to Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~handles.lijevo_desno)
    
    handles.y_L=handles.y_L+1;
    velicina=size(handles.right);

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_L-i)^2+(handles.y_L-j)^2)<=20)
                handles.right_patela(i,j,1)=0;
                handles.right_patela(i,j,2)=0;
                handles.right_patela(i,j,3)=0;
            else
                handles.right_patela(i,j,1)=handles.right(i,j,1);
                handles.right_patela(i,j,2)=handles.right(i,j,2);
                handles.right_patela(i,j,3)=handles.right(i,j,3);
            end
        end
    end
    axes(handles.axes5);
    imshow(handles.right_patela);
else
    
    velicina=size(handles.left);

    handles.y_R=handles.y_R+1;

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_R-i)^2+(handles.y_R-j)^2)<=20)
                handles.left_patela(i,j,1)=0;
                handles.left_patela(i,j,2)=0;
                handles.left_patela(i,j,3)=0;
            else
                handles.left_patela(i,j,1)=handles.left(i,j,1);
                handles.left_patela(i,j,2)=handles.left(i,j,2);
                handles.left_patela(i,j,3)=handles.left(i,j,3);
            end
        end
    end
    axes(handles.axes4);
    imshow(handles.left_patela);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Up.
function Up_Callback(hObject, eventdata, handles)
% hObject    handle to Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~handles.lijevo_desno)
    
    handles.x_L=handles.x_L-1;
    velicina=size(handles.right);

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_L-i)^2+(handles.y_L-j)^2)<=20)
                handles.right_patela(i,j,1)=0;
                handles.right_patela(i,j,2)=0;
                handles.right_patela(i,j,3)=0;
            else
                handles.right_patela(i,j,1)=handles.right(i,j,1);
                handles.right_patela(i,j,2)=handles.right(i,j,2);
                handles.right_patela(i,j,3)=handles.right(i,j,3);
            end
        end
    end
    axes(handles.axes5);
    imshow(handles.right_patela);
else
    
    velicina=size(handles.left);

    handles.x_R=handles.x_R-1;

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_R-i)^2+(handles.y_R-j)^2)<=20)
                handles.left_patela(i,j,1)=0;
                handles.left_patela(i,j,2)=0;
                handles.left_patela(i,j,3)=0;
            else
                handles.left_patela(i,j,1)=handles.left(i,j,1);
                handles.left_patela(i,j,2)=handles.left(i,j,2);
                handles.left_patela(i,j,3)=handles.left(i,j,3);
            end
        end
    end
    axes(handles.axes4);
    imshow(handles.left_patela);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Down.
function Down_Callback(hObject, eventdata, handles)
% hObject    handle to Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~handles.lijevo_desno)
    
    handles.x_L=handles.x_L+1;
    velicina=size(handles.right);

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_L-i)^2+(handles.y_L-j)^2)<=20)
                handles.right_patela(i,j,1)=0;
                handles.right_patela(i,j,2)=0;
                handles.right_patela(i,j,3)=0;
            else
                handles.right_patela(i,j,1)=handles.right(i,j,1);
                handles.right_patela(i,j,2)=handles.right(i,j,2);
                handles.right_patela(i,j,3)=handles.right(i,j,3);
            end
        end
    end
    axes(handles.axes5);
    imshow(handles.right_patela);
else
    
    velicina=size(handles.left);

    handles.x_R=handles.x_R+1;

    for i=1:velicina(1)
        for j=1:velicina(2)
            if(sqrt((handles.x_R-i)^2+(handles.y_R-j)^2)<=20)
                handles.left_patela(i,j,1)=0;
                handles.left_patela(i,j,2)=0;
                handles.left_patela(i,j,3)=0;
            else
                handles.left_patela(i,j,1)=handles.left(i,j,1);
                handles.left_patela(i,j,2)=handles.left(i,j,2);
                handles.left_patela(i,j,3)=handles.left(i,j,3);
            end
        end
    end
    axes(handles.axes4);
    imshow(handles.left_patela);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DefineLeft.
function DefineLeft_Callback(hObject, eventdata, handles)
% hObject    handle to DefineLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lijevo_desno=0;

velicina=size(handles.right);
handles.x_L=velicina(1)/2;
handles.y_L=velicina(2)/2;

handles.right_patela=uint8(zeros(velicina(1),velicina(2),velicina(3)));

for i=1:velicina(1)
    for j=1:velicina(2)   
        if(sqrt((handles.x_L-i)^2+(handles.y_L-j)^2)<=20)
            handles.right_patela(i,j,1)=0;
            handles.right_patela(i,j,2)=0;
            handles.right_patela(i,j,3)=0;
        else   
            handles.right_patela(i,j,1)=handles.right(i,j,1);
            handles.right_patela(i,j,2)=handles.right(i,j,2);
            handles.right_patela(i,j,3)=handles.right(i,j,3);
        end
    end
end

size(handles.right)
size(handles.right_patela)

axes(handles.axes5);
imshow(handles.right_patela);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Define_right.
function Define_right_Callback(hObject, eventdata, handles)
% hObject    handle to Define_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lijevo_desno=1;

velicina=size(handles.left);
handles.x_R=velicina(1)/2;
handles.y_R=velicina(2)/2;
handles.left_patela=uint8(zeros(velicina(1),velicina(2),velicina(3)));

for i=1:velicina(1)
    for j=1:velicina(2)
        if(sqrt((handles.x_R-i)^2+(handles.y_R-j)^2)<=20)
            handles.left_patela(i,j,1)=0;
            handles.left_patela(i,j,2)=0;
            handles.left_patela(i,j,3)=0;
        else
            handles.left_patela(i,j,1)=handles.left(i,j,1);
            handles.left_patela(i,j,2)=handles.left(i,j,2);
            handles.left_patela(i,j,3)=handles.left(i,j,3);
        end
    end
end
axes(handles.axes4);
imshow(handles.left_patela);


% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in OA_L.
function OA_L_Callback(hObject, eventdata, handles)
% hObject    handle to OA_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
velicina=size(handles.right_patela);
temp_krug=0;
temp_van=0;
k=0;
l=0;
for i=1:velicina(1)
    for j=1:velicina(2)
        if(handles.right_patela(i,j,1)==0 && handles.right_patela(i,j,2)==0 && handles.right_patela(i,j,3)==0)
            temp_krug=temp_krug+handles.right_temp(i,j);
            k=k+1;
        elseif(handles.right_patela(i,j,1)~=255 || handles.right_patela(i,j,2)~=255 || handles.right_patela(i,j,3)~=255)
            temp_van=temp_van+handles.right_temp(i,j);
            l=l+1;
        end
    end
end

prosjek_krug=temp_krug/k;
prosjek_van=temp_van/l;

if(prosjek_krug>=prosjek_van)
    set(handles.Normal_L,'String', 'Abnormal');
    handles.OA_L='Abnormal';
else
    set(handles.Normal_L,'String','Normal');
    handles.OA_L='Normal';
end

    guidata(hObject, handles);    

% --- Executes on button press in OA_R.
function OA_R_Callback(hObject, eventdata, handles)
% hObject    handle to OA_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
velicina=size(handles.left_patela);
temp_krug=0;
temp_van=0;
k=0;
l=0;
for i=1:velicina(1)
    for j=1:velicina(2)
        if(handles.left_patela(i,j,1)==0 && handles.left_patela(i,j,2)==0 && handles.left_patela(i,j,3)==0)
            temp_krug=temp_krug+handles.left_temp(i,j);
            k=k+1;
        elseif(handles.left_patela(i,j,1)~=255 || handles.left_patela(i,j,2)~=255 || handles.left_patela(i,j,3)~=255)
            temp_van=temp_van+handles.left_temp(i,j);
            l=l+1;
        end
    end
end

prosjek_krug=temp_krug/k;
prosjek_van=temp_van/l;

if(prosjek_krug>=prosjek_van)
    set(handles.Normal_R,'String', 'Abnormal');
    handles.OA_R='Abnormal';
    handles.OA_R
else
    set(handles.Normal_R,'String','Normal');
    handles.OA_R='Normal';
end

    guidata(hObject, handles);

% --------------------------------------------------------------------
function PDF_Callback(hObject, eventdata, handles)
% hObject    handle to PDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

surname=get(handles.surname, 'string');
name=get(handles.name, 'string');
age=get(handles.age,'string');
if isempty(handles.myImage)
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
    
    report_generator(strcat(surname,'_',name), surname, name, age, handles.myImage, maks, sizeof_max, avg_temp_max, avg_temp, avg_L, avg_R, H_L, H_R, handles.OA_L, handles.OA_R,handles.thresh_comparator);
end

% --- Executes on button press in comparator.
function comparator_Callback(hObject, eventdata, handles)
% hObject    handle to comparator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles   structure with handles and user data (see GUIDATA)
    handles.thresh_flag=0;
    [differenceImage] = imageRegistrator(handles.imag, handles.table,handles.thresh_comparator);
    axes(handles.axes2);
    imshow(differenceImage);
    % Update handles structure
    guidata(hObject, handles);



function surname_Callback(hObject, eventdata, handles)
% hObject    handle to surname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of surname as text
%        str2double(get(hObject,'String')) returns contents of surname as a double


% --- Executes during object creation, after setting all properties.
function surname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to surname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function age_Callback(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of age as text
%        str2double(get(hObject,'String')) returns contents of age as a double


% --- Executes during object creation, after setting all properties.
function age_CreateFcn(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
