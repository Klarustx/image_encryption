%%% liuªÏ„ÁœµÕ≥%%%
function dy = Liu(t,y)
    a = 3.8;
    b = 2.5;
    c = 7;   
    dy = zeros(3,1);
    dy(1) =  a * (y(3) - y(1)) - y(2) * y(3);
    dy(2) =  b* y(1) + y(1) * y(3);
    dy(3) = -c * y(3) - 4 * y(1) * y(2);
end