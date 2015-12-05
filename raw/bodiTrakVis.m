clear all;
%close all;
clc;

% save name of all subjects
subjects = {'achin', 'david', 'dhurva', 'hao', 'kuk', 'marco',...
    'mb', 'paritosh', 'santi','yash'};
% save the poses labels
poses = {'left', 'right', 'front', 'back'};

% define characters to complete the filename
us = '_';
us1 = '_1.txt';

%%
%{
- Now we will load all the data for each pose of every subject 
- We will not average the time series for a given pose from a subject
- When we save a pose, we will define two additional labels
    - subject_ID, - pose_ID
%}

num_subjects = length(subjects);
num_poses = length(poses);


for ii = 1:num_subjects
    
    for jj = 1:num_poses
        
        filename = strcat(subjects(ii),us,poses(jj),us1);
        sample_data = load(char(filename));
        num_samples = size(sample_data,1);
        sample_lab = jj*ones(num_samples,1);
        
        if((ii==1)&&(jj==1))
            data = sample_data;
            labels = sample_lab;
        else
            data = vertcat(data,sample_data);
            labels = vertcat(labels,sample_lab);
        end

    end
    
end
        
        
load('paritosh_back_1.txt');
rawdata=paritosh_back_1;
rawdata_avg=mean(paritosh_back_1);
frame=rawdata(1,:);
frame= reshape(frame,16,16);
frame=frame';
neg_frame=-frame;
figure
subplot(2,1,1)
image(frame);
colormap(jet(256));

%meshgrid
[X Y]=meshgrid(1:16);
subplot(2,1,2);
surf(X,Y,neg_frame)

%2d interpolation, cubic splines
[Xq Yq]=meshgrid(1:0.1:16);
neg_frame_q=interp2(X,Y,neg_frame,Xq,Yq);
frame_q=-1*neg_frame_q;
figure
subplot(2,1,1)
image(frame_q);
colormap(jet(256));
subplot(2,1,2);
surf(Xq,Yq,neg_frame_q);

%contour plot
figure
contourf(frame_q)