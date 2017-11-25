for i = 1:25
    
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
%     imshow(edgeG);
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
    close all;
    %% Edges without non max suppression
    sortedMaxValues = sort(accum(:),'descend');
    top4 = sortedMaxValues(1:4);
    figure('name','Accumulator Array');
    title('Accumulator Array without non-max suppression');
    imshow(accum(1:10:end,:),[]); colormap jet;
    colorIm = f;
    for line = 1:4
        lineValue = top4(line);
        [I,J] = find(accum == lineValue);
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