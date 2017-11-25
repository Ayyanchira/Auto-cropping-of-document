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
    
end