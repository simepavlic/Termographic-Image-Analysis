function [ name ] = report_generator( document, surname, name, age, originalImage,  maks, sizeof_max, avg_temp_max, avg_temp, avg_L, avg_R, H_L, H_R, OA_L, OA_R, threshComparator)
%report_generator Generates reports in doc from matlab

%set filename, if filename is taken try filename(1), if that is taken try
%filename(2) etc.
dateToday=datestr(clock, 'dd.mm.yyyy.');
reportFilename = strcat(document,'_report_',dateToday,'.doc');
p=1;
while(p)
    if exist(reportFilename, 'file')
        reportFilename=strcat(document,'_report_',dateToday,'_(',num2str(p),').doc');
        p=p+1;
    else
        p=0;
    end
end
wr = wordreport(fullfile(pwd, reportFilename));


%set heading property for Heading files, if property set wrong try english

headingString = 'Naslov ';
try
    % Set style to 'Naslov 1' for top level titles
    wr.setstyle([headingString '1']);
    % Define title
    textString = 'Medical thermographic report';
    % Insert title in the document
    wr.addtext(textString, [0 2]); % two line breaks after text
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for heading styles to default ''Heading ''');
    headingString = 'Heading ';
    wr.setstyle([headingString '1']);
    textString = 'Medical thermographic report';
    wr.addtext(textString, [0 2]); % two line breaks after text
end


headingString = 'Normal ';
try
    % Set style to 'Normal' for top level titles
    wr.setstyle([headingString]);
    % Define title
    textString =strcat('Patient: ',surname,', ',name);
    % Insert title in the document
    wr.addtext(textString, [0 1]); % one line break after text
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for text styles to default ''Normal ''');
    headingString = 'Normal ';
    wr.setstyle([headingString]);
    textString = strcat('Patient: ',surname,', ',name);
    wr.addtext(textString, [0 1]); % one line break after text
end

textString=strcat('Date of birth: ',age);
wr.addtext(textString, [0,2]);

textString=strcat('Date of examination: ',dateToday);
wr.addtext(textString, [0,2]);

textString='__________________________________________________________________________________';
wr.addtext(textString, [0,2]);


headingString = 'Naslov ';
try
    % Set style to 'Naslov' for top level titles
    wr.setstyle([headingString '2']);
    % Define title
    textString ='Sample image';
    % Insert title in the document
    wr.addtext(textString, [0 1]); % one line break after text
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for text styles to default ''Heading ''');
    headingString = 'Heading ';
    wr.setstyle([headingString '2']);
    textString = 'Sample image';
    wr.addtext(textString, [0 1]); % one line break after text
end

wr.insertImage(originalImage);
wr.addtext();
wr.addtext();
wr.addtext('Highlighted higher temperature region', [0 1]);


image=which('roiImageDummy.png');
wr.insertImage(image);
delete roiImageDummy.png
wr.addtext('', [0 3]);

headingString = 'Normal';
try
    % Set style to 'Normal' for top level titles
    wr.setstyle(headingString);
    % Define title
    textString ='';
    % Insert title in the document
    wr.addtext(textString, [0 2]); % two lines break after text
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for text styles to default ''Normal ''');
    headingString = 'Normal ';
    wr.setstyle(headingString);
    textString = '';
    wr.addtext(textString, [0 2]); % two lines break after text
end

wr.addtable(2,4,{'Average leg temperature (°C)', 'Max leg temperature (°C)', 'Area of highlighted region (pixels)', 'Average temperature of highlighted region (°C)';  num2str(maks-273.15), num2str(avg_temp_max-273.15), num2str(sizeof_max), num2str(avg_temp-273.15)},[0 2]);


headingString = 'Naslov ';
textString='Knee segmentation';

try
    % Set style to 'Naslov' for top level titles
    wr.setstyle([headingString '2']);
    wr.addtext(textString, [0, 2]);
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for text styles to default ''Heading ''');
    headingString = 'Heading ';
    wr.setstyle([headingString '2']);
    wr.addtext(textString, [0, 2]);
end


headingString = 'Normal';
try
    % Set style to 'Normal' for top level titles
    wr.setstyle(headingString);
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for text styles to default ''Normal ''');
    headingString = 'Normal ';
    wr.setstyle(headingString);
end


textString='Left knee';
wr.addtext(textString, [0 1]);
image=which('rightKneeSeg.png');
wr.insertImage(image);
wr.addtext('', [0 2]);

textString='Histogram';
wr.addtext(textString, [0 1]);
image=which('rightKneeHist.png');
wr.insertImage(image);

textString=strcat('Average knee temperature (°C) = ',num2str(avg_L-273.15),' Entropy = ',num2str(H_L));
wr.addtext(textString, [0 0]);

    wr.addtext();
    wr.addtext();


textString='Right knee';
wr.addtext(textString, [0 1]);
image=which('leftKneeSeg.png');
wr.insertImage(image);
wr.addtext('', [0 2]);

textString='Histogram';
wr.addtext(textString, [0 1]);
image=which('leftKneeHist.png');
wr.insertImage(image);

textString=strcat('Average knee temperature (°C) = ',num2str(avg_R-273.15),' Entropy = ',num2str(H_R));
wr.addtext(textString, [0 0]);

    wr.addtext('', [0 7]);


headingString = 'Naslov ';
try
    % Set style to 'Naslov' for top level titles
    wr.setstyle([headingString '1']);
    textString='Leg comparison';
    wr.addtext(textString, [0,2]);
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for text styles to default ''Heading ''');
    headingString = 'Heading ';
    wr.setstyle([headingString '1']);
    textString='Leg comparison';
    wr.addtext(textString, [0,2]);
end

image=which('legComparison.png');
wr.insertImage(image);

headingString = 'Normal';
try
    % Set style to 'Normal' for top level titles
    wr.setstyle(headingString);
catch
    % Error when trying to insert first heading. The generic name for
    % heading styles must be wrong, problably due to Microsoft Office
    % language. Resetting to default: ENGLISH (see above for more details)
    warning('Resetting generic name for text styles to default ''Normal ''');
    headingString = 'Normal ';
    wr.setstyle(headingString);
end
wr.addtext();
textString='dT (°C) = 2';
wr.addtext(textString, [0 0]);

delete leftKneeSeg.png leftKneeHist.png rightKneeSeg.png rightKneeHist.png legComparison.png;

wr.select('left','wdWord',10000,'wdExtend');
wr.allign();

%Save and close
wr.close();

dlgString = 'The report has been successfully generated. Do you want to open it ?';
dlgTitle = 'Open the report ?';
answer = questdlg(dlgString, dlgTitle, 'Yes', 'No', 'Yes');
if strcmp(answer, 'Yes')
    open(reportFilename);
end

end