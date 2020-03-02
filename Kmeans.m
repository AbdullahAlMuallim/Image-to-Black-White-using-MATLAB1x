clear all
close all
clc

% Load the image.
IM=imread('IMG_BC.jpg');
% 'A' can be modified to guarantee a better result.
A=10;
M=255;
% Convert the image to gray scale.
IMgray=rgb2gray(IM);
% Use 'kmeans' function to get the centroids.
[a,b]=imsegkmeans(IM,A);
% The threshold is the mean of all elements in b.
Level=mean(mean(b));
IMbw1=im2bw(IMgray,Level/M);
% Show the Black and White image.
imshow(IMbw1)