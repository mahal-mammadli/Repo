%Matlab Script

%Code:
aoa = [0 2 4 6 8 10 12 14 16 18 20];
% Clean, cond 1
L1 = [-0.23 0.101 0.387 0.84 1.276 1.674 1.96 2.408 2.767 3.01 3.075];
D1 = [-0.211 -0.202 -0.204 -0.223 -0.25 -0.278 -0.305 -0.375 -0.448 -0.63 -0.77];
M1 = [0.2 0.2 0.2 0.4 0.5 0.7 0.7 0.6 0.5 -0.3 -0.2];
P1 = [1.96 1.91 1.91 1.91 1.91 1.91 1.91 1.91 1.91 1.9 1.89];
T1 = [75.2 78.9 79.1 79.3 79.5 79.7 79.8 80 80.2 80.2 80.6];
%Slats only, cond 2	
L2 = [-0.301 0.06 0.23 0.621 1.075 1.541 1.899 2.383 2.965 3.503 3.92];
D2 = [-0.235 -0.207 -0.231 -0.237 -0.253 -0.274 -0.3 -0.342 -0.416 -0.486 -0.56];
M2 =[-0.5 -0.3 -0.1 0 0 0 0 0 -0.2 -0.2 -0.3];
P2 =[1.89 1.89 1.89 1.9 1.9 1.9 1.9 1.89 1.9 1.89 1.89];
T2 =[78.9 79.8 80.4 80.7 81.1 81.1 81.3 81.5 81.6 81.8 82];
 
%Flaps and Slats, cond 3
L3 = [2.339 2.888 3.223 3.822 4.401 5.02 5.443 6.089 6.773 7.364 7.82];
D3 = [-0.766 -0.843 -0.898 -1.006 -1.12 -1.234 -1.335 -1.498 -1.668 -1.825 -1.975];
M3 = [-7 -7.4 -7.5 -7.8 -8.1 -8.3 -8.5 -8.8 -9 -9.3 -9.6];
P3 = [1.87 1.88 1.88 1.87 1.87 1.87 1.86 1.86 1.86 1.85 1.85];
T3 = [81.1 81.8 82 82.4 82.4 82.5 82.5 82.7 82.7 82.7 82.7];
 
%Flaps only, cond 4
L4 = [2.39 2.907 3.317 3.981 4.523 5.136 5.513 6.157 6.275 6.9 7.075];
D4 = [-0.72 -0.797 -0.859 -0.98 -1.096 -1.24 -1.343 -1.531 -1.745 -2.09 -2.24];
M4 = [-6.3 -6.5 -6.7 -7 -7.4 -8 -8.3 -8.7 -9.4 -10.7 -11.5];
P4 =[1.88 1.87 1.87 1.87 1.87 1.87 1.87 1.86 1.85 1.84 1.83];
T4 =[81.3 82 82.4 82.7 82.9 82.9 83.1 83.1 83.3 83.3 83.4];

%assuming its 75 cmHg, roair
roair=(99991.77/(287*(273+24.5)));
 
for i=1:1:11  
%Calculation of velocity
v1 = sqrt(((2*P1(i)*249.088)/roair)/(1-0.019775));
v2 = sqrt(((2*P2(i)*249.088)/roair)/(1-0.019775));
v3 = sqrt(((2*P3(i)*249.088)/roair)/(1-0.019775));
v4 = sqrt(((2*P4(i)*249.088)/roair)/(1-0.019775));
%Calculation of lift, drag, moment coefficient   
Cl(i) = (L1(i)*4.4482)/(0.5*roair*v1^2*0.05325);
CD(i) = (D1(i)*4.4482)/(0.5*roair*v1^2*0.05325);
CM(i) = (M1(i)*0.113)/(0.5*roair*v1^2*0.05325*0.15);
     
Cl2(i) = (L2(i)*4.4482)/(0.5*roair*v2^2*0.05325);
CD2(i) = (D2(i)*4.4482)/(0.5*roair*v2^2*0.05325);
CM2(i) = (M2(i)*0.113)/(0.5*roair*v2^2*0.05325*0.15);
      
Cl3(i) = (L3(i)*4.4482)/(0.5*roair*v3^2*0.05325);
CD3(i) = (D3(i)*4.4482)/(0.5*roair*v3^2*0.05325);
CM3(i) = (M3(i)*0.113)/(0.5*roair*v3^2*0.05325*0.15);
    
Cl4(i) = (L4(i)*4.4482)/(0.5*roair*v4^2*0.05325);
CD4(i) = (D4(i)*4.4482)/(0.5*roair*v4^2*0.05325);
CM4(i) = (M4(i)*0.113)/(0.5*roair*v4^2*0.05325*0.15);
    
X(i) =CM(i)/Cl(i);
X2(i) =CM2(i)/Cl2(i);
X3(i) =CM3(i)/Cl3(i);
X4(i) =CM4(i)/Cl4(i);
end
 %Aerodynamic Center
for j=1:1:10
m1 = (CM(j+1)-CM(j))/(Cl(j+1)-Cl(j));
m2 = (CM2(j+1)-CM2(j))/( Cl2(j+1)-Cl2(j));
m3 = (CM3(j+1)-CM3(j))/(Cl3(j+1)-Cl3(j));
m4 = (CM4(j+1)-CM4(j))/(Cl4(j+1)-Cl4(j));
    
xac(j) = -m1*0.15;
xac2(j) = -m2*0.15;
xac3(j) = -m3*0.15;
xac4(j) = -m4*0.15;
end
%Center of pressure
for k=1:1:11
Mle1 = ((-0.15/5)*L1(k))+M1(k);    
Mle2 = ((-0.15/5)*L2(k))+M2(k);
Mle3 = ((-0.15/5)*L3(k))+M3(k);
Mle4 = ((-0.15/5)*L4(k))+M4(k);

xcp(k) = (-Mle1/L1(k))*0.0254;
xcp2(k) = (-Mle2/L2(k))*0.0254;
xcp3(k) = (-Mle3/L3(k))*0.0254;
xcp4(k) = (-Mle4/L4(k))*0.0254;
end

figure()
plot(aoa,Cl,'--x',aoa,Cl2,'--o',aoa,Cl3,'--*',aoa,Cl4,'--+');
xlabel('Angle of Attack')
ylabel('Lift Coefficient')
title('Lift Coefficient vs. Angle of Attack')

figure()
plot(aoa,CD,'--x',aoa,CD2,'--o',aoa,CD3,'--*',aoa,CD4,'--+');
xlabel('Angle of Attack')
ylabel('Drag Coefficient')
title('Drag Coefficient vs. Angle of Attack')

figure()
plot(aoa,X,'--x',aoa,X2,'--o',aoa,X3,'--*',aoa,X4,'--+');
xlabel('Angle of Attack')
ylabel('Moment Coefficient/Lift Coefficient')
title('Moment Coefficient/Lift Coefficient vs. Angle of Attack')
 
legend('Clean','Slats Only','Flaps and Slats','Flaps')
hold all

