function [ picture,mini,maxs ] = removeHeader( table )
%removeHeader removes header of zeros from temperature table
%   removes the zeros header by putting those pixels in next min value,
%   then calculates min and max value of temperature matrix

picture=zeros(240,320);

for i = 1:240 
    for j = 1:320 
        if(table(i, j)~=0)
            picture(i, j)=table(i, j);
        end
        if(table(i,j)==0)
            picture(i,j)=1000;
        end
    end
end

for i = 1:240
    for j = 1:320
        if(picture(i,j)==1000)
            picture(i,j)=min(min(picture));
        end
    end
end


maxs=max(max(picture))
mini=min(min(picture))

end