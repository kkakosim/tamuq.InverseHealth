function [Rsq]=Stockie_InverseV4(Qs,xrand,yrand,z,REFrand,t,P,Q,CorTL,AEGLk,Agent,Src)%Stockie's inverse code - modified for our case
    % This function solves the inverse atmospheric dispersion problem for xxxxx
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Stack emission source data:
    source.n = 1;     % # of sources
    source.x = 0;     % x-location (m)
    source.y = 500;     % y-location (m)
    source.z = 0;     % height (m)
    source.label=' S1';

    % Set locations of receptors where observations are recorded:
    recept.n = length(xrand);% # of receptors
    recept.x = xrand; % x location (m)
    recept.y = yrand; % y location (m)
    recept.z = zeros(recept.n);  % height (m)
    % Set all parameter values.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    slist = 1;          % list of sources
    Ns    = length(slist);% number of sources
    rlist = 1:recept.n;        % list of receptors
    Nr    = length(rlist);% number of receptors

    %Prepare Interpolation
    PP=PrepPV4(Q,Qs,P);

    cguess=zeros(1,length(REFrand));
    for i=1:length(REFrand)
        cguess(i)=ImpactV4(CorTL,PP,AEGLk,Agent,Src,xrand(i),yrand(i),z,t);
    end
    %SME=sum(((cguess - TLrand).^2));
    %SME=mean(((cguess - TLrand).^2)./(TLrand-mean(TLrand).^2));
    Rsq=sum((REFrand-cguess).^2)/sum((REFrand-mean(REFrand)).^2);
end