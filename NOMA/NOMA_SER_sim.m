%Simulate SER for downlink Power domain NOMA
clear;
ABER_nu=[];
ABER_fu=[];
alpha=0.3;%power allocation for Near user
PL=2;%Path loss exponent
dist_nu=1;
dist_fu=2*dist_nu;
SNR_dB=-20:2.5:40;
for P_dB=SNR_dB
    b_nu=0;
    b_fu=0;
    P = 10^(P_dB/10);
    No=1;
    i=1;
    for sample = 1:10^6
        %Data generation at BS
        d_nu=rand(1)>0.5;%out 0 or 1
        x_nu=2*d_nu-1;%BPSK %out -1 or 1
        d_fu=rand(1)>0.5;
        x_fu=2*d_fu-1;%BPSK
        %Superposition
        %achieving snr by sig pwr=1 and noise pwr=1/snr
        x_noma=sqrt(alpha*P)*x_nu+sqrt((1-alpha)*P)*x_fu;

        %channel variations
        %Fading with Path loss h~CN(0,1)
        h_nu=(1/sqrt(2*dist_nu^PL))*(randn(1)+1i*randn(1));%root 2 for making variance of CN 1;
        h_fu=(1/sqrt(2*dist_fu^PL))*(randn(1)+1i*randn(1));
        n_nu=(1/sqrt(2))*(randn(1)+1i*randn(1));
        n_fu=(1/sqrt(2))*(randn(1)+1i*randn(1));

        %Far user decoding
        y_fu=h_fu*x_noma+n_fu;
        rx_fu=real(y_fu/h_fu)>0;%ML decoding
        b_fu=b_fu+(rx_fu~=d_fu);

        %Near user decoding
        y_nu=h_nu*x_noma+n_nu;
        rx_fu_at_nu=real(y_nu/h_nu)>0;
        rx_fu_at_nu=2*rx_fu_at_nu-1;
        mod_rx_fu_at_nu=h_nu*sqrt((1-alpha)*P)*rx_fu_at_nu;
        rx_nu=real((y_nu-mod_rx_fu_at_nu)/h_nu)>0;
        b_nu=b_nu+(rx_nu~=d_nu);
        
    end
    ABER_nu=[ABER_nu b_nu/sample];
    ABER_fu=[ABER_fu b_fu/sample];
    i=i+1;
end
semilogy(SNR_dB,ABER_nu,'-g');
hold on
grid on
semilogy(SNR_dB,ABER_fu,'-r');
legend('Near User','Far User');