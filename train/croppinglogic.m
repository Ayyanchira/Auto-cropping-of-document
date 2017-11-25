for i = 1:25
    
    folder_name = 'data/';
    fn = sprintf ( '%sinput_%02d.jpg%', folder_name, i);
    f = imread ( fn );
    
    gr = rgb2gray(f);
    edgeG = edge(gr);
    figure('name','Edge Image');
    imshow(edgeG);
    
    %     [R,C] = size(edgeG);
    [R,C] = size(edgeG);
d = ceil(sqrt(R^2 + C^2)); 
    %     im1 = edgeG(1:floor(R/2),1:C);
    %     im2 = edgeG(1:R,1:floor(C/2));
    %     im3 = edgeG(floor(R/2):R,1:C);
    %     im4 = edgeG(1:R,floor(C/2):C);
    %
    %     subplot(2,2,1);
    %     imshow(im1);
    %     subplot(2,2,2);
    %     imshow(im2);
    %     subplot(2,2,3);
    %     imshow(im3);
    %     subplot(2,2,4);
    %     imshow(im4);
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
    %     level = graythresh(f);
    %     rgb1 = f(:,:,1);
    % %     figure;
    % %     imshow(rgb1);
    %     rgb2 = f(:,:,2);
    % %     figure;
    % %     imshow(rgb2);
    %     rgb3 = f(:,:,3);
    % %     figure;
    % %     imshow(rgb3);
    %
    %     g1 = imbinarize(rgb1,level);
    % %     figure;
    % %     imshow(g1);
    %     g2 = imbinarize(rgb2,level);
    % %     figure;
    % %     imshow(g2);
    %     g3 = imbinarize(rgb3,level);
    % %     figure;
    % %     imshow(g3);
    %
    %     sumI = g1&g2&g3;
    % %     figure;
    % %     imshow(sumI);
    close all;
    
end