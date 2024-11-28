%Refershing Terminal & Workspace
clc
clear

nPilot = 10;
nData = 1e3;
blockLength = nPilot+nData;
nBlocks = 2e3;
SNRdb = 0:0.5:15;
SNR = 10.^(SNRdb/10);

No = 1;
BER_pCSI = zeros(size(SNRdb));
BER_imCSI = zeros(size(SNRdb));
hEstErr = zeros(size(SNRdb));

for blk = 1:nBlocks
     h = randn + 1j*randn;
    Bits = randi([0 1],1,blockLength);
    Sym = 2*Bits-1;
    pSym = Sym(1:nPilot).';
    pNorm = norm(pSym)^2;
    noise = (sqrt(No / 2)) * (randn(1, blockLength) + 1i * randn(1, blockLength));
    for K = 1: length(SNRdb)
        TxSym = Sym;
        RxSym = h * TxSym + sqrt(1/SNR(K))* noise;
        pObser = RxSym(1:nPilot).';
        hEst = (pSym/pNorm)'*pObser;
        hEstErr(K) = hEstErr(K) + abs(hEst - h)^2;
        EqSym_pCSI = RxSym(nPilot+1:end)/h;
        Decbits_pCSI = real(EqSym_pCSI)>0 ;
        BER_pCSI(K) = BER_pCSI(K) + sum(Bits(nPilot + 1:end) ~= Decbits_pCSI);
        EqSym_imCSI = RxSym(nPilot+1:end)/hEst;
        Decbits_imCSI = real(EqSym_imCSI)>0;
        BER_imCSI(K) = BER_imCSI(K) + sum(Bits(nPilot + 1:end) ~= Decbits_imCSI);
    end
end
hEstMSE = hEstErr/nBlocks;
BER_pCSI = BER_pCSI/nData/nBlocks;
BER_imCSI = BER_imCSI/nData/nBlocks;

figure;
plot(SNRdb,10*log(hEstMSE),'b','LineWidth',2.0)
grid on
legend('Channel Estimation MSE')
xlabel('SNR(dB)')
ylabel('MSE (dB)')

figure;
semilogy(SNRdb,BER_pCSI,'b','LineWidth',2.0)
hold on
semilogy(SNRdb,BER_imCSI,'r','LineWidth',2.0)
grid on
legend('BER with perfect CSI','BER with Estimated CSI')
xlabel('SNR(dB)')
ylabel('BER')

