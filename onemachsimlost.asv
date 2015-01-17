%Simulation Single Unreliable Machine Deterministic Deman Continuous Flow
%Lost sales case

clear
close all

DiscreteSim= 1;
SimIter = 1;
dt = 0.001;
Ncycle =5;
Optim = 0;
fig = 1;
   

Zu = 2;
x0 = 1;

cp = 1;
cm = 1;
mu1 = 1;
p1 = 0.1;
r1 = 0.1;

mu2 = 0.5;




 rng('default')
%  for i=1:Ncycle
%       Uptimes(i) = - 1/p1*log(1-rand);
%       Downtimes(i)= - 1/r1*log(1-rand);
%   end
% 
%
%  Uptimes = [5, 11, 12, 6, 5, 12, 8, 9, 11, 10, 6, 7, 13, 9, 10];
%  Downtimes = [10, 13, 9, 15, 10, 10, 3, 5, 6, 5, 7, 9, 8, 5, 6, 10];
 
Uptimes = [5, 11, 12, 6, 5];
Downtimes = [10, 13, 9, 15, 10];
 

   Failnext(1) = Uptimes(1);
for k=1:Ncycle-1
   Repairnext(k) = Failnext(k) + Downtimes(k);
   Failnext(k+1) = Repairnext(k) + Uptimes(k+1);
end   
   Repairnext(Ncycle) = Failnext(k+1) + Downtimes(k+1);
   Failnext(Ncycle+1)=Repairnext(k+1);

   Tlimit = Repairnext(k+1);
   
   tu = [0, Repairnext];
   td = Failnext;
   
   tu = floor(tu);
   td = floor(td);


   if DiscreteSim==1

% Discrete Simulation
%-------------------------------------------
t = 0;

i=1;
k=1;
STATE1(1) = 1;
% FAILNEXT = - 1/p1*log(1-rand);   
FAILNEXT = Failnext(1);
REPAIRNEXT = 1000000;

STATE2(1) = 1;

xcum(1) = x0;
dcum(1) = 0;
pcum(1) = x0;
time(1) = 0;

while t<Tlimit
   
   xcum(i) = max(min(Zu,pcum(i) - dcum(i)),0);

   t = t + dt;
   
   if xcum(i)<Zu
      out(i) = mu1*dt*STATE1(i);
   elseif xcum(i)>=Zu
      out(i) = mu2*dt*STATE1(i);
   end
   
   if xcum (i)>0
      out2(i) = mu2*dt;
   elseif xcum(i)<Zu
      out2(i) = 0;
   end

   
   i = i+1;

   time(i) = t; 
   dcum(i) = dcum(i-1) + out2(i-1);
   pcum(i) = pcum(i-1) + out(i-1);

   %Failures
  
        
         if t>FAILNEXT
	         STATE1(i) = 0;
      	   REPAIRNEXT = Repairnext(k);
           FAILNEXT = REPAIRNEXT*100; 
		   elseif t>REPAIRNEXT
   		   STATE1(i) = 1;
           k = k+1;
           FAILNEXT = Failnext(k); 
	       REPAIRNEXT = FAILNEXT*100;
	   	else
   	   	STATE1(i) = STATE1(i-1);
      	end   
   
end   


WIPiter = sum(xcum(xcum>0))*dt/Tlimit;
Pxg0iter =sum(xcum>0)*dt/Tlimit; 

%BG = -sum(xcum(xcum<0))*dt/Tlimit;

%COST = cp*WIP + cm*BG;

%disp([WIP,BG]);

if fig==1
	
	
subplot(2,1,2)
plot(time(1,1:Tlimit/dt),xcum)
axis([0,Tlimit,min(xcum),max(xcum)+0.5])
%xlabel('time')
%ylabel('x(t)')

subplot(2,1,1)
plot(time,STATE1)
axis([0,Tlimit,0,1.1])
%xlabel('time')
%ylabel('State of the machine')


end

   end
   if SimIter==1

%-------------------------------------------
% Simulation via Optimization

xu(1)=x0;  %Starting buffer level (machine is UP)
xup(1) = max(0,xu(1));
xun(1) = max(0,-xu(1));
xd(1)=0;  %initialization

for n=1:Ncycle

%Going Up

%Reaching Full Buffer
tf(n) = (Zu-xu(n))/(mu1-mu2)+tu(n);

% tf(n) - td(n) = dfp(n) - dfn(n)
%   dfp(n) >=0, dfn(n) >=0

dfp(n) = max(tf(n)-td(n),0);
dfn(n) = max(-tf(n)+ td(n),0);

