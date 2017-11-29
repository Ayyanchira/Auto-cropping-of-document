function [x0, y0, x1, y1, x2, y2, x3, y3] = auto_crop ( f )
 f = imresize(f,0.5);
%%%IMPORTANT%%%
% x0,y0 are the x, y coordinates of the top left corner of image
% x1,y1 are the x, y coordinates of the top right corner of image
% x2,y2 are the x, y coordinates of the bottom right corner of image
% x3,y3 are the x, y coordinates of the bottom left corner of image

%getting size of the input image
% Ro = size(f,1);
% Co = size(f,2);
% 
% % always pick middle half
% x0 = double(Co*.25);
% y0 = double(Ro*.25);
% 
% x1 = double(Co*.75);
% y1 = double(Ro*.25);
% 
% x2 = double(Co*.75);
% y2 = double(Ro*.75);
% 
% x3 = double(Co*.25);
% y3 = double(Ro*.75);
% for i = 1:25
%     close all;
%     folder_name = 'data/';
%     fn = sprintf ( '%sinput_%02d.jpg%', folder_name, i);
%     f = imread ( fn );
    h = histeq(f);
    g = imadjust(rgb2gray(h));
%     bn = imbinarize(g);
    edgeG = edge(g);
    edgeG = bwareaopen(edgeG,10);

%     imshow(edgeG);
    [R,C] = size(edgeG);
%     lineImage = zeros(R,C);
%     [R,C] = size(image);
    d = ceil(sqrt(R^2 + C^2)); 
    [lineImage,theta,leftLineXs,leftLineYs] = showLine(edgeG,g,2,0,R,C,d);
    adjacentAngle = mod(theta + 90,180);
    if adjacentAngle > 90 
       adjacentAngle = adjacentAngle - 180; 
    end
    oppositeAngle = theta;
    [lineImage,~,topLineXs,topLineYs] = showLine(edgeG,lineImage,1,adjacentAngle,R,C,d);
    [lineImage,~,rightLineXs,rightLineYs] = showLine(edgeG,lineImage,3,oppositeAngle,R,C,d);
    [~,~,bottomLineXs,bottomLineYs] = showLine(edgeG,lineImage,4,adjacentAngle,R,C,d);

    [topleftCornerX,topLeftCornerY] = polyxpoly(topLineXs,topLineYs,leftLineXs,leftLineYs);
    [topRightCornerX,topRightCornerY] = polyxpoly(topLineXs,topLineYs,rightLineXs,rightLineYs);
    [bottomLeftCornerX,bottomLeftCornerY] = polyxpoly(bottomLineXs,bottomLineYs,leftLineXs,leftLineYs);
    [bottomRightCornerX,bottomRightCornerY] = polyxpoly(bottomLineXs,bottomLineYs,rightLineXs,rightLineYs);
    
    x0 = ceil(topleftCornerX) * 2;
    y0 = ceil(topLeftCornerY) * 2;
    x1 = ceil(topRightCornerX) * 2;
    y1 = ceil(topRightCornerY) * 2;
    x2 = ceil(bottomRightCornerX) * 2;
    y2 = ceil(bottomRightCornerY) * 2;
    x3 = ceil(bottomLeftCornerX) * 2;
    y3 = ceil(bottomLeftCornerY) * 2;
end

function [lineImageOut,theta,x1,y1] = showLine(image,lineImageIn,part,angle,R,C,d)
   
    portionImage = zeros(R,C);
    accum = zeros(2*d+1,180);
    
    if part == 1
        portionImage(1:ceil(R/2),1:C) = image(1:ceil(R/2),1:C);
        [ri, ci] = find(portionImage == 1);
        if angle > 10 && angle < 60
            perform = 1; % perform right only
        elseif angle < -10 && angle 
            perform = 2; % perform left only
        else
            perform = 3; % perform both
        end
        
        for j = 1:numel(ri)
            if (perform == 1)
                for theta = angle-10:angle+10
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                end
            end
            if (perform == 2)
                for theta = 180-abs(angle)-10:180-abs(angle) + 10
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                end
            end
            if perform == 3
                 for theta = 1:10
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                 end
                for theta = 170:180
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                end
            end
        end
    elseif part == 2
        portionImage(1:R,1:ceil(C/2)) = image(1:R,1:ceil(C/2));
        [ri, ci] = find(portionImage == 1);
         for j = 1:numel(ri)
            for theta = 50:140
                rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
            end
        end
    elseif part == 3
        portionImage(1:R,ceil(C*(5/8)):C) = image(1:R,ceil(C*(5/8)):C);
        [ri, ci] = find(portionImage == 1);
        for j = 1:numel(ri)
            for theta = angle-10:angle+10
                rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
            end
        end
    elseif part == 4
        portionImage(ceil(R/2):R,1:C) = image(ceil(R/2):R,1:C);
        [ri, ci] = find(portionImage == 1);
        if angle > 10
            perform = 1; % perform right only
        elseif angle < -10
            perform = 2; % perform left only
        else
            perform = 3; % perform both
        end
        for j = 1:numel(ri)
            if (perform == 1)
                for theta = angle-10:angle+10
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                end
            end
            if (perform == 2)
                for theta = 180-abs(angle)-10:180-abs(angle) + 10
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                end
            end
            if perform == 3
                 for theta = 1:10
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                 end
                for theta = 170:180
                    rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                    accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
                end
            end
        end
    end
%     imagesc(accum);
    sortedMaxValues = sort(accum(:),'descend');
    lineValue = sortedMaxValues(1);
    [I,J] = find(accum == lineValue);
    rho = I(1)-d-1;
    theta = J(1)-1;
    
    x1 = [];
    y1 = [];
    for x = 1:C
        %         y = round(-x*cotd(theta)) + round(rho*cscd(theta));
        y = (rho - x*sind(theta))/cosd(theta);
        x1 = [x1,x];
        y1 = [y1,y];
    end
%     if part == 2
%         endCordinate = min(x1(end),800);
%     else
        endCordinate = x1(end);
%     end
    lineImageOut = insertShape(lineImageIn,'line',[x1(1),y1(1),x1(floor(endCordinate/2)),y1(floor(endCordinate/2)),x1(endCordinate),y1(endCordinate)]);
%      imshow(lineImageOut);
    
end

%%Some random numbers come out of here
%x0 = randi([1 Co],1,1);
%y0 = randi([1 Ro],1,1);
%x1 = randi([1 Co],1,1);
%y1 = randi([1 Ro],1,1);
%x2 = randi([1 Co],1,1);
%y2 = randi([1 Ro],1,1);
%x3 = randi([1 Co],1,1);
%y3 = randi([1 Ro],1,1);




