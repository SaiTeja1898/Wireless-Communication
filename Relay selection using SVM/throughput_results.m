% clear;
% runsvmtest;
R=2;%target data rate
K=3;%relay count
% L=1e5;%No of channel samples%2.4e5
% S=(1/sqrt(2))*(randn(L,3*K)+1i*randn(L,3*K));%Channel samples CN~(0,1)
% data=readmatrix('testdatasetwoSNR.csv');
% Sabs=data(:,1:end-1);
% L=size(Sabs,1);
Sabs=Xtest;
L=size(Xtest,1);
SNR_dB=0:1:20;
throughput_exhaustive=[];
throughput_mm=[];
throughput_svm=[];
svm_label=predictedRelay;
random_label = randi([1 K],1,L);
for snr_wo_fading_dB=SNR_dB
    label=zeros(1,L);
    max_min_label=zeros(1,L);
    the=0;
    thmm=0;
    thsvm=0;
    for l=1:L
        %For a given lth channel sample
        snr_wo_fading = 10^(snr_wo_fading_dB/10);
        snr_sr=snr_wo_fading.*Sabs(l,1:K);
        snr_ru(1,:)=snr_wo_fading.*(Sabs(l,K+1:2*K));
        snr_ru(2,:)=snr_wo_fading.*(Sabs(l,(2*K)+1:3*K));
        C_sr=log2(1+snr_sr);%Capacity between source and Relay i with OMA
        C_ru(1,:)=log2(1+snr_ru(1,:));
        C_ru(2,:)=log2(1+snr_ru(2,:));
        best_relay=0;%0 means outage
        relays_with_noma=[];
        relays_with_oma=[];
        %NOMA constraints
        for i=1:K   %conditions on ith relay
            %alpha availability for noma
            is_noma_possible=0;
            if C_sr(i)>=2*R
                if(snr_ru(1,i)>snr_ru(2,i))
                    lower_limit=((power(2,R)-1)*snr_ru(1,i))/(snr_ru(1,i)-(power(2,R)-1)*power(2,R));
                    is_noma_possible=(snr_ru(2,i)>lower_limit);
                else
                    lower_limit=((power(2,R)-1)*snr_ru(2,i))/(snr_ru(2,i)-(power(2,R)-1)*power(2,R));
                    is_noma_possible=(snr_ru(1,i)>lower_limit);
                end
            end
            if is_noma_possible==1
                relays_with_noma=[relays_with_noma i];
            end
            %Check if oma possible
            is_oma_possible=0;
            if is_noma_possible==0
                if C_sr(i)>=R
                    is_oma_possible=C_ru(1,i)==R || C_ru(2,i)==R;
                end
            end
            if is_oma_possible==1
                relays_with_oma=[relays_with_oma i];
            end
        end
        %Applying max min if more than one combination is present
        if(~isempty(relays_with_noma))
            min_set=[];
            for r=relays_with_noma
                min_set=[min_set min(min(Sabs(r),Sabs(K+1+r)),min(Sabs(K+1+r),Sabs(2*K+1+r)))];
            end
            [val,pos]=max(min_set);
            best_relay=relays_with_noma(pos);
            the=the+2;
        elseif(~isempty(relays_with_oma))
            min_set=[];
            for r=relays_with_oma
                min_set=[min_set min(min(Sabs(r),Sabs(K+1+r)),min(Sabs(K+1+r),Sabs(2*K+1+r)))];
            end
            [val,pos]=max(min_set);
            best_relay=relays_with_oma(pos);
            the=the+1;
        end
        if(~isempty(find(relays_with_noma==svm_label(l))))
            thsvm=thsvm+2;
        elseif(~isempty(find(relays_with_oma==svm_label(l))))
            thsvm=thsvm+1;
        end

        label(l)=best_relay;
        %Finding best relay for max min condition
        S1=Sabs(l,1:K);
        S2=Sabs(l,K+1:2*K);
        S3=Sabs(l,(2*K)+1:3*K);
        Scomb=[S1;S2;S3];
        Smin=min(Scomb);
        [val,max_min_label(l)]=max(Smin);
        maxmininnoma=find(relays_with_noma==max_min_label(l));
        if(~isempty(maxmininnoma))
            thmm=thmm+2;
        end

        %Calculate throughput of the scenario with best relay


    end
    throughput_exhaustive=[throughput_exhaustive the/(2*L)];
    throughput_mm=[throughput_mm thmm/(2*L)];
    throughput_svm=[throughput_svm thsvm/(2*L)];
end
hold on;
label==Ytest'
plot(SNR_dB,throughput_exhaustive);
plot(SNR_dB,throughput_mm);
plot(SNR_dB,throughput_svm);
legend('exhaustive','max-min','SVM');
xlabel("SNR(dB)");
ylabel("Throughput");