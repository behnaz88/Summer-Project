function [ inventory_table ] = Inventory( run_duration )
    
    %constants
    mu1 = 1.2;
    mu2 = 1;
    buffer_capacity = 10;
    
    %initial values
    inventory.value = 5;
    inventory.time = 0;
   
    machine1 = Machine1( run_duration );
    machine2 = Machine2( run_duration );
    [cop n1] = size(machine1.time);
    [cop n2] = size(machine2.time);
    
    current_time = 0;
    iteration1 = 1;  %iteration over machine1 transition vector
    iteration2 = 1;  %iteration over machine2 transition vector
    i = 2;
    while( current_time < run_duration && iteration1 < n1 && iteration2 < n2)
        
        if machine1.time(iteration1) < machine2.time(iteration2)
            inventory.time(i) = machine1.time(iteration1);
            iteration1 = iteration1 + 1;
        else
            inventory.time(i) = machine2.time(iteration2);
            iteration2 = iteration2 + 1;
        end
        
        current_time = inventory.time(i);
        
        if (machine1.state(iteration1) == 1 || machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 6)      %both machines are working
            slope = mu1 - mu2;
        elseif (machine1.state(iteration1) == 1 || machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 7) %machine1 running and machine 2 not working
            slope  = mu1;
        elseif (machine1.state(iteration1) == 3 || machine1.state(iteration1) == 4 || machine1.state(iteration1) == 5) && (machine2.state(iteration2) == 6) %machine1 not working and machine 2 working
            slope = -mu2;
        elseif (machine1.state(iteration1) == 3 || machine1.state(iteration1) == 4 || machine1.state(iteration1) == 5) && (machine2.state(iteration2) == 7) %machine1 working and machine 2 not working
            slope = 0;
        end
        
        %ToDo: stop working after passing capacity or dropping zero
        inventory.value(i) = inventory.value(i-1) + slope * (inventory.time(i)-inventory.time(i-1));
        i = i + 1;
    end
    
    inventory_table = inventory;
end

