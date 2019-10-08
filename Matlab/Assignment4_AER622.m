%% AER622 Gas Dynamics Assigment 4 
%Mahal Mammadli 500642220

syms Uinf x;
U_u=Uinf*sqrt(1+3.1*(x^0.5)*(1-x));
U_l=Uinf*sqrt(1+1.3*(x^0.5)*(1-x)^2);

%Incompressible pressure coefficients 
Cp_u0=1-(U_u/Uinf)^2;
simplify(Cp_u0)

Cp_l0=1-(U_l/Uinf)^2;
simplify(Cp_l0)

%Plotting incompressible pressure distribution
i=1;
for x=0:0.01:1
Cp_u0(i)=(31*x.^(1/2)*(x - 1))/10;
Cp_l0(i)=-(13*x.^(1/2)*(x - 1).^2)/10;
i=i+1;
end

x=linspace(0,1,(i-1));
figure(1);
plot(x,Cp_u0,'-x',x,Cp_l0,'-o');
set(gca, {'YDir'}, {'reverse'});
title('Incompressible Pressure Distribution');
legend('Upper Surface','Lower Surface');
xlabel('Chordwise distance');
ylabel('Cp');
hold on;
grid on;

%Prandtl-Glauert correction 
Minf=0.6; %Given M=0.6 flow
Cp_u=Cp_u0/sqrt(1-Minf^2);
Cp_l=Cp_l0/sqrt(1-Minf^2);

figure(2);
plot(x,Cp_u,'-x',x,Cp_l,'-o');
set(gca, {'YDir'}, {'reverse'});
title('Prandtl-Glauert Corrected Pressure Distribution (Compressible)');
legend('Upper Surface','Lower Surface');
xlabel('Chordwise distance');
ylabel('Cp');
grid on;
hold on;

clear x
f=@(x)-((((31.*x.^(1/2).*(x - 1))/10)/sqrt(1-Minf^2))-((-(13.*x.^(1/2).*(x - 1).^2)/10)/sqrt(1-Minf^2)));
Cl=integral(f,0,1)

%Critical pressure coefficient
Cp_cr=(2/(1.4*Minf^2))*(((1+0.2*Minf^2)/(1.2))^(3.5)-1);
refline(0,-1.2943);
text(0.15,-1.25,'\uparrow Shock Occurs');

%Minimum Cp value 
x=linspace(0,1,(i-1));
Cp_u=(((31.*x.^(1/2).*(x - 1))/10)/sqrt(1-Minf^2));
Cp_u_min=min(Cp_u)

%Max Mach number at location of minumum Cp
%at i=34 is when Cp_u == -1.4914
% x value at this location is 0.33

syms M Pa_Pinf
M=0.6;
Cp_a=(2/(1.4*M^2))*((Pa_Pinf)-1)==-1.4914;
Pa_Pinf=vpasolve(Cp_a,Pa_Pinf);
%Isentropic table for M=0.6 - Pinf/P0=0.7840
Pinf_P0=0.7840;
%Pa/Pinf=0.6241672
Pa_Pinf=0.6241672;
Pa_P0=(Pa_Pinf*Pinf_P0)
%Isentropic tables Pa/Po=0.4893 M~1.065
Mmax=1.065;
%Normal shock tables M1=1.065 - M2=0.94 P2/P1=1.5;
M2=0.94;P2_P1=1.5;
P_P0=Pa_P0*P2_P1;
Cp_shock=(2/(1.4*0.6^2))*((P_P0)-1)

%closest value to Cp_shock [-1.04670198570319] at i=68
x1=[x(34) x(34)];x2=[x(34) x(69)];
y1=[Cp_u_min Cp_shock];y2=[Cp_shock Cp_shock];
plot(x(34),Cp_shock,'+',x1,y1,'--',x2,y2,'--');
text(x(34),Cp_shock+0.03,'\uparrow Cp at Mend of shock ');

%Intergration to find lift loss
f=@(x)-((((31.*x.^(1/2).*(x - 1))/10)/sqrt(1-Minf^2))-Cp_shock);
Cl_loss=integral(f,x(34),x(68))

%Modification to lower surface 

f=@(x)-((((31.*x.^(1/2).*(x - 1))/10)/sqrt(1-Minf^2))-((-(7.98.*x.^(1/2).*(x - 1).^2)/10)/sqrt(1-Minf^2)));
%Cl_mod must be Cl plus Cl_loss = 0.7857+0.0956 == 0.8813
Cl_mod=integral(f,0,1)
Cl_mod=Cl_mod-Cl_loss
Cp_l_mod=(-(7.98.*x.^(1/2).*(x - 1).^2)/10)/sqrt(1-Minf^2);

plot(x,Cp_l_mod,'-*');
legend('Upper Surface','Lower Surface','Modified Lower Surface');
