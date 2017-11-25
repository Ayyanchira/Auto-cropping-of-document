function [x0, y0, x1, y1, x2, y2, x3, y3] = auto_crop ( f )

%%%IMPORTANT%%%
% x0,y0 are the x, y coordinates of the top left corner of image
% x1,y1 are the x, y coordinates of the top right corner of image
% x2,y2 are the x, y coordinates of the bottom right corner of image
% x3,y3 are the x, y coordinates of the bottom left corner of image

%getting size of the input image
Ro = size(f,1);
Co = size(f,2);

% always pick middle half
x0 = double(Co*.25);
y0 = double(Ro*.25);

x1 = double(Co*.75);
y1 = double(Ro*.25);

x2 = double(Co*.75);
y2 = double(Ro*.75);

x3 = double(Co*.25);
y3 = double(Ro*.75);


%%Some random numbers come out of here
%x0 = randi([1 Co],1,1);
%y0 = randi([1 Ro],1,1);
%x1 = randi([1 Co],1,1);
%y1 = randi([1 Ro],1,1);
%x2 = randi([1 Co],1,1);
%y2 = randi([1 Ro],1,1);
%x3 = randi([1 Co],1,1);
%y3 = randi([1 Ro],1,1);




