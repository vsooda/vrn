clear all, close all, clc

% Define some parameters.
input_folder = 'examples/';
output_folder = 'output/';
model_file = 'vrn-unguided.t7';
gpunum = 0;
texture = 0; % rudimentary texture mapping

% Make sure the output directory exists.
if ~exist(output_folder, 'dir')
    mkdir(output_folder)
end
if ~exist([input_folder '/scaled'], 'dir')
    mkdir([input_folder '/scaled'])
end



% Normalise the images so that they are optimal size.
pts = dir([input_folder '*.txt']);
for p=1:numel(pts)
    P = load([input_folder pts(p).name]);
    if exist([input_folder pts(p).name(1:end-4) '.jpg'], 'file')
        imName = [input_folder pts(p).name(1:end-4) '.jpg'];
    else
        imName = [input_folder pts(p).name(1:end-4) '.png'];
    end
    imNameD = [input_folder '/scaled/' pts(p).name(1:end-4) '.jpg'];
    I = imread(imName);
    scale = 90/sqrt(prod(max(P)-min(P)));
    cen = size(I)/2;
    dxy = [cen(2) cen(1)]-mean(P);
    I = imtranslate(I, dxy);
    I = imresize(I, scale);
    I = padarray(I, [32 32 0]);
    cen = floor(size(I)/2);
    I = I(cen(1)-95:cen(1)+96,cen(2)-95:cen(2)+96,:);
    imwrite(I, imNameD);
end

% Visualise the output from VRN.
vols = dir([output_folder '/*.raw']);

for f=1:numel(vols)
    fname = vols(f).name(1:end-4);

    rendervol([input_folder '/scaled/' fname '.jpg'], ...
              [output_folder fname '.raw'], texture);
    rotate3d % allow dragging in 3D.

    fprintf('Rendered %s.\n', fname);
end

fprintf('All images rendered.\n');
