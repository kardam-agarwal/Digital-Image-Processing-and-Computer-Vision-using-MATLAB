facedetector=vision.CascadeObjectDetector();
videofilereader=vision.VideoFileReader('video1.mp4');
videoframe=step(videofilereader);                           %Since frames are added in stack, face has to be detected as the frame changes
bbox=step(facedetector,videoframe);
videoout=insertObjectAnnotation(videoframe,'rectangle',bbox,'face');
imshow(videoout);
[huechannel,~,~]=rgb2hsv(videoframe);                       %Hsv is better for detecting skin tones
figure;
imshow(huechannel);
rectangle('Position',bbox(1,:),'LineWidth',2,'EdgeColor',[1 1 0]);
nosedetector=vision.CascadeObjectDetector('Nose','UseROI',true);     %UseRoi-Region of interest ,used when we need to focus on a particular boundary and need to process it. By default,false

nosebbox=step(nosedetector,videoframe,bbox(1,:));
tracker=vision.HistogramBasedTracker();

%For simultaneously detecting face and nose

initializeObject(tracker,huechannel,nosebbox(1,:));
Videoinfo=info(videofilereader);
videoplayer=vision.VideoPlayer('Position',[300 300 Videoinfo.VideoSize+30]);    %Videosize + 30 , for creating margin
while ~isDone(videofilereader)
    videoframe=step(videofilereader);
    [huechannel,~,~] =rgb2hsv(videoframe);                                      %to black and white%
    bbox=step(tracker,huechannel);
    videoout=insertObjectAnnotation(videoframe,'rectangle',bbox,'face');
    step(videoplayer,videoout);
end
release(videofilereader);
release(videoplayer);
