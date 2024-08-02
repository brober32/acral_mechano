close all;
clear all;
proceed = false;

%% Getting Day 0 Image Locations From The User

while proceed == false
    folder_dir = input("Enter the folder containing the images for day 0: ", 's');
    confirm = input("Confirm correct image path (y/n)? ", 's');
    
    if strcmpi(confirm, 'y')
        proceed = true;

    elseif strcmp(confirm, 'n')
        proceed = false;
   
    else
        return
    end
end

%Import Files for Compression
cell_metric_0 = readtable([folder_dir, '\CellsQC.csv'], VariableNamingRule="preserve");
fold_metric_0 = rmmissing(readtable([folder_dir, '\ImageQC.csv'], VariableNamingRule="preserve"));

proceed = false;

%% Getting Day 3 Image Locations From The User

while proceed == false
    folder_dir = input("Enter the folder containing the images for day 3: ", 's');
    confirm = input("Confirm correct image path (y/n)? ", 's');
    
    if strcmpi(confirm, 'y')
        proceed = true;

    elseif strcmp(confirm, 'n')
        proceed = false;
   
    else
        quit
    end
end

%Import Files for Compression
cell_metric_3 = readtable([folder_dir, '\CellsQC.csv'], VariableNamingRule="preserve");
fold_metric_3 = rmmissing(readtable([folder_dir, '\ImageQC.csv'], VariableNamingRule="preserve"));

%% Fold Change Metrics
%hank cod 
%create output lists
%output = zeros(12,8); not this
well_types = ["A","B","C","D","E","F",'G',"H"];
shitbroke = 0;

sizeX = 8; 
sizeY = 12;
output = cell(sizeX, sizeY);
for q = 1:sizeX
    for u = 1:sizeY
        c{q,u} = [];
    end
end

for i = 1:height(fold_metric_0)
    name = fold_metric_0{i,5};
    %str = string(name);
    well_label =  extractBetween(name, 5,5); %substr(str,4,1);
    col_label = extractBetween(name, 6,7);% substr(str,5,2);
    %get first pos
    temp = str2double(col_label);
    col = int32(temp); 
    %get second pos
    row = -1;
    for s = 1:length(well_types)
        b = strcmp(well_label,well_types{s});
        if(b == 1)
            row = s;
        end
    end

    if(row == -1)
        %shit broke
        shitbroke = 1;
        fprintf("shit is broke col:%d, row:%d, name : %s <3 \n", col, row, string(name))
    end
    %populate output matrix
    output{row,col} = [output{row,col}, fold_metric_0{i,1}];
end 


%grab avg of every cell 
meansDayOne = zeros(sizeX, sizeY); 
for q = 1:sizeX
    for u = 1:sizeY
        l_temp = output{q,u}; 
        meansDayOne(q,u) = mean(l_temp);
    end
end


%Day 3
%Make empty matrices to put our data into



%GF Note: the below breaks with NaN entries
%Also forgot the G in well types
%hank cod 
%create output lists
%output = zeros(12,8); not this
well_types = ["A","B","C","D","E","F",'G',"H"];
shitbroke = 0;

sizeX = 8; 
sizeY = 12;
output = cell(sizeX, sizeY);
for q = 1:sizeX
    for u = 1:sizeY
        c{q,u} = [];
    end
end

for i = 1:height(fold_metric_3)
    name = fold_metric_3{i,5};
    %str = string(name);
    well_label =  extractBetween(name, 5,5); %substr(str,4,1);
    col_label = extractBetween(name, 6,7);% substr(str,5,2);
    %get first pos
    temp = str2double(col_label);
    col = int32(temp); 
    %get second pos
    row = -1;
    for s = 1:length(well_types)
        b = strcmp(well_label,well_types{s});
        if(b == 1)
            row = s;
        end
    end

    if(row == -1)
        %shit broke
        shitbroke = 1;
        fprintf("shit is broke col:%d, row:%d, name : %s <3 \n", col, row, string(name))
    end
    %populate output matrix
    output{row,col} = [output{row,col}, fold_metric_3{i,1}];
end 


%grab avg of every cell 
meansDay3 = zeros(sizeX, sizeY); 
for q = 1:sizeX
    for u = 1:sizeY
        l_temp = output{q,u}; 
        meansDay3(q,u) = mean(l_temp);
    end