dp(n) = td(n) - tu(n) - dfn(n);  %Time to reach the full buffer
df(n) = td(n) - tf(n) + dfp(n);  %Time the process stays at the full buffer


%Main Buffer dynamics

xd(n) = xu(n) + dp(n)*(mu1-mu2);


% xd(n) = xdp(n) - xdn(n);
% xdp(n) >= 0,  xdn(n) >= 0


%xdp(n) = max(0, xd(n));
%xdn(n) = max(0, -xd(n));


%Reaching 0

%tz(n) = xun(n)/(mu1-mu2)+tu(n);

%   tz(n) - td(n) = dzp(n) - dzn(n)
%   dzp(n) >=0, dzn(n) >=0

%dzp(n) = max(tz(n)-td(n),0);
%dzn(n) = max(-tz(n)+ td(n),0);

%dz(n) = tz(n) - tu(n) - dzp(n);  %Time the process stays below 0 going up from tu(n)

%Going Down

te(n) = xd(n)/mu2 + td(n);

% te(n) - tu(n+1) = dep(n) - den(n)
%   dep(n) >=0, den(n) >=0
dep(n) = max(te(n)-tu(n+1),0);
den(n) = max(-te(n)+ tu(n+1),0);

dm(n) = tu(n+1)-td(n) - den(n);  %time the process stays above 0 going down from td(n)
de(n) = tu(n+1)- te(n) + dep(n); %time the process stays below 0 going down from td(n)


%Main Buffer dynamics

%xu(n+1) = xd(n) - (tu(n+1)-td(n))*mu2;
xu(n+1) = xd(n) - dm(n)*mu2;

   
% xu(n) = xup(n) - xun(n);
% xup(n) >= 0,  xun(n) >= 0
    
%xun(n+1) = max(0,-xu(n+1));
%xup(n+1) = max(0,xu(n+1));


%Expected WIP contribution

%wip(n) =1/2*(xup(n)+ xdp(n))*(dp(n)-dz(n)) + 1/2*(xdp(n)+xup(n+1))*dm(n) + Zu*df(n);

wip(n) =1/2*(xu(n)+ xd(n))*dp(n) + 1/2*(xd(n)+xu(n+1))*dm(n) + Zu*df(n);

pxl0(n) = tu(n+1)-td(n)-dm(n);


%Expected backlog contribution

%bg(n) = 1/2*(xun(n)+xdn(n))*dz(n) + 1/2*(xdn(n)+xun(n+1))*de(n);

end

WIPo = sum(wip)/Tlimit;
Pxg0o = 1 - sum(pxl0)/Tlimit;

disp([WIPiter,Pxg0iter]);
disp([WIPo,Pxg0o]);


%BGo = sum(bg)/Tlimit;

%disp([WIPo,BGo]);

%y0 = [xup(1:Ncycle),xun(1:Ncycle),xdp,xdn,dfp,dfn,dp,df,dzp,dzn,dz,dep,den,dm,de,xup(Ncycle+1),xun(Ncycle+1),Zu];  

   end

   
 
  
%xu,xup,xun --> Ncycle + 1  others Ncycle

if Optim ==1
   
   
%Optimization setup
%State variables

%y = [xup, xun, xdp,xdn,dfp,dfn,dp,df,dzp,dzn,dz,dep,den, dm, de,xup(N+1),xun(N+1),   Z  ]
 %  w  1    2   3    4   5   6   7  8  9   10 11  12  13  14  15  15*N+1  15*N+2   15*N+3 
%  Index_n: (w-1)*Ncycle + n


%Objective Function   1/2 y'Qy + f'y

% Ay = b
%  y >=LB


A = zeros(15*Ncycle+3,15*Ncycle+3);
b = zeros(15*Ncycle+3,1);

%xu(1)=x0;  %Starting buffer level (machine is UP)
%y(1) = x0;

%xup(1) - xun(1) = x0


if x0>=0
  A(1,1) = 1;
  b(1) = x0;
  A(2,Ncycle+1)=1;
  b(2) = 0;
else
  A(1,1) = 1;
  b(1) = 0;
  A(2,Ncycle+1) = 1;
  b(2) = -x0;
end
 

%Zu is given
A(3,15*Ncycle+3)=1;
b(3) = Zu;

ceq= 4;


for n=1:Ncycle

%1 xdp(n) - xdn(n) = xup(n) - xun(n) + dp(n)*(mu-d)     
   A(ceq,(3-1)*Ncycle+n) = 1;
   A(ceq,(4-1)*Ncycle+n) = -1;
   A(ceq,(1-1)*Ncycle+n) = -1;
   A(ceq,(2-1)*Ncycle+n) = 1;
   A(ceq,(7-1)*Ncycle+n) = -(mu1-mu2);
   b(ceq) = 0;
   
   ceq = ceq + 1;
   
