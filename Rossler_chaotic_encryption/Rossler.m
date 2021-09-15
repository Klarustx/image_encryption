%%% Rossler超混沌系统%%%
function dy = Rossler(t,y)
    a = 0.25;
    b = 3;
    c = 0.05;
    d = 0.5;
   
    dy = zeros(4,1);
    dy(1) =  -y(2) - y(3);
    dy(2) =  y(1) + a * y(2) + y(4);
    dy(3) = b + y(3) * y(1);
    dy(4) = c * y(4) - d * y(3);
end
