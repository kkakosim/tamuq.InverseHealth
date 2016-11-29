%% Compare Predicts on Concentrations
clear;
Agent=AgentSetup('H2S');

x=400;%0:10:5000;
y=0;
z=2;
Src.x=0;
Src.y=0;
t=0:10:1000;
Q=[50 125 250 500];
CorTL='C';
AEGLk=1;
hold off;
c=zeros(length(t),4);
for ip=1:4
    P= Read_PredictV4(strcat('SLAB/predict_0',int2str(ip-1))); 
    for i=1:length(t)
        c(i,ip)=ImpactV4( CorTL,P,AEGLk,Agent,Src,x,y,z,t(i) );
    end
    plot(t,c(:,ip)/Q(ip));
    drawnow;
    hold on;
    %axis([1000 3000 0 15]);
end