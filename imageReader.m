tekst = dlmread('Slike/Adel front.txt');
slika = imread('Slike/Adel front.png');

binary = tekst > 297;
maskedSlika = bsxfun(@times, slika, cast(binary, class(slika)));
imshow(maskedSlika);

%{
for i=1:240
    for j=1:320
        if tekst(i,j)<297
            tekst(i,j)=0;
            slika(i,j)=0;
        end
    end
end
%}



%{
Slika1=Slika(:, 1 : (size(Slika,2)/2));
Slika2=Slika(:, (size(Slika,2)) : -1 : (size(Slika,2)/2)+1);
Tekst1=Tekst(:, 1 : (size(Tekst,2)/2));
Tekst2=Tekst(:, (size(Tekst,2)/2)+1 : (size(Tekst,2)));

figure, imshow(Slika1);
figure, imshow(Slika2);
%imshow(Slika);

ptsPrva = detectSURFFeatures(Slika1);
ptsDruga = detectSURFFeatures(Slika2);

[featuresPrva, validPtsPrva] = extractFeatures(Slika1, ptsPrva);
[featuresDruga, validPtsDruga] = extractFeatures(Slika2, ptsDruga);

indexPairs = matchFeatures(featuresPrva, featuresDruga);

matchedPrva = validPtsPrva(indexPairs(:, 1));
matchedDruga = validPtsDruga(indexPairs(:, 2));

figure;
showMatchedFeatures(Slika1, Slika2, matchedPrva, matchedDruga);
title('Putatively matched points.');

[tform, inlierDruga, inlierPrva] = estimateGeometricTransform(matchedDruga, matchedPrva, 'similarity');

figure;
showMatchedFeatures(Slika1, Slika2, inlierPrva, inlierDruga);
title('Matching points (inlier only)');
legend('ptsPrva', 'ptsDruga');
%}