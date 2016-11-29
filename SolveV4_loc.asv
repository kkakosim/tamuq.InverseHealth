function [Res]=SolveV4_loc(NRecS,NStep,NRecE,NIter,CorTL)
%Find location of source using correllation

% NRecS=10;
% NStep=10;
% NRecE=10;
% NIter=2;
%CorTL='TL';

%% SET GLOBAL Parameters
x=0:25:2000;
y=0:25:1000;
t=100;
z=2;
Src.x=500;
Src.y=300;


AEGLk=1;
Agent=AgentSetup('H2S');
%Iter=100;
%NRecS=10;
%NRecE=10;
%NStep=1;
Iterations=NRecS:NStep:NRecE;


%% COLLECT Predict
Q=[50 125 250 500];
for ip=1:4
    P(ip)= Read_PredictV4(strcat('SLAB/predict_0',int2str(ip-1)));
end


%% CREATE REF and BASE case
Qx=100;
Pref= Read_PredictV4('SLAB/predict_x100');
%Pref=PrepPV4(Q,100,P);
REF=zeros(length(x),length(y));
Pbase=PrepPV4(Q,300,P);
BSrc.ixB=round(length(x)/2);
BSrc.iyB=round(length(y)/2);
BSrc.x=x(BSrc.ixB);
BSrc.y=y(BSrc.iyB);
for ix=1:length(x)
    for iy=1:length(y)
        REF(ix,iy)=ImpactV4(CorTL,Pref,AEGLk,Agent,Src,x(ix),y(iy),z,t);
        BASE(ix,iy)=ImpactV4(CorTL,Pbase,AEGLk,Agent,BSrc,x(ix),y(iy),z,t);  
    end 
end

%parpool(2);
fileNameBase=strcat('output/Loc_',CorTL,'_i',int2str(NIter));
fileNameProg=strcat(fileNameBase,'_', int2str(NRecS),'_',int2str(NRecE));
parfor_progress(fileNameProg,numel(Iterations)*length(x));

%% CREATE random Sample

%parpool(2);

for iR=1:numel(Iterations)
iRec=Iterations(iR);
   
    iREF=find(REF>0);
    nsample=NIter;
    if numel(iREF)<iRec
        error( 'Not possible to proceed further, available Receptors: %4i\n', numel(iREF));
    end
    binomComb=nchoosek(numel(iREF),iRec);
    if binomComb<nsample;nsample=binomComb;end
    randREF=zeros(nsample,iRec);
    for h=1:nsample
        randREF(h,:)=randperm(numel(iREF),iRec);%Random sample of receptors following TLn filter  
    end
    [nzXX,nzY]=ind2sub(size(REF),iREF(randREF));%Linear indixing convertred back into subscripts
    REFrand=REF(iREF(randREF));
    xrand=x(nzXX);
    yrand=y(nzY);

%% RUN ITERATIONS
    N = size(xrand,1);
    Res=zeros(numel(x),numel(y));
    FSrc.x=mean(x);
    FSrc.y=mean(y);
    minRes=100;
    for ix=1:length(x)
         for iy=1:length(y)
            ixB=ix-BSrc.ixB;
            iyB=iy-BSrc.iyB;
            nBASE=shiftmatrix(BASE,ixB, iyB);
            BASErand=nBASE(iREF(randREF));      
            CorRes=zeros(1,N);
            for it=1 : N %Different realizations     
                tcorcof  = corrcoef(REFrand(it,:),BASErand(it,:));
                CorRes(it)=tcorcof(1,2);
            end
            Res(ix,iy)=mean(CorRes);
            if abs((1-Res(ix,iy))/Res(ix,iy))<minRes
                FSrc.x=x(ix);
                FSrc.y=y(iy);
                minRes=abs((1-Res(ix,iy))/Res(ix,iy));
            end
         end
         parfor_progress(fileNameProg);
    end
    minRes=1/(1+minRes);
    fileNameMat=strcat(fileNameBase,'_r',int2str(iRec));
    save(strcat(fileNameMat, '.mat'),'AEGLk', 't', 'Iterations', 'Res','FSrc','minRes');
end

parfor_progress(fileNameProg,0);
drawnow;
end

