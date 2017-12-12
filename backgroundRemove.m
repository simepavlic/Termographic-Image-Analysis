function [ imag ] = backgroundRemove( imag, table )
%backgroundRemove Removes background in image
% detects and removes background using histogram approximation

picture=removeHeader(table);

[hist,edges,~]=histcounts(picture);

[pks,locs]=findpeaks(hist,edges(1:end-1));

p=0;
s=size(locs);
for i=1:s(2)
    if(i==1)
        if(pks(1)>0 && pks(2)<pks(1))
            localMax(1)=1;
            p=1;
        end
    elseif(i==s(2))
        if(pks(i)>0 && pks(i)>pks(i-1))
            p=p+1;
            localMax(p)=i;
        end
    else
        if(pks(i)>pks(i-1) && pks(i)>pks(i+1))
            p=p+1;
            localMax(p)=i;
        end
    end
end

localMax(1)=locs(localMax(1));
localMax(2)=locs(localMax(2));

localMax
p=0;
s=size(hist);
for i=1:s(2)
    if(p)
        if(m>hist(i))
            m=hist(i);
            % MIJENJAJ OVAJ PARAMETAR 
            % +1, +2, +3, +4, +5, +6... 
            % PA KAKO TI NAJBOLJE ISPADA
            n=edges(i+4); 
        end
        if(edges(i)==localMax(2))
            break;
        end
    end
    if(edges(i)==localMax(1))
        p=1;
        m=hist(i);
    end
end

s=size(imag);

for i=1:s(1)
    for j=1:s(2)
        if(picture(i,j)<=n)
            imag(i,j,1)=255;
            imag(i,j,2)=255;
            imag(i,j,3)=255;
        end
    end
end


end

