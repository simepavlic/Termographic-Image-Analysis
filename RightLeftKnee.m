function [ left, left_temp, right, right_temp, avg_L, avg_D, celsijusi_L, celsijusi_D ] = RightLeftKnee( table, imag )
%RightLeftKnee separates right and left knee
%   with input arguments of thermo image and its table of temperatures,
%   separates knees in two different pictures

provjera=0;
sirina=0;
sirina_D=0;


[picture, ~, maks]=removeHeader(table);
[temp_max, ~, ~]=highTemp(picture,imag,0.5);
[avg_temp_high, ~]=avgTemp(temp_max, picture,0.5);


for i = 1:320

    if(table(3,i) > (avg_temp_high-(maks-avg_temp_high)) && ~provjera)
        provjera=1;
    end
    
    if((table(3,i)<(avg_temp_high-(maks-avg_temp_high))) && provjera==1)
       y=i;
       provjera=2;
    end
    
    if(provjera==1)
       
        sirina=sirina+1;
        
    end
    
    if(provjera==3 && (table(3,i)<(avg_temp_high-(maks-avg_temp_high))))
        yD=i;
        break;
    end
    
    if(provjera==2 && (table(3,i)>(avg_temp_high-(maks-avg_temp_high))))
       sirina_D=sirina_D+1;
       provjera=3;
    end
    
    if(provjera==3)
        sirina_D=sirina_D+1;
    end
    
end

left=uint8(zeros(120, sirina+20, 3));
left_temp=zeros(120, sirina+20);

for i=1:120
    for j=1:sirina+20
        
        left(i,j,1) = imag(59+i,y-sirina-20-1+j,1);
        left(i,j,2) = imag(59+i,y-sirina-20-1+j,2);
        left(i,j,3) = imag(59+i,y-sirina-20-1+j,3);
        
        left_temp(i,j) = table(59+i,y-sirina-20-1+j);
    end
end

right=uint8(zeros(120, sirina_D+20, 3));
right_temp=zeros(120, sirina_D+20);

for i=1:120
    for j=1:sirina_D+20
        
        right(i,j,1) = imag(59+i,yD-sirina_D-1+j,1);
        right(i,j,2) = imag(59+i,yD-sirina_D-1+j,2);
        right(i,j,3) = imag(59+i,yD-sirina_D-1+j,3);
        
        right_temp(i,j) = table(59+i,yD-sirina_D-1+j);
    end
end

mn=min(min(left_temp));

temp_L=0;
size_L=0;
for i = 1:120
    for j = 1:sirina+20
          
        if(((mn+5) >= left_temp(i,j)))
            left(i,j,1)=255;
            left(i,j,2)=255;
            left(i,j,3)=255;
        
        else
            
            temp_L=temp_L+left_temp(i,j);
            size_L=size_L+1;
        end
        
    end
end


mn_D=min(min(right_temp));

temp_D=0;
size_D=0;
for i = 1:120
    for j = 1:sirina_D+20
          
        if(((mn_D+5) >= right_temp(i,j)))
            right(i,j,1)=255;
            right(i,j,2)=255;
            right(i,j,3)=255;
        
        else
            temp_D=temp_D+right_temp(i,j);
            size_D=size_D+1;
        end
        
    end
end

avg_D=temp_D/size_D;
avg_L=temp_L/size_L;

k=0;
for i = 1:120
    for j = 1:sirina+20
        
        if(left_temp(i,j)>mn+5)
            k=k+1;
            celsijusi_L(k)=left_temp(i,j)-273.15;
        
        end
    end
end

k=0;
for i = 1:120
    for j = 1:sirina_D+20
        
        if(right_temp(i,j)>mn_D+5)
           k=k+1;
           celsijusi_D(k)=right_temp(i,j)-273.15;
        end
    end
end

end