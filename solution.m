function [P001,P011,PN10,PN11,in_process_inventory,production_rate] = solution (mu1,mu2,buffer_capacity)

p1 = 0.01;
r1 = 0.1;
p2 = 0.05;
r2 = 0.1;
%for mu1=mu2
if (mu1 == mu2)
 Y1 = (r1+r2)/(p1+p2);
 Y2 = (r1+r2)/(p1+p2);
 lambda = (1/mu1)*((r1*p2)-(r2*p1))*((1/(p1+p2))+(1/(r1+r2)));
 if abs(lambda)>1e-5
      M = ((exp(lambda*buffer_capacity)-1)/lambda)*(Y1+Y2+(Y1*Y2)+1);
   else   
      M = buffer_capacity*(1+Y1+Y2+Y1*Y2);
 end
 %for probability density calculation
 N = (mu1/(r1*p2))*(r1+r2);                                       %for P001 calculation
 O = (mu1/p2)*((r1+r2)/(p1+p2));                                  %for P011 calculation
 A = (mu1/(r2*p1))*(r1+r2)*exp(lambda*buffer_capacity);           %for PN10 calculation
 B = (mu1/p1)*((r1+r2)/(p1+p2))*exp(lambda*buffer_capacity);      %for PN11 calculation
 C = 1/(M+N+O+A+B);                                               %calculating the constant number C
 P001 = C*N
 P011 = C*O
 PN10 = C*A
 PN11 = C*B
 if (abs(lambda)<1e-5)
     in_process_inventory = C/2*(buffer_capacity*(1+Y1))^2+ buffer_capacity*(PN10 + PN11)
  else
     in_process_inventory = C*((1+Y1)/lambda)^2*(exp(lambda*buffer_capacity)*(lambda*buffer_capacity-1)+1)+ buffer_capacity*(PN10 + PN11)
  end 
