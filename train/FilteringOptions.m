%%code to try different image filtering for challenge 4

for i = 1:25
    folder_name = 'data/';
    fn = sprintf ( '%sinput_%02d.jpg%', folder_name, i);
    f = imread ( fn );
    g = imadjust(rgb2gray(f));
    
    edgeG = edge(g);
    BW2 = bwareaopen(edgeG,20);
    figure;
    imshow(BW2);
end