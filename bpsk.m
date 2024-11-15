% Bit Error Rate For WireLess Channel
% Now The recieved signal is: r(t) = h*x(t) + n(t)
% At the reciever we need to equalize it (Removing the channel Effect)

% BPSK

close all;
clc;

blocklength = 1000;
nBlocks = 20000;

SNRdB = 0:1:15;
SNR = 10.^(SNRdB / 10); % Converting dB to a linear scale

No = 1;

BER_BPSK_Wireless = zeros(1, length(SNRdB)); % Initialize the BER array

BER_BPSK_Theoretical = zeros(1, length(SNRdB)); % Initialize the BER array


for blk = 1:nBlocks
    
    h = randn(1, 1) + 1i * randn(1, 1); % Introduce the Channel
    Bits = randn(1, blocklength); % Generate random bits of length equal to block length
    Bits = Bits >= 0; % If value >= 0, it is 1; otherwise, 0

    sym = 2* (Bits) -1; % This is the symbol transmitted. map 1 --> 1 and 0 --> -1 (FOR BPSK)

    noise = sqrt(No/2).*(randn(1, blocklength)) + (1i * randn(1, blocklength)); % Generate Complex Noise

    for k = 1:length(SNRdB)

        TxSym =  sym*sqrt(SNR(k)); % Transmit the symbol and adjust the amplitude of the symbol relative to the desired SNR at kth index

        RxSym_Wireless = h.*TxSym + noise; % Calculate the recieved signal and decode the original bits
        % RxSym = TxSym + noise;

        DecodedBits_Wireless = real(RxSym_Wireless ./ h) > 0; % Make Descisions based on recieved signal
        % DecodedBits = real(RxSym ./ h) > 0;

        BER_BPSK_Wireless(k) = BER_BPSK_Wireless(k) + sum(DecodedBits_Wireless ~= Bits);
        
        % BER_BPSK_Theoretical(k) = BER_BPSK_Theoretical()

    end
    BER_BPSK_Theoretical(k) = BER_BPSK_Theoretical(k) + qfunc(abs(h)*sqrt(SNR(k)));
end

BER_BPSK_Wireless = BER_BPSK_Wireless / blocklength / nBlocks;
BER_BPSK_Theoretical = BER_BPSK_Theoretical / nBlocks;
semilogy(SNRdB,BER_BPSK_Wireless,'g','LineWidth',2.0,'MarkerSize',9.0);
hold on
semilogy(SNRdB,BER_BPSK_Theoretical,'r--','LineWidth',2.0,'MarkerSize',9.0);
grid on;
legend('BER');
xlabel('SNR(db)');
ylabel('Bit Error Rate');
title('BER vs SNR(db) for Wireless with BPSK');