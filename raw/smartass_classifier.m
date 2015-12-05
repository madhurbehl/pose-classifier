% smartass_classifier

clear all;
close all;
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
        subject_lab = (ii-1)*ones(num_samples,1);
        avg_subject = (sum(sample_data,2));
        max_subject = max(max(sample_data))*ones(num_samples,1);
        
        if((ii==1)&&(jj==1))
            data = sample_data;
            labels = sample_lab;
            ID_label =  subject_lab;
        else
            data = vertcat(data,sample_data);
            labels = vertcat(labels,sample_lab);
            ID_label = vertcat(ID_label,subject_lab);
        end

    end
    
end

% also create another object to pass to Matlab's classification app.
all_data = horzcat(data,labels);

% Now sample 20% the entire dataset to be used fir testing.

tot_samples = length(data);
hold_out = 0.2; 

test_len = floor(tot_samples*hold_out);
test_samples = randsample(tot_samples,test_len);

testset_features = data(test_samples,:);
testset_labels = labels(test_samples,:);
testset_label_ID = labels(test_samples,:);

data(test_samples,:)=[];
labels(test_samples,:)=[];
ID_label(test_samples,:)=[];


%% Plot subject variational data

rand_subjects =  randsample(num_subjects,4);
figure();
for kk = 1:4
    
    filename = strcat(subjects(kk),us,poses(1),us1);
    frame = mean(load(char(filename)));
    frame= reshape(frame,16,16);
    frame=frame';
    frame = fliplr(frame);
    neg_frame=-frame;
%     [X,Y]= meshgrid(1:16);
%     [Xq,Yq]= meshgrid(1:0.1:16);
%     neg_frame_q=interp2(X,Y,neg_frame,Xq,Yq);
%     frame_q=-1*neg_frame_q;
    subplot(2,2,kk);
%     contourf(frame_q)
    contourf(frame)
    axis off
    axis image
    title(subjects(kk));
    
end

%% Fit a classification decision tree

tree = fitctree(data,labels);
prediction = predict(tree,testset_features);
CP = classperf(testset_labels, prediction);
%plotroc(testset_labels,prediction);

fprintf('Correct Rate: %.2f \n',CP.CorrectRate);

%% Random Forests
disp('Learning a Random Decision Tree Forest for pose estimation');

% leaf = [10 20 50 100];
% col = 'rbcmyk';
% figure();
% for i=1:length(leaf)
%     brf = TreeBagger(300,data,labels,'Method','classification',...
%         'OOBPred','On','OOBVarImp','on','MinLeaf',leaf(i));
%     plot(sqrt(oobError(brf)),col(i));
%     hold on;
% end
% xlabel 'Number of Grown Trees';
% ylabel 'Root Mean Squared Error' ;
% legend({'10','20' '50' '100'},'Location','NorthEast');
% hold off;
% 
% figure();
% barh(brf.OOBPermutedVarDeltaError);
% xlabel 'Feature' ;
% ylabel 'Out-of-Bag Feature Importance';
% set(gca,'YTickLabel',colnames);

%train a random forest with 500 trees.
tic;
B = TreeBagger(500,data,labels,'Method','classification');
toc;

Ybag = predict(B,testset_features);
forest_label = str2num(cell2mat(Ybag));
CP_RF = classperf(testset_labels,forest_label);
fprintf('Pose Estimation Correct Classification Rate (RF): %.2f \n',CP_RF.CorrectRate);

disp('Learning a Random Decision Tree Forest for subject identification');

tic;
B_id = TreeBagger(500,data,ID_label,'Method','classification');
toc;

Ybag_ID = predict(B_id,testset_features);
forest_labelID = str2num(cell2mat(Ybag_ID));
CP_ID = classperf(testset_label_ID,forest_labelID);

fprintf('Subject Estimation Correct Classification Rate (RF): %.2f \n',CP_ID.CorrectRate);

%% 
        