function [ differenceImage, leftPix, rightPix, tempDiff ] = calcDifference(firstLeg, secondLeg, registeredLeg, image, threshold, tform, backgroundDiff, minTemp)

    [rows, columns, ~] = size(image);
    leftPixel = 0; 
    rightPixel = 0;
    maxDiff = 0;


    slicedColumns=size(firstLeg,2);
    for i=1:rows
        for j=1:slicedColumns
            if firstLeg(i,j)~=0 && firstLeg(i,j)>minTemp + backgroundDiff && registeredLeg(i,j)~=0 && registeredLeg(i,j)>minTemp+backgroundDiff
                if abs(firstLeg(i,j)-registeredLeg(i,j))>maxDiff
                    maxDiff = abs(firstLeg(i,j)-registeredLeg(i,j));
                end
                if firstLeg(i,j)-registeredLeg(i,j)>=threshold
                    firstLeg(i,j) = 500;
                    registeredLeg(i,j) = 500;
                elseif firstLeg(i,j)-registeredLeg(i,j)<= -threshold
                    firstLeg(i,j) = 1000;
                    registeredLeg(i,j) = 1000;
                end
            end
        end
    end

    invtform = invert(tform);
    oznacena2 = imwarp(registeredLeg,invtform,'OutputView',imref2d(size(secondLeg)));

    oznacena2 = oznacena2(:, size(oznacena2,2) : -1 : 1, :);
    
    markedImage=cat(2,firstLeg, oznacena2);

    
    for i=1:rows
        for j=1:columns
            if(markedImage(i,j)==500)
                rightPixel =rightPixel+1;
                image(i,j,1)=0;
                image(i,j,2)=0;
                image(i,j,3)=0;
            elseif(markedImage(i,j)==1000)
                leftPixel =leftPixel+1;
                image(i,j,1)=255;
                image(i,j,2)=255;
                image(i,j,3)=255;
            end
        end
    end

    
    differenceImage=image;
    leftPix = leftPixel;
    rightPix = rightPixel;
    tempDiff = maxDiff + 0.5;

end