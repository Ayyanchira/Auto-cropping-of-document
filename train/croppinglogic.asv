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
    edgeG = bwareaopen(edgeG,15);
    figure;
     imshow(edgeG);
    %     [R,C] = size(edgeG);
    [R,C] = size(edgeG);
    d = ceil(sqrt(R^2 + C^2)); 

    %% Generating accumulator array
    accum = zeros(2*d+1,180);
    
    [ri, ci] = find(edgeG == 1);
    
    for j = 1:numel(ri)
        for theta = 1:180
            rho = ceil((ri(j) *cosd(theta-1)) + (ci(j)*(sind(theta-1))));
            accum(rho+d+1,theta) = accum(rho+d+1,theta)+1;
        end
    end
    figure('name','Accumulator Array');
    title('Accumulator Array without non-max suppression');
    imshow(accum(1:10:end,:),[]); colormap jet;
%     close all;
    %% Implementing Non-Max Suppression
% figure('name','Edge Image for non-max suppression');
% title('Edge Image for non-max suppression');
% imshow(edgeG);

[I,J] = size(accum);
accumCopy = zeros(I,J);
windowSize = 20;
for r = 1:I
    for c = 1:J
        rowMin = max(1,r-windowSize);
        rowMax = min(I,r+windowSize);
        colMin = max(1,c-windowSize);
        colMax = min(J,c+windowSize);
        
        windowImage = accum(rowMin:rowMax,colMin:colMax);
        maxOfWindow = max(max(windowImage));
        if accum(r,c) == maxOfWindow
            accumCopy(r,c) = maxOfWindow;
        end
    end
end
    %% Edges without non max suppression
    sortedMaxValues = sort(accumCopy(:),'descend');
    top4 = sortedMaxValues(1:4);
    figure('name','Accumulator Array');
    title('Accumulator Array without non-max suppression');
    imshow(accumCopy(1:10:end,:),[]); colormap jet;
    colorIm = f;
    for line = 1:4
        lineValue = top4(line);
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
    end
    figure('name','Lines without non-max suppression');
    title('Top 4 lines without non-max suppression');
    imshow(colorIm);
end