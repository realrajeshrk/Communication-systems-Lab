clc;
close all;
clear all;
n=7;%length of code word is 7
k=4;%length of message is 4
I=eye(4,4);%creating identity matrix
m1=I(:,1);m2=I(:,2);m3=I(:,3);m4=I(:,4);
p_1=xor(m1,m2);p1=xor(p_1,m3);
p_2=xor(m2,m3);p2=xor(p_2,m4);
p_3=xor(m1,m3);p3=xor(p_3,m4);
G=[p1 p2 p3 m1 m2 m3 m4] %generator matrix
P=G(:,1:3);%parity matrix
P_1=P';I_1=eye(3,3);
H=[I_1 P_1] %parity check matrix
X=zeros(1,4);
X=input('Enter 4 bits as message');
code=zeros(1,7);
code_1=X*G;
code=zeros(1,length(code));%generating codeword
for i=1:length(code_1)
code(i)=mod(code_1(i),2);%modulo2 operation
end
code
pos=input('Enter position for introducing error');%position for introducing error
ercode=code;
ercode(pos)=not(code(pos));
ercode
H_T=H';
syndrome_1=ercode*H_T;%calculating syndrome
syndrome=zeros(1,3);
for i=1:length(syndrome_1)
syndrome(i)=mod(syndrome_1(i),2);%modulo2 operation on syndrome
end
syndrome
syndrome_2=syndrome';k=1;erpos=0;
for i=1:7
if syndrome_2==H(:,k)
erpos=k %finding out the error position by comparing syndrome and parity check matrix
end
k=k+1;

end
rectified=ercode;
rectified(erpos)=not(ercode(erpos)); %negating the bit at the specified error position
rectified