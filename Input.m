function [critical_times,slopes] = Input(duration,buffer_capacity, mu1, mu2)

    [machine1,w] = Machine1(duration);
    [machine2,w] = Machine2(duration);

    iteration1 = 1;
    iteration2 = 1;
    i = 2;
    j = 2;
    current_time = 0;
    mat_inventory.value = 5;
    mat_inventory.time=0;
    
    
    while( current_time < duration ) 
        
        
        if (machine1.state(iteration1) == 1) && (machine2.state(iteration2) == 1)      %both machines are working
            slope = mu1 - mu2;
        elseif (machine1.state(iteration1) == 1) && (machine2.state(iteration2) == 2)  %machine1 running and machine 2 not working
            slope  = mu1;
        elseif (machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 1) %machine1 not working and machine 2 working
            slope = -mu2;
        elseif (machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 2) %machine1 working and machine 2 not working
            slope = 0;
        end
        
        slopes(i-1) = slope; 
        
        if machine1.time(iteration1+1) < machine2.time(iteration2+1)
            mat_inventory.time(i) = machine1.time(iteration1+1);
            iteration1 = iteration1 + 1;
        else
            mat_inventory.time(i) = machine2.time(iteration2+1);
            iteration2 = iteration2 + 1;
        end 
        
        
        current_time = mat_inventory.time(i);
        
        
        i= i+1;
        j = j + 1;
        
        
    end
    
    
    critical_times = mat_inventory.time;    
        
end