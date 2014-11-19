function [A,A_prim,b,b_prim] = matrix_generator1(duration, buffer_capacity)

    [critical_time, slopes] = Input(duration, buffer_capacity, 1.2, 1);
    n =   size(slopes);
    A = zeros(7 * n + 1, 9 * n + 1);
    b = zeros(7 * n + 1, 1);
    
    x0 = 5;
    
    
    for i = 1 : n
        %x(t_{i+1}) = x(t_i) + deltaP_i * u_i
        A(i+1,i+1) = 1; %x(t_{i+1})
        A(i,i) = -1;    %x(t_i)
        if(slopes(i) > 0)
            A(i+1, n + i + 1) = -slopes(i);   %deltaP_i * u_i
        elseif(slopes(i)<0)
            A(i+1, 3 * n + i + 1) = -slopes(i);  %deltaE_i * u_i
        end
        
        
        %deltaP_i = t_{i+1} - t_i - deltaf_i-
        A(n + i + 1, n + 1 + i) = 1;       %deltaP_i
        A(n + i + 1, 6 * n + i + 1) = 1;   %deltaF_i
        b(n + i + 1,1) = critical_time(i+1)-critical_time(i);
         
        
        %delta f_i
        A(2 * n + i + 1, 2 * n + i + 1) = 1;       %deltaF_i
        A(2 * n + i + 1, i + 1) = -1 / slopes(i);  %1/u_i
        A(2 * n + i + 1, 5 * n + i + 1) = -1;      %deltaF_i+ 
        b(2 * n + i + 1,1) = critical_time(i+1)-critical_time(i)-(buffer_capacity/slopes(i));   
        
        %delta f_+ & f_-
        A(3 * n + i + 1, i + 1) = -1/slopes(i);    %1/u_i
        A(3 * n + i + 1, 5 * n + i + 1) = -1;      %deltaF_i+
        A(3 * n + i + 1, 6 * n + i + 1) = 1;       %deltaF_i-
        b(3 * n + i + 1,1) = critical_time(i+1)-critical_time(i)+(buffer_capacity/slopes(i));
        
        %delta e_i
        A(4 * n + i + 1, 3 * n + i + 1) = 1;   %deltaE_i
        A(4 * n + i + 1, 8 * n + i + 1) = 1;   %deltaZ_i
        b(4 * n + i + 1,1) = critical_time(i+1)-critical_time(i);
        
        %delta z_i
        A(5 * n + i + 1, 4 * n + i + 1) = 1;    %deltaZ_i
        A(5 * n + i + 1, i + 1) = -1/slopes(i); %1/u_i
        A(5 * n + i + 1, 7 * n + i + 1) = -1;   %deltaZ_i+
        b(5 * n + i + 1,1) = critical_time(i+1)-critical_time(i);
        
        %delta z_+ & z_-
        A(6 * n + i + 1, i + 1) = -1/slopes(i);  %1/u_i
        A(6 * n + i + 1, 7 * n + i + 1) = -1;    %deltaZ_i+
        A(6 * n + i + 1, 8 * n + i + 1) = 1;     %deltaZ_i-
        b(6 * n + i + 1,1) = critical_time(i+1)-critical_time(i);
        
    end
    

    
    
    
    
    A_prim = zeros(9 * n + 1, 9 * n + 1);
    b_prim = zeros(9 * n + 1, 1);
   
    
    for i = 1:n
        
        A_prim( i + 1, i + 1) = -1;
         
      if(slopes(i) > 0)
          
          A_prim(n + i + 1, 5 * n + i + 1) = 1;
          A_prim(2 * n + i + 1, 6 * n + i + 1) = 1;
          A_prim(3 * n + i + 1, 5 * n + i + 1) = -1;
          A_prim(4 * n + i + 1, 6 * n + i + 1) = -1;
          b_prim(n + i + 1, 1) = 0;
          b_prim(2 * n + i + 1, 1) = 0;
          b_prim(3 * n + i + 1, 1) = 0;
          b_prim(4 * n + i + 1, 1) = 0;
          
          
          
          
      elseif(slopes(i) < 0)
          
          A_prim(5 * n + i + 1, 7 * n + i + 1) = 1;
          A_prim(6 * n + i + 1, 8 * n + i + 1) = 1;
          A_prim(7 * n + i + 1, 7 * n + i + 1) = -1;
          A_prim(8 * n + i + 1, 8 * n + i + 1) = -1;
          b_prim(5 * n + i + 1, 1) = 0;
          b_prim(6 * n + i + 1, 1) = 0;
          b_prim(7 * n + i + 1, 1) = 0;
          b_prim(8 * n + i + 1, 1) = 0;
            
      end
    end
             

end