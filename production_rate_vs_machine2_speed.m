graph_production_rate2 = [];

for mu2 = 0.001:0.1:2.001
 
  [x cop] = system_control(500000,1,mu2,17);
  graph_production_rate2 = [graph_production_rate2 x];
  
  
end


plot(0.001:0.1:2.001,graph_production_rate2)
