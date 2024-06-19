%%%%%%%%%%%%%%%%%%%%% input of pix2pix data %%%%%%%%%%%%%%%%
for p =1:10000
    img1 = imread(['In/',int2str(p),'.png']);
    img2 = imread(['fg/',int2str(p),'.png']);
    %get size
    [row1, col1] = size(img1);
    [row2, col2] = size(img2);
    
    %creat a support and concat the pics
    img_concat = zeros(max(row1,row2), col1+col2, 'uint8');
    img_concat(1:row1, 1:col1) = img1;
    img_concat(1:row2, col1+1:col1+col2) = img2;

    imwrite(img_concat,['0912/cat/',int2str(p),'.png']);
end