clc;
load('svm6e5.mat');
dataset=readmatrix('dataset.csv');
% dataset=dataset(1:100000,:);
% Xtrain=dataset(1:0.8*size(dataset,1),1:end-1);
% Ytrain=dataset(1:0.8*size(dataset,1),end);
Xtest=dataset((0.8*size(dataset,1))+1:end,1:end-1);
Ytest=dataset((0.8*size(dataset,1))+1:end,end);
Xtest=dataset(:,1:end-1);
Ytest=dataset(:,end);
classes=unique(dataset(:,end));

Scores=zeros(size(Ytest,1),numel(classes));
for j=1:numel(classes)
    [~,score]=predict(SVMModels{j},Xtest);
    Scores(:,j)=score(:,2); % Second column contains positive-class scores
end
[~,predictedRelay]=max(Scores,[],2);
predictedRelay=predictedRelay-1;
accuracy=sum(nnz(Ytest==predictedRelay))/size(Ytest,1);