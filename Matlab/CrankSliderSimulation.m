% Crank-Slider Simulation 
% Mechanisms and Vibrations AER 403

clear 
close all
clc

ratio=pi/180; 
theta_2=15*ratio*(1:48); %2 rotations

%Link lengths and angular velocity 
w2=50; %rad/s
r2=150;
r3=200;
r1=sqrt(r3^2-r2^2);

%Simulation

for i=1:48
    r1=r2*cos(theta_2(i))+sqrt((r2*cos(theta_2(i)))^2+r3^2-r2^2);
    
        c3=((r1^2+r3^2-r2^2)/(2*(r1*r3)));
        theta_3=acos(c3);
          
        v1=(r2*w2*cos(theta_2(i)-theta_3))/(cos(pi-theta_3));
        v1=(v1/100);       
        v2=(w2*r2)/100;
    
    zz(1,:)=[0, 0]; %A
    zz(2,:)=[r2*cos(theta_2(i)),r2*sin(theta_2(i))]; %B
    zz(3,:)=[r1, 0]; %C
    zz(4,:)=[0,0];        
        
    plot(zz(:,1),zz(:,2),'--o');
    axis([-200 400 -200 200]);
    grid on;
    xlabel('x axis (cm)')
    ylabel('y axis (cm)')
    title('Crank-Slider')
    hold on;
    quiver(r1,0,v1,0);
    quiver(r2*cos(theta_2(i)),r2*sin(theta_2(i)),v2*cos((pi/2)+theta_2(i)),v2*sin((pi/2)+theta_2(i)));
    hold off;
    pause(0.1);

end

