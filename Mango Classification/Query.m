clc;close all;clear all;

path = 'Path of image';

filename= path;
data = imread(filename);
data = imresize(data , [227,227]);
[mask,lab] = createMask(data);
mask = filterRegions(mask);
[mask,lab] = segmentImage(data,mask);
%Make sure only one region exists, if multiple make changes in the filter-%-regions
ROI = regionprops(mask, 'BoundingBox','Area');
lab = imcrop(lab, ROI.BoundingBox);
%figure;imshow(lab)
originalImage = lab;
[rows,columns,numberOfColorBands] = size(originalImage);
% Construct the 3D gamut.
%lutSize = 256;  % Use 256 to get maximum resolution possible out of a 24 bit RGB image.
lutSize = 8;  % Use a smaller LUT size to get colors grouped into fewer, larger groups in the gamut.
reductionFactor = double(256) / double(lutSize);
gamut3D = zeros(lutSize, lutSize, lutSize);
    
for row = 1 : rows
    for col = 1: columns
        redValue = floor(double(originalImage(row, col, 1)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
        greenValue = floor(double(originalImage(row, col, 2)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
        blueValue = floor(double(originalImage(row, col, 3)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
        gamut3D(redValue, greenValue, blueValue) = gamut3D(redValue, greenValue, blueValue) + 1;
    end
end
colorFrequencyImage = zeros(rows, columns);
for row = 1 : rows
    for col = 1: columns
        redValue = floor(double(originalImage(row, col, 1)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
        greenValue = floor(double(originalImage(row, col, 2)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
        blueValue = floor(double(originalImage(row, col, 3)) / reductionFactor) + 1;	% Convert from 0-255 to 1-256
        freq = gamut3D(redValue, greenValue, blueValue);
        colorFrequencyImage(row, col) =  freq;
    end
end

    dom1R = 0; dom1G = dom1R; dom1B = dom1R;
    dom2R = 0; dom2G = dom2R; dom2B = dom2R;
    dom3R = 0; dom3G = dom3R; dom3B = dom3R;
    dom4R = 0; dom4G = dom4R; dom4B = dom4R;
    domfreq1 =0;
    domfreq2=0;
    domfreq3=0;domfreq4=0; 
    dist1 =0;dist2 =0; dist3=0; dist4=0;
    cfi = colorFrequencyImage;
    
    resolution =rows * columns;% dominant frequency
    m1 =max(colorFrequencyImage);
    maxfreq1 =max(m1);
    
    cfi(cfi>maxfreq1-1) = [];
    maxfreq2 = max(cfi);
    
    cfi(cfi>maxfreq2-1) = [];
    maxfreq3 = max(cfi);
    
    cfi(cfi>maxfreq3-1) = [];
    maxfreq4 = max(cfi);
    for row =1 : rows
        for col =1: columns
             
             if(colorFrequencyImage(row,col)==maxfreq1)
                newfreq =colorFrequencyImage(row,col);          %retrieved frequency
                if (domfreq1==0)
                    domfreq1=newfreq;                           % checking with first dominant freq.
                    dist1 =((domfreq1/(resolution)));  % calculating percentage distribution
                
                    dom1R =(double(originalImage(row, col, 1)));
                    dom1G =(double(originalImage(row, col, 2)));
                    dom1B =(double(originalImage(row, col, 3)));
                end
             
                         
             elseif(colorFrequencyImage(row,col) == maxfreq2)
                newfreq =colorFrequencyImage(row,col);
                if ((domfreq2==0))     % checking with second dominant freq.
                domfreq2 = newfreq;
                
                dist2 =((domfreq2/(resolution)));  % calculating percentage distribution
                
                dom2R =(double(originalImage(row, col, 1)));
                dom2G =(double(originalImage(row, col, 2)));
                dom2B =(double(originalImage(row, col, 3)));
                end
            

             elseif (colorFrequencyImage(row,col) == maxfreq3)    % checking with third dom freq
                newfreq =colorFrequencyImage(row,col);
                if ((domfreq3==0)) 
                    domfreq3 =newfreq;
                
                    dist3 =((domfreq3/(resolution)));  % calculating percentage distribution
                
                    dom3R =(double(originalImage(row, col, 1)));
                    dom3G =(double(originalImage(row, col, 2)));
                    dom3B =(double(originalImage(row, col, 3)));
                end
        
             elseif (colorFrequencyImage(row,col) == maxfreq4)    % checking with third dom freq
                newfreq =colorFrequencyImage(row,col);
                if ((domfreq4==0)) 
                    domfreq4 =newfreq;
                
                    dist4 =((domfreq4/(resolution)));  % calculating percentage distribution
                
                    dom4R =(double(originalImage(row, col, 1)));
                    dom4G =(double(originalImage(row, col, 2)));
                    dom4B =(double(originalImage(row, col, 3)));
                end
            end
        end
    end
 %initializing normalized dist values
    normdist1 = 0.0;normdist2 = 0.0;normdist3 = 0.0; normdist4 = 0.0;
    distsum1 = (dist1+dist2+dist3+dist4);
    normdist1 =(dist1/distsum1);               % calculating normalized values of distributions
    normdist2 =(dist2/distsum1);
    normdist3 =(dist3/distsum1);
    normdist4 =(dist4/distsum1);
    
     %defining color features for each region
    color1 = [dom1R  dom1G  dom1B normdist1;];
    color2 = [dom2R  dom2G  dom2B normdist2;];
    color3 = [dom3R  dom3G  dom3B normdist3;];
    color4 = [dom4R  dom4G  dom4B normdist4;];
    %color_mat = [color_mat;color1;color2;color3;color4];
color  = [color1;color2;color3;color4]; 
rcolor = [color1(1,1:3);color2(1,1:3);color3(1,1:3);color4(1,1:3);];
    
%removing black color as dominant color
nbcolor = color(any(rcolor,2),:);
meanvalue = mean(nbcolor);  %find mean of each column
meanR = meanvalue(1);       %mean value of R

if ((meanR>=201) && (meanR <=255))
    display("Cluster 5 - Artifical Mango");
elseif ((meanR>=145) && (meanR <=200))
    display("Cluster 4 - Natural Mango");
elseif ((meanR>=101) && (meanR <=144))
    display("Cluster 3 - Natural Mango");
else
    display("Not defined");
end