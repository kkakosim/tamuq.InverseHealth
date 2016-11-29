%%what to execute
examples='Q';
switch examples
    case 'Solve'
        %% Examples of Running Code
        [Qmean,RESmean]=SolveV4(2,7,100,2,14,100,'C'); % find Q using concentration
        % [Qmean,RESmean]=SolveV4(2,2,20,10,10,5,30,'TL'); % find Q using Toxic Load
        % [Qmean,RESmean]=SolveV4(2,2,20,10,10,5,30,'HE'); % find Q using Toxic Load
        % [Res,FSrc]=SolveV4_loc(2,2,20,10,'C'); % find Location using concentration
        % [Res,FSrc]=SolveV4_loc(2,2,20,10,'TL'); % find Location using Toxic Load
        % [Res,FSrc]=SolveV4_loc(2,2,20,10,'HE'); % find Location using Toxic Load
    
    case 'Location'
        %% TEST of Location Identification
        %   Runs should be already done

        x=0:25:2000;
        y=0:25:1000;
        Src.x=500;
        Src.y=300;
        [fgh]=figure;
        hold on;

        %GET DATA
        NRecS=12;
        NStep=10;
        NRecE=62;
        NIter=10;
        CorTL='C'; % change to C or TL or HE
        fileNameBase=strcat('output_1/Loc_',CorTL,'_i',int2str(NIter));

        Receptors=NRecS;%:NStep:NRecE;
        for iR=1:numel(Receptors)
            iRec=Receptors(iR);
            fileNameMat=strcat(fileNameBase,'_r',int2str(iRec));
            load(strcat(fileNameMat, '.mat'));
            figure(fgh);
            contourf(x,y,Res');
            caxis([0 1]);
            colormap hot;
            colorbar;
            plot(Src.x,Src.y,'-x','MarkerSize',15);
            drawnow;
            Movie(iR)=getframe(gcf);
            minResR(iR)=minRes;
            rDistance(iR)=sqrt((FSrc.x-Src.x)^2+(FSrc.y-Src.y)^2);
        end
        hold off;
        %plot(Receptors,minResR);
        % myVideo = VideoWriter('myfile.avi');
        % myVideo.FrameRate = 1;  % Default 30
        % myVideo.Quality = 50;    % Default 75
        % open(myVideo);
        % writeVideo(myVideo, Movie);
        % close(myVideo);

    case 'Q'
        
        %% TEST of Source Rate
        %   Runs should be already done

        x=0:25:5000;
        y=0:25:1000;
        Src.x=500;
        Src.y=300;
        [fghQ]=figure;

        %GET DATA
        NRecS=2;
        NStep=10;
        NRecE=92;
        NIterS=100;
        NItStep=300;
        NIterE=400;
        CorTL='HE'; % change to C or TL
        fileNameBase=strcat('output_1/Q_',CorTL);

        Receptors=NRecS:NStep:NRecE;
        Iterations=[10 100 400];%NIterS:NItStep:NIterE;
        
        sQguessALL=zeros(NIterE,numel(Receptors));
        
        for iR=1:numel(Receptors)
            iRec=Receptors(iR);
            for it1=1:numel(Iterations)
                iTer=Iterations(it1);
                fileNameMat=strcat(fileNameBase,'_i',int2str(iTer),'_r',int2str(iRec));
                load(strcat(fileNameMat, '.mat'));
                %RES(iR,it,:)=SRes;
                meanRES(iR,it1)=mean(SRes);
                %QGUESS(iR,it,:)=SQguess;
                meanQGUESS(iR,it1)=mean(SQguess);
                stdevQGUESS(iR,it1)=std(SQguess);
                clear diff;
                diff=abs(SQguess-100)/100;
                diff(diff>0.1)=0;
                probQGUESS(iR,it1)=nnz(diff)/iTer;
%                 figure(fghQ);
%                 hist(Qguess);;
%                 drawnow;
%                 MovieQ(iR)=getframe(gcf);
            end
            sQguessALL(:,iR)=SQguess';
        end
       
        plot(probQGUESS,'o')
        %boxplot(sQguessALL,'symbol','')
%%
end

%% Plot Q Mean
%figure;
it1=1;
Iterations(it1)
X=[Receptors,fliplr(Receptors)];                %#create continuous x value array for plotting
Ay1=meanQGUESS(:,it1)-stdevQGUESS(:,it1);
Ay2=meanQGUESS(:,it1)+stdevQGUESS(:,it1);
Ay=meanQGUESS(:,it1);
AY=[Ay2',fliplr(Ay1')];              %#create y values for out and then back
h=fill(X,AY,'b');                  %#plot filled area
set(h,'Facecolor',[1 0.84 0.99]);
set(h,'FaceAlpha',0.5);
set(h,'LineStyle','none');
hold on;


it2=7;
Iterations(it2)
X=[Receptors,fliplr(Receptors)];                %#create continuous x value array for plotting
By1=meanQGUESS(:,it2)-stdevQGUESS(:,it2);
By2=meanQGUESS(:,it2)+stdevQGUESS(:,it2);
By=meanQGUESS(:,it2);
BY=[By2',fliplr(By1')];              %#create y values for out and then back
h2=fill(X,BY,'b');                  %#plot filled area
set(h2,'Facecolor',[0.5 0.34 0.99]);
set(h2,'FaceAlpha',0.5);
set(h2,'LineStyle','none');

h2=plot(Receptors,By);
set(h2,'Color',[0.5 0.34 0.99]);
set(h2,'LineWidth',2);

h=plot(Receptors,Ay);
set(h,'Color',[1 0.84 0.99]);
set(h,'LineWidth',2);

