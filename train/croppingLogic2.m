
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
    lineImage = showLine(edgeG,lineImage,1);
    lineImage = showLine(edgeG,lineImage,2);
    lineImage = showLine(edgeG,lineImage,3);
    lineImage = showLine(edgeG,lineImage,4);
    
%      upperEdgeImage = edgeG(1:ceil(R/2),1:C);
%      leftEdgeImage = edgeG(1:R,1:ceil(C/2));
%      rightEdgeImage = edgeG(1:R,ceil(C/2):C);
%      bottomEdgemage = edgeG(ceil(R/2):R,1:C);
    
end

function lineImageOut = showLine(image,lineImageIn,part)
    [R,C] = size(image);
    d = ceil(sqrt(R^2 + C^2)); 
    portionImage = zeros(R,C);
    accum = zeros(2*d+1,180);
    
    if part == 1
        portionImage(1:ceil(R/2),1:C) = image(1:ceil(R/2),1:C);
        [ri, ci] = find(portionImage == 1);
        for j = 1:numel(ri)
            for theta = 1:35
                rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
            end
            for theta = 135:180
                rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
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
        portionImage(1:R,ceil(C/2):C) = image(1:R,ceil(C/2):C);
        [ri, ci] = find(portionImage == 1);
        for j = 1:numel(ri)
            for theta = 50:140
                rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
            end
        end
    elseif part == 4
        portionImage(ceil(R/2):R,1:C) = image(ceil(R/2):R,1:C);
        [ri, ci] = find(portionImage == 1);
        for j = 1:numel(ri)
            for theta = 1:35
                rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
            end
            for theta = 135:180
                rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
                accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
            end
        end
    end
    
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
    lineImageOut = insertShape(lineImageIn,'line',[x1(1),y1(1),x1(end),y1(end)]);
    imshow(lineImageOut);
end