end
%for mu1~=mu2
if (mu1 ~= mu2)
    if (mu1>mu2)
    a = -(mu2-mu1)*p1;
    b = (((mu2-mu1)*(r1+r2))-((mu2*p1)+(mu1*p2)));
    c = mu2*(r1+r2);
    delta = (b^2)-(4*a*c);
    Y11 = ((-b)-(sqrt(delta)))/(2*a);
    Y12 = ((-b)+(sqrt(delta)))/(2*a);
    Y21 = ((r1+r2)-(p1*Y11))/p2;
    Y22 = ((r1+r2)-(p1*Y12))/p2;
    lambda1 = -((p1*Y11-r1)*((1+Y11)/Y11))/mu1;
    lambda2 = -((p1*Y12-r1)*((1+Y12)/Y12))/mu1;
    A = ((mu1-mu2)/r1)*(Y11*Y21);
    B = ((mu1-mu2)/r1)*(Y12*Y22);
    D = ((mu1/p1)*Y21*(exp(lambda1*buffer_capacity)));
    E = ((mu1/p1)*Y22*(exp(lambda2*buffer_capacity)));
    F = (mu1/(r2*p1))*(r1+r2)*exp(lambda1*buffer_capacity);
    G = (mu1/(r2*p1))*(r1+r2)*exp(lambda2*buffer_capacity);
    H = ((exp(lambda1*buffer_capacity)-1)/lambda1)*(Y11+Y21+(Y11*Y21)+1);
    I = ((exp(lambda2*buffer_capacity)-1)/lambda2)*(Y12+Y22+(Y12*Y22)+1);
    
    C1 = 1/((H+A+D+F)+((-Y11/Y12)*(I+B+E+G)));
    C2 = -(C1*Y11)/Y12;
    
    P001 = C1*A+C2*B
    P011 = 0
    PN10 = C1*F+C2*G
    PN11 = C1*D+C2*E
    
     elseif (mu2>mu1)
    a = -(mu2-mu1)*p1;
	b = (mu2-mu1)*(r1+r2)-(mu2*p1+mu1*p2);
    c = mu2*(r1+r2);
    delta = (b^2)-(4*a*c);
    Y11 = ((-b)-(sqrt(delta)))/(2*a);
    Y12 = ((-b)+(sqrt(delta)))/(2*a);
    Y21 = ((r1+r2)-(p1*Y11))/p2;
    Y22 = ((r1+r2)-(p1*Y12))/p2;
    lambda1 = -((p1*Y11-r1)*((1+Y11)/Y11))/mu1;
    lambda2 = -((p1*Y12-r1)*((1+Y12)/Y12))/mu1;
     A = (mu2/(r1*p2))*(r1+r2);
     B = (mu2/(r1*p2))*(r1+r2);
     D = (mu2/p2)*Y11;
     E = (mu2/p2)*Y12;
     F = ((mu2-mu1)/r2)*(Y11*Y21)*(exp(lambda1*buffer_capacity));
     G = ((mu2-mu1)/r2)*(Y12*Y22)*(exp(lambda2*buffer_capacity));
     H = ((exp(lambda1*buffer_capacity)-1)/lambda1)*(Y11+Y21+(Y11*Y21)+1);
     I = ((exp(lambda2*buffer_capacity)-1)/lambda2)*(Y12+Y22+(Y12*Y22)+1);
    A1 = (exp(lambda1*buffer_capacity)-1)/lambda1*(Y11+Y21+Y11*Y21+1)+(mu2-mu1)/r2*exp(lambda1*buffer_capacity)*Y11*Y21+mu2/p2*Y11+mu2/(r1*p2)*(r1+r2);
	A2 = (exp(lambda2*buffer_capacity)-1)/lambda2*(Y12+Y22+Y12*Y22+1)+(mu2-mu1)/r2*exp(lambda2*buffer_capacity)*Y12*Y22+mu2/p2*Y12+mu2/(r1*p2)*(r1+r2);

	C1 = 1/(A1-A2*Y21*exp(lambda1*buffer_capacity)/Y22/exp(lambda2*buffer_capacity));
	C2 = -Y21*exp(lambda1*buffer_capacity)/Y22/exp(lambda2*buffer_capacity)*C1;
    
    P001 = C1*A+C2*B
    P011 = C1*D+C2*E
    PN10 = C1*F+C2*G
    PN11 = 0
     end
     
   if ((abs(lambda1)>1e-5)&&(abs(lambda2)>1e-5))
         in_process_inventory = C1*(1+Y11)*(1+Y21)/lambda1^2*(exp(lambda1*buffer_capacity)*(lambda1*buffer_capacity-1)+1)+ C2*(1+Y12)*(1+Y22)/lambda2^2*(exp(lambda2*buffer_capacity)*(lambda2*buffer_capacity-1)+1)+ buffer_capacity*(PN10 + PN11)
    elseif (abs(lambda1)<1e-5)&&(abs(lambda2)>1e-5)
      in_process_inventory = C1/2*buffer_capacity^2*(1+Y11)*(1+Y21)+C2*(1+Y12)*(1+Y22)/lambda2^2*(exp(lambda2*buffer_capacity)*(lambda2*buffer_capacity-1)+1)+buffer_capacity*(PN10 + PN11)
    elseif (abs(lambda1)>1e-5)&&(abs(lambda2)<1e-5)
      in_process_inventory = C1*(1+Y11)*(1+Y21)/lambda1^2*(exp(lambda1*buffer_capacity)*(lambda1*buffer_capacity-1)+1)+ C2/2*buffer_capacity^2*(1+Y12)*(1+Y22)+buffer_capacity*(PN10 + PN11)
    elseif (abs(lambda1)<1e-5)&&(abs(lambda2)<1e-5)
      in_process_inventory = C1/2*buffer_capacity^2*(1+Y11)*(1+Y21)+C2/2*buffer_capacity^2*(1+Y12)*(1+Y22)+buffer_capacity*(PN10 + PN11)
    end
    
end 

%blocking probability 
  
pb = PN10 + (1-(mu2/mu1))*PN11;

%production rate

production_rate = mu1*r1/(p1+r1)*(1-pb)
    
        
end
 
 
 
 
    