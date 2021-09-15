%%% liuªÏ„ÁœµÕ≥%%%
function dy = Liu_new(t,y)
    a = 10;
    b = 40;
    c = 2.5;
    d = 4;
    e = 1;
    dy = zeros(3,1);
    dy(1) =  a * (y(2) - y(1));
    dy(2) =  b* y(1) - e * y(1) * y(3);
    dy(3) = -c * y(3) + d * y(1) * y(1);
end