end
%end hank cod 

%Output AVG Reps
writematrix(meansDayOne,'Day0_AVG.xlsx');
writematrix(meansDay3,'Day3_AVG.xlsx');

%Take the fold change
fold_change_reps = rdivide(meansDay3, meansDayOne);

%Output Fold Change
writematrix(fold_change_reps, 'Fold_Change.xlsx')

%% Morphology Metrics
%Make empty matrices to put morphology data into
X01 = [];
X02 = [];
X03 = [];
X04 = [];
X05 = [];
X06 = [];
X07 = [];
X08 = [];
X09 = []; 
X10 = [];
X11 = [];
X12 = [];

for i = 1:height(cell_metric_3)
    name = cell_metric_3{i,3};
    
    %Gather all the 0.1kPa values
    if contains(name, '01_') == 1
        X01 = [X01;cell_metric_3(i,:)];
    end

    %Gather all the 0.2kPa values
    if contains(name, '02_') == 1
        X02 = [X02;cell_metric_3(i,:)];
    end

      %Gather all the 0.5kPa values
    if contains(name, '03_') == 1
        X03 = [X03;cell_metric_3(i,:)];
    end

    %Gather all the 1kPa values
    if contains(name, '04_') == 1
        X04 = [X04;cell_metric_3(i,:)];
    end
    %Gather all the 2kPa values
    if contains(name, '05_') == 1
        X05 = [X05;cell_metric_3(i,:)];
    end

    %Gather all the 4kPa values
    if contains(name, '06_') == 1
        X06 = [X06;cell_metric_3(i,:)];
    end

      %Gather all the 8kPa values
    if contains(name, '07_') == 1
        X07 = [X07;cell_metric_3(i,:)];
    end

    %Gather all the 12kPa values
    if contains(name, '08_') == 1
        X08 = [X08;cell_metric_3(i,:)];
    end
    %Gather all the 25kPa values
    if contains(name, '09_') == 1
        X09 = [X09;cell_metric_3(i,:)];
    end

    %Gather all the 50kPa values
    if contains(name, '10_') == 1
        X10 = [X10;cell_metric_3(i,:)];
    end

      %Gather all the 100kPa values
    if contains(name, '11_') == 1
        X11 = [X11;cell_metric_3(i,:)];
    end

    %Gather all the plastic values
    if contains(name, '12_') == 1
        X12 = [X12;cell_metric_3(i,:)];
    end
end

%Pull out our specific morphology metrics
%Pull out area shape stats
area_Vals = [];
X_01A = table2array(X01(:,5));
X_02A = table2array(X02(:,5));
X_03A = table2array(X03(:,5));
X_04A = table2array(X04(:,5));
X_05A = table2array(X05(:,5));
X_06A = table2array(X06(:,5));
X_07A = table2array(X07(:,5));
X_08A = table2array(X08(:,5));
X_09A = table2array(X09(:,5));
X_10A = table2array(X10(:,5));
X_11A = table2array(X11(:,5));
X_12A = table2array(X12(:,5));

%Area Vals
area_avg_01 = mean(X_01A);
area_std_err_01 = std(X_01A)/sqrt(height(X_01A));
area_Vals = [area_avg_01,area_std_err_01];

area_avg_02 = mean(X_02A);
area_std_err_02 = std(X_02A)/sqrt(height(X_02A));
area_Vals(2,:) = [area_avg_02,area_std_err_02];

area_avg_03 = mean(X_03A);
area_std_err_03 = std(X_03A)/sqrt(height(X_03A));
area_Vals(3,:) = [area_avg_03,area_std_err_03];

area_avg_04 = mean(X_04A);
area_std_err_04 = std(X_04A)/sqrt(height(X_04A));
area_Vals(4,:) = [area_avg_04,area_std_err_04];

area_avg_05 = mean(X_05A);
area_std_err_05 = std(X_05A)/sqrt(height(X_05A));
area_Vals(5,:) = [area_avg_05,area_std_err_05];

area_avg_06 = mean(X_06A);
area_std_err_06 = std(X_06A)/sqrt(height(X_06A));
area_Vals(6,:) = [area_avg_06,area_std_err_06];

