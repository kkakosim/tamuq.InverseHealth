function [ Res ] = CF_loc(CorTL,Pbase,AEGLk,REFrand,Agent,xrand,yrand,BSrc,z,t )
%Calculate correlation for given REF and BASE

%   translate BASE to Loc (x,y) using the indices
BASE=zeros(1,numel(xrand));
for i=1:length(REFrand)
    BASE(i)=ImpactV4(CorTL,Pbase,AEGLk,Agent,BSrc,xrand(i),yrand(i),z,t);
end 
Res=corrcoef(REFrand,BASE);
Res=Res(1,2);

end

