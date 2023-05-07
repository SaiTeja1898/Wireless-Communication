%Simulate SER of 2*2 and 4*4 MIMO system using Alamouti code
ASER_ala=[];
for SNR_dB=-10:2.5:20
    b=0;
    for sample = 1:10^6
        H_ala=(1/sqrt(2))*(randn(4,4)+1i*randn(4,4));%root 2 for making variance of CN 1;
        
        d_ala=rand(3,1)>0.5;
        x_ala=2*d_ala-1;%BPSK
        %4*4 OSTBC 
        X_ala=[  x_ala(1)    0        x_ala(2)  -x_ala(3);
                  0          x_ala(1) x_ala(3)' x_ala(2)';
                -x_ala(2)'  -x_ala(3) x_ala(1)'      0;
                 x_ala(3)'  -x_ala(2)    0       x_ala(1)' ];

        sd=sqrt(1/10^(SNR_dB/10));%keeping signal power 1 and reducing the remaining from noise
        E_ala=sd*(randn(4,4)+1i*randn(4,4));

        y_ala=(H_ala*X_ala)+E_ala;

%detection at receiver end for obtaining symbols
rx_ala=zeros(3,1);
rx_ala(1)=((H_ala(:,1)'*y_ala(:,1))+(H_ala(:,2)'*y_ala(:,2))+((H_ala(:,3).')*conj(y_ala(:,3)))+((H_ala(:,4).')*conj(y_ala(:,4))));

rx_ala(2)=((H_ala(:,1)'*y_ala(:,3))+((H_ala(:,2).')*conj(y_ala(:,4)))-((H_ala(:,3).')*conj(y_ala(:,1)))-(H_ala(:,4)'*y_ala(:,2)));

rx_ala(3)=((-H_ala(:,1)'*y_ala(:,4))+((H_ala(:,2).')*conj(y_ala(:,3)))-(H_ala(:,3)'*y_ala(:,2))+((H_ala(:,4).')*conj(y_ala(:,1))));

        %detection at receiver end for obtaining symbols
        rx_ala=real(rx_ala)/(norm(H_ala,"fro")^2);
        est_ala=rx_ala>0;
        b=b+nnz(est_ala-d_ala);%adding the number of symbol errors
        %b=b+nnz(est_ala(1)-d_ala(1))+nnz(est_ala(2)-d_ala(2))+nnz(est_ala(3)-d_ala(3));
    end
    ASER_ala=[ASER_ala b/(3*sample)];%3 symbols are transmitted in one experiment
end
SNR_dB=-10:2.5:20;
SNR=10.^(SNR_dB/10);
semilogy(SNR_dB,ASER_ala,'-g');
title('Performance analysis of OSTBC with 4*4 MIMO setup');
xlabel('SNR(dB)');
ylabel('BER');
hold on
grid on