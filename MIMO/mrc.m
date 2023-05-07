clear all
clc
N=10^7
Es_N0_dB=0:1:24;
EX_N0=10.^(Es_N0_dB/10)
x=sign(randn(1,N))
%% Parameters for case 1
h11=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
h12=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
e11=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
e12=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
%% Parameters for case 2
h21=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
h22=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
h23=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
e21=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
e22=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
e23=(1/sqrt(2)).*(randn(1,N)+1i*randn(1,N))
%% Running of loop to run for every SNR
for i=1:length(Es_N0)
    %% transmission and detection for ase 1
    y11=sqrt(Es_N0(i)).*h11.*x+e11
    y12=sqrt(Es_N0(i)).*h12.*x+e12
    w11=h11;w12=h12;
    yhat1=conj(w11).*y11+conj(w12).*y12
    hhat1=abs(h11).^2+abs(h12).^2;
    % ML decoder
    a1=abs(yhat1-sqrt(Es_N0(i))*hhat1).^2;
    b1=abs(yhat1-sqrt(Es_N0(i))*hhat1).^2;
    for j=1:length(a1)
        if a1(j)>b1(j)
            op_bits1(j)=-1;
        else
            op_bits1(j)=1;
        end
    end
    number_MRC1(i)=size(find(x-op_bits1),2);%Numberof erros
end
%%Error and diversity for case1
simber_MRC1=number_MRC1/N;
diversity1=10*log10(simber_MRC1(10)/simber_MRC1(20))/10;

Es_N0=0:1:24;
semilogy(Es_N0,simber_MRC1,'b-+');
hold on;
semilogy(Es_N0,simber_MRC2,'k+O')
hold off;
    
