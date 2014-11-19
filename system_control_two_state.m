function [production_rate inventory] = system_control_two_state(run_duration,mu1,mu2,buffer_capacity)
    

    P1 = 0.01;
    R1 = 0.1;
    P2 = 0.05;
    R2 = 0.1;
    [inventory cop1 machine1 cop2 machine2 cop3] = Inventory_two_state(run_duration,mu1,mu2,buffer_capacity);
    hold;
    axis([0 run_duration+10 0 buffer_capacity+5]);
    hold;
    plot(inventory.time, inventory.value,'g');
    [cop n] = size(inventory.time);
    
    %For Machine1:
    iter1 = 1;    %iteration over machine1 
    %iter2 = 1;    %iteration over machine2
%     full_time1 = 0;
%     not_full_time1 = 0;
%     empty_time1 = 0;
%     
    %iter1 = 1;    %iteration over machine1 
    iter2 = 1;    %iteration over machine2
%     full_time2 = 0;
%     not_full_time2 = 0;
%     empty_time2 = 0;
    
%   for iter = 1 : n-1   
%         if (machine1.state(iter1) == 1)
%             if (inventory.value(iter) == buffer_capacity && inventory.value(iter+1) == buffer_capacity && machine2.state(iter2) == 1)
%                 full_time1 = full_time1 + inventory.time(iter+1) - inventory.time(iter);
%             elseif ((inventory.value(iter+1) ~= inventory.value(iter)))
%                 not_full_time1 = not_full_time1 + inventory.time(iter+1) - inventory.time(iter);
%             elseif (inventory.value(iter) == 0 && inventory.value(iter+1) == 0 && machine2.state(iter2) == 1)
%                 empty_time1 = empty_time1 + inventory.time(iter+1) - inventory.time(iter);
%             end
%         end
%             
%         
%         if (machine2.state(iter2) == 1)
%             if(inventory.value(iter) == buffer_capacity && inventory.value(iter+1) == buffer_capacity && machine1.state(iter1) == 1)
%                 full_time2 = full_time2 + inventory.time(iter+1) - inventory.time(iter);
%             elseif ((inventory.value(iter) ~= inventory.value(iter+1)))
%                 not_full_time2 = not_full_time2 + inventory.time(iter+1) - inventory.time(iter);
%             elseif (inventory.value(iter) == 0 && inventory.value(iter+1) == 0 && machine1.state(iter1) ==1)
%                 empty_time2 = empty_time2 + inventory.time(iter+1) - inventory.time(iter);
%             end
%         end
%     
%        
%         %iterate over machine1
%         if (inventory.time(iter+1) == machine1.time(iter1+1))
%             iter1 = iter1 + 1;
%         end
%         %iterate over machine2
%         if (inventory.time(iter+1) == machine2.time(iter2+1))
%             iter2 = iter2 + 1;
%         end
%         
%    end
%     
%     full1 = full_time1;
%     not_full1 = not_full_time1;
%     empty1 = empty_time1;
%     full2 = full_time2;
%     not_full2 = not_full_time2;
%     empty2 = empty_time2;
A1 = 0;
A2 = 0;
A3 = 0;
A4 = 0;
    for iter = 1 : n-1 
        if(machine1.state(iter1) == 1 && machine2.state(iter2) == 2 && inventory.value(iter) == buffer_capacity && inventory.value(iter+1) == buffer_capacity )
            A1 = A1 + inventory.time(iter+1) - inventory.time(iter);
        end
        if(machine1.state(iter1) == 1 && machine2.state(iter2) == 1 && inventory.value(iter) == buffer_capacity && inventory.value(iter+1) == buffer_capacity )
           A2 = A2 + inventory.time(iter+1) - inventory.time(iter); 
        end
        if(machine1.state(iter1) == 2 && machine2.state(iter2) == 1 && inventory.value(iter) == 0 && inventory.value(iter+1) == 0 )
           A3 = A3 + inventory.time(iter+1) - inventory.time(iter); 
        end
        if(machine1.state(iter1) == 1 && machine2.state(iter2) == 1 && inventory.value(iter) == 0 && inventory.value(iter+1) == 0 )
           A4 = A4 + inventory.time(iter+1) - inventory.time(iter); 
        end
        %iterate over machine1
        if (inventory.time(iter+1) == machine1.time(iter1+1))
            iter1 = iter1 + 1;
        end
        %iterate over machine2
        if (inventory.time(iter+1) == machine2.time(iter2+1))
            iter2 = iter2 + 1;
        end
    end
    
    blocking_probability = (A1/run_duration)+((1-(mu2/mu1))*(A2/run_duration));
    starving_probability = (A3/run_duration)+((1-(mu1/mu2))*(A4/run_duration));
    if (mu2>mu1)
           production_rate = mu1*(R1/(R1+P1))*(1-blocking_probability)
    else 
           production_rate = mu2*(R2/(R2+P2))*(1-starving_probability)  
    end
    
%     % Production rate control
%     machine1_produced_amount = (full_time1/run_duration)*mu2+(not_full_time1/run_duration)*mu1+(empty_time1/run_duration)*mu1
%     machine2_produced_amount = (full_time2/run_duration)*mu2+(not_full_time2/run_duration)*mu2+(empty_time2/run_duration)*mu1
%     
%     m1p = (full_time1)*mu2+(not_full_time1)*mu1+(empty_time1)*mu1
%     m2c = (full_time2)*mu2+(not_full_time2)*mu2+(empty_time2)*mu1
%     inventory.value(n)
%     sum2 = m2c + inventory.value(n) - inventory.value(1)
    
    %Average inventory in process:
    
    sum = 0;
    for i  = 1 : n-1
        if (inventory.value(i) ~= inventory.value(i+1) )
            sum  = sum + (((inventory.value(i) + inventory.value(i+1)) * (inventory.time(i+1) - inventory.time(i)))/ 2);
        else
            sum = sum + ((inventory.value(i)) * (inventory.time(i+1) - inventory.time(i))); 
        end
    end
    
    average_inventory = sum/run_durationa
    
    
    
    
    
end
