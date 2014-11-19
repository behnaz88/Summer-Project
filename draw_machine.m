function draw_machine(temp, c)

m.t(1) = 0;
m.s(1) = 1;

[x y] = size(temp.time);
for i = 1 : y-1;
    m.t(i*2) = temp.time(i+1);
    m.t(i*2+1) = temp.time(i+1) + 0.00001;
    
    m.s(i*2) = temp.state(i);
    m.s(i*2+1) = temp.state(i+1);
end

hold;
plot(m.t, m.s, c);
hold;
end
