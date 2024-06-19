% the simulation of ADCs/DACs
% Author：MaKe date：2023/11/5


for p=1:5
    %%% parameters
    % generate random atoms
    numPoints = randi([40 80]);
    % set min distance
    minDist = 6; 
    block = randi([1 2])*32;
    r=2;
    color1 = randi([150,170]);
    
    color2 = randi([80 100]);
    
    
    
    %%% set background 
    bg = zeros(256,256,"uint8");
    block = 32;                      
    numBlock = 256/block;
    color_block = 30;
    for i=1:numBlock
        for j=1:numBlock
            min_ = randi([5 40]);
            max_ = min_ + 40;
            bg((i-1)*block+1:i*block, (j-1)*block+1:j*block) = randi([min_ max_],block);
        end
    end
    bg = imgaussfilt(bg,10); 

    %%% get atom positions
    points = zeros(numPoints,2);
    
    for i = 1:numPoints 
        x = randi([6 250]);
        y = randi([6 250]);
        valid = true; 
        for j = 1:i-1
            dist = sqrt((x-points(j,1))^2 + (y-points(j,2))^2);
            if dist < minDist
                valid = false;
                break;
            end
        end
        if valid
            points(i,:) = [x y];
        end  
    end
    idx = find(points(:,1)==0 & points(:,2)==0);
    points(idx,:) = [];

    %%% print 
    
    fg = zeros(256,256,"uint8");
    label = zeros(256,256,3);
    % dimer
    for i = 1:size(points,1)
       [x,y] = meshgrid(1:256, 1:256);
       choi = randi([0 1]);
       if choi==0
           fg( (x-points(i,1)).^2 + (y-points(i,2)).^2 <= r.^2 ) = color2;
           label(points(i,2)-r:points(i,2)+r,points(i,1)-r:points(i,1)+r,2) = 1;
           label(points(i,2)-r,points(i,1)-r,2 ) = 0;
           label(points(i,2)-r,points(i,1)+r,2 ) = 0;
           label(points(i,2)+r,points(i,1)-r,2 ) = 0;
           label(points(i,2)+r,points(i,1)+r,2 ) = 0;
       else
           fg( (x-points(i,1)).^2 + (y-points(i,2)).^2 <= r.^2 ) = color1;
           label(points(i,2)-r:points(i,2)+r,points(i,1)-r:points(i,1)+r,1) = 1;
           label(points(i,2)-r,points(i,1)-r,1) = 0;
           label(points(i,2)-r,points(i,1)+r,1 ) = 0;
           label(points(i,2)+r,points(i,1)-r,1 ) = 0;
           label(points(i,2)+r,points(i,1)+r,1 ) = 0;
       end
    end
    
    
    %%% print better
    se = strel('disk',1);
    fg = imgaussfilt(fg,1);             % gauss image as one input
    I = fg+bg;                          % fg+bg as one input
    % add noise
    num_p = randi([5,15]);
    
    In = imnoise(I,'gaussian');         % noise image as output
    bg = imnoise(bg,'gaussian');
    for i=1:num_p
        In = imnoise(In,'poisson'); 
        bg = imnoise(bg,'poisson');
    end
    imwrite(bg,['0930/bg/',int2str(p),'.png']);
    imwrite(fg,['0930/fg/',int2str(p),'.png']);
    imwrite(In,['0930/In/',int2str(p),'.png']);
end
