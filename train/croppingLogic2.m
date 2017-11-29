
for i = 1:25
    close all;
    folder_name = 'data/';
    fn = sprintf ( '%sinput_%02d.jpg%', folder_name, i);
    f = imread ( fn );
    h = histeq(f);
    g = imadjust(rgb2gray(h));
    edgeG = edge(g);
    edgeG = bwareaopen(edgeG,10);

    imshow(edgeG);
    [R,C] = size(edgeG);
    lineImage = zeros(R,C);
    
    [lineImage,theta] = showLine(edgeG,g,2,0);
    adjacentAngle = mod(theta + 90,180);
    if adjacentAngle > 90 
       adjacentAngle = adjacentAngle - 180; 
    end
    oppositeAngle = theta;
    [lineImage,~] = showLine(edgeG,lineImage,1,adjacentAngle);
    [lineImage,~] = showLine(edgeG,lineImage,3,oppositeAngle);
    [lineImage,~] = showLine(edgeG,lineImage,4,adjacentAngle);
%     lineImage = showLine(edgeG,lineImage,1);
%     lineImage = showLine(edgeG,lineImage,3);
%     lineImage = showLine(edgeG,lineImage,4);
    
%      upperEdgeImage = edgeG(1:ceil(R/2),1:C);
%      leftEdgeImage = edgeG(1:R,1:ceil(C/2));
%      rightEdgeImage = edgeG(1:R,ceil(C/2):C);
%      bottomEdgemage = edgeG(ceil(R/2):R,1:C);
    
end

function [lineImageOut,theta] = showLine(image,lineImageIn,part,angle)
    [R,C] = size(image);
    d = ceil(sqrt(R^2 + C^2)); 
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
    imagesc(accum);
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
    if part == 2
        endCordinate = min(x1(end),800);
    else
        endCordinate = x1(end);
    end
    
    lineImageOut = insertShape(lineImageIn,'line',[x1(1),y1(1),x1(floor(endCordinate)/2),y1(floor(endCordinate)/2),x1(endCordinate),y1(endCordinate)]);
    imshow(lineImageOut);
    
end