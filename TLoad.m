function [TL]=TLoad(xx,yy,tt,c)
TL=zeros(length(yy),length(xx),3,length(tt));
for i=1:length(xx)%all of x
       for j=1:length(yy) %all of y
            cc=squeeze(c(j,i,:));
            TL(j,i,:,:)=[cc,cc,cc]'; %cTL(cc,tt);
       end
end
end

