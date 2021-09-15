%%% ¶þÎ¬ñîºÏLogisticÓ³Éä%%%
function [xk,yk] = Logistic_2D(u1,u2,x0,y0,num)
    x = 0.01;
    y = 0.02;
    k = 1 ;
   while(k <= num)
       x = 4 * u1 * x *(1 - x) + (1 - u1) * x * y; 
       y = 4 * u2 * y *(1 - y) + (1 - u2) * x * y;
       xk(k) = x;
       yk(k) = y;
       k = k+1;
   end
end