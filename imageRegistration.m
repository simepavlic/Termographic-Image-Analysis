
%tekst = dlmread('Slike/Hume prije isokinetike back.txt');
%slika = imread('Slike/Hume prije isokinetike back.png');

%stavi da se samo jednom racuna registracija i podijeli u funkcije!!!!


function [ registeredLeg, tform ] = imageRegistration(firstLeg, secondLeg)

    [optimizer, metric] = imregconfig('multimodal');
    optimizer.InitialRadius = 0.00002;
    optimizer.Epsilon = 1.5e-4;
    optimizer.GrowthFactor = 1.01;
    optimizer.MaximumIterations = 1000;
    tform = imregtform(secondLeg, firstLeg, 'affine', optimizer, metric);
    registeredLeg = imwarp(secondLeg,tform,'OutputView',imref2d(size(firstLeg)));

end



