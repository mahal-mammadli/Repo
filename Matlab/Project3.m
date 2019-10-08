
x=linspace(10,11,10);
%y=(sqrt(1^2-(x-6).^2))+12;
y=x;
%Simulation of Mechanism 
i=0;
while i<10
    i=i+1;

        L1=10;L2=7;L3=15;
        theta2(i)=-acos((x(i).^2+y(i).^2-(L1^2+L2^2))/(2*L1*L2));
        k1(i)=L1+L2*cos(theta2(i));
        k2(i)=L2*sin(theta2(i));
        theta1(i)=atan2(y(i),x(i))-atan2(k2(i),k1(i));
        
        d1(i)=L1^2+L2^2+2*L1*L2*cos(theta2(i));
        alp(i)=acos((L1^2+d1(i)-L2^2)/(2*L1*sqrt(d1(i))));
        d2(i)=(d1(i)+L3^2-2*sqrt(d1(i))*L3*cos(theta1(i)-alp(i)));
        beta(i)=asin((sqrt(d2(i))*sin(theta1(i)-alp(i)))/sqrt(d2(i)));
        angle(i)=acos((L1^2+d2(i)+L2^2)/2*L1*sqrt(d2(i)));
        phi2(i)=pi-beta(i)-angle(i);
                       
        x1=[0 , L1*cos(theta1(i))];
        x2=[L1*cos(theta1(i)) , L1*cos(theta1(i))+L2*cos(theta1(i)+theta2(i))];
        
        y1=[0 , L1*sin(theta1(i))];
        y2=[L1*sin(theta1(i)) , L1*sin(theta1(i))+L2*sin(theta1(i)+theta2(i))];
        
        x3=[0,L3];
        x4=[L3,L1*cos(phi2(i))];
        
                
        y3=[0,0];
        y4=[0,L1*sin(phi2(i))];
        
        
        figure(1);
        plot(x1,y1,'-b',x2,y2,'-r',x3,y3,x,y);
        grid on;
        pause(0.05);
        
              

end
