close all
clear all
clc

% Load the image.
IM=imread('IMG_BC.jpg');
% 'A' better to be modified so that it matches the number of objects in the image.   
A=7;
M=255;
IMgray=rgb2gray(IM);
[r,c]=size(IMgray);
% Determine the 'A' objects using enhanced Kmeans. 
 wavelength = 2.^(0:5) * 3;
 orientation = 0:45:135;
 g = gabor(wavelength,orientation);
 gabormag = imgaborfilt(IMgray,g);
 for i = 1:length(g)
     sigma = 0.5*g(i).Wavelength;
     gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),3*sigma); 
 end
[X,Y]=meshgrid(1:c,1:r);
featureSet=cat(3,IMgray,gabormag,X,Y);
% Matrix 'a' is used to categorize the objects in the image.
a = imsegkmeans(featureSet,A,'NormalizeInput',true);
% C = labeloverlay(IMgray,a);
% imshow(C);
m=0;
n=0;
v=0;
z=0;
s=0;
u=0;
w=0;
% Fragment the image into 'A' objects.
for i=1:r
    for j=1:c
        % Separate the object to distinct images.
        switch a(i,j)
            case 1
                m=m+1;
                e1(i,j)=IMgray(i,j);
                IM1(m)=IMgray(i,j);
            case 2
                v=v+1;
                e2(i,j)=IMgray(i,j);
                IM2(v)=IMgray(i,j);
            case 3
                w=w+1;
                e3(i,j)=IMgray(i,j);
                IM3(w)=IMgray(i,j);
            case 4
                z=z+1;
                e4(i,j)=IMgray(i,j);
                IM4(z)=IMgray(i,j);
            case 5
                s=s+1;
                e5(i,j)=IMgray(i,j);
                IM5(s)=IMgray(i,j);
            case 6
                u=u+1;
                e6(i,j)=IMgray(i,j);
                IM6(u)=IMgray(i,j);
            otherwise
                n=n+1;
                e7(i,j)=IMgray(i,j);
                IM7(n)=IMgray(i,j);
        end
    end
end
% NOTE: The user might have to omit some of pmf#, L#, and IM## lines depending on the value of ‘A’.
% Get the pmf of the objects.
pmf1=imhist(IM1)/m;
pmf2=imhist(IM2)/v;
pmf3=imhist(IM3)/w;
pmf4=imhist(IM4)/z;
pmf5=imhist(IM5)/s;
pmf6=imhist(IM6)/u;
pmf7=imhist(IM7)/n;
% Get otsu's threshold for each object.
L1=otsuthresh(pmf1);
L2=otsuthresh(pmf2);
L3=otsuthresh(pmf3);
L4=otsuthresh(pmf4);
L5=otsuthresh(pmf5);
L6=otsuthresh(pmf6);
L7=otsuthresh(pmf7);
% Convert the each object to Black & white.
IM11=im2bw(e1,L1);
IM22=im2bw(e2,L2);
IM33=im2bw(e3,L3);
IM44=im2bw(e4,L4);
IM55=im2bw(e5,L5);
IM66=im2bw(e6,L6);
IM77=im2bw(e7,L7);
% Create the black & white image by combining the black & white objects.
for i=1:r
    for j=1:c
        switch a(i,j)
            case 1
                IMBW(i,j)=IM11(i,j);
            case 2
                IMBW(i,j)=IM22(i,j);
            case 3
                IMBW(i,j)=IM33(i,j);
            case 4
                IMBW(i,j)=IM44(i,j);
            case 5
                IMBW(i,j)=IM55(i,j);
            case 6
                IMBW(i,j)=IM66(i,j);
            otherwise 
                IMBW(i,j)=IM77(i,j);
        end
    end
end
% show the Black&White image.
imshow(IMBW)
