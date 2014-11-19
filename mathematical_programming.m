function mathematical_programming(times,values,slopes)

x = zeros(size(times));

x(1)=5;

for i = 1:size(times, 2)-1
    t = times(i);
    slopes(i);
    if (slopes(i) > 0)
        tf = ((10-x(i))/slopes(i)) + t;
        
        if(tf > times(i) && tf < times(i+1))
           deltap = tf-times(i);
        else
           deltap = times(i+1)-times(i);
        end
        
        x(i+1) = x(i) + slopes(i) * deltap;
    elseif (slopes(i) < 0)
        te = ((-x(i))/slopes(i))+ t;
        %te = [te tet];
        if(te > times(i) && te < times(i+1))
           deltae =  te - times(i);
        else
           deltae = times(i+1)-times(i);
        end
        
        x(i+1) = x(i) + deltae * slopes(i);
    else
        x(i+1) = x(i);
    end
end


x
values

check = 1;

for i = 1 : size(times,2)
    if(x(i) ~= values(i))
        check = 0;
        %break;
    end
end
        
   
if(check == 1)
    display('it is working fine');
else
    display('there is a problem!!!');
end

end