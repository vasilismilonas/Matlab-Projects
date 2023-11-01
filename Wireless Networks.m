clear
N = 10^6; % number of bits or symbols
rand('seed',1); % initializing the rand() function so that random bits produced 
% are same in every simulation
% Transmitter
ip1 = rand(1,N/2)>0.5; % using rand() generate a (1,N/2) vector with zeros and ones 
% representing x1
ip2 = rand(1,N/2)>0.5; % using rand() generate a (1,N/2) vector with zeros and ones
% representing x2
ip=[ip1;ip2];
% BPSK modulation 

m1 = 2*ip1-1;
m2 = 2*ip2-1; % transform ip2 so as 0s become -1s and 1s remain 1s
msg=[m1;m2;];
SNR = -3:10 ; % in dB
nErr=zeros(length(SNR),1); %initializing error with 0.
h= [1.0 0.0; 0.0 1.0]; % define a transition matrix where h1,1=1 h1,2=0 h2,1=0 and h2,2=1
hin= pinv(h); % using pinv define the pseudo-reverse matrix of h
s = [h(1,1),h(1,2); h(2,1) h(2,2)]* msg; % calculate output as defined in equation (3) 
% without the noise factor [n1;n2]
for ii = 1:length(SNR)
 %Addition Of Noise 
 y = awgn(s,SNR(ii)); %using awgn() add the current value of SNR vector to s as 
%noise
 
 % receiver - zero forcing decoding
 
 xg = hin * y; % using the calculated y output considering noise and hin 
%calculate.
 % the input that would have led to y
 sr = real(xg) > 0;
 % counting the errors
 nErr(ii) = size(find(ip - sr),1);
end
simBer = nErr/N; % simulated ber
%plot
close all
figure
semilogy(SNR,simBer,'b.-');
axis([-3 10 10^-4 0.6])
grid on
legend( 'simulation');
xlabel('SNR, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for BPSK modulation');