for i = 1:25
    close all;
    folder_name = 'data/';
    fn = sprintf ( '%sinput_%02d.jpg%', folder_name, i);
    f = imread ( fn );
%     gr = rgb2gray(f);
%     edgeG = edge(gr);
%     figure('name','Edge Image');
%     imshow(edgeG);
    h = histeq(f);
    g = imadjust(rgb2gray(h));
%     figure;
%     imshow(h);
    edgeG = edge(g);
    edgeG = bwareaopen(edgeG,10);
    figure;
     imshow(edgeG);
     [R,C] = size(edgeG);
     d = ceil(sqrt(R^2 + C^2)); 
     upperEdgeImage = edgeG(1:ceil(R/2),1:C);
     leftEdgeImage = edgeG(1:R,1:ceil(C/2));
     rightEdgeImage = edgeG(1:R,ceil(C/2):C);
     bottomEdgemage = edgeG(ceil(R/2):R,1:C);
     
     upperImage = h(1:ceil(R/2),1:C);
     leftImage = h(1:R,1:ceil(C/2));
     rightImage = h(1:R,ceil(C/2):C);
     bottomImage = h(ceil(R/2):R,1:C);
     
     accumUp = accumOfHorizontalLines(upperEdgeImage,d);
     accumLeft = accumOfVerticalLines(leftEdgeImage,d);
     accumRight = accumOfVerticalLines(rightEdgeImage,d);
     accumBottom = accumOfHorizontalLines(bottomEdgemage,d);

%      accumCopy = zeros(2*d+1,180);
     accumAll = accumUp + accumLeft + accumRight + accumBottom;
     sortedMaxValues = sort(accumAll,'descend');
     showlines(accumAll,f,d);
     accumCopy = zeros(2*d+1,180);
     
     inclinationTopEdge = showlines(accumUp,upperImage,d);
     inclinationLeftEdge = showlines(accumLeft,leftImage,d);
     inclinationRightEdge = showlines(accumRight,rightImage,d);
     inclinationBottomEdge = showlines(accumBottom,bottomImage,d);

     parallelcheckVertical = abs(inclinationLeftEdge - inclinationRightEdge);
     parallelcheckHorizontal = abs(inclinationTopEdge - inclinationBottomEdge);
%      leftUpCHeck = slopeLeft * slopeUp;
%      fprintf('product of left edge and top edge is %d',leftUpCHeck);
     perpendicularCheck1 = abs(inclinationLeftEdge - inclinationTopEdge);
     perpendicularCheck2 = abs(inclinationLeftEdge - inclinationBottomEdge);
     perpendicularCheck3 = abs(inclinationRightEdge - inclinationTopEdge);
     perpendicularCheck4 = abs(inclinationRightEdge - inclinationBottomEdge);
     
     if (parallelcheckVertical<10) && (parallelcheckHorizontal < 10)
         if perpendicularCheck1 > 80 && perpendicularCheck2 > 80 && perpendicularCheck3 > 80 && perpendicularCheck4 > 80
            fprintf('Everything seems OK');
         else
             fprintf('Needs to be looked upon for edge detection');
         end
     end
     
     
     %% collect lines and check if they form rectangle shape

end
% 


function accum = accumOfVerticalLines(halfImage,d)
%     [R,C] = size(halfImage);
%     d = ceil(sqrt(R^2 + C^2));
    accum = zeros(2*d+1,180);
    
    [ri, ci] = find(halfImage == 1);
    
    for j = 1:numel(ri)
        for theta = 50:140
            rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
            accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
        end
    end
end

function accum = accumOfHorizontalLines(halfImage,d)
%     [R,C] = size(halfImage);
%     d = ceil(sqrt(R^2 + C^2));
    accum = zeros(2*d+1,180);
    
    [ri, ci] = find(halfImage == 1);
    
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

% function accum = performNonMaxSuppression(accumulatorArray)
% [I,J] = size(accumulatorArray);
% accum = zeros(I,J);
% windowSize = 20;
% for r = 1:I
%     for c = 1:J
%         rowMin = max(1,r-windowSize);
%         rowMax = min(I,r+windowSize);
%         colMin = max(1,c-windowSize);
%         colMax = min(J,c+windowSize);
%         
%         windowImage = accum(rowMin:rowMax,colMin:colMax);
%         maxOfWindow = max(max(windowImage));
%         if accumulatorArray(r,c) == maxOfWindow
%             accum(r,c) = maxOfWindow;
%         end
%     end
% end
% 
% end

function inclination = showlines(accumCopy,image,d)
    [R,C] = size(image);
    [sortedMaxValuesI,sortedMaxValuesJ] = sort(accumCopy,'descend');
    top4 = sortedMaxValues(1:4);
    figure('name','Accumulator Array');
    title('Accumulator Array without non-max suppression');
    imshow(accumCopy(1:10:end,:),[]); colormap jet;
    colorIm = image;
%     for line = 1:4
        lineValue = top4(1);
        [I,J] = find(accumCopy == lineValue);
        k = I(1);
        %get actual rho
        rho = k-d-1;
        theta = J(1)-1;
        %     y = mx+c
        x1 = [];
        y1 = [];
        for x = 1:C
            %         y = round(-x*cotd(theta)) + round(rho*cscd(theta));
            y = (rho - x*sind(theta))/cosd(theta);
            x1 = [x1,x];
            y1 = [y1,y];
        end
        colorIm = insertShape(colorIm,'line',[x1(1),y1(1),x1(end),y1(end)]);
%         inclination = (y1(end)-y1(1))/(x1(end)-x1(1));
        inclination = theta;
        
%     end
    figure('name','Lines without non-max suppression');
    title('Top 4 lines without non-max suppression');
    imshow(colorIm);
end