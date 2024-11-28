close all;
clear;
clc;
blockLength = 1000;
nBlocks = 20000;
SNRdB = 0:1:15;
SNR = 10.^(SNRdB/10);
No = 1;
BER = zeros(1,16); %Initialize BER Array
BER_QAM = zeros(1,16); %Initialize BER Array

for blk = 1:nBlocks
    randvaluesI = randn(1,blockLength) ;
    randvaluesQ = randn(1,blockLength) ;   % Generate random bits of length equal to block length
    BitsI = randvaluesI > 0;
    BitsQ = randvaluesQ > 0;
    Sym =   (2*BitsI - 1) + j*(2*BitsQ-1); %Generate BPSK symbols, map bit 1 -> +1 and bit 0 -> -1
    noise = sqrt(No/2)*(randn(1,blockLength) +1j*(randn(1,blockLength))); %Generate noise

    for K = 1:length(SNRdB)
        TxSym = sqrt(SNR(K))*Sym;  % Transmit the symbols, adjust the amplitude of the symbols
        RxSym = TxSym + noise;
        DecBitsI = real(RxSym) > 0;
        DecBitsQ = imag(RxSym) > 0;

        BER(K) = BER(K) + sum(DecBitsI ~= BitsI) + sum(DecBitsQ ~= BitsQ);
    end
end

BER = (BER/blockLength)/nBlocks; %Average BER
semilogy(SNRdB,BER,'g','linewidth',2.0,'MarkerSize',9.0);
grid on;
legend('BER');
xlabel('SNR (dB)');
ylabel('BER');
title('BER vs SNR(dB) for AWGN with BPSK')


M = 16;
modulation = @(x) qammod(x,M,'InputType','bit','UnitAveragePower',true);
demodulation = @(x) qamdemod(x,M, 'OutputType','bit','UnitAveragePower',true);

for K = 1:length(SNRdB)
    snr = SNRdB(K);
    snrLinear = 10^(snr/10);
    errorCount = 0;

    for blk = 1:nBlocks
        Bits = randi([0,1],blocklength,1);
        TxSymbols = modulation(Bits);
        noiseStdDev*(1/(2*snrLinear));
        noise = noiseStdDev*(randn(size(TxSymbols)) + 1i*randn(size(TxSymbols)));
        RxSymbols = TxSymbols + noise;

        DecBits = demodulation(RxSymbols);
        errorCount = errorCount + sum(Bits ~= DecBits);
    end

    BER_QAM(K) = errorCount/ (blockLength*nBlocks);
end
figure;

