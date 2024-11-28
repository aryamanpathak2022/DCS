%Refershing Terminal & Workspace
clc
clear

blockLength = 1e3;
nBlocks = 2e4;
SNRdb = 0:0.5:10;
SNR = 10.^(SNRdb/10);

No = 1;
BER_WiredChannel = zeros(size(SNRdb));
BER_WirelessChannel = zeros(size(SNRdb));

for blk = 1:nBlocks
    h = randn+1j*randn;
    Bits = randi([0 1],1,blockLength);
    Sym = 2*Bits-1;
    noise = sqrt(No/2)*(randn(1,blockLength)+1j*randn(1,blockLength));

    for K = 1: length(SNRdb)
        TxSym = Sym*sqrt(SNR(K)*No);
        RxSym = h*TxSym + noise;
        EqSym = RxSym/h;
        Decbits = (real(EqSym) > 0);
        BER_WirelessChannel(K) = BER_WirelessChannel(K)+sum(Decbits~=Bits);
    end

    for K = 1: length(SNRdb)
        TxSym = Sym*sqrt(SNR(K)*No);
        RxSym = TxSym + noise;
        EqSym = RxSym;
        Decbits = (real(EqSym) > 0);
        BER_WiredChannel(K) = BER_WiredChannel(K)+ sum(Decbits~=Bits);
    end
end

BER_WiredChannel = BER_WiredChannel/(nBlocks*blockLength);
BER_WirelessChannel = BER_WirelessChannel/(nBlocks*blockLength);

semilogy(SNRdb,BER_WiredChannel,'r','LineWidth',3.0,'MarkerFaceColor', ...
        'g','MarkerSize',9.0)
grid on
legend('BER')
xlabel('SNR(dB)')
ylabel('BER')

hold on
semilogy(SNRdb,BER_WirelessChannel,'b','LineWidth',3.0,'MarkerFaceColor', ...
        'g','MarkerSize',9.0)
hold off 

legend('Wired Channel','Wireless Channel')
