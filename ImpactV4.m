function [ Impact ] = ImpactV4( CorTL,P,AEGLk,Agent,Src,x,y,z,t )
%Return Concentration or Load depending on the requirement

%transform X Y for theta
    theta=30*pi()/180;
    xySlab(1)=x-Src.x;
    xySlab(2)=y-Src.y;
%      lamda=sqrt(dot(xySlab,xySlab));
%      xySlab(1)=xySlab(1)*cos(theta);
%      xySlab(2)=xySlab(2)*sin(theta);
% %     xySlab(2)=xySlab(1)/tan(theta);


    switch CorTL
        case 'C' %concentration
            %Calculate C at givent t
            Impact=KK_SlabV4(P,xySlab(1),xySlab(2),z,t);
            Impact=squeeze(Impact(AEGLk));
        case 'TL' %toxic load
            %Calculate toxic Load up to given tstep>t
            tt=P.t(P.t<t);
            creft=zeros(1,numel(tt));
            for it=1:numel(tt)
                creft(it)=KK_SlabV4(P,xySlab(1),xySlab(2),z,tt(it));
            end
            Impact=cTLV4(creft,tt,AEGLk,Agent);
            Impact=squeeze(Impact(AEGLk));
        case 'HE' %health effect
            %Calculate toxic Load up to given tstep>t
            tt=P.t(P.t<t);
            creft=zeros(1,numel(tt));
            for it=1:numel(tt)
                creft(it)=KK_SlabV4(P,xySlab(1),xySlab(2),z,tt(it));
            end
            Impact=cTLV4(creft,tt,AEGLk,Agent);
            if Impact(3)>1
                Impact=3;
            elseif Impact(2)>1
                Impact=2;
            elseif Impact(1)>1
                Impact=1;
            else
                Impact=0;
            end
    end
end