area_avg_07 = mean(X_07A);
area_std_err_07 = std(X_07A)/sqrt(height(X_07A));
area_Vals(7,:) = [area_avg_07,area_std_err_07];

area_avg_08 = mean(X_08A);
area_std_err_08 = std(X_08A)/sqrt(height(X_08A));
area_Vals(8,:) = [area_avg_08,area_std_err_08];

area_avg_09 = mean(X_09A);
area_std_err_09 = std(X_09A)/sqrt(height(X_09A));
area_Vals(9,:) = [area_avg_09,area_std_err_09];

area_avg_10 = mean(X_10A);
area_std_err_10 = std(X_10A)/sqrt(height(X_10A));
area_Vals(10,:) = [area_avg_10,area_std_err_10];

area_avg_11 = mean(X_11A);
area_std_err_11 = std(X_11A)/sqrt(height(X_11A));
area_Vals(11,:) = [area_avg_11,area_std_err_11];

area_avg_12 = mean(X_12A);
area_std_err_12 = std(X_12A)/sqrt(height(X_12A));
area_Vals(12,:) = [area_avg_12,area_std_err_12];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pull out equivalent diameter shape stats
dia_Vals = [];
X_01D = table2array(X01(:,16));
X_02D = table2array(X02(:,16));
X_03D = table2array(X03(:,16));
X_04D = table2array(X04(:,16));
X_05D = table2array(X05(:,16));
X_06D = table2array(X06(:,16));
X_07D = table2array(X07(:,16));
X_08D = table2array(X08(:,16));
X_09D = table2array(X09(:,16));
X_10D = table2array(X10(:,16));
X_11D = table2array(X11(:,16));
X_12D = table2array(X12(:,16));

%Equivalent Diameter Values
area_avg_01 = mean(X_01D);
area_std_err_01 = std(X_01D)/sqrt(height(X_01D));
dia_Vals = [area_avg_01,area_std_err_01];

area_avg_02 = mean(X_02D);
area_std_err_02 = std(X_02D)/sqrt(height(X_02D));
dia_Vals(2,:) = [area_avg_02,area_std_err_02];

area_avg_03 = mean(X_03D);
area_std_err_03 = std(X_03D)/sqrt(height(X_03D));
dia_Vals(3,:) = [area_avg_03,area_std_err_03];

area_avg_04 = mean(X_04D);
area_std_err_04 = std(X_04D)/sqrt(height(X_04D));
dia_Vals(4,:) = [area_avg_04,area_std_err_04];

area_avg_05 = mean(X_05D);
area_std_err_05 = std(X_05D)/sqrt(height(X_05D));
dia_Vals(5,:) = [area_avg_05,area_std_err_05];

area_avg_06 = mean(X_06D);
area_std_err_06 = std(X_06D)/sqrt(height(X_06D));
dia_Vals(6,:) = [area_avg_06,area_std_err_06];

area_avg_07 = mean(X_07D);
area_std_err_07 = std(X_07D)/sqrt(height(X_07D));
dia_Vals(7,:) = [area_avg_07,area_std_err_07];

area_avg_08 = mean(X_08D);
area_std_err_08 = std(X_08D)/sqrt(height(X_08D));
dia_Vals(8,:) = [area_avg_08,area_std_err_08];

area_avg_09 = mean(X_09D);
area_std_err_09 = std(X_09D)/sqrt(height(X_09D));
dia_Vals(9,:) = [area_avg_09,area_std_err_09];

area_avg_10 = mean(X_10D);
area_std_err_10 = std(X_10D)/sqrt(height(X_10D));
dia_Vals(10,:) = [area_avg_10,area_std_err_10];

area_avg_11 = mean(X_11D);
area_std_err_11 = std(X_11D)/sqrt(height(X_11D));
dia_Vals(11,:) = [area_avg_11,area_std_err_11];

area_avg_12 = mean(X_12D);
area_std_err_12 = std(X_12D)/sqrt(height(X_12D));
dia_Vals(12,:) = [area_avg_12,area_std_err_12];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pull out form factor shape stats
form_Vals = [];
X_01F = table2array(X01(:,19));
X_02F = table2array(X02(:,19));
X_03F = table2array(X03(:,19));
X_04F = table2array(X04(:,19));
X_05F = table2array(X05(:,19));
X_06F = table2array(X06(:,19));
X_07F = table2array(X07(:,19));
X_08F = table2array(X08(:,19));
X_09F = table2array(X09(:,19));
X_10F = table2array(X10(:,19));
X_11F = table2array(X11(:,19));
X_12F = table2array(X12(:,19));

