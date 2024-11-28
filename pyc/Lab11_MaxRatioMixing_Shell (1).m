clc
clear

blockLength = 1e3;
nBlocks = 1e3;
L = 3;            %3 recivers and 1 transmitter
SNRdb = 0:2:10;
SNR = 10.^(SNRdb/10);
No  = 1;
BER = zeros(size(SNRdb));

for blk = 1:nBlocks
    h = (randn(L, 1) + 1j * randn(L, 1)) / sqrt(2);   %dimension L x 1 --> L channels
    BitsI = randi([0, 1], 1 ,blockLength);   %BlockLength bits
    BitsQ = randi([0, 1], 1,blockLength);    %BlockLength bits
    Sym = sqrt(1/2)*((2*BitsI-1) + 1j*(2*BitsQ-1)); 
    noise = sqrt(No/2)*(randn(L,blockLength) +1j*randn(L,blockLength));          %L x blockLength
    
    for K = 1:length(SNRdb)
        TxSym = sqrt(SNR(K))*Sym;
        RxSym = h*TxSym;
        EqSym = h'*RxSym;                     %h' is hermition
        DecBitsI = real(EqSym)>0;
        DecBitsQ = imag(EqSym)>0;
        BER(K) = BER(K)+ sum(DecBitsI ~= BitsI)+ sum(DecBitsQ ~= BitsQ);
    end
end

BER = BER/blockLength/nBlocks;    %check this line---> correct it
semilogy(SNRdb,BER,'LineWidth',3.0)

grid on
legend(sprintf('L = %d',L))
xlabel('SNR(dB)')
ylabel('BER')