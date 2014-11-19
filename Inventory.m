function [ inventory_table, T2,machine1,state_matrix1,machine2,state_matrix2] = Inventory(run_duration,mu1,mu2,buffer_capacity)
    
    %initial values
    inventory.value = 5;
    inventory.time = 0;
   
    [machine1 state_matrix1] = Machine1( run_duration );
    [machine2 state_matrix2] = Machine2( run_duration );
    %axis([-5 run_duration+50 -5 buffer_capacity+5]);
    %hold;
    %draw_machine(machine1, 'r');
    %axis([-5 run_duration+50 -5 buffer_capacity+5]);
    %hold;
    %draw_machine(machine2, 'b');
    %hold;
    [cop n1] = size(machine1.time);
    [cop n2] = size(machine2.time);
    
    
    
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
    
    
    
    full_buffer_probability = T1/run_duration ;
    empty_buffer_probability = T2/run_duration;
   
    inventory_table = inventory;
    
    
    % For performance evaluation 1:
%     
%     machine1.time = [machine1.time 0 0];
%     machine1.state = [machine1.state 0 0];
%     machine2.time = [machine2.time 0 0];
%     machine2.state = [machine2.state 0 0];
%     
%     iteration1 = 1;
%     iteration2 = 1;
%     slopes = zeros(1, size(inventory.time,2)-1);
%     for i = 1:size(inventory.time, 2)-1
%         
%         
%         if (machine1.state(iteration1) == 1) && (machine2.state(iteration2) == 1)      %both machines are working
%             s = mu1 - mu2;
%             %slope = [slope mu1 - mu2];
%         elseif (machine1.state(iteration1) == 1) && (machine2.state(iteration2) == 2)  %machine1 running and machine 2 not working
%             s = mu1;
%             %slope  = [slope mu1];
%         elseif (machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 1) %machine1 not working and machine 2 working
%             s = - mu2;
%             %slope = [slope -mu2];
%         elseif (machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 2) %machine1 working and machine 2 not working
%             s = 0;
%             %slope = [slope 0];
%         end
%          
%         %if there were a change in inventory without change in machines
%         %i's slope = 0
%         t = inventory.time(i);
%         if t ~= machine1.time(iteration1) && t ~= machine2.time(iteration2)
%             s = 0;
%         end
%         
%         t = inventory.time(i+1);
%         
%         if (t == machine1.time(iteration1+1))
%             iteration1 = iteration1+1;
%         elseif (t == machine2.time(iteration2+1))
%             iteration2 = iteration2+1;
%         end
%         
%         slopes(i) =  s;
%     end
%     machine1.state;
%     machine2.state;
%     slopes
%     mathematical_programming(inventory.time,inventory.value,slopes);
%     
%      while( current_time < run_duration ) 
        
    
    % For performance evaluation 2:
    
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
    
    inventory.value;
    mat_inventory.value;
    
    
    if check == 1
        display('system is working fine');
    else
        display('there is a problem!!!');
    end
    
    
        
        
end