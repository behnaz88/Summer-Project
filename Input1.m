function [ critical_times,slopes, inventory_table, T2,machine1,state_matrix1,machine2,state_matrix2, simulation_results, mathematical_results] = Input1(run_duration,mu1,mu2,buffer_capacity)
    
    %initial values
    inventory.value = 5;
    inventory.time = 0;
    duration = run_duration;
   
    [machine1 state_matrix1] = Machine1( run_duration );
    [machine2 state_matrix2] = Machine2( run_duration );
    [cop n1] = size(machine1.time);
    [cop n2] = size(machine2.time);
    
    
    
    % For simulation:
   
    current_time = 0;
    iteration1 = 1;  %iteration over machine1 transition vector
    iteration2 = 1;  %iteration over machine2 transition vector
    i = 2;
    T1=0;          %For probability calculation
    T2=0;          %For probability calculation
    
    while( current_time < run_duration ) 
        
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
            inventory.time(i) = machine1.time(iteration1+1);
            iteration1 = iteration1 + 1;
        else
            inventory.time(i) = machine2.time(iteration2+1);
            iteration2 = iteration2 + 1;
        end
        
        inventory.value(i) = inventory.value(i-1) + (slope * (inventory.time(i)-inventory.time(i-1)));
        
        current_time = inventory.time(i);
        
        
        
        if (inventory.value(i) > buffer_capacity)
            temp = inventory.time(i);
               inventory.time(i) = inventory.time(i-1) + ((buffer_capacity - inventory.value(i-1))/slope);
            inventory.value(i) = buffer_capacity;
            
            i = i+1;
            
            inventory.time(i) = temp;
            inventory.value(i) = buffer_capacity;
            T1 = T1+(inventory.time(i) - inventory.time(i-1));    %For probability calculation (total amount of time with full buffer)
       elseif ((inventory.value(i)) < 0)
            temp = inventory.time(i);
            inventory.time(i) = inventory.time(i-1) + ((0-inventory.value(i-1))/slope);
            inventory.value(i) = 0;
            
            i = i+1;
            
            inventory.time(i) = temp;
            inventory.value(i) = 0;
            T2 = T2+(inventory.time(i) - inventory.time(i-1));    %For probability calculation (total amount of time with empty buffer)
        end
        
        if ( iteration1 > n1 || iteration2 > n2)
            break;
        end
        
        i = i + 1;
    end
    
    
    
    inventory_table = inventory;
    
    % Mathematical calculations 
    
    iteration1 = 1;
    iteration2 = 1;
    i = 2;
    j = 2;
    current_time = 0;
    mat_inventory.value = 5;
    mat_inventory.time=0;
    check = 1;
    
    
    while( current_time < run_duration ) 
        
        
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
        
        slopes(i-1) = slope; 
        
        if (slope > 0)
            
            tf = ((buffer_capacity - (mat_inventory.value(i-1)))/slope) + mat_inventory.time(i-1);
            
            if( tf <= mat_inventory.time(i))
                deltap = tf - mat_inventory.time(i-1);
            else
                deltap = mat_inventory.time(i)-mat_inventory.time(i-1);
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
        end
        
        
        %compare two inventory method
        
        while (inventory.time(j) < mat_inventory.time(i))
            j = j + 1;   %if there was a change in inventory values & time and no change in machines just ignore it and proceed
        end
        
        precision = 4;
        p = 10^precision;
        if round(inventory.value(j)*p) / p ~= round(mat_inventory.value(i) * p) / p
            check = 0;
        end
        
        
        
        current_time = mat_inventory.time(i);
        
        
        i= i+1;
        j = j + 1;
        
        
    end
    
    simulation_results = inventory.value;
    mathematical_results = mat_inventory.value
    
    
    if check == 1
        display('system is working fine');
    else
        display('there is a problem!!!');
    end
    
    
    critical_times = mat_inventory.time; 

    critical_times
    slopes
    
    


    %---------------------------Discrete Simulatoin----------------------
    discrete_simulation_time = discrete_simulation(machine1, machine2, mu1, mu2, run_duration, buffer_capacity, 5, 0.01);
    
    %fprintf(discrete_simulation_time);
    
               
        
end
    
    
    
    
    
    
    