%y = [xup, xun, xdp,xdn,dfp,dfn,dp,df,dzp,dzn,dz,dep,den, dm, de,xup(N+1),xun(N+1),   Z  ]
 %  w  1    2   3    4   5   6   7  8  9   10 11  12  13  14  15  15*N+1  15*N+2   15*N+3 
%  Index_n: (w-1)*Ncycle + n

   
%2 xup(n+1) - xun(n+1) = xdp(n) - xdn(n) - (tu(n+1) - td(n))*d
 if n<Ncycle
   A(ceq,(1-1)*Ncycle+n+1) = 1;
   A(ceq,(2-1)*Ncycle+n+1) = -1;
 elseif n==Ncycle
   A(ceq,15*Ncycle + 1) = 1;
   A(ceq,15*Ncycle + 2) = -1;
 end   
   A(ceq,(3-1)*Ncycle+n) = -1;
   A(ceq,(4-1)*Ncycle+n) = 1;
   b(ceq) = -(tu(n+1) - td(n))*mu2;
 
   ceq = ceq + 1;     
   
 %3 dm(n) = tu(n+1) - td(n) - den(n)
   A(ceq,(14-1)*Ncycle+n) = 1;
   A(ceq,(13-1)*Ncycle+n) = 1;
   b(ceq) = tu(n+1) - td(n);
 
   ceq = ceq + 1;     
   
 %4 de(n) = tu(n+1) - xdp(n)/d - td(n) + dep(n)
   A(ceq,(15-1)*Ncycle+n) = 1;
   A(ceq,(3-1)*Ncycle+n) = 1/mu2;
   A(ceq,(12-1)*Ncycle+n) = -1;
   b(ceq) = tu(n+1) - td(n);
   
   ceq = ceq + 1;   
      
 %5 dz(n) = xun(n)/(mu-d) - dzp(n)
   A(ceq,(11-1)*Ncycle+n) = 1;
   A(ceq,(2-1)*Ncycle+n) = -1/(mu1-mu2);
   A(ceq,(9-1)*Ncycle+n) = 1;
   b(ceq) = 0;
   
   ceq = ceq + 1;   
   
 %6 dp(n) = td(n) - tu(n) - dfn(n);
   A(ceq,(7-1)*Ncycle+n) = 1;
   A(ceq,(6-1)*Ncycle+n) = 1;
   b(ceq) = td(n) - tu(n);
 
   ceq = ceq + 1;   
  
 %7 df(n) = td(n) - (Z-xup(n)+xun(n))/(mu-d)-tu(n)+ dfp(n)
   A(ceq,(8-1)*Ncycle+n) = 1;
   A(ceq,15*Ncycle+3) = 1/(mu1-mu2);
   A(ceq,(1-1)*Ncycle+n) = -1/(mu1-mu2);
   A(ceq,(2-1)*Ncycle+n) = 1/(mu1-mu2);
   A(ceq,(5-1)*Ncycle+n) = -1;
   b(ceq) = td(n) - tu(n);
   
   ceq = ceq + 1;   
   
 %y = [xup, xun, xdp,xdn,dfp,dfn,dp,df,dzp,dzn,dz,dep,den, dm, de,xup(N+1),xun(N+1),   Z  ]
 %  w  1    2   3    4   5   6   7  8  9   10 11  12  13  14  15  15*N+1  15*N+2   15*N+3 
   
 %8 xdp(n)/d + td(n) - tu(n+1) = dep(n) - den(n)
   A(ceq,(3-1)*Ncycle+n) = 1/mu2;
   A(ceq,(12-1)*Ncycle+n) = -1;
   A(ceq,(13-1)*Ncycle+n) = 1;
   b(ceq) = tu(n+1) - td(n);
 
   ceq = ceq + 1;   
 
 
 %9 xun(n)/(mu-d) + tu(n) - td(n) = dzp(n) - dzn(n)
   A(ceq,(2-1)*Ncycle+n) = 1/(mu1-mu2);
   A(ceq,(9-1)*Ncycle+n) = -1;
   A(ceq,(10-1)*Ncycle+n) = 1;
   b(ceq) = td(n) - tu(n);
 
   ceq = ceq + 1;   
 
 %10  (Z-xup(n)+xun(n))/(mu-d) + tu(n) - td(n) = dfp(n) - dfn(n) 
   A(ceq,15*Ncycle+3) = 1/(mu1-mu2);
   A(ceq,(1-1)*Ncycle+n) = -1/(mu1-mu2);
   A(ceq,(2-1)*Ncycle+n) = 1/(mu1-mu2);
   A(ceq,(5-1)*Ncycle+n) = -1;
   A(ceq,(6-1)*Ncycle+n) = 1;
   b(ceq) = td(n) - tu(n);
 
    ceq = ceq + 1;  
