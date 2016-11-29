%%Read Predict Files & Simple test
clear;
P= Read_PredictV4('SLAB/predict_x100');
Agent=AgentSetup('H2S');

% Calculate for a point
t=200;
x=300;
y=0;
z=2;
Src.x=0;
Src.y=0;
CorTL='HE';
AEGLk=1;
ImpactV4( CorTL,P,AEGLk,Agent,Src,x,y,z,t)

%% Make Plot-x
Agent=AgentSetup('H2S');
x=0:10:10000;
y=0;
z=2;
Src.x=0;
Src.y=0;
CorTL='C';
AEGLk=1;
P= Read_PredictV4('SLAB/predict_x100');
for it=1:200:2000
    for i=1:length(x)
        c(i)=ImpactV4( CorTL,P,AEGLk,Agent,Src,x(i),y,z,it);
    end
    plot(x,c,'red');
    hold on;
    axis([0 10000 0 100]);
    drawnow;
end
hold off;
figure;
x=1000;
t=1:1:1000;
CorTL='TL';
c1=zeros(1,numel(P.t));
c2=zeros(1,numel(P.t));
c3=zeros(1,numel(P.t));
for it=1:length(P.t)
    c1(it)=ImpactV4( CorTL,P,1,Agent,Src,x,y,z,P.t(it));
    c2(it)=ImpactV4( CorTL,P,2,Agent,Src,x,y,z,P.t(it));
    c3(it)=ImpactV4( CorTL,P,3,Agent,Src,x,y,z,P.t(it));
end
plot(P.t,c1,'blue');
hold on;
plot(P.t,c2,'green');
plot(P.t,c3,'red');

%% Make plot-xy
Agent=AgentSetup('H2S');
x=0:10:1400;
y=0:10:700;
Src.x=500;
Src.y=300;
z=2;
PlotC='Y';
PlotTL='Y';
PlotHE='Y';
AEGLk=1;
P= Read_PredictV4('SLAB/predict_x100');

figure;
clear F;
hFig = figure(1);
set(hFig, 'Position', [100 100 700 1050])
for it=44:44;
    
    cC=zeros(numel(y),numel(x));
    cTL=zeros(numel(y),numel(x));
    cHE=zeros(numel(y),numel(x));
    for iy=1:length(y)
        parfor ix=1:length(x)
            if PlotC=='Y'
                cC(iy,ix)=ImpactV4( 'C',P,AEGLk,Agent,Src,x(ix),y(iy),z,P.t(it));
            end
            if PlotTL=='Y'
                cTL(iy,ix)=ImpactV4( 'TL',P,AEGLk,Agent,Src,x(ix),y(iy),z,P.t(it));
            end
            if PlotHE=='Y'
                cHE(iy,ix)=ImpactV4( 'HE',P,AEGLk,Agent,Src,x(ix),y(iy),z,P.t(it));
            end
        end
    end
    
    if PlotC=='Y'
            subplot(3,1,1);
            scale=logspace(-2,3,10);
            Ctemp=cC;
            Ctemp(log(Ctemp)<log(scale(1)))=scale(1);
            Ctemp(log(Ctemp)>log(scale(length(scale))))=scale(length(scale));
            contourf(x,y,log(Ctemp),log(scale));
            colormap(flipud(hot));
            title(strcat('Concentration, t= ',num2str(P.t(it)),' s'));
            hold on;
            caxis([log(scale(1)) log(scale(length(scale)))]);
            colorbar('FontSize',11,'YTick',log(scale),'YTickLabel',sprintf('%0.3G|',scale));
            plot(Src.x,Src.y,'-x','MarkerSize',15);
            axis([min(x) max(x) min(y) max(y)]);
            hold off;
    end
    if PlotTL=='Y'
            subplot(3,1,2);
            scale=linspace(0,3,10);
            Ctemp=cTL;
            Ctemp(Ctemp<scale(1))=scale(1);
            Ctemp(Ctemp>scale(length(scale)))=scale(length(scale));
            contourf(x,y,Ctemp,scale);
            title(strcat('Toxic Load'))
            hold on;
            colormap(flipud(hot));
            caxis([scale(1) scale(length(scale))]);
            colorbar('FontSize',11,'YTick',scale,'YTickLabel',sprintf('%0.2g|',scale));
            plot(Src.x,Src.y,'-x','MarkerSize',15);
            axis([min(x) max(x) min(y) max(y)]);
            hold off;
    end
    if PlotHE=='Y'
            subplot(3,1,3);
            scale=[0 1 2 3];
            Ctemp=cHE;
            Ctemp(Ctemp<scale(1))=scale(1);
            Ctemp(Ctemp>scale(length(scale)))=scale(length(scale));
            contourf(x,y,Ctemp,scale);
            title(strcat('Health Effect'))
            hold on;  
            colormap(flipud(hot));
            caxis([scale(1) scale(length(scale))]);
            colorbar('YTickLabel',...
            {'Nothing','AEGL1','AEGL2','AEGL3'},...
            'YTick',scale);
            plot(Src.x,Src.y,'-x','MarkerSize',15);
            axis([min(x) max(x) min(y) max(y)]);
            hold off;
    end
    
    set(gcf,'color','w'); % set figure background to white
    drawnow;
    frame = getframe(hFig);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    outfile = 'sinewave.gif';
 
    % On the first loop, create the file. In subsequent loops, append.
    if it==1
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf);
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'writemode','append');
    end
    