%Form Factor Values
area_avg_01 = mean(X_01F);
area_std_err_01 = std(X_01F)/sqrt(height(X_01F));
form_Vals = [area_avg_01,area_std_err_01];

area_avg_02 = mean(X_02F);
area_std_err_02 = std(X_02F)/sqrt(height(X_02F));
form_Vals(2,:) = [area_avg_02,area_std_err_02];

area_avg_03 = mean(X_03F);
area_std_err_03 = std(X_03F)/sqrt(height(X_03F));
form_Vals(3,:) = [area_avg_03,area_std_err_03];

area_avg_04 = mean(X_04F);
area_std_err_04 = std(X_04F)/sqrt(height(X_04F));
form_Vals(4,:) = [area_avg_04,area_std_err_04];

area_avg_05 = mean(X_05F);
area_std_err_05 = std(X_05F)/sqrt(height(X_05F));
form_Vals(5,:) = [area_avg_05,area_std_err_05];

area_avg_06 = mean(X_06F);
area_std_err_06 = std(X_06F)/sqrt(height(X_06F));
form_Vals(6,:) = [area_avg_06,area_std_err_06];

area_avg_07 = mean(X_07F);
area_std_err_07 = std(X_07F)/sqrt(height(X_07F));
form_Vals(7,:) = [area_avg_07,area_std_err_07];

area_avg_08 = mean(X_08F);
area_std_err_08 = std(X_08F)/sqrt(height(X_08F));
form_Vals(8,:) = [area_avg_08,area_std_err_08];

area_avg_09 = mean(X_09F);
area_std_err_09 = std(X_09F)/sqrt(height(X_09F));
form_Vals(9,:) = [area_avg_09,area_std_err_09];

area_avg_10 = mean(X_10F);
area_std_err_10 = std(X_10F)/sqrt(height(X_10F));
form_Vals(10,:) = [area_avg_10,area_std_err_10];

area_avg_11 = mean(X_11F);
area_std_err_11 = std(X_11F)/sqrt(height(X_11F));
form_Vals(11,:) = [area_avg_11,area_std_err_11];

area_avg_12 = mean(X_12F);
area_std_err_12 = std(X_12F)/sqrt(height(X_12F));
form_Vals(12,:) = [area_avg_12,area_std_err_12];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pull out form major axis stats
major_Vals = [];
X_01M = table2array(X01(:,20));
X_02M = table2array(X02(:,20));
X_03M = table2array(X03(:,20));
X_04M = table2array(X04(:,20));
X_05M = table2array(X05(:,20));
X_06M = table2array(X06(:,20));
X_07M = table2array(X07(:,20));
X_08M = table2array(X08(:,20));
X_09M = table2array(X09(:,20));
X_10M = table2array(X10(:,20));
X_11M = table2array(X11(:,20));
X_12M = table2array(X12(:,20));

%Major Axis Values
area_avg_01 = mean(X_01M);
area_std_err_01 = std(X_01M)/sqrt(height(X_01M));
major_Vals = [area_avg_01,area_std_err_01];

area_avg_02 = mean(X_02M);
area_std_err_02 = std(X_02M)/sqrt(height(X_02M));
major_Vals(2,:) = [area_avg_02,area_std_err_02];

area_avg_03 = mean(X_03M);
area_std_err_03 = std(X_03M)/sqrt(height(X_03M));
major_Vals(3,:) = [area_avg_03,area_std_err_03];

area_avg_04 = mean(X_04M);
area_std_err_04 = std(X_04M)/sqrt(height(X_04M));
major_Vals(4,:) = [area_avg_04,area_std_err_04];

area_avg_05 = mean(X_05M);
area_std_err_05 = std(X_05M)/sqrt(height(X_05M));
major_Vals(5,:) = [area_avg_05,area_std_err_05];

area_avg_06 = mean(X_06M);
area_std_err_06 = std(X_06M)/sqrt(height(X_06M));
major_Vals(6,:) = [area_avg_06,area_std_err_06];

