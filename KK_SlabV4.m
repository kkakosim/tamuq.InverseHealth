function [ c] = KK_SlabV4( P,x,y,z,t)
%Calculcate C based on SLAB Cav
%   -
% [t, tStep] = min(abs(P.t-t));
% t=P.t(tStep);

%Interpolate
tstep=find(P.t>t,1);

bt_V= LinIterm(P.bt,P.t,tstep-1,tstep,t);   %interp1(P.t,P.bt,t);
betact_V=LinIterm(P.betact,P.t,tstep-1,tstep,t);
zct_V=LinIterm(P.zct,P.t,tstep-1,tstep,t);
sigt_V=LinIterm(P.sigt,P.t,tstep-1,tstep,t);
cct_V=LinIterm(P.cct,P.t,tstep-1,tstep,t);
xct_V=LinIterm(P.xct,P.t,tstep-1,tstep,t);
bxt_V=LinIterm(P.bxt,P.t,tstep-1,tstep,t);
betaxt_V=LinIterm(P.betaxt,P.t,tstep-1,tstep,t);

sr2 = sqrt(2.0);
xa = (x-xct_V+bxt_V)/(sr2*betaxt_V);
xb = (x-xct_V-bxt_V)/(sr2*betaxt_V);
ya= (y+bt_V)/(sr2*betact_V);
yb = (y-bt_V)/(sr2*betact_V);
za = (z-zct_V)/(sr2*sigt_V);
zb= (z+zct_V)/(sr2*sigt_V);

c = (cct_V* (erf(xa)-erf(xb))* (erf(ya)-erf(yb))* (exp(-za*za)+exp(-zb*zb))*(1e6*34.1/24.04));%concentration converted to units of mg/m3 (based on the EAGLE code)for use in the TL calcultions 
%c=erf(ya)-erf(yb);

%add artificial noise to all results
a=0.8;
b=1.2;
%c=c*(a + (b-a).*rand(1,1));
end