end

%% Test Error Function
clear
Agent=AgentSetup('H2S');
xx=0:10:1000;
y=0;
Src.x=0;
Src.y=0;
t=100;
z=2;
CorTL='C';
AEGLk=2;
P= Read_PredictV4('SLAB/predict_x100');

tstep=find(P.t>t,1);

for ix=1:length(xx)
    x=xx(ix);
    %y=xx(ix);
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

    c(ix) = (cct_V* (erf(xa)-erf(xb))* (erf(ya)-erf(yb))* (exp(-za*za)+exp(-zb*zb))*(1e6*34.1/24.04));%concentration converted to units of mg/m3 (based on the EAGLE code)for use in the TL calcultions 
    
    xxx(ix)=xa;
end
plot(xx,c);


%% Compare Predicts on Concentrations
clear;
Agent=AgentSetup('H2S');

x=0:10:600;
y=0;
z=2;
Src.x=0;
Src.y=0;
t=100;
Q=[50 125 250 500];
CorTL='C';
AEGLk=1;
hold off;
for ip=1:4
    P= Read_PredictV4(strcat('SLAB/predict_0',int2str(ip-1))); 
    for i=1:length(x)
        c(i,ip)=ImpactV4( CorTL,P,AEGLk,Agent,Src,x(i),y,z,t);
    end
    plot(x,c(:,ip));
    drawnow;
    hold on;
    %axis([1000 3000 0 15]);
end
    
%% Compare Predicts
clear;
Q=[50 125 250 500];
hold off;
for ip=1:4
    P(ip)= Read_PredictV4(strcat('SLAB/predict_0',int2str(ip-1))); 
    plot(P(ip).t,(P(ip).cct*(1e6*34.1/24.04))/Q(ip));
    drawnow;
    hold on;
    axis([0 500 0 500]);
end

hold off;
%% CREATE Interpolated Predict
clear;
Q=[50 125 250 500];
for ip=1:4
    P(ip)= Read_PredictV4(strcat('SLAB/predict_0',int2str(ip-1)));
end
fields = fieldnames(P(1));

Qx=100;
for ifld = 1:numel(fields)
    Values=horzcat(P.(fields{ifld}));
    for i=1:length(P(ip).t)
        PP.(fields{ifld})(i)=interp1(Q,Values(i,:),Qx);
    end
end

%% COMPARE Interpolation
t=0:200:1000;
x=0:10:1000;
y=50;
z=2;
CorTL='C';
AEGLk=1;
Pref= Read_PredictV4('SLAB/predict_x100');
for it=1:length(t)
    for i=1:length(x)
        cref(i)=ImpactV4(CorTL,Pref,AEGLk,x(i),y,z,t(it));
        c(i)=ImpactV4(CorTL,PP,AEGLk,x(i),y,z,t(it));
    end
    plot(x,(c),'red');
    hold on;
    plot(x,(cref),'blue');
    %axis([0 10000 0 10]);
    drawnow;
    %MSE(it) = mean((cx - c).^2);
    %NMSE(it)=1-mean(((cref - c).^2)./(cref-mean(cref).^2));
end
hold off;
%plot(t,NMSE);

%% EXTRA TESTING
for i=1:length(TLrand)
    cguess(i)=KK_SlabV4(Pref,xrand(i),yrand(i),z,t);
end
res=mean(((cguess - TLrand).^2)./(TLrand-mean(TLrand).^2))
error=cguess-TLrand;
error_squared=error.^2;
resb=sum(error_squared)

%% PROCESS Resuts
NRecS=10;
NRecE=300;
NStep=10;

Iterations=NRecS:NStep:NRecE;
%fileNameProg=strcat('Res_', int2str(NRecS),'_',int2str(NRecE),'_',int2str(NIter));
%hold on;
for i=1:numel(Qguess)
   avg(i)=mean(Qguess(1:i)); 
end
plot((avg))
Iterations=NRecS:NStep:NRecE;
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor',[0 .5 .5],'EdgeColor','w')

%% Test Inverse modelling
%run for multiple iterations
[Qmean,RESmean]=SolveV4(10,10,10,100,'TL');

