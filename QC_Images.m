close all;
clear all;

proceed = false;

%% Getting image locations from user

while proceed == false
    folder_dir = input("Enter the folder containing the images for QC: ", 's');
    confirm = input("Confirm correct image path (y/n)? ", 's');
    if strcmpi(confirm, 'y')
        proceed = true;
    end
end

%% QC Setup

% Loading in .CSV files
imageData = readtable([folder_dir, '/Image.csv']);
cellData = readtable([folder_dir, '/Cells.csv']);

% Getting all .jpg files in folder_dir
images = dir([folder_dir, '/*.jpeg']);

%% QC Main

% Manipulating .CSV
for i = 1:numel(images)
    file = images(i).name;
    
    % Display images
    img = imread([folder_dir, '/', file]);
    imS = imresize(img, [800, 800]); 
    imshow(imS);
    waitforbuttonpress; % Wait for user input
    close all;
    
    % Removing rows according to user input
    decision = input('Image Good? (y/n): ', 's');
    if strcmpi(decision, 'n')
        img_name = strrep(strrep(file, [folder_dir, '\'], ''), '_Outline.jpeg', '');
        img_name = strcat(img_name, '.tif');
        imageData(strcmpi(imageData.FileName_Raw_Data, img_name), :) = [];
        cellData(strcmpi(cellData.FileName_Raw_Data, img_name), :) = [];
        disp('Removed!');
    end
end

%% Saving Files

% Saving to same directory as images
writetable(imageData, [folder_dir, '/ImageQC.csv']);
writetable(cellData, [folder_dir, '/CellsQC.csv']);
