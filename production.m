function [production_rate] = production(run_duration,mu1,mu2,buffer_capacity)

[cop1 empty_buffer_time cop2 state_matrix2] = Inventory(run_duration,mu1,mu2,buffer_capacity);
operating_time = state_matrix2(1);
production_time = operating_time - empty_buffer_time;
production_amount = mu2 * production_time;
production_rate = production_amount/run_duration
end
