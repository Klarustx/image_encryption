%»­Ë«ÖØLogisticÓ³Éä·Ö²íÍ¼
clear
clc
close all
u1 = 0.995;
count = 1;
num = 200;

u2 = linspace(0,1,200);
for k = 1 : 200
     x0 = 0.01;
     y0 = 0.02;
     for p  = 1 : 200
        xn = 4 * u1 * x0 *(1 - x0) + (1 - u1) * x0 * y0; 
        yn = 4 * u2(k) * y0 *(1 - y0) + (1 - u2(k)) * x0 * y0;
        if p < 50
            plot(0,0)
        else
            hold on
            plot(u2(k),xn,'k')
        end
        x0 = xn;
        y0 = yn;
     end
end
grid on 
xlabel('u_2')
ylabel('x')
% for u2 = 0 : 0.1 : 1
%    [xk,yk] = Logistic_2D(u1,u2,x0,y0,num);
%    u(count) = xk;
%    x(count) = xk;
% end