end
   
   ylb = zeros(15*Ncycle+3,1);
   
 
 %Objective Function

%Expected WIP*cp

%wip(n) =1/2*(xup(n)+ xdp(n))*(dp(n)-dz(n)) + 1/2*(xdp(n)+xup(n+1))*dm(n) + Zu*df(n);
%       =1/2*(xup(n)*dp(n) - xup(n)*dz(n) + xdp(n)*dp(n) - xdp(n)*dz(n) +
%       xdp(n)*dm(n) + xup(n+1)*dm(n)) + Zu*df(n)

  Q = zeros(15*Ncycle+3,15*Ncycle+3);
  
for n=1:Ncycle
  Q((1-1)*Ncycle + n , (7-1)*Ncycle + n ) = cp;
  Q((1-1)*Ncycle + n , (11-1)*Ncycle + n ) = -cp;
  Q((3-1)*Ncycle + n , (7-1)*Ncycle + n ) = cp;
  Q((3-1)*Ncycle + n , (11-1)*Ncycle + n ) = -cp;
  Q((3-1)*Ncycle + n , (14-1)*Ncycle + n ) = cp;
  
 if n<Ncycle 
  Q((1-1)*Ncycle + n+1 , (14-1)*Ncycle + n ) = cp;
 elseif n==Ncycle
  Q( 15*Ncycle + 1 , (14-1)*Ncycle + n) = cp;   
 end 
  Q( 15*Ncycle+3, (8-1)*Ncycle + n) = 2*cp;

end  


%Expected backlog contribution

%bg(n) = 1/2*(xun(n)+xdn(n))*dz(n) + 1/2*(xdn(n)+xun(n+1))*de(n);
%      =1/2* (xun(n)*dz(n) + xdn(n)*dz(n) + xdn(n)*de(n) + xun(n+1)*de(n))


for n=1:Ncycle
  Q((2-1)*Ncycle + n , (11-1)*Ncycle + n ) = cm;
  Q((4-1)*Ncycle + n , (11-1)*Ncycle + n ) = cm;
  Q((4-1)*Ncycle + n , (15-1)*Ncycle + n ) = cm;
  if n<Ncycle 
  Q((2-1)*Ncycle + n+1 , (15-1)*Ncycle + n ) = cm;
 elseif n==Ncycle
  Q( 15*Ncycle + 2 , (15-1)*Ncycle + n) = cm;   
 end 
end  

% Set the sum of all deltap and deltam to 0 to force one of them to zero

%y = [xup, xun, xdp,xdn,dfp,dfn,dp,df,dzp,dzn,dz,dep,den, dm, de,xup(N+1),xun(N+1),   Z  ]
 %  w  1    2   3    4   5   6   7  8  9   10 11  12  13  14  15  15*N+1  15*N+2   15*N+3 
%  Index_n: (w-1)*Ncycle + n

  f=zeros(1,15*Ncycle+3); 
  
w = 1000;
for n=1:Ncycle
  f((1-1)*Ncycle + n) = w;
  f((2-1)*Ncycle + n) = w;
  f((3-1)*Ncycle + n) = w;
  f((4-1)*Ncycle + n) = w;
  f((5-1)*Ncycle + n) = w;
  f((6-1)*Ncycle + n) = w;
  f((9-1)*Ncycle + n) = w;
  f((10-1)*Ncycle + n) = w;
  f((12-1)*Ncycle + n) = w;
  f((13-1)*Ncycle + n) = w;
  
%   Q((1-1)*Ncycle + n,(1-1)*Ncycle + n) = 1;
%   Q((2-1)*Ncycle + n,(2-1)*Ncycle + n) = 1;
%   Q((3-1)*Ncycle + n,(3-1)*Ncycle + n) = 1;
%   Q((4-1)*Ncycle + n,(4-1)*Ncycle + n) = 1;
%   Q((5-1)*Ncycle + n,(5-1)*Ncycle + n) = 1;
%   Q((6-1)*Ncycle + n,(6-1)*Ncycle + n) = 1;
%   Q((9-1)*Ncycle + n,(9-1)*Ncycle + n) = 1;
%   Q((10-1)*Ncycle + n,(10-1)*Ncycle + n) = 1;
%   Q((12-1)*Ncycle + n,(12-1)*Ncycle + n) = 1;
%   Q((13-1)*Ncycle + n,(13-1)*Ncycle + n) = 1;
end  
  f(15*Ncycle+1) = w;
  f(15*Ncycle+2) = w;
