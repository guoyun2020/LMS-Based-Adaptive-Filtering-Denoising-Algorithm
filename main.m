% 基于LMS的蓝牙耳机自适应降噪算法
% Author:GY Date:2021.6.4

[music,Fs] = audioread('D:\360MoveData\Users\Hoshino Naoki\Desktop\降噪耳机仿真\music.mp3');
[noise,fs] = audioread('D:\360MoveData\Users\Hoshino Naoki\Desktop\降噪耳机仿真\noise.m4a');
Z=zeros(1,length(noise)-length(music));

music=reshape(music,[1,length(music)]);
noise=reshape(noise(:,1)*10,[1,length(noise)]);
music=[music,Z];

figure;
subplot(1,2,1);
plot(noise,'r');
axis([0 500000 -0.1 0.1]);
xlabel( '单位' );ylabel( '幅度' );
title('噪声信号时域波形');
subplot(1,2,2);
plot(music);
xlabel( '单位' );ylabel( '幅度' );
title('原始信号时域波形');
figure;
music_noise=music+noise;
plot(music_noise,'r');
hold on;
plot(music,'Color', [0  114  189]/255);
xlabel( '单位' );ylabel( '幅度' );
title('带噪信号时域波形');

audiowrite('D:\360MoveData\Users\Hoshino Naoki\Desktop\降噪耳机仿真\music_noise.wav',music+noise,48000);

% %% --- LMS Algorithm ---
mu = 0.05;            %LMS步长0.05
M = 3;                  %抽头数M=2
LMS=dsp.LMSFilter('Length',M,'StepSize',mu);
% d 参考理想信号
% u 输入带噪信号
% y 预测信号
% e 预测误差
music=reshape(music,[length(music),1]);
music_noise=reshape(music_noise,[length(music_noise),1]);
[y,e,w] = LMS(music,music_noise);
audiowrite('D:\360MoveData\Users\Hoshino Naoki\Desktop\降噪耳机仿真\music_predict.wav',y,48000);
[Y,Fs]=audioread('D:\360MoveData\Users\Hoshino Naoki\Desktop\降噪耳机仿真\music_predict.wav');
sound(Y,Fs);
% 归一化的均方差
std_lms=std(e,1);
% 预测结果y与理想参考信号d的自相关
[corr_lms]=xcorr(music,y);
disp("LMS抽头权值为：");
disp(w);
figure; hold on;
subplot(3,1,1);
plot(y); 
legend('预测值');      %添加图例
subplot(3,1,2);
plot(music,'r'); 
legend('参考值');      %添加图例
subplot(3,1,3);
plot(e,'m');
axis([0 500000 -1 1]);
legend('预测误差');      %添加图例