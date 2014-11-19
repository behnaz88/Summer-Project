function [ inventory_averages] = Average_graph_input(run_duration,mu1,mu2,buffer_capacity)

    %initial values
    inventory.value = 5;
    inventory.time = 0;

    [machine1 state_matrix1] = Machine1( run_duration );
    [machine2 state_matrix2] = Machine2( run_duration );
    
    [cop n1] = size(machine1.time);
    [cop n2] = size(machine2.time);

    

    iteration1 = 1;
    iteration2 = 1;
    i = 2;
    j = 2;
    current_time = 0;
    mat_inventory.value = 5;
    mat_inventory.time=0;

    sum = 0;

    while( current_time < run_duration )


        deltae = 0;
        deltap = 0;
        deltaf = 0;
        
       if (machine1.state(iteration1) == 1 || machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 1)      %both machines are working
            slope = mu1 - mu2;
        elseif (machine1.state(iteration1) == 1 || machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 2)  %machine1 running and machine 2 not working
            slope  = mu1;
        elseif (machine1.state(iteration1) == 3 || machine1.state(iteration1) == 4 || machine1.state(iteration1) == 5) && (machine2.state(iteration2) == 1) %machine1 not working and machine 2 working
            slope = -mu2;
        elseif (machine1.state(iteration1) == 3 || machine1.state(iteration1) == 4 || machine1.state(iteration1) == 5) && (machine2.state(iteration2) == 2) %machine1 not working and machine 2 not working
            slope = 0;
        end


        if machine1.time(iteration1+1) < machine2.time(iteration2+1)
            mat_inventory.time(i) = machine1.time(iteration1+1);
            iteration1 = iteration1 + 1;
        else
            mat_inventory.time(i) = machine2.time(iteration2+1);
            iteration2 = iteration2 + 1;
        end


        if (slope > 0)

            tf = ((buffer_capacity - (mat_inventory.value(i-1)))/slope) + mat_inventory.time(i-1);    %time to reach capacity

            if( tf <= mat_inventory.time(i))
                deltap = tf - mat_inventory.time(i-1);
                deltaf = mat_inventory.time(i)-tf;     %i is already 2 at the first step!!!
            else
                deltap = mat_inventory.time(i)-mat_inventory.time(i-1);
                deltaf = 0;
            end

            mat_inventory.value(i) = mat_inventory.value(i-1) + slope * deltap;

        elseif (slope < 0)
            te = (-(mat_inventory.value(i-1))/slope)+ mat_inventory.time(i-1);

            if(te <= mat_inventory.time(i))
                deltae =  te - mat_inventory.time(i-1);
            else
                deltae = mat_inventory.time(i)-mat_inventory.time(i-1);
            end

            mat_inventory.value(i) = mat_inventory.value(i-1) + deltae * slope;
        elseif (slope == 0)
            mat_inventory.value(i) = mat_inventory.value(i-1);
            deltap = mat_inventory.time(i) - mat_inventory.time(i-1);
        end


        current_time = mat_inventory.time(i);
        

        
        sth =  (0.5 * ((mat_inventory.value(i-1) + mat_inventory.value(i)) * (deltap + deltae) + 2 * buffer_capacity * deltaf));
        sum = sum + sth;
        
        i= i+1;
        j = j + 1;


    end
    
    mat_inventory_average = sum / run_duration;

    sum = 0;
    for i  = 1 : size(inventory.value,2)-1
        sth = (((inventory.value(i) + inventory.value(i+1)) * (inventory.time(i+1) - inventory.time(i)))/ 2);
        sum  = sum + sth;
    end

     inventory_averages = sum/run_duration;
     
     inventory_averages = mat_inventory_average;
     


end