function [ avg_temp_high, avg_temp ] = avgTemp( temp_max, picture, threshold )
%avgTemp calculates the average temp of non white area
%   calculates the average temp of non 0 area with and without the higher
%   temp region


temperatura=0;
broj=0;

mks=max(max(picture));
mn=min(min(picture));

for i=1:240
    for j=1:320
        if(temp_max(i,j,1) ~= 255 || temp_max(i,j,2) ~= 255 || temp_max(i,j,3) ~= 255)
            temperatura=temperatura+picture(i,j);
            broj=broj+1;
            
        end
    end
end

prosjecna_temp=temperatura/broj;

temperatura_bez_povisene=0;
broj3=0;

for i=1:240
    for j=1:320
        if(picture(i,j)<(mks-threshold) && picture(i,j)>(mn+5))
            temperatura_bez_povisene=temperatura_bez_povisene+picture(i,j);
            broj3=broj3+1;
        end
    end
end

prosjek_bez_povisene=temperatura_bez_povisene/broj3;

avg_temp=prosjek_bez_povisene;
avg_temp_high=prosjecna_temp;

end