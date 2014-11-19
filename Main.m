function [ inventory,  machine10, state_matrix1, machine20, state_matrix2] = Main(run_duration, buffer_capacity, mu1, mu2)
% %run variables
% run_duration = 50;
% buffer_capacity = 10;
% mu1 = 4;
% mu2 = 2;

[inventory, T2, machine10, state_matrix1, machine20, state_matrix2] = Inventory(run_duration, mu1, mu2, buffer_capacity);
hold;
axis([0 run_duration+10 0 buffer_capacity+5]);
hold;
plot(inventory.time, inventory.value,'g');
end