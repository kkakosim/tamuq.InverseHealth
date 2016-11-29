function [ v ] = LinIterm( Values,Times,i1,i2,t)
    v=Values(i1)+(t-Times(i1))*(Values(i2)-Values(i1))/(Times(i2)-Times(i1));

end

