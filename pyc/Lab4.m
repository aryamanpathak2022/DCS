close all;
clear all;
blockLength = 1000;
nBlocks=20000;
SNRdB = 0:1:15;
SNR = 10.^(SNRdB/10); 
No = 1;
BER = zeros(size(SNR));

for blk = 1:nBlocks
    Bits = randi([0 1],1,blockLength);
%     Sym = zeros(size(Bits));
%     Sym(Bits==0)=-1;
%     Sym(Bits==1)=1;
    Sym = 2*Bits-1;
    noise = sqrt(No/2)*(randn(1,blockLength)+1j*randn(1,blockLength));
    for K = 1:length(SNRdB)
        TxSym = Sym*sqrt(SNR(K)*No);
        RxSym = TxSym + noise;
        DecBits = (real(RxSym) > 0);
        BER(K) = BER(K)+ sum(DecBits~=Bits);
    end
end
BER = BER/(nBlocks*blockLength);
semilogy(SNRdB,BER,'g','linewidth',2.0,'MarkerSize',9.0);
grid on;
legend('BER')
xlabel('SNR (dB)');
ylabel('BER');
title('BER vs SNR(dB) for AWGN with BPSK');