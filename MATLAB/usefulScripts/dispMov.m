%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                      %%
%% Display all of the node data for a   %%
%% particular movement                  %%
%%                                      %%
%% Author: Hunter Massey                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ output_args ] = dispMov( exp_num, subject_num, movement_num, data_type )

d1 = importdata(sprintf('m00%s_s%s_m%s_n01.txt', num2str(exp_num, '%02d'), num2str(subject_num, '%02d'), num2str( movement_num, '%02d')));
d2 = importdata(sprintf('m00%s_s%s_m%s_n02.txt', num2str(exp_num, '%02d'), num2str(subject_num, '%02d'), num2str(movement_num, '%02d')));
d3 = importdata(sprintf('m00%s_s%s_m%s_n03.txt', num2str(exp_num, '%02d'), num2str(subject_num, '%02d'), num2str(movement_num, '%02d')));
d4 = importdata(sprintf('m00%s_s%s_m%s_n04.txt', num2str(exp_num, '%02d'), num2str(subject_num, '%02d'), num2str(movement_num, '%02d')));
d5 = importdata(sprintf('m00%s_s%s_m%s_n05.txt', num2str(exp_num, '%02d'), num2str(subject_num, '%02d'), num2str(movement_num, '%02d')));
d6 = importdata(sprintf('m00%s_s%s_m%s_n06.txt', num2str(exp_num, '%02d'), num2str(subject_num, '%02d'), num2str(movement_num, '%02d')));

t1 = d1(:,data_type); t2 = d2(:,data_type); t3 = d3(:,data_type); t4 = d4(:,data_type); t5 = d5(:,data_type); t6 = d6(:,data_type);

figure; plot(t1); hold; plot(t2, 'r'); plot(t3, 'k'); plot(t4, 'm'); plot(t5, 'c'); plot(t6, 'g');

end

