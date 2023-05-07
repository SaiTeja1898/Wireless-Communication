%Simulate SER of 2*2 and 4*4 MIMO system using Alamouti code
ASER_ala=[];
for SNR_dB=-20:2.5:30
    b=0;
    for sample = 1:10^6
        h_ala=(1/sqrt(2))*(randn(2,2)+1i*randn(2,2));%root 2 for making variance of CN 1;
        %Converting orthogonality in symbol matrix to channel matrix
        H_ala=[h_ala(1,1) h_ala(1,2);h_ala(2,1) h_ala(2,2);h_ala(1,2)' -h_ala(1,1)';h_ala(2,2)' -h_ala(2,1)'];

        d_ala=rand(2,1)>0.5;
        x_ala=2*d_ala-1;%BPSK

        sd=sqrt(1/10^(SNR_dB/10));%keeping signal power 1 and reducing the remaining from noise
        E_ala=sd*(randn(4,1)+1i*randn(4,1));

        y_ala=H_ala*x_ala+E_ala;

        %detection at receiver end
        rx_ala=real(H_ala'*y_ala)/(norm(H_ala,"fro")^2);
        est_ala=(rx_ala)>0;
        b=b+nnz(est_ala-d_ala);%adding the number of symbol errors
    end
    ASER_ala=[ASER_ala b/(2*sample)];%2 symbols are transmitted in one experiment
end
SNR_dB=-20:2.5:30;
SNR=10.^(SNR_dB/10);
semilogy(SNR_dB,ASER_ala,'-g');
title('Performance analysis of OSTBC with 2*2 MIMO setup');
xlabel('SNR(dB)');
ylabel('BER');
hold on
grid on