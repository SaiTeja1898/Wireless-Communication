clc;
clear;

ABER=[];
ERa=[];

for SNR_dB = 0:2.5:30
    SNR = 10^(SNR_dB/10);
    b=0;
    BErrora=0;
    m=4;
    for sample=1:10^6

        H=sqrt(gamrnd(m,1/m,1));%alpha=m , beta = 1/m and mean = 1 

        d=rand(1)>0.5;%BPSK
        x=2*d-1;

        sd=sqrt(1/10^(SNR_dB/10)); %standard deviation of noise
        E=sd*(randn(1)+1i*randn(1)); %Additive white gaussian noise prototype

        y=H*x+E;

        rx=y/H;
        est = real(rx)>0;
        if(est-d~=0)
            b=b+1;
        end

        ber=qfunc(abs(H)*(sqrt(SNR)));
        BErrora=BErrora+ber;
    end
    ABER = [ABER b/sample];

    ERa=[ERa BErrora/sample];
end
SNR_dB=0:2.5:30;
SNR=10.^(SNR_dB/10);
semilogy(SNR_dB,ABER,'-c');
hold on
semilogy(SNR_dB,ERa,'*k');
legend("Practical BER","Analytical BER")
title("Nakagami-m Fading")
xlabel("SNR(dB)")
ylabel("BER")
grid on
hold off