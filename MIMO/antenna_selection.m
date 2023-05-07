M=1;% no .of transmitter antenna
ABER=[];
for SNR_dB=0:2.5:30
    SNR=10.^(SNR_dB/10);
    b=0;
    for sample=1:10^6
        H=zeros(1,M);
        for n=1:M
            h=randn(1)+1i*randn(1); %Rayleigh channel
            H(n)=h;
        end
        d=rand(1)>0.5;
        x=2*d-1;
        [val,index]=max(H);
        sd=sqrt(1/10^(SNR_dB/10));%standard deviation of noise
        E=sd*(randn(1)+1i*randn(1));%Additive white gaussian noise prototype

        y=H(index)*x+E;

        rx=y/H(index);
        est=real(rx)>0;
        if(est-d~=0)
            b=b+1;
        end
    end
    ABER=[ABER b/sample];

end
SNR_dB=0:2.5:30;
SNR=10.^(SNR_dB/10);
semilogy(SNR_dB,ABER,'-g');
hold on
grid on
