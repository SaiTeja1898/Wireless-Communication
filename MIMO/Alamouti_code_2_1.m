%Simulate SER of 2*2 and 4*4 MIMO system using Alamouti code
ABER_ala=[];
for SNR_dB=0:2.5:30
    b=0;
    for sample = 1:10^5
        h_ala=(1/sqrt(2))*(randn(1,2)+1i*randn(1,2));%root 2 for making variance of CN 1;
        H_ala=[h_ala(1) h_ala(2);h_ala(2)' -h_ala(1)'];

        d_ala=rand(2,1)>0.5;
        x_ala=2*d_ala-1;%BPSK

        sd=sqrt(1/10^(SNR_dB/10));%keeping signal power 1 and reducing the remaining from noise
        E_ala=sd*(randn(2,1)+1i*randn(2,1));

        y_ala=(H_ala*x_ala)+E_ala;

        rx_ala=H_ala'*y_ala/(norm(H_ala,"fro")^2);

        est_ala=real(rx_ala)>0;
        b=b+nnz(est_ala-d_ala);
    end
    ABER_ala=[ABER_ala b/sample];
end
SNR_dB=0:2.5:30;
SNR=10.^(SNR_dB/10);
semilogy(SNR_dB,ABER_ala,'-g');
hold on
grid on