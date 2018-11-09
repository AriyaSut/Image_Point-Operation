clear;
clc;
    %up load picture
refColor = imread('pic.jpg');
toastColor = imread('toast.jpg');

    %change to black&white color
ref = rgb2gray(refColor);
toast = rgb2gray(toastColor);

    %pic size
pix1 = size(ref,1);
pix2 = size(ref,2);
pixT1 = size(toast,1);
pixT2 = size(toast,2);

    %Histrogram
 hisRef = zeros(1,256);
 for u=1:pix1
     for v=1:pix2
         count = ref(u,v);
         if count==255
             hisRef(256)=hisRef(256)+1;             
         else
             hisRef(count+1)=hisRef(count+1)+1;
         end
     end
 end
 
 hisToast = zeros(1,256);
 for u=1:pixT1
     for v=1:pixT2
         count = toast(u,v);
         if count==255
             hisToast(256)=hisToast(256)+1;             
         else
             hisToast(count+1)=hisToast(count+1)+1;
         end
     end
 end
 
    %Comulative distribution function(CDF)
 comNewim(1) = hisRef(1);    %find Comulative histogram
 for i = 2:256
     comNewim(i) = (comNewim(i-1)+hisRef(i));
 end
 cdfRef = comNewim./(pix1*pix2); %find CDF
 
 comToast(1) = hisToast(1);    %find Comulative histogram
 for i = 2:256
     comToast(i) = (comToast(i-1)+hisToast(i));
 end
 cdfToast = comToast./(pixT1*pixT2); %find CDF
 
     %Calculate new pixel value 
 for i = 1:256
     for n = 2:256
          if cdfToast(i) < cdfRef(n) 
            if cdfRef(n)-cdfToast(i) <= cdfToast(i)-cdfRef(n-1)
                newValue(i) = n-1;
            else
                newValue(i) = n-2;
            end
            break;
          end
     end
 end
 newValue(256) = 255;
  
    %map new image
newim = uint8(zeros(pixT1,pixT2));
for row=1:pixT1
     for c=1:pixT2
         value = toast(row,c);
         newim(row,c)=newValue(value+1);
     end
end

    %new Image Histrogram
 hisNewim = zeros(1,256);
 for u=1:pixT1
     for v=1:pixT2
         count = newim(u,v);
         if count==255
             hisNewim(256)=hisNewim(256)+1;             
         else
             hisNewim(count+1)=hisNewim(count+1)+1;
         end
     end
 end

    %CDF of new image
 comNewim(1) = hisNewim(1);    %find Comulative histogram
 for i = 2:256
     comNewim(i) = (comNewim(i-1)+hisNewim(i));
 end
 cdfNewim = comNewim./(pixT1*pixT2); %find CDF
   
subplot(2,3,3); imshow(ref, 'InitialMagnification', 'fit'); title('Reference Image')
subplot(2,3,6); plot(cdfRef); axis([0 256 0 inf]); 
subplot(2,3,1); imshow(toast, 'InitialMagnification', 'fit'); title('Original Image')
subplot(2,3,4); plot(cdfToast); axis([0 256 0 inf]);
subplot(2,3,2); imshow(newim, 'InitialMagnification', 'fit'); title('New image')
subplot(2,3,5); plot(cdfNewim); axis([0 256 0 inf]);

 