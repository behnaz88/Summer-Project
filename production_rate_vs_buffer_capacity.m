graph_production_rate = [];

for buffer_capacity = 0:0.1:20
 
  [x cop] = system_control(500000,1,1,buffer_capacity);
  graph_production_rate = [graph_production_rate x];
  
  
end


plot(0:0.1:20,graph_production_rate)