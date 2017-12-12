function [ firstLeg, secondLeg ] = divideLegs(txtPicture, backDiff, minTemp)

    
    [~, columns] = size(txtPicture);
    row = txtPicture(3, :);
    
    for i=1:columns
        if(row(i) > minTemp + backDiff + 2)
            index1 = i;
            break;
        end
    end
    for i=columns : -1 : index1
        if(row(i) > minTemp + backDiff + 2)
            index2 = i;
            break;
        end
    end
    
    rowPart = row(index1:index2);
    index = index1 + find(rowPart == min(rowPart)) - 1;
    
    firstLeg = txtPicture(:, 1:index);
    secondLeg = txtPicture(:, columns : -1 : index + 1);

end