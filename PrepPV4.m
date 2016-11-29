function [ PP ] = PrepPV4( Q,Qs,P )
%Prepare the interpolate PP based on the available P predicts

if Q(1)<Qs && Qs<Q(4)
    iQ=find(Q>Qs,1);
    i2=iQ;
    i1=i2-1;
    fields = fieldnames(P(1));
    for ifld = 1:numel(fields)
        Values=horzcat(P.(fields{ifld}));
        for i=1:length(P(1).t)
            %PP.(fields{ifld})(i)=interp1(Q,Values(i,:),Qs);
            PP.(fields{ifld})(i)=LinIterm(Values(i,:),Q,i1,i2,Qs);
        end
    end
else
    error('Qsource %d is out of range\n' , Qs);
end


end
