
clc;
close all;
clear all;
 n=input('Enter number of bits');
 L=2.^n;%no of levels
 fm=2;fs=10*fm;
 
 a=2;
 t=0.001:0.001:1;
x=a*sin(2*pi*fm*t);
x1=x+a;
subplot(3,1,1);plot(t,x1);title('Level Shifted Message signal');
sq=square(2*pi*fs*t);
sq=(sq+1)./2;
subplot(3,1,2);plot(t,sq);title('Square signal for sampling');
 
samp=sq.*x1;
samp_1=zeros(1,length(samp));
subplot(3,1,3);plot(t,samp);title('Sampled Signal');
 
%quantization
ss=4/L;
X=linspace(0,4,L+1)
for d=1:L
for i=1:length(t)
      if samp(i)>=X(d) && samp(i)<=X(d+1)
          samp_1(i)=X(d);
      end
 end
end
 
figure;
subplot(2,1,1);plot(t,samp);title('Sampled Signal');
subplot(2,1,2);plot(t,samp_1);title('Quantized Signal');
 
%indexing for the purpose of encoding
index=zeros(1,length(t));
for i=1:length(t)
     index(i)=(samp_1(i)-0)/(ss);  %index=(sampled signal-Vmin)/(stepsize)
end
 
%encoding
en=de2bi(index,'left-msb');
figure;
en_1=en(:)';
subplot(2,1,1);plot(t,samp_1);title('Quantized Signal');
subplot(2,1,2);plot(en_1);title('Encoded Signal'); 
 
%decoding
de=bi2de(en,'left-msb');
de_1=(de*ss)+0;     %because 0 is vmin in this case
figure;
subplot(2,1,1);plot(t,samp_1);title('Quantized Signal');
subplot(2,1,2);plot(t,de_1);title('Decoded Signal');
 
%reverse operation of level shifting
de_2=de_1-a;
figure;
plot(t,x,'red',t,de_2,'blue');title('Original and Retrieved Signal');
legend('Original Signal','Retrieved Signal');
 
%design of filter
Wn=6*fm/1000;
figure;
[z,p]=butter(2,Wn,'Low');
f=filter(z,p,de_2);
 
[z_1,p_1]=butter(4,Wn,'Low');
f_1=filter(z_1,p_1,de_2);
 
[z_2,p_2]=butter(6,Wn,'Low');
f_2=filter(z_2,p_2,de_2);
 
plot(t,f,'green',t,f_1,'red',t,f_2,'blue');
title('Signals recovered for different order of Butterworth lpf');
legend('Response of order 2','Response of order 4','Response of order 6');