area_avg_07 = mean(X_07M);
area_std_err_07 = std(X_07M)/sqrt(height(X_07M));
major_Vals(7,:) = [area_avg_07,area_std_err_07];

area_avg_08 = mean(X_08M);
area_std_err_08 = std(X_08M)/sqrt(height(X_08M));
major_Vals(8,:) = [area_avg_08,area_std_err_08];

area_avg_09 = mean(X_09M);
area_std_err_09 = std(X_09M)/sqrt(height(X_09M));
major_Vals(9,:) = [area_avg_09,area_std_err_09];

area_avg_10 = mean(X_10M);
area_std_err_10 = std(X_10M)/sqrt(height(X_10M));
major_Vals(10,:) = [area_avg_10,area_std_err_10];

area_avg_11 = mean(X_11M);
area_std_err_11 = std(X_11M)/sqrt(height(X_11M));
major_Vals(11,:) = [area_avg_11,area_std_err_11];

area_avg_12 = mean(X_12M);
area_std_err_12 = std(X_12M)/sqrt(height(X_12M));
major_Vals(12,:) = [area_avg_12,area_std_err_12];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pull out form minor axis stats
minor_Vals = [];
X_01m = table2array(X01(:,26));
X_02m = table2array(X02(:,26));
X_03m = table2array(X03(:,26));
X_04m = table2array(X04(:,26));
X_05m = table2array(X05(:,26));
X_06m = table2array(X06(:,26));
X_07m = table2array(X07(:,26));
X_08m = table2array(X08(:,26));
X_09m = table2array(X09(:,26));
X_10m = table2array(X10(:,26));
X_11m = table2array(X11(:,26));
X_12m = table2array(X12(:,26));

%Minor Axis Values
area_avg_01 = mean(X_01m);
area_std_err_01 = std(X_01m)/sqrt(height(X_01m));
minor_Vals = [area_avg_01,area_std_err_01];

area_avg_02 = mean(X_02m);
area_std_err_02 = std(X_02m)/sqrt(height(X_02m));
minor_Vals(2,:) = [area_avg_02,area_std_err_02];

area_avg_03 = mean(X_03m);
area_std_err_03 = std(X_03m)/sqrt(height(X_03m));
minor_Vals(3,:) = [area_avg_03,area_std_err_03];

area_avg_04 = mean(X_04m);
area_std_err_04 = std(X_04m)/sqrt(height(X_04m));
minor_Vals(4,:) = [area_avg_04,area_std_err_04];

area_avg_05 = mean(X_05m);
area_std_err_05 = std(X_05m)/sqrt(height(X_05m));
minor_Vals(5,:) = [area_avg_05,area_std_err_05];

area_avg_06 = mean(X_06m);
area_std_err_06 = std(X_06m)/sqrt(height(X_06m));
minor_Vals(6,:) = [area_avg_06,area_std_err_06];

area_avg_07 = mean(X_07m);
area_std_err_07 = std(X_07m)/sqrt(height(X_07m));
minor_Vals(7,:) = [area_avg_07,area_std_err_07];

area_avg_08 = mean(X_08m);
area_std_err_08 = std(X_08m)/sqrt(height(X_08m));
minor_Vals(8,:) = [area_avg_08,area_std_err_08];

area_avg_09 = mean(X_09m);
area_std_err_09 = std(X_09m)/sqrt(height(X_09m));
minor_Vals(9,:) = [area_avg_09,area_std_err_09];

area_avg_10 = mean(X_10m);
area_std_err_10 = std(X_10m)/sqrt(height(X_10m));
minor_Vals(10,:) = [area_avg_10,area_std_err_10];

area_avg_11 = mean(X_11m);
area_std_err_11 = std(X_11m)/sqrt(height(X_11m));
minor_Vals(11,:) = [area_avg_11,area_std_err_11];

area_avg_12 = mean(X_12m);
area_std_err_12 = std(X_12m)/sqrt(height(X_12m));
minor_Vals(12,:) = [area_avg_12,area_std_err_12];

