%Simulate SER of 2*1 MIMO system using SSK modulation
Nt=2;
Nr=1;
ASER_ssk=[];
for SNR_dB=-30:2.5:30
    b=0;
    for sample = 1:10^6
        H_ssk=(1/sqrt(2))*(randn(Nr,Nt)+1i*randn(Nr,Nt));%root 2 for making variance of CN 1;

        x_ssk=zeros(Nt,1);
        d_ssk=rand>0.5;
        %Activating only that antenna required for transmission
        %Symbol 0 - [1 0]
        %Symbol 1 - [0 1]
        x_ssk(d_ssk+1,1)=1;

        sd=sqrt(1/10^(SNR_dB/10));%keeping signal power 1 and reducing the remaining from noise
        E_ssk=sd*(randn(Nr,1)+1i*randn(Nr,1));

        y_ssk=(H_ssk*x_ssk)+E_ssk;

        %detection at receiver end based on channel parameters
        rx_ssk=norm((y_ssk-H_ssk(1,1)),"fro")>norm((y_ssk-H_ssk(1,2)),"fro");

        est_ssk=rx_ssk;
        b=b+nnz(est_ssk-d_ssk);
    end
    ASER_ssk=[ASER_ssk b/sample];
end
SNR_dB=-30:2.5:30;
SNR=10.^(SNR_dB/10);
semilogy(SNR_dB,ASER_ssk,'-g');
title('Performance analysis of SSK with 2*1 MIMO setup');
xlabel('SNR(dB)');
ylabel('BER');
hold on
grid on