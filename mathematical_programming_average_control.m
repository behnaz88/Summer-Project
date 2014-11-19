function average_inventory = mathematical_programming_average_control(times,slopes, run_duration, capacity)

    x = zeros(size(times));

    x(1)=5;

    sum = 0;

    for i = 1:size(times, 2)-1
        t = times(i);
        slopes(i);
        if (slopes(i) > 0)
            tf = ((10-x(i))/slopes(i)) + t;

            if(tf > times(i) && tf < times(i+1))
               deltap = tf-times(i);
               deltaf = times(i+1)-tf;
            else
               deltap = times(i+1)-times(i);
               deltaf = 0;
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

        sum = sum + (0.5 * ((x(i) + x(i+1)) * (deltap + deltae) + 2 * capacity * deltaf)); 
    end
    
    average_inventory = sum / run_duration;
end