%Export all of the morphology data for each stiffness into individual .xlsx
writetable(X01,'0.1kPa.xlsx');
writetable(X02,'0.2kPa.xlsx');
writetable(X03,'0.5kPa.xlsx');
writetable(X04,'1kPa.xlsx');
writetable(X05,'2kPa.xlsx');
writetable(X06,'4kPa.xlsx');
writetable(X07,'8kPa.xlsx');
writetable(X08,'12kPa.xlsx');
writetable(X09,'25kPa.xlsx');
writetable(X10,'50kPa.xlsx');
writetable(X11,'100kPa.xlsx');
writetable(X12,'Glass.xlsx');

%Export the averages and STE of each metric as .xlsx
writematrix(area_Vals,'Cell Area.xlsx');
writematrix(dia_Vals,'Equivalent Diameter.xlsx');
writematrix(form_Vals,'Form Factor.xlsx');
writematrix(major_Vals,'Major Axis.xlsx');
writematrix(minor_Vals,'Minor Axis.xlsx');

%% Plotting
%Cell Area (# of pixels)
figure;
area_avg = area_Vals(:,1);
stiffnesses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
stiffnesses = stiffnesses';
bar(stiffnesses, area_avg)
xlim([0 13])
xticklabels({'0.1', '0.2', '0.5', '1', '2', '4', '8', '12', '25', '50', '100', '1000000'})
hold on;
errorbar(stiffnesses,area_avg,area_Vals(:,2), 'LineStyle','none');
title('Cell Area as a Function of Substrate Stiffness');
xlabel('Stiffness (kPa)');
ylabel('Cell Area (Pixel #)');
exportgraphics(gcf,'Area_Bar.png','Resolution',300)
hold off; 

%Equivalent Diameter (in pixels)
figure;
equiv_avg = dia_Vals(:,1);
stiffnesses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
stiffnesses = stiffnesses';
bar(stiffnesses, equiv_avg);
xlim([0 13]);
xticklabels({'0.1', '0.2', '0.5', '1', '2', '4', '8', '12', '25', '50', '100', '1000000'})
hold on;
errorbar(stiffnesses,equiv_avg,dia_Vals(:,2), 'LineStyle','none');
title('Equivalent Diameter as a Function of Substrate Stiffness');
xlabel('Stiffness (kPa)');
ylabel('Equivalent Diameter (Pixel #)');
exportgraphics(gcf,'Equiv_Bar.png','Resolution',300)
hold off;

%Form Factor
figure;
form_avg =form_Vals(:,1);
stiffnesses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
stiffnesses = stiffnesses';
bar(stiffnesses, form_avg);
xlim([0 13]);
xticklabels({'0.1', '0.2', '0.5', '1', '2', '4', '8', '12', '25', '50', '100', '1000000'})
hold on;
errorbar(stiffnesses,form_avg,form_Vals(:,2), 'LineStyle','none');
title('Form Factor as a Function of Substrate Stiffness');
xlabel('Stiffness (kPa)');
ylabel('Circularity');
exportgraphics(gcf,'Form_Bar.png','Resolution',300)
hold off;

%Major Axis (in pixels)
figure;
major_avg =major_Vals(:,1);
stiffnesses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
stiffnesses = stiffnesses';
bar(stiffnesses, major_avg);
xlim([0 13]);
xticklabels({'0.1', '0.2', '0.5', '1', '2', '4', '8', '12', '25', '50', '100', '1000000'})
hold on;
errorbar(stiffnesses,major_avg,major_Vals(:,2), 'LineStyle','none');
title('Major Axis as a Function of Substrate Stiffness');
xlabel('Stiffness (kPa)');
ylabel('Major Axis Length (Pixel #)');
exportgraphics(gcf,'Major_Bar.png','Resolution',300)
hold off;

%Minor Axis (in pixes)
figure;
minor_avg =minor_Vals(:,1);
stiffnesses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12];
stiffnesses = stiffnesses';
bar(stiffnesses, minor_avg);
xlim([0 13]);
xticklabels({'0.1', '0.2', '0.5', '1', '2', '4', '8', '12', '25', '50', '100', '1000000'})
hold on;
errorbar(stiffnesses,minor_avg,minor_Vals(:,2), 'LineStyle','none');
title('Minor Axis as a Function of Substrate Stiffness');
xlabel('Stiffness (kPa)');
ylabel('Minor Axis Length (Pixel #)');
exportgraphics(gcf,'Minor_Bar.png','Resolution',300)
hold off;

close all;
clear all;
