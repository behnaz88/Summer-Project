
graph_inventory = [];

for buffer_capacity = 0:0.1:20
 
  x =  Average_graph_input(100000,1,1,buffer_capacity);
  graph_inventory = [graph_inventory x];
  
  
end


plot(0:0.1:20,graph_inventory)
