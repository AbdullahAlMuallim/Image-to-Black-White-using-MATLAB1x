close all
clear all
clc

% Maximum number of intensities.
M=255;
% Read the image.
IM=imread('IMG_BC.jpg');
% Convert the coloured image to grayscale.
IMgray=imnoise(rgb2gray(IM),'gaussian');
% Get the #rows and #colums.
[r,c]=size(IMgray);
% Calculate #pixles
NumPix=r*c;
% Get the histogram.
[y,x]=imhist(IMgray);
% Convert the histogram to pmf.
pmf=y./NumPix;
% Finding the threshold level using MATLAB built in function 'otsuthresh' of the image.
L=otsuthresh(pmf);
% Find the biggest numbers that can divide #rows.
R=max(factor(r));
% Find the biggest numbers that can divide # columns.
C=max(factor(c));
% Calculate the number of pixels of each row and columns in the subimage.
segr=r/R;
segc=c/C;
% Divide the image into R*C subimages.
for p=1:R
    for q=1:C
% Create two vector to separate the pixels for the rows and the columns.  
        RR=[1+(p-1)*segr:p*segr];
        CC=[1+(q-1)*segc:q*segc];
        for rr=1:segr
            for cc=1:segc
                SUBIMs(rr,cc,p,q)=IMgray(RR(rr),CC(cc));
            end
        end
    end
end
% 'T' and 't' are Parameters to guarantee a better image quality and to
% avoid noises from the variation of threshold level as much as possible.

%   Cutting the left and right sides of the threshold level into to two portions
%   using Otsu method with conditional pmfs.
    xb=1:(M*L);
    xw=(((M*L)+1):M);
    Pb=sum(pmf(xb)); 
    Mb=M*L;
    Mw=M-(M*L);
    Pmfb=pmf(xb)/Pb;
    Pmfw=pmf(xw)/(1-Pb);
    BB=Mb*otsuthresh(Pmfb);
    WW=Mw*otsuthresh(Pmfw)+(M*L);
    % Get the edges of the left and the right portions.
    Tb=floor(BB);
    Tw=ceil(WW);
%   Divide the regions between Tb and Tw of the image's pmf into to two
%   subregions by using Otsu method with conditional pmfs.
    xbs=Tb:(M*L);
    xws=((M*L)+1):Tw;
    Pbs=sum(pmf(xbs)); 
    Pws=sum(pmf(xws));
    Mb=M*L-Tb;
    Mw=Tw-(M*L+1);
    Pmfb=pmf(xbs)/Pbs;
    Pmfw=pmf(xws)/Pws;
    BB=Mb*otsuthresh(Pmfb)+Tb;
    WW=Mw*otsuthresh(Pmfw)+(M*L);
%   Get the edges of the Subregions.
    tb=ceil(BB);
    tw=floor(WW);
    
% Convert the individual subimages into Black and White.
for p=1:R
    for q=1:C
        Subpmf=(imhist(SUBIMs(:,:,p,q)))./(segr*segc);
        Level(p,q)=M*otsuthresh(Subpmf);

        if Level(p,q)>=(Tb) && Level(p,q)<=(Tw)
            if Level(p,q)<=(tb)
              Subimbw(:,:,p,q)=im2bw(SUBIMs(:,:,p,q),L);
            elseif Level(p,q)>=(tw)
              Subimbw(:,:,p,q)=im2bw(SUBIMs(:,:,p,q),L);
            else 
            Subimbw(:,:,p,q)=im2bw(SUBIMs(:,:,p,q),L);
            end 
        else
          if Level(p,q)<(Tb)
              Subimbw(:,:,p,q)=im2bw(SUBIMs(:,:,p,q),((tw+Level(p,q))/2)/M);
          end   
          if Level(p,q)>(Tw)
              Subimbw(:,:,p,q)=im2bw(SUBIMs(:,:,p,q),((tb+Level(p,q))/2)/M);
          end 
        end
    end
end

% Combine the black and white subimages.
for p=1:R
    for q=1:C
        RR=[1+(p-1)*segr:p*segr];
        CC=[1+(q-1)*segc:q*segc];
        for rr=1:segr
            for cc=1:segc
                IMBW(RR(rr),CC(cc))=Subimbw(rr,cc,p,q);
            end
        end
    end
end

figure(1)
imshow(IMgray)
title('The coloured image');
figure(2)
imhist(IMgray)
xlabel('Intensity in the grayscale');
ylabel('Number of pixels');
title('The histogram');
figure(3)
stem(x,pmf,'.')
xlabel('Intensity in the grayscale');
ylabel('Dinsity of the pixels');
title('The pmf');
figure(4)
imshow(IMBW)
title('Image in black and whight');
