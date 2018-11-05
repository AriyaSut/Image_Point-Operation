clear
clc
    %up load picture
picColor = imread('pic2.jpg');

    %change to black&white color
pic = rgb2gray(picColor);

    %pic size
pix1 = size(pic,1);
pix2 = size(pic,2);

low = min(min(pic)); 
high = max(max(pic));
low = double(low);
high = double(high);

    %Probability density function
 hisPic = zeros(1,256);
 for u=1:pix1
     for v=1:pix2
         count = pic(u,v);
         if count==255
             hisPic(256)=hisPic(256)+1;             
         else
             hisPic(count+1)=hisPic(count+1)+1;
         end
     end
 end
 pdfPic = hisPic./(pix1*pix2);

%% Automatic contrast adjustment
for u=1:pix1
     for v=1:pix2
         aca(u,v)= (pic(u,v)-low)*(255/(high-low));      
     end
end


%% Modified automatic contrast
q = 0.005;
haed = 0;
tail = 0;

    %fiind new low and high
for i=1:256
    haed = haed+pdfPic(i);
    if haed>=q 
        if haed-q >= q-(haed-pdfPic(i-1))
            low2 = i-2;
        else
            low2 = i-1;
        end
        break;
    end
end
for i=1:256
    tail = tail+pdfPic(257-i);
    if tail>=q 
        if tail-q >= q-(tail-pdfPic(i-1))
            high2 = 256-i;
        else
            high2 = 255-i;
        end
        break;
    end
end

for u=1:pix1
     for v=1:pix2
         if pic(u,v)<=low2
             mac(u,v) = 0;
         elseif pic(u,v)>=high2   
             mac(u,v) = 255;
         else
             mac(u,v)= (pic(u,v)-low2)*(255/(high2-low2));
         end
     end
end

figure;
imshow(pic, 'InitialMagnification', 'fit')
figure;
imshow(aca, 'InitialMagnification', 'fit')
figure;
imshow(mac, 'InitialMagnification', 'fit')



