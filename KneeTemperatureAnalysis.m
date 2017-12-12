function varargout = KneeTemperatureAnalysis(varargin)
% KNEETEMPERATUREANALYSIS MATLAB code for KneeTemperatureAnalysis.fig
%      KNEETEMPERATUREANALYSIS, by itself, creates a new KNEETEMPERATUREANALYSIS or raises the existing
%      singleton*.
%
%      H = KNEETEMPERATUREANALYSIS returns the handle to a new KNEETEMPERATUREANALYSIS or the handle to
%      the existing singleton*.
%
%      KNEETEMPERATUREANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KNEETEMPERATUREANALYSIS.M with the given input arguments.
%
%      KNEETEMPERATUREANALYSIS('Property','Value',...) creates a new KNEETEMPERATUREANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KneeTemperatureAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KneeTemperatureAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KneeTemperatureAnalysis

% Last Modified by GUIDE v2.5 18-May-2017 15:10:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KneeTemperatureAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @KneeTemperatureAnalysis_OutputFcn, ...
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


% --- Executes just before KneeTemperatureAnalysis is made visible.
function KneeTemperatureAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KneeTemperatureAnalysis (see VARARGIN)

    
gui=getappdata(0,'gui')
handles.imag=getappdata(gui,'image');
handles.table=getappdata(gui,'table');

KneeSeg_Callback(hObject,eventdata,handles);




% Choose default command line output for KneeTemperatureAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KneeTemperatureAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KneeTemperatureAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in KneeSeg.
function KneeSeg_Callback(hObject, eventdata, handles)
% hObject    handle to KneeSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

axes(handles.axes1)
imshow(handles.left)

axes(handles.axes2)
imshow(handles.right)

set(handles.Left_leg,'String', strcat('Average temperature (°C): ',num2str(avg_L-273.15)));
set(handles.Right_leg,'String', strcat('Average temperature (°C): ',num2str(avg_R-273.15)));

axes(handles.axes5)
histogram(hist_R,'Normalization','probability','BinMethod','fd')
[N_R,~,~]=histcounts(hist_R,'BinMethod','fd');

N_R=N_R/sum(N_R);

axes(handles.axes4)
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
[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

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
    axes(handles.axes2);
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
    axes(handles.axes1);
    imshow(handles.left_patela);
end


% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Right.
function Right_Callback(hObject, eventdata, handles)
% hObject    handle to Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

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
    axes(handles.axes2);
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
    axes(handles.axes1);
    imshow(handles.left_patela);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Up.
function Up_Callback(hObject, eventdata, handles)
% hObject    handle to Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

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
    axes(handles.axes2);
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
    axes(handles.axes1);
    imshow(handles.left_patela);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Down.
function Down_Callback(hObject, eventdata, handles)
% hObject    handle to Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

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
    axes(handles.axes2);
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
    axes(handles.axes1);
    imshow(handles.left_patela);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DefineLeft.
function DefineLeft_Callback(hObject, eventdata, handles)
% hObject    handle to DefineLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

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

axes(handles.axes2);
imshow(handles.right_patela);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Define_right.
function Define_right_Callback(hObject, eventdata, handles)
% hObject    handle to Define_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.left,handles.left_temp,handles.right,handles.right_temp, avg_L, avg_R, hist_L, hist_R]=RightLeftKnee(handles.table,handles.imag);

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
axes(handles.axes1);
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
    set(handles.Normal_L,'String', strcat('Marked area T=',num2str(prosjek_krug - 273.15), ' °C'));
    set(handles.Normal_L1,'String', strcat('Rest of the knee T=', num2str(prosjek_van - 273.15),' °C'));
    handles.OA_L='Abnormal';
else
   % set(handles.Normal_L,'String',strcat('Marked area ',num2str(prosjek_krug - 273.15), ' °C < rest of the knee ', num2str(prosjek_van - 273.15),' ¢C'));
   set(handles.Normal_L,'String', strcat('Marked area T=',num2str(prosjek_krug - 273.15), ' °C'));
   set(handles.Normal_L1,'String', strcat('Rest of the knee T=', num2str(prosjek_van - 273.15),' °C')); 
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
   % set(handles.Normal_R,'String', 'Abnormal');
    set(handles.Normal_R,'String', strcat('Marked area T=',num2str(prosjek_krug - 273.15), ' °C'));
    set(handles.Normal_R1,'String', strcat('Rest of the knee T=', num2str(prosjek_van - 273.15),' ¢C'));
    handles.OA_R='Abnormal';
    handles.OA_R
else
  %  set(handles.Normal_R,'String','Normal');
    set(handles.Normal_R,'String', strcat('Marked area T=',num2str(prosjek_krug - 273.15), ' °C'));
    set(handles.Normal_R1,'String', strcat('Rest of the knee T=', num2str(prosjek_van - 273.15),' ¢C'));
    handles.OA_R='Normal';
end

    guidata(hObject, handles);
