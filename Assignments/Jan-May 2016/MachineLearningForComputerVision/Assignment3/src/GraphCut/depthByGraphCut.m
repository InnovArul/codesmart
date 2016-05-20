function [depth_label, afi]= depthByGraphCut(warpIpath,nImages,prefix,format,start)

 display('Reading images .....');
 
 
Fmethod='GRA3';
NHsize=20;

 
for i=start:nImages+start-1
    I=imread(strcat(warpIpath,prefix,sprintf('%.d',i+start-1),format));
    display(strcat(warpIpath,prefix,sprintf('%.d',i+start-1),format));
    imStack(:,:,:,i)=I;
    FM(:,:,i) = focusmeasure(im2double(rgb2gray(I)),Fmethod,NHsize);
    
end

Sc=zeros(nImages);
Dc=max(max(max(FM)))-FM;
for i=1:nImages
    for j=1:nImages
      Sc(i,j)=1.01-0.9^(abs(i-j));
    end
end

display(' Graph cut');
tic
gch = GraphCut('open', Dc, Sc);
%[gch, L] = GraphCut('expand',gch);
[gch, L] = GraphCut('swap',gch);
gch = GraphCut('close', gch);
toc
depth_label= L ;
L=round(L);
afi=zeros([size(L),3]);

for i=1:size(L,1)
    for j=1:size(L,2)
        frame=L(i,j)+1;
        afi(i,j,:)=imStack(i,j,:,frame);
    end
end
%display('test');

% figure,imshow(uint8(afi));
% figure,imshow(uint8(L*25.5));


