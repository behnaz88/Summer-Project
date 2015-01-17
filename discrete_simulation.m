function [computation_time] = discrete_simulation(machine1, machine2, mu1, mu2, run_duration, buffer_capacity, x0, dt)

    tic;
    
    
    
    
    %dt = 0.001;
    T = 0:dt:run_duration;
    inventory = zeros(length(T));

    iteration1 = 1;
    iteration2 = 1;
    counter = 1;
    inventory(counter) = x0;

    for t=T
        counter = counter + 1;
        
        
        if (machine1.state(iteration1) == 1 || machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 1)      %both machines are working
            slope = mu1 - mu2;
        elseif (machine1.state(iteration1) == 1 || machine1.state(iteration1) == 2) && (machine2.state(iteration2) == 2)  %machine1 running and machine 2 not working
            slope  = mu1;
        elseif (machine1.state(iteration1) == 3 || machine1.state(iteration1) == 4 || machine1.state(iteration1) == 5) && (machine2.state(iteration2) == 1) %machine1 not working and machine 2 working
            slope = -mu2;
        elseif (machine1.state(iteration1) == 3 || machine1.state(iteration1) == 4 || machine1.state(iteration1) == 5) && (machine2.state(iteration2) == 2) %machine1 not working and machine 2 not working
            slope = 0;
        end
        
        temp = inventory(counter - 1) + (slope * dt);
        if temp < 0
            temp = 0;
        elseif temp > buffer_capacity
            temp = buffer_capacity;
        end
        
        inventory(counter) = temp;
        
        if t+dt >= machine1.time(iteration1)
            iteration1 = iteration1 + 1;
            if iteration1 > length(machine1.time)
                break;
            end
        end
        if t+dt >= machine2.time(iteration2)
            iteration2 = iteration2 + 1;
            if iteration2 > length(machine2.time)
                break;
            end
        end
    end
    
    
    
    computation_time = toc;
    
    
    plot(T, inventory)
end