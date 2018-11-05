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

    %histogram
    hisAca = zeros(1,256);
 for u=1:pix1
     for v=1:pix2
         count = aca(u,v);
         if count==255
             hisAca(256)=hisAca(256)+1;             
         else
             hisAca(count+1)=hisAca(count+1)+1;
         end
     end
 end

%% Modified automatic contrast
q = 0.005;
haed = 0;
tail = 0;

    %find new low and high
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

    %Calculate new pixel value
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

    %histogram
    hisMac = zeros(1,256);
 for u=1:pix1
     for v=1:pix2
         count = mac(u,v);
         if count==255
             hisMac(256)=hisMac(256)+1;             
         else
             hisMac(count+1)=hisMac(count+1)+1;
         end
     end
 end

figure;
subplot(3,2,1); imshow(pic, 'InitialMagnification', 'fit'); title('Picture')
subplot(3,2,2); plot(hisPic); axis([0 256 0 inf]); title('Histogram')
subplot(3,2,3); imshow(aca, 'InitialMagnification', 'fit');
subplot(3,2,4); plot(hisAca); axis([0 256 0 inf]);
subplot(3,2,5); imshow(mac, 'InitialMagnification', 'fit');
subplot(3,2,6); plot(hisMac); axis([0 256 0 inf]);



