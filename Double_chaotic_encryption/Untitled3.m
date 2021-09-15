clear all;
close all;
clc;
IMGS = imread('./425gaopao.jpeg');
IMG = rgb2gray(IMGS);
IMG = imresize(IMG,[224,300]);   %²Ã¼ôÍ¼Ïñ
IMG1 = IMG;
IMG(192,270)
IMG1(192,270) = IMG(192,270) + 1;
t1 = mod(sum(sum(IMG)),256);
t1_s = mod(sum(sum(IMG1)),256);
[m,n] = size(IMG);
N = m * n;
N0 = N /2;
aver =  mean(sum(sum(IMG)));
aver1 =  mean(sum(sum(IMG1)));
x0 = aver / m;
y0 = aver / n;
x0_s= aver1 / m;
y0_s = aver1 / n;
h = mod(sum(sum(IMG)),N);
h1 = mod(sum(sum(IMG1)),N);
t0 = mod(sum(sum(IMG)),256);
t0_s = mod(sum(sum(IMG1)),256);
u1 = 0.995;
u2 = abs(sin(h * pi)/2) /10 + 0.8;
u2_s = abs(sin(h1 * pi)/2) /10 + 0.8;
num = t0 + N;
num1 = t0_s + N;
[xk1,yk1] = Logistic_2D(u1,u2,x0,y0,num);
[xk1_s,yk1_s] = Logistic_2D(u1,u2_s,x0_s,y0_s,num1);
% t1 = mod(N,1000);
options = odeset('RelTol',1e-3,'AbsTol',[1e-4 1e-4 1e-4]);
[T1,Y1] = ode45(@Liu_new,[0 2000],[0.18 1.05 0.11],options);
% figure(1)
% plot(Y1(:,1),Y1(:,2))

Y_new(:,1) = xk1(t0+1 : t0 + N)';
Y_new(:,2) = yk1(t0+1 : t0 + N)';
Y_new(:,3:5) = Y1(t1+1:t1 + N,:);

Y_new1(:,1) = xk1_s(t0_s + 1 : t0_s + N)';
Y_new1(:,2) = yk1_s(t0_s + 1 : t0_s + N)';
Y_new1(:,3:5) = Y1(t1_s+1:t1_s + N,:);





obj1 = image_encryption(IMG,m,n,Y_new);
blur_img1 = double(obj1.encryption());

obj2 = image_encryption(IMG1,m,n,Y_new1);
blur_img2 = double(obj2.encryption());

[NPCR,UACI]= diff_attack (blur_img1,blur_img2)    % ·ÖÎö²î·Ö¹¥»÷



