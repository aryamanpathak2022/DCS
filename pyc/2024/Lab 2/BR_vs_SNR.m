close all;
clear;
clc;
blockLength = 1000;
nBlocks = 20000;
SNRdB = 0:1:15;
SNR = 10.^(SNRdB/10);
No = 1;
BER = zeros(1,16); %Initialize BER Array

for blk = 1:nBlocks
    randvalues = randn(1,blockLength) ;% Generate random bits of length equal to block length
    Bits = randvalues > 0;
    Sym =   2*Bits - 1; %Generate BPSK symbols, map bit 1 -> +1 and bit 0 -> -1
    noise = sqrt(No/2)*(randn(1,blockLength) +1j*(randn(1,blockLength))); %Generate noise

    for K = 1:length(SNRdB)
        TxSym = sqrt(SNR(K))*Sym;  % Transmit the symbols, adjust the amplitude of the symbols
        RxSym = TxSym + noise;
        DecBits = RxSym > 0;
        BER(K) = BER(K) + sum(DecBits ~= Bits);
    end
end

BER = (BER/blockLength)/nBlocks; %Average BER
semilogy(SNRdB,BER,'g','linewidth',2.0,'MarkerSize',9.0);
grid on;
legend('BER');
xlabel('SNR (dB)');
ylabel('BER');
title('BER vs SNR(dB) for AWGN with BPSK')
