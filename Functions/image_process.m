function y = image_process(x)
%%This function is used to resize the 
%%training images to 128*128 by bicubic.
    x = abs(x);
    y = (x-min(x)) ./(max(x)-min(x));
    y = imresize(y,[128,128],"bicubic");
end
