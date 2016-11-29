function [Qmean,RESmean]=SolveV4(NRecS,NStep,NRecE,NIterS,NItStep,NIterE,CorTL)
%% SET GLOBAL Parameters
x=0:25:5000;
y=0:25:1000;
t=600;
z=2;
Src.x=500;
Src.y=300;

%CorTL='HE';
AEGLk=1;
Agent=AgentSetup('H2S');
%Iter=100;
%NRecS=10;
%NRecE=10;
%NStep=1;
Receptors=NRecS:NStep:NRecE;
Iterations=NIterS:NItStep:NIterE;


%% COLLECT Predict
Q=[50 125 250 500];
for ip=1:4
    P(ip)= Read_PredictV4(strcat('SLAB/predict_0',int2str(ip-1)));
end


%% CREATE REF case
Qx=100;
Pref= Read_PredictV4('SLAB/predict_x100');
%Pref=PrepPV4(Q,100,P);
REF=zeros(length(x),length(y));
for ix=1:length(x)
    for iy=1:length(y)
        REF(ix,iy)=ImpactV4(CorTL,Pref,AEGLk,Agent,Src,x(ix),y(iy),z,t);
    end 
end


% Toxic Load Calculation
% [TL]=TLoad(x,y,Pref.t,cref);

%parpool(2);
fileNameBase=strcat('output_1/Q_',CorTL);
fileNameProg=strcat(fileNameBase,'_', int2str(NRecS),'_',int2str(NRecE),'_',int2str(NIterS),'_',int2str(NIterE));
parfor_progress(fileNameProg,NIterE*((NRecE-NRecS)/NStep+1));

%% CREATE random Sample

poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    poolsize = 0;
else
    poolsize = poolobj.NumWorkers;
end

for iR=1:numel(Receptors)
    iRec=Receptors(iR);
       
    %TLn=squeeze(TL(:,:,:,timeStep));%Fixed time 
    %nzTL=find(TLn>=1);%Vector containing linear indices of the values of TL at which health observations occur
    %TLn(isnan(TLn))=0; %Apply filtering on TL
    %TLn=squeeze(TLn(:,:,AEGLk)); %Use only filtered receptors for a specific AEG-Level
    iREF=find(REF>0);
    nsample=NIterE;
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

%% RUN ALL ITERATIONS
Qguess=zeros(1,NIterE);
res=zeros(1,NIterE);
    parfor it=1 : NIterE
         %[Qguess(it),res(it)]=fminbnd(@(Qs)Stockie_InverseV4(Qs,xrand(it,:),yrand(it,:),z,REFrand(it,:),t,P,Q,CorTL,AEGLk),50,500);
         %[Qguess(it),res(it)]=fminsearch(@(Qs)Stockie_InverseV4(Qs,xrand(it,:),yrand(it,:),z,REFrand(it,:),t,P,Q,CorTL,AEGLk,Agent,Src),100);
         [Qguess(it),res(it)]=fminbnd(@(Qs)Stockie_InverseV4(Qs,xrand(it,:),yrand(it,:),z,REFrand(it,:),t,P,Q,CorTL,AEGLk,Agent,Src),50,500);
         parfor_progress(fileNameProg);
    end
    % Save the partial files
    for it=1:numel(Iterations)
        NIter=Iterations(it);
        SQguess=Qguess(1: NIter);
        SRes=res(1: NIter);
        Qmean(iR,it)=mean(SQguess);
        Qstdev(iR,it)=std(SQguess);
        RESmean(iR,it)=mean(SRes);
        fileNameMat=strcat(fileNameBase,'_i',int2str(NIter),'_r',int2str(iRec));
        save(strcat(fileNameMat, '.mat'),'AEGLk', 't','SQguess', 'SRes');
    end
    
end

parfor_progress(fileNameProg,0);
drawnow;
    
end
