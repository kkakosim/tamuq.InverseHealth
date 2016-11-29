function Plot_XY(Xm,Ym,time,CppmV,Cmin,Cmax)
        %% Define ColorMap
    B(1,:)= [0:1/31:1 ones(1,32)];
    B(2,:)= [0:1/31:1 1:-1/31:0];
    B(3,:)= [ones(1,32) 1:-1/31:0];


    %% Make plot-xy
    %Cmin=-2;
    %Cmax=3;
    scale=logspace(Cmin,Cmax,10);

    for it=1:numel(time);
    %     c=zeros(numel(y),numel(x));
    %     for iy=1:length(y)
    %         for ix=1:length(x)
    %             c(iy,ix)=Impact_ID2( CorTL,P,AEGLk,Agent,Src,x(ix),y(iy),z,t(it));
    %         end
    %     end
    %    c(isnan(c))=0;
        Ctemp=CppmV(:,:,it);
        Ctemp(log(Ctemp)<log(scale(1)))=scale(1);
        Ctemp(log(Ctemp)>log(scale(length(scale))))=scale(length(scale));
        contourf(Ym,Xm,log(Ctemp),log(scale));
        colormap(flipud(hot));
        title(strcat('t= ',num2str(time(it)),' s'));
        caxis([log(scale(1)) log(scale(length(scale)))]);
        colorbar('FontSize',11,'YTick',log(scale),'YTickLabel',sprintf('%0.3g|',scale));
        drawnow;

    end
end