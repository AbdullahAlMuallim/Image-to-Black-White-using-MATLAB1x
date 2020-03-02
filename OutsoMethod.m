%% EE315 Term Project_191
%   Group: 
%   (305) Alwaleed Alfaqeh  
%   (322) Abdullah Almuallim
%   (327) Mohammed Shahar   
clear all
close all
clc

% Load the image.
IM=imread('IMG_BC.jpg'); % The name of the image file.
% Convert to grayscale.
IMgray=rgb2gray(IM);
% Get the histogram and the pmf.
[m,n]=size(IMgray);
NumPix=m*n;
[y,x]=imhist(IMgray);
imhist(IMgray)
pmf=y./NumPix;
% Segment the image using our Otsu implementation.
Level=smartotsu(x,pmf);
% Segment the image using MATLAB's Otsu.
LEVELotsu=otsuthresh(pmf);
% Convert the image to Black and White using im2bw.
IMbw1=im2bw(IMgray,Level);
IMbwotsu=im2bw(IMgray,LEVELotsu);
% Show the gray image, histogram, pmf, and the black-white image.
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
imshow(IMbw1)
title('Image in black and whight');

function LEVEL=smartotsu(x,pmf)
    % Get the first, second moment, and second central moment.
    temp=x.*pmf;
    MEAN=sum(temp,'all');
    M2=sum(temp.*x,'all');
    Var=M2-MEAN^2;
 
    % number of intensities.
    MAX=max(x)+1;
    % calculate the intra-variances for all possible threshold.
    for i = 1:MAX 
        % Seprate the last itration to avoid divsion by zero.
        if i ~= MAX
            % probability of the black side
            Pb=sum(pmf(1:i)); 
            % probability of the white side
            Pw=1-Pb;
%           Get the first, second moment, and second central moment of
%           the black and wihte side using thier pmfs.
            pmfb=pmf(1:i)./Pb;
            pmfw=pmf(i+1:MAX)./(1-Pb);
            MEANb=dot(x(1:i),pmfb); 
            MEANw=dot(x(i+1:MAX)-x(i+1),pmfw);   
            M2b=dot(x(1:i).^2,pmfb);
            M2w=dot((x(i+1:MAX)-x(i+1)).^2,pmfw);  
            Vb=M2b-MEANb^2;
            Vw=M2w-MEANw^2;
%           get the intra-variance (i.e., within class veriance) for all
%           itrations.
            Vintra(i)=Pb*Vb+Pw*Vw;
        else
            Pb=1;
            Pw=0;
            pmfb=pmf;      
            pmfw=0;
            MEANb=MEAN; 
            MEANw=0;   
            M2b=dot(x.^2,pmfb);
            M2w=0;  
            Vb=M2b-MEANb^2;
            Vw=M2w-MEANw^2;   
            Vintra(i)=Pb*Vb+Pw*Vw;

        end       
    end
    % take the corresponding level for the minimum intra-variance.
    [VintraMin,L]=min(Vintra);
    LEVEL=x(L)/x(MAX);
end