
IMGS = imread('./425gaopao.jpeg');
IMG = rgb2gray(IMGS);
IMG = imresize(IMG,[224,300]);   %²Ã¼ôÍ¼Ïñ
IMG1 = IMG;
IMG(132,56)
IMG1(132,56) = IMG(132,56) + 1;
t1_s = mod(sum(sum(IMG1)),256);
[m,n] = size(IMG1);
N = m * n;
N0 = N /2;
aver =  mean(sum(sum(IMG1)));
x0 = aver / m;
y0 = aver / n;
h = mod(sum(sum(IMG1)),N);
t0 = mod(sum(sum(IMG1)),256);
u1 = 0.995;
u2 = abs(sin(h * pi)/2) /10 + 0.8;
num = t0 + N;
[xk1,yk1] = Logistic_2D(u1,u2,x0,y0,num);
options = odeset('RelTol',1e-3,'AbsTol',[1e-4 1e-4 1e-4]);
[T1,Y1] = ode45(@Liu_new,[0 2000],[0.18 2.05 12.11],options);
% figure(1)
% plot(Y1(:,1),Y1(:,2))
Y_new1(:,1) = xk1(t0+1 : t0 + N)';
Y_new1(:,2) = yk1(t0+1 : t0 + N)';
Y_new1(:,3:5) = Y1(t1+1 : t1 + N,:);

obj2 = image_encryption(IMG1,m,n,Y_new1);
blur_img2 = obj2.encryption();

% obj2 = image_encryption(IMG1,m,n,New_Y2);
% blur_img2 = obj2.encryption();

%  deblur_img = obj1.decryption(blur_img1);

[NPCR,UACI]= diff_attack (blur_img1,blur_img2)    % ·ÖÎö²î·Ö¹¥»÷

