%AER 404 Flap Mechanism 

clear 
close all
clc

ratio=pi/180; 
theta_2=-15*ratio*(1:60); %2 rotations
theta_22=15*ratio*(1:60);
phi=-20*ratio;

%Link lengths
r2=35;
r3=200;


r22=30;
r33=175;


%Simulation

for i=12:60
    r1=r2*cos(theta_2(i))+sqrt((r2*cos(theta_2(i)))^2+r3^2-r2^2);
    r11=r22*cos(theta_22(i))+sqrt((r22*cos(theta_22(i)))^2+r33^2-r22^2);
    
        c3=((r1^2+r3^2-r2^2)/(2*(r1*r3)));
        theta_3=acos(c3);
        
    zz(1,:)=[20, 50]; %A
    zz(2,:)=[20+r2*cos(theta_2(i)),50+r2*sin(theta_2(i))]; %B
    zz(3,:)=[20+r1*cos(phi),50+(r2*cos(theta_2(i))+r3*cos(theta_3))*sin(phi)]; %C
    zz(4,:)=[20,50];        
    
    zz(5,:)=[0,-6.43332364873534]; %A(1)
    zz(6,:)=[0+r22*cos(theta_22(i)),r22*sin(theta_22(i))-6.43332364873534]; %B(1)
    zz(7,:)=[0+r11,-6.43332364873534]; %C(1)
    zz(8,:)=[0,[-6.43332364873534]];
    
    xx(1,:)=[20+r1*cos(phi),50+(r2*cos(theta_2(i))+r3*cos(theta_3))*sin(phi)];
    xx(2,:)=[0+r11,-8.1434];
    
    plot(zz(:,1),zz(:,2),'--o',xx(:,1),xx(:,2),'s-r');
    
    axis([-100 300 -200 200]);
    grid on;
    xlabel('x axis (cm)')
    ylabel('y axis (cm)')
    title('Flap Design')
    pause(0.15);

end