% Q(15*Ncycle+1,15*Ncycle+1)=1;
% Q(15*Ncycle+2,15*Ncycle+2)=1;

   
 Q = 1/2*(Q+Q');
   
 %Q = Q + 5*eye(size(Q,1));
   
  
 %----------Matlab Quadratic Programming-----------
 options = optimset('Algorithm','interior-point-convex');

  % options = optimset('Algorithm','active-set');
 
  y = quadprog(Q,f,[],[],A,b,ylb,[],y0',options); 
 
%  [y,fval,exitflag]  = quadprog(Q,f,[],[],A,b,ylb,[],y0'); 

 
 %----------CPLEX-------------------
 
 %Q = 1/2*(Q+Q');
 
 %[D,V] = eig(Q);
 
 %Q = V*(D+(1+abs(min(min(D))))*eye(length(Q)))*V';
 
% y = cplexqp(Q,f,[],[],A,b,ylb,[],y0');
% options = cplexoptimset('TolFun',1e-9);
% options = cplexoptimset('TolRLPFun',1e-10);
 
% y = cplexqp(Q,f,[],[],A,b,ylb,[],y0',options);

%------------MATLAB fmincon------------------

%Inputs = [Zu,x0,cp,cm,mu1,p1,r1,mu2,Ncycle,Uptimes(1:Ncycle),Downtimes(1:Ncycle)];

%OPTIONS = optimset('TolX',1e-10,'TolFun',1e-10,'TolCon',1e-10,'MaxIter',1e10,'Display','off');

%y = fmincon('fonemachsim',y0',[],[],A,b,ylb,[],[],OPTIONS,Inputs);




%Extract the solution
  
   %y = [xup, xun, xdp,xdn,dfp,dfn,dp,df,dzp,dzn, dz,dep,den, dm, de, xup(N+1),xun(N+1),   Z  ]
 %  w    1    2   3    4   5   6   7  8  9   10  11  12  13  14  15  15*N+1  15*N+2    15*N+3 

 xups =  [y(1:Ncycle);y(15*Ncycle+1)];
 xuns =  [y(Ncycle+1:2*Ncycle);y(15*Ncycle+2)];
  xdps = y(((3-1)*Ncycle+1):((3-1)*Ncycle+Ncycle));  
  xdns = y(((4-1)*Ncycle+1):((4-1)*Ncycle+Ncycle)); 
  dfps = y(((5-1)*Ncycle+1):((5-1)*Ncycle+Ncycle)); 
  dfns = y(((6-1)*Ncycle+1):((6-1)*Ncycle+Ncycle)); 
  dps =  y(((7-1)*Ncycle+1):((7-1)*Ncycle+Ncycle));
  dfs =  y(((8-1)*Ncycle+1):((8-1)*Ncycle+Ncycle));
  dzps = y(((9-1)*Ncycle+1):((9-1)*Ncycle+Ncycle));
  dzns = y(((10-1)*Ncycle+1):((10-1)*Ncycle+Ncycle));
  dzs =  y(((11-1)*Ncycle+1):((11-1)*Ncycle+Ncycle)); 
  deps = y(((12-1)*Ncycle+1):((12-1)*Ncycle+Ncycle)); 
  dens = y(((13-1)*Ncycle+1):((13-1)*Ncycle+Ncycle)); 
  dms =  y(((14-1)*Ncycle+1):((14-1)*Ncycle+Ncycle)); 
  des =  y(((15-1)*Ncycle+1):((15-1)*Ncycle+Ncycle)); 
  Zs  = y(15*Ncycle + 3);


  Comparison

  
for n=1:Ncycle
wip(n) =1/2*(xups(n)+ xdps(n))*(dps(n)-dzs(n)) + 1/2*(xdps(n)+xups(n+1))*dms(n) + Zu*dfs(n);
bg(n) = 1/2*(xuns(n)+xdns(n))*dzs(n) + 1/2*(xdns(n)+xuns(n+1))*des(n);

end    
  
  

  %Comparison


  wip = sum(wip)/Tlimit;
  
  bg = sum(bg)/Tlimit;
  
  Costoptim = cp*wip + cm*bg
  
  disp([wip,bg])
    
  
  Costsim = cp*WIPo + cm*BGo
  

  disp([WIPo, BGo])
  
  
end


