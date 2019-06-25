clc; 
clear all;
close all;
x=input('Enter no of bits');
fc=x;
a=round(rand(1,x));
x1=10*x;
t=1/x1:1/x1:1;
b=repmat(a,1,10);
c=reshape(b,x,10);
d=c';e=d(:)';

%plotting input stream
t_1=t(:,1:100);
e_1=e(:,1:100);
subplot(5,1,1);plot(t_1,e_1);grid on;title('Original Data stream');

c1=sin(2*pi*fc*t);  %carrier with low frequency
c2=sin(2*pi*2*fc*t);  %carrier with high frequency
C1=c1(:,1:100);
C2=c2(:,1:100);

subplot(5,1,2);plot(t_1,C1);title('Carrier wave with low frequency');
subplot(5,1,3);plot(t_1,C2);title('Carrier wave with high frequency');
%fsk modulation
y=zeros(1,x1);
for i=1:x1
    if e(i)==1
        y(i)=c2(i);
    else
        y(i)=c1(i);
    end
end
Y=y(:,1:100);
subplot(5,1,4);plot(t_1,Y);title('FSK Modulated Wave');

%demodulation
y_1=zeros(1,x1);y_2=zeros(1,x1);
y_3=zeros(1,x1);y_4=zeros(1,x1);
y_1=y.*c1;  %correlation with first carrier wave
y_2=y.*c2;  %correlation with second carrier wave 

%integration of y_1 using cumsum
k=1;z1=zeros(1,x);
    for l=1:10:x1
    y_3(l:l+9)=cumsum(y_1(l:l+9)); 
    z1(k)=y_3(l+9); 
    k=k+1; 
    end
%integration of y_2using cumsum
  k=1;z2=zeros(1,x);
    for l=1:10:x1
    y_4(l:l+9)=cumsum(y_2(l:l+9)); 
    z2(k)=y_4(l+9); 
    k=k+1; 
    end
 %demodulation by comparing z1,z2
 k=1;
 for i=1:x
     if z2(i)>z1(i)
        a_1(k)=1;
     else 
         a_1(k)=0;
     end
     k=k+1;
 end
 %plotting the demodulated wave
 b_1=repmat(a_1,1,10); 
c_1=reshape(b_1,x,10); d_1=(c_1)';
e_2=d_1(:)';
E_2=e_2(:,1:100);
subplot(5,1,5);plot(t_1,E_2);title('Demodulated FSK Wave');

%adding noise
 k=1;
for i=[-10 -5 0 5]
n(k,:)=awgn(y,i,'measured'); 
k=k+1; 
end
figure;
k=1;str={'Signal with SNR @-10dB' 
    'Signal with SNR @-5dB' 
    'Signal with SNR @0dB' 
    'Signal with SNR @5dB'};
for i=1:4
    nn(i,:)=n(i,1:100);
end

for i=1:4
    subplot(4,1,i);plot(t_1,nn(k,:));grid on;title(str(i));
    k=k+1;
end

%multiplying noisy signals with carrier waves(stored in r and g)
for i=1:4 
    r(i,:)=(n(i,:).*c1); %multiplying with first carrier wave
end
for i=1:4 
    g(i,:)=(n(i,:).*c2); %multiplying with second carrier wave
end
for i=1:4
    rr(i,:)=r(i,1:100);
end
for i=1:4
    gg(i,:)=g(i,1:100);
end
figure;k=1;
str={'Signal at -10dB multiplied with first carrier wave of low frequency'
    'Signal at -5dB multiplied with first carrier wave of low frequency'
    'Signal at 0dB multiplied with first carrier wave of low frequency'
    'Signal at 5dB multiplied with first carrier wave of low frequency'};
for i=1:4
    subplot(4,1,i);plot(t_1,rr(k,:));grid on;title(str(i));
    k=k+1;
end
figure;k=1;
str={'Signal at -10dB multiplied with  carrier wave of high frquency'
    'Signal at -5dB multiplied with  carrier wave of high frequency'
    'Signal at 0dB multiplied with  carrier wave of high frequency'
    'Signal at 5dB multiplied with  carrier wave of high frequency'};
for i=1:4
    subplot(4,1,i);plot(t_1,gg(k,:));grid on;title(str(i));
    k=k+1;
end

%integrating r with cumsum
k=1;str={'Signal 1 Integrated  for SNR of -10dB' 
    'Signal 1 Integrated   for SNR of -5dB' 
    'Signal 1 Integrated   for SNR of 0dB' 
    'Signal 1 Integrated   for SNR of 5dB'}; 
figure;
for i=1:4
   X_1=r(i,:); 
   for l=1:10:x1
    Y_1(l:l+9)=cumsum(X_1(l:l+9)); 
    Z_1(k)=Y_1(l+9); 
    k=k+1; 
   end
   P_1(i,:)=Y_1; 
subplot(4,1,i); plot(t_1,P_1(i,1:100)); grid on;
title(str(i)); 
end
%integrating g with cumsum
figure;
k=1;str={'Signal 2 Integrated  for SNR of -10dB' 
    'Signal 2 Integrated  for SNR of -5dB' 
    'Signal 2 Integrated for SNR of 0dB' 
    'Signal 2 Integrated for SNR of 5dB'}; 
for i=1:4
   X_2=g(i,:); 
   for l=1:10:x1
    Y_2(l:l+9)=cumsum(X_2(l:l+9)); 
    Z_2(k)=Y_2(l+9); 
    k=k+1; 
   end
   P_2(i,:)=Y_2; 
subplot(4,1,i); plot(t_1,P_2(i,1:100)); grid on;
title(str(i)); 
end

v=zeros(1,4*x1); v1=0; o=1;
for i=1:4*x
if Z_2(i)>Z_1(i)
v1=ones(1,10);
else
v1=zeros(1,10);
end
v(1,((i-1)*10)+1:i*10)=v1;  
%v=[v v1];
end
u=reshape(v,x1,4);
u1=u';
str={'Retreived Binary Stream for SNR @-10dB' 
    'Retreived Binary Stream for SNR @-5dB' 
    'Retreived Binary Stream for SNR @0dB' 
    'Retreived Binary Stream for SNR @5dB'};
figure;
subplot(5,1,1);plot(t_1,e_1);grid on;title('Input Stream');k=2;

for i=1:4
subplot(5,1,k); plot(t_1,u1(i,1:100)); grid on; 
 title(str(i)); 
k=k+1;
end

%calculating error
be1=0;be2=0;be3=0;be4=0;
for i=1:(10*x)
    if e(1,i)~=u1(1,i)
        be1=be1+1;
    end
end
for i=1:(10*x)
    if e(1,i)~=u1(2,i)
        be2=be2+1;
    end
end
for i=1:(10*x)
    if e(1,i)~=u1(3,i)
        be3=be3+1;
    end
end
for i=1:(10*x)
    if e(1,i)~=u1(4,i)
        be4=be4+1;
    end
end
ber1=be1/(10*x);ber2=be2/(10*x);ber3=be3/(10*x);ber4=be4/(10*x);
T_1=[ber1 ber2 ber3 ber4];
T=[-10 -5 0 5];
figure;
semilogy(T,T_1,'linewidth',1),grid on;title('BER CURVE');xlabel('SNR');


