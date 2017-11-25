%%code to try different image filtering for challenge 4

for i = 1:25
    folder_name = 'data/';
    fn = sprintf ( '%sinput_%02d.jpg%', folder_name, i);
    f = imread ( fn );
    
    h = histeq(f);
    g = imadjust(rgb2gray(h));
%     figure;
%     imshow(h);
    edgeG = edge(g);
    BW2 = bwareaopen(edgeG,10);
    figure;
    imshow(BW2);
end