function [ temp_max,sizeof_max,avg_temp ] = highTemp( picture, imag, threshold )
%highTemp calculates area of high temperature
%   marks area of highest temperature, calculates the average temp of that
%   area and the size of area

velicina=size(picture);

temp_max=zeros(velicina(1),velicina(2),3);

temp_max=uint8(temp_max);

velicina_toplog=0;
pros_temp=0;

mks=max(max(picture));
mn=min(min(picture));

for i = 1:velicina(1)
    for j = 1:velicina(2)
        if(((mks-threshold) <= picture(i,j)))
            temp_max(i,j,1)=0;
            temp_max(i,j,2)=0;
            temp_max(i,j,3)=0;
            velicina_toplog=velicina_toplog+1;
            pros_temp=pros_temp+picture(i,j);
            
        elseif(((mn+5) >= picture(i,j)))
            temp_max(i,j,1)=255;
            temp_max(i,j,2)=255;
            temp_max(i,j,3)=255;
            
        else
            temp_max(i,j,1)=imag(i,j,1);
            temp_max(i,j,2)=imag(i,j,2);
            temp_max(i,j,3)=imag(i,j,3);
        end
        
    end
end

avg_temp=pros_temp/velicina_toplog;
sizeof_max=velicina_toplog;

end