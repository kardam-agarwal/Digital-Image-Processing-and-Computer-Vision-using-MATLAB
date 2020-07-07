a=videoinput('winvideo',1,'YUY2_320x240');  %Start the webcam
b=getselectedsource(a);
a.FramesPerTrigger=Inf;     %No. of frames that the webcam will read
a.ReturnedColorSpace='rgb';
a.frameGrabInterval=5;
preview(a);                %For starting the video preview
start(a);                  %For starting the counter to count 100 frames
while(a.FramesAcquired<=100)
c=getsnapshot(a);
d=imsubtract(c(:,:,1),rgb2gray(c));
d=medfilt2(d,[1,1]);       %Better focus , used in field of depth 
d=im2bw(d,0.05);
e=bwlabel(d,8);
f=regionprops(e,'BoundingBox','Centroid', 'FilledArea','Area');
length(f);
imshow(c);
hold on
for(g=1:length(f))         %Tells the number of boxes that needs to be considered.Here,all
db=f(g).BoundingBox;
dc=f(g).Centroid;
df=f(g).FilledArea;
dg=f(g).Area;
if(df>95)                   %Shouldnt be considered if its too small
rectangle('Position',db,'EdgeColor', 'R', 'LineWidth', 4);
plot(dc(1),dc(2));          %x and y coordinates 
end
end
hold off
end
stop(a);
stoppreview(a);
