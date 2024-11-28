%Refershing Terminal & Workspace
clc
clear

blockLength = 1e3;
nBlocks = 2e4;
SNRdb = 0:0.5:10;
SNR = 10.^(SNRdb/10);

No = 1;
BER_WiredChannel_Practical = zeros(size(SNRdb));
BER_WirelessChannel_Practical = zeros(size(SNRdb));
BER_WiredChannel_Theoretical = zeros(size(SNRdb));
BER_WirelessChannel_Theoretical = zeros(size(SNRdb));

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
        BER_WirelessChannel_Practical(K) = BER_WirelessChannel_Practical(K)+sum(Decbits~=Bits);
    end

    for K = 1: length(SNRdb)
        TxSym = Sym*sqrt(SNR(K)*No);
        RxSym = TxSym + noise;
        EqSym = RxSym;
        Decbits = (real(EqSym) > 0);
        BER_WiredChannel_Practical(K) = BER_WiredChannel_Practical(K)+ sum(Decbits~=Bits);
        BER_WirelessChannel_Theoretical(K) = BER_WirelessChannel_Theoretical(K) + qfunc(abs(h)*sqrt(2*SNR(K)));
        BER_WiredChannel_Theoretical(K) = BER_WiredChannel_Theoretical(K) + qfunc(sqrt(2*SNR(K)));
    end
end
BER_WirelessChannel_Theoretical = BER_WirelessChannel_Theoretical/(nBlocks);
BER_WiredChannel_Theoretical = BER_WiredChannel_Theoretical/(nBlocks);
BER_WiredChannel_Practical = BER_WiredChannel_Practical/(nBlocks*blockLength);
BER_WirelessChannel_Practical = BER_WirelessChannel_Practical/(nBlocks*blockLength);

semilogy(SNRdb,BER_WiredChannel_Practical,'LineWidth',3.0,'MarkerFaceColor', ...
        'g','MarkerSize',9.0)
grid on
legend('BER')
xlabel('SNR(dB)')
ylabel('BER')

hold on
semilogy(SNRdb,BER_WirelessChannel_Practical,'LineWidth',3.0,'MarkerFaceColor', ...
        'g','MarkerSize',9.0)
hold on
scatter(SNRdb,BER_WiredChannel_Theoretical)
hold on
scatter(SNRdb,BER_WirelessChannel_Theoretical)
hold off 

legend('Wired Channel Practical','Wireless Channel Practical','Wired Channel Theroetical','Wireless Channel Theoretical');
