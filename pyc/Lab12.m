clc
clear

[y,x] = MIMO(2,2);
semilogy(x,y,"LineWidth",3)

hold on
[y,x] = MIMO(4,2);
semilogy(x,y,"LineWidth",3)
hold off

hold on
[y,x] = MIMO(2,4);
semilogy(x,y,"LineWidth",3)
hold off


grid on 
grid minor

xlabel("SNR (db)")
ylabel("BER")

legend("r = 2, t= 2","r = 4, t= 2","r = 2, t= 4")

function [BER_ZF,SNRdB] = MIMO(r,t)
    blockLength = 1e3;
    nBlocks = 1e4;
    SNRdB = 0:5:35;
    SNR = 10.^(SNRdB/10);
    No = 1;
    BER_ZF = zeros(size(SNRdB));
    
    for blk = 1:nBlocks
        h = sqrt(1/2)*(randn(r,t) + 1j*randn(r,t));
        BitsI = randi([0 1],t,blockLength);
        BitsQ = randi([0 1],t,blockLength);
        Sym = sqrt(1/2)*((2*BitsI-1) + 1j*(2*BitsQ-1));
        noise = (sqrt(No / 2)) * (randn(r, blockLength) + 1j * randn(r, blockLength));
        
        for K = 1:length(SNRdB)
            TxSym = sqrt(SNR(K))*Sym;
            RxSym = h*TxSym + noise;
            EqSym = ((h'*h)^(-1)*h')*RxSym;
            DecBitsI = (real(EqSym) > 0);
            DecBitsQ = (imag(EqSym) > 0);
            BER_ZF(K) = BER_ZF(K) + sum(DecBitsI ~= BitsI,"all") + sum(DecBitsQ ~= BitsQ,"all");
        end
    end
    
    BER_ZF = BER_ZF/blockLength/nBlocks/t;
end