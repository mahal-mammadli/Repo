function[R,E] = rangeAndEndurance(Rt,C,V,eff,n,P,U)
    

E = Rt^(1-n)*((eff*V*C)/P)^(n);
R = E * U * 3.6;
