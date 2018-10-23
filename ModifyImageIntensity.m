%up load picture
picColor = imread('pic.jpg');

%change to black&white color
pic = rgb2gray(picColor);

%pic size
pix1 = size(pic,1);
pix2 = size(pic,2);

%%contrast&Brightness
    %contrast : xa to all pixle
a = 0.5;
picCon = pic.*a;
    %Brightness : +a to all pixle
a = 20;
picBri = pic+a;

%%Inversting
for u=1:pix1
     for v=1:pix2
         picInv(u,v) = 255-pic(u,v);
     end
end

%%Threshold : map all pixles to 2 fix intensity value a,b
a = 0;
b = 255;
th = 128;
for u=1:pix1
     for v=1:pix2
         if pic(u,v)<= 128
             picTh(u,v) = a;
         else 
             picTh(u,v) = b;
         end
     end
end
