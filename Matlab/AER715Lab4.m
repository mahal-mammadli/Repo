num = 0.08355;
den = [1 0 0];
G4_elev1_open=tf(num,den);
den2=[1 0 num];
G4_elev1_closed=tf(num,den2);
sisotool('rlocus',G4_elev1_open);

C_PID=pid(C);
Kp=C_PID.Kp;
Ki=C_PID.Ki;
Kd=C_PID.Kd;


