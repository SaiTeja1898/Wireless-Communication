dataset=readmatrix('datasetwithSNR.csv');
% dataset=dataset(1:100000,:);
Xtrain=dataset(1:0.8*size(dataset,1),1:end-1);
Ytrain=dataset(1:0.8*size(dataset,1),end);
% Xtest=dataset((0.8*size(dataset,1))+1:end,1:end-1);
% Ytest=dataset((0.8*size(dataset,1))+1:end,end);
classes=unique(dataset(:,end));
ms=length(classes);
SVMModels=cell(ms,1);
for j = 1:numel(classes)
    indx=(Ytrain==classes(j)); % Create binary classes for each classifier
    SVMModels{j}=fitcsvm(Xtrain,indx,'ClassNames',[false true],'Standardize',true,...
        'KernelFunction','rbf');
end
% Scores=zeros(size(Ytest,1),numel(classes));
% for j=1:numel(classes)
%     [~,score]=predict(SVMModels{j},Xtest);
%     Scores(:,j)=score(:,2); % Second column contains positive-class scores
% end
% [~,predictedRelay]=max(Scores,[],2);
% predictedRelay=predictedRelay-1;
% accuracy=sum(nnz(Ytest==predictedRelay))/size(Ytest,1);
save('svm1_2e5SNR.mat', 'SVMModels');
% figure
% gscatter(x1(:),x2(:),maxScore,'cym');
% hold on;
% gscatter(X(:,1),X(:,2),Y,'rgb','.',30);
% title('{\bf Iris Classification Regions}');
% xlabel('Petal Length (cm)');
% ylabel('Petal Width (cm)');
% axis tight
% hold off
