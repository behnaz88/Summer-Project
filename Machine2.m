function [ transition_matrix, state_matrix ] = Machine2( run_duration )

    %state imputatons
    %   1p:     1
    %   0p:     2

    %random variables
    meanp_p = 1/0.015;
    meanr_p = 1/0.15;
    
    %initial assumptions
    transition.time = 0;
    transition.state = 1;
    
    iteration = 1;

    while(transition.time(iteration) < run_duration)
         
        switch transition.state(iteration)
            case 1    %being in state 1-p
                rand1 = exprnd(meanp_p);
                transition.time(iteration+1) = transition.time(iteration) + rand1;
                transition.state(iteration+1) = 2;            
            case 2
                rand = exprnd(meanr_p);
                transition.time(iteration+1) = transition.time(iteration) + rand;
                transition.state(iteration+1) = 1;
        end
        
        iteration = iteration + 1;
    end
    %ToDo: cut the extra time
    [cop n] = size(transition.time);
    transition_matrix.time = transition.time(1:n-1);
    transition_matrix.time(n-1) = run_duration;
    
    transition_matrix.state = transition.state(1:n-1);
    transition_matrix.state(n-1) = transition.state(n-2);
    
    
    % Calculating the probability of being on each state
    state_matrix = zeros(1,2);
    [m1 m2] = size(transition_matrix.time);
    for j = 1:m2-1
       state_matrix(transition_matrix.state(j)) = state_matrix(transition_matrix.state(j)) + transition_matrix.time(j+1) - transition_matrix.time(j);
    end
    %state_matrix(transition_matrix.state(j)) = state_matrix(transition_matrix.state(j)) + run_duration - transition_matrix.time(j);
    probability_matrix2 = (state_matrix)/run_duration;
       
end