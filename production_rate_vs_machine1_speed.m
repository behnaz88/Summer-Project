graph_production_rate1 = [];

for mu1 = 0.001:0.1:2.001
 
  [x cop] = system_control(50000,mu1,1,17);
  graph_production_rate1 = [graph_production_rate1 x];
  
  
end


plot(0.001:0.1:2.001,graph_production_rate1)
