    
graph_inventory = [];

for mu1 = 0:0.1:2
 
  x =  Average_graph_input(100000,mu1,1,17);
  graph_inventory = [graph_inventory x];
  
  
end


plot(0:0.1:2,graph_inventory)
