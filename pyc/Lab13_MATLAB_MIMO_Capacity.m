close all;
clear all;

SNRdB = -10:1:10;
SNR = 10.^(SNRdB/10);
numBlocks = 10;
Capacity_OPT = zeros(1,length(SNRdB));
Capacity_EQ = zeros(1,length(SNRdB));
r = 4;
t = 4;

for L = 1:numBlocks
    H = (randn(r,t)+1j*randn(r,t))/sqrt(2);
    S = svd(H);
    for kx = 1:length(SNRdB)
        Capacity_OPT(kx) = Capacity_OPT(kx) + OPT_CAP_MIMO(H,SNR(kx));
        Capacity_EQ(kx) = Capacity_EQ(kx) + EQ_CAP_MIMO(H,SNR(kx));
    end
end
Capacity_OPT = Capacity_OPT/numBlocks;
Capacity_EQ = Capacity_EQ/numBlocks;


plot(SNRdB,Capacity_OPT,'b-s','linewidth',3.0,'MarkerFaceColor','b','MarkerSize',9.0);
hold on;
plot(SNRdB,Capacity_EQ,'r-.o','linewidth',3.0,'MarkerFaceColor','r','MarkerSize',9.0);
grid on
legend('OPT','Equal','Location','NorthWest');
title('MIMO Capacity vs SNR(dB)')
xlabel('SNR (dB)')
ylabel('Capacity (b/s/Hz)')

function CAP = OPT_CAP_MIMO(Heff,SNR);
S = svd(Heff);
t = length(S);
CAP = 0;
while ~CAP
    onebylambda = (SNR + sum(1./S(1:t).^2))/t;
    if onebylambda >= 1/S(t)^2
        optP = onebylambda - 1./S(1:t).^2;
        CAP = sum(log2(1+S(1:t).^2.*optP));
    else
        t = t-1;
    end
end
end

function CAP = EQ_CAP_MIMO(Heff,SNR);
S = svd(Heff);
t = length(S);
CAP = sum(log2(1+S.^2*SNR/t));
end

