function varargout = pose_estimator(varargin)
% POSE_ESTIMATOR MATLAB code for pose_estimator.fig
%      POSE_ESTIMATOR, by itself, creates a new POSE_ESTIMATOR or raises the existing
%      singleton*.
%
%      H = POSE_ESTIMATOR returns the handle to a new POSE_ESTIMATOR or the handle to
%      the existing singleton*.
%
%      POSE_ESTIMATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSE_ESTIMATOR.M with the given input arguments.
%
%      POSE_ESTIMATOR('Property','Value',...) creates a new POSE_ESTIMATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pose_estimator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pose_estimator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pose_estimator

% Last Modified by GUIDE v2.5 18-Aug-2015 21:45:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pose_estimator_OpeningFcn, ...
                   'gui_OutputFcn',  @pose_estimator_OutputFcn, ...
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


% --- Executes just before pose_estimator is made visible.
function pose_estimator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pose_estimator (see VARARGIN)

% Choose default command line output for pose_estimator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

handles=guidata(handles.output);
axes(handles.axes1);
%mImage = imread('logo.jpg');
%image(mImage)
imshow('logo.jpg');
axis off
axis image

load forrest_classifier.mat
load testset.mat

handles.tree = B;
handles.features = testset_features;
handles.labels = testset_labels;
handles.poses = {'Left', 'Right', 'Front', 'Back'};
handles.num_samples = length(handles.labels);

guidata(handles.output,handles);

% UIWAIT makes pose_estimator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pose_estimator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load forrest_classifier.mat
% load testset.mat

disp_idx =  randsample(handles.num_samples,1);
ground_truth = handles.labels(disp_idx);
true_pose = cell2mat(handles.poses(ground_truth));
frame=handles.features(disp_idx,:);
frame= reshape(frame,16,16);
frame=frame';
frame = fliplr(frame);
neg_frame=-frame;
axes(handles.axes2)
[X Y]= meshgrid(1:16);
[Xq Yq]= meshgrid(1:0.1:16);
neg_frame_q=interp2(X,Y,neg_frame,Xq,Yq);
frame_q=-1*neg_frame_q;
contourf(frame_q)
axis off
axis image

predicted_label = predict(handles.tree,handles.features(disp_idx,:));
predicted_pose = handles.poses(str2num(cell2mat(predicted_label)));
string1 = true_pose;
string2 = predicted_pose;
set(handles.edit2, 'String', string1);
set(handles.edit1, 'String', string2);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



disp_idx =  randsample(handles.num_samples,1);
ground_truth = handles.labels(disp_idx);
true_pose = handles.poses(ground_truth);
frame=handles.features(disp_idx,:);
frame= reshape(frame,16,16);
frame=frame';
frame = fliplr(frame);
neg_frame=-frame;
axes(handles.axes2)
[X Y]= meshgrid(1:16);
[Xq Yq]= meshgrid(1:0.1:16);
neg_frame_q=interp2(X,Y,neg_frame,Xq,Yq);
frame_q=-1*neg_frame_q;
contourf(frame_q)
axis off
axis image

predicted_label = predict(handles.tree,handles.features(disp_idx,:));
predicted_pose = handles.poses(str2num(cell2mat(predicted_label)));
string1 = true_pose;
string2 = predicted_pose;
set(handles.edit2, 'String', string1);
set(handles.edit1, 'String', string2);


  
