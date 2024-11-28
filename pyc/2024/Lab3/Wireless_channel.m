close all;
clc;
clearvars;

%{
no_samples = 1000;



x = randn(1,nBlocks);
y = randn(1,nBlocks);

h = x + 1i*y;

a = abs(h);
phase = angle(h);

figure;
histogram(a);
title('Distribution of the gain of h');
xlabel('Samples');
ylabel('distribution of the channel gain');
grid on;

figure;
histogram(phase);
title('Distribution of the angle of h');
xlabel('Samples');
ylabel('distribution of the channel angle');
grid on;

%}


%%%

%BER : Bit error rate(# of wrong bits when recieved)
%SNR : Signal to noise ratio


blocklength = 1000;
nBlocks = 20000;
SNRdB = 0:1:15;
SNR = 10.^(SNRdB/10);
No = 1;
length_BER = length(SNR);
BER_BPSK = zeros(1, length_BER); % Initialize BER array
BER_theoritical = zeros(1, length_BER); % Initialize BER array


for blk = 1:nBlocks
    h = randn + 1j*randn;
    Bits = randi([0,1],1,blocklength);%1. Generate random bits of length equal to block length
    Sym = 2 * Bits - 1;%2. Generate BPSK symbols, ie map bit 1--->+1 and 0--->-1
    noise = sqrt(No/2)*(randn(1,blocklength) + 1j*randn(1,blocklength));% Generate of noise

    for K = 1:length(SNRdB)
        TxSym = sqrt(SNR(K))*Sym; %3. Transmit the symbols, adjust the amplitude of the symbols.
                % relative to the desired SNR at Kth index.
        RxSym = (TxSym)*h + noise;
        RxSym = RxSym/(h);%4. Calculate the received symbol and decode the original bits.
        DecBits = (real(RxSym) > 0);%5 Make decision based on received symbols to recover the bits.
        BER_BPSK(K) = BER_BPSK(K) + sum(DecBits ~= Bits);
        BER_theoritical(K) = BER_theoritical(K) + qfunc(abs(h)*(sqrt(2*SNR(K)))) ;%6. Calculate BER for each iteration.

    end
end

BER = BER_BPSK/blocklength/nBlocks; % Compute the Average BER
BER_theoritical = BER_theoritical/nBlocks;

figure;
semilogy(SNRdB,BER,'r','LineWidth',2.0,'MarkerSize',9.0);
grid on;
legend('BER_wireless');
xlabel('SNR(dB)');
ylabel('BER');
title('BER vs SNR(dB) for AWGN with BPSK');

blocklength = 1000;
nBlocks = 20000;
SNRdB = 0:1:15;
SNR = 10.^(SNRdB/10);
No = 1;
length_BER = length(SNR);
BER_BPSK = zeros(1, length_BER); % Initialize BER array

for blk = 1:nBlocks
    Bits = randi([0,1],1,blocklength);%1. Generate random bits of length equal to block length
    Sym = 2 * Bits - 1;%2. Generate BPSK symbols, ie map bit 1--->+1 and 0--->-1
    noise = sqrt(No/2)*(randn(1,blocklength) + 1j*randn(1,blocklength));% Generate of noise

    for K = 1:length(SNRdB)
        TxSym = sqrt(SNR(K))*Sym; %3. Transmit the symbols, adjust the amplitude of the symbols.
                % relative to the desired SNR at Kth index.
        RxSym = (TxSym) + noise;
       %4. Calculate the received symbol and decode the original bits.
        DecBits = (real(RxSym) > 0);%5 Make decision based on received symbols to recover the bits.
        BER_BPSK(K) = BER_BPSK(K) + sum(DecBits ~= Bits);%6. Calculate BER for each iteration.

    end
end

BER = BER_BPSK/blocklength/nBlocks; % Compute the Average BER

hold on;
semilogy(SNRdB,BER,'g','LineWidth',2.0,'MarkerSize',9.0);
grid on;
legend('BER');
xlabel('SNR(dB)');
ylabel('BER');
title('BER vs SNR(dB) for AWGN with BPSK');

hold on;
%BER_theoritical = qfunc(abs(h(1:16)).*(sqrt(2*SNR)));
semilogy(SNRdB,BER_theoritical,'b');
legend('BER_theoritical_wireless');
xlabel('SNR(dB)');
ylabel('BER');
title('BER vs SNR(dB) for AWGN with BPSK');
