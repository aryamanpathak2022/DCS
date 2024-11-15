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
BER_pCSI = zeros(size(SNRdb)); % BER of perfect chanel
BER_imCSI = zeros(size(SNRdb)); % BER of imperfect or estimated channel
hEstErr = zeros(size(SNRdb)); % Channel estimation error

for blk = 1:nBlocks
    h = (randn + 1i*randn) / sqrt(2); % 1. Generate complex gaussian channel
    Bits = randi([0 1], 1, blockLength);% 2. Generate bits of length equal to blocklength
    Sym = 2*Bits - 1;  % BPSK modulation (0 -> -1, 1 -> +1)  % 3. BPSK modulation
    pSym =  2*randi([0 1], 1, nPilot) - 1;  % 4. generate/get nPilot number of pilot symbols
    pNorm =  nPilot;   % 5. Calculate the norm square of pilot symbols
    noise =sqrt(No/2) * (randn(1, blockLength)); % Generate complex noise of variance N0 
    for K = 1: length(SNRdb)
        TxSym = Sym; % Generate transmit symbol 
        RxSym = h * TxSym + noise; % Calculate the received symbol
        pObser = RxSym(1:nPilot);   % Get the reveived observation vector corresponding to the pilot symbols
        hEst = sum(pObser .* conj(pSym)) / pNorm; % calculate estimated channel
        hEstErr(K) =  % Calculate channel estimation error
        EqSym_pCSI =  % Equlization of perfect channel
        Decbits_pCSI =  % Make decision based on received symbols to recover the bits under perfect channel
        BER_pCSI(K) =  % Calculate BER of perfect channel
        EqSym_imCSI = % Equlization of estimated/imperfect channel
        Decbits_imCSI = %Make decision based on received symbols to recover the bits under imperfect channel
        BER_imCSI(K) =  % Calculate BER of imperfect channel
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


