%the simulation opf 1T''-ReSe2
% Author:MaKe date：2023/11/5

% parameters
color1 = randi([100 180]);
r = 2;
color2 = randi([200 230]);
color3 = randi([40 80]);


%%% background simulation
bg = zeros(256,256,"uint8");
block = 16;                     
numBlock = 256/block;
color_block = 30;
for i=1:numBlock
    for j=1:numBlock
        min_ = randi([5 30]);
        max_ = min_ + 30;
        bg((i-1)*block+1:i*block, (j-1)*block+1:j*block) = randi([min_ max_],block);
    end
end
bg = imgaussfilt(bg,10);

% cell
centers = [];
for i=1:11
    for j = 1:6
        x = i*22;
        y = j*38;
        centers = cat(1,centers,[x y]);
    end
end

for i=1:11
    for j =1:7
        x = i*22-11;
        y = j*38-19;
        centers = cat(1,centers,[x y]);
    end
end



%%% atom positions
points = [];
for i=1:size(centers)
    cx = centers(i,1);
    cy = centers(i,2);
    pi = [cx-3 cy-4;cx-6 cy+4;cx+3 cy+4;cx+6 cy-4];
    points = cat(1,points,pi);
end
% atom types
points_n = [];
points_sub = [];
points_ad = [];
for i=1:size(points,1)
    choi = randi(50);
    if choi<=3
        points_sub = cat(1,points_sub,points(i,:));       
    elseif choi >=47
        points_ad = cat(1,points_ad,points(i,:));
    else 
        points_n = cat(1,points_n,points(i,:));
    end
end

%%% print
color1 = 180;
r = 2;
color2 = 255;
color3 = 100;
fg = zeros(256,256,"uint8");
label = zeros(256,256,'uint8');
for i = 1:size(points_n,1)
   [x,y] = meshgrid(1:256, 1:256);
   fg( (x-points_n(i,1)).^2 + (y-points_n(i,2)).^2 <= r.^2 ) = color1;

   label(points_n(i,1)-r1:points_n(i,1)+r1,points_n(i,2)-r1:points_n(i,2)+r1 ) = 255;
end
for i = 1:size(points_ad,1)
   [x,y] = meshgrid(1:256, 1:256);
   fg( (x-points_ad(i,1)).^2 + (y-points_ad(i,2)).^2 <= r.^2 ) = color2;
   
   label(points_n(i,1)-r1:points_n(i,1)+r1,points_n(i,2)-r1:points_n(i,2)+r1 ) = 155;
end
for i = 1:size(points_sub,1)
   [x,y] = meshgrid(1:256, 1:256);
   fg( (x-points_sub(i,1)).^2 + (y-points_sub(i,2)).^2 <= r.^2 ) = color3;
   
   label(points_n(i,1)-r1:points_n(i,1)+r1,points_n(i,2)-r1:points_n(i,2)+r1 ) = 55;
end


%%% print better
fg = imgaussfilt(fg,1);             % gauss image as one input
I = fg+bg;                          % fg+bg as one input
%噪音
num_g = randi([0,2]);
num_p = randi([5,15]);

In = imnoise(I,'gaussian');         % noise image as output
for i=1:num_g
    In = imnoise(In,'gaussian');
end
for i=1:num_p
    In = imnoise(In,'poisson'); 
end


%%% High-throughput data generation
% for p=1:10000
%     %parameters
%     color1 = randi([140 160]);
%     r = 2;
%     color2 = randi([210 230]);
%     color3 = randi([60 80]);
%     
%     centers = [];
%     for i=1:11
%         for j = 1:6
%             x = i*22;
%             y = j*38;
%             centers = cat(1,centers,[x y]);
%         end
%     end
%     
%     for i=1:11
%         for j =1:7
%             x = i*22-11;
%             y = j*38-19;
%             centers = cat(1,centers,[x y]);
%         end
%     end
%     

%     points = [];
%     for i=1:size(centers)
%         cx = centers(i,1);
%         cy = centers(i,2);
%         pi = [cx-3 cy-4;cx-6 cy+4;cx+3 cy+4;cx+6 cy-4];
%         points = cat(1,points,pi);
%     end
%     points_n = [];
%     points_sub = [];
%     points_ad = [];
%     for i=1:size(points,1)
%         choi = randi(50);
%         if choi<=2
%             points_sub = cat(1,points_sub,points(i,:));       
%         elseif choi >=48
%             points_ad = cat(1,points_ad,points(i,:));
%         else 
%             points_n = cat(1,points_n,points(i,:));
%         end
%     end
%     
%     % color1 = 180;
%     % r = 2;
%     % color2 = 255;
%     % color3 = 100;
%     fg = zeros(256,256,"uint8");
%     label = zeros(256,256,3);
%     for i = 1:size(points_n,1)
%        [x,y] = meshgrid(1:256, 1:256);
%        fg( (x-points_n(i,1)).^2 + (y-points_n(i,2)).^2 <= r.^2 ) = color1;
%     
%        label(points_n(i,2)-r:points_n(i,2)+r,points_n(i,1)-r:points_n(i,1)+r,2 ) = 1;
% 
%        label(points_n(i,2)-r,points_n(i,1)-r,2 ) = 0;
%        label(points_n(i,2)-r,points_n(i,1)+r,2 ) = 0;
%        label(points_n(i,2)+r,points_n(i,1)-r,2 ) = 0;
%        label(points_n(i,2)+r,points_n(i,1)+r,2 ) = 0;
%     end
%     for i = 1:size(points_ad,1)
%        [x,y] = meshgrid(1:256, 1:256);
%        fg( (x-points_ad(i,1)).^2 + (y-points_ad(i,2)).^2 <= r.^2 ) = color2;
%        
%        label(points_ad(i,2)-r:points_ad(i,2)+r,points_ad(i,1)-r:points_ad(i,1)+r,1 ) = 1;
% 
%        label(points_ad(i,2)-r,points_ad(i,1)-r,1 ) = 0;
%        label(points_ad(i,2)-r,points_ad(i,1)+r,1 ) = 0;
%        label(points_ad(i,2)+r,points_ad(i,1)-r,1 ) = 0;
%        label(points_ad(i,2)+r,points_ad(i,1)+r,1 ) = 0;
%     end
%     for i = 1:size(points_sub,1)
%        [x,y] = meshgrid(1:256, 1:256);
%        fg( (x-points_sub(i,1)).^2 + (y-points_sub(i,2)).^2 <= r.^2 ) = color3;
%        
%        label(points_sub(i,2)-r:points_sub(i,2)+r ,points_sub(i,1)-r:points_sub(i,1)+r,3) = 1;
%        label(points_sub(i,2)-r,points_sub(i,1)-r,3 ) = 0;
%        label(points_sub(i,2)-r,points_sub(i,1)+r,3 ) = 0;
%        label(points_sub(i,2)+r,points_sub(i,1)-r,3 ) = 0;
%        label(points_sub(i,2)+r,points_sub(i,1)+r,3 ) = 0;
%     end
%     
%     fg = imgaussfilt(fg,1);            
%     I = fg;                          
%     num_g = randi([0,2]);
%     num_p = randi([5,20]);
%     In = imnoise(I,'gaussian');         
%     for i=1:num_g
%         In = imnoise(In,'gaussian');
%     end
%     for i=1:num_p
%         In = imnoise(In,'poisson'); 
%     end
% 
%     imwrite(label,['0903/labels/',int2str(p),'.png']);
%     imwrite(fg,['0903/fg/',int2str(p),'.png']);
%     imwrite(In,['0903/In/',int2str(p),'.png']);
% end