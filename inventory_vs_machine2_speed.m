
graph_inventory = [];

for mu2 = 0:0.1:2
 
  x =  Average_graph_input(100000,1,mu2,17);
  graph_inventory = [graph_inventory x];
  
  
end


plot(0:0.1:2,graph_inventory)
