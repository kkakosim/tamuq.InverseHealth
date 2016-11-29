function [nBASE]=shiftmatrix(BASE,ixB, iyB);
%Shifts a matric by ixB and iyB, elements outside domain remain 0
nX=size(BASE,1);
nY=size(BASE,2);
nBASE=zeros(nX,nY);
for ix=1:nX
    ixN=ix+ixB;
    if ixN>0 && ixN<=nX
        for iy=1:nY
            iyN=iy+iyB;
            if iyN>0 && iyN<=nY
                nBASE(ixN,iyN)=BASE(ix,iy);
            end        
        end 
    end
end
    



end

