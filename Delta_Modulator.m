%  DELTA MODULATION

% necessary parameters 

signal_duration = 2; % in seconds

freq_m_cos = 125;  %in Hertz
freq_m_sin = 35;  %in Hertz
amp_m_cos = -1;  % Volts
amp_m_sin = 1;  % Volts

BW = max([freq_m_sin,freq_m_cos]);
nyquist_rate = 2 * BW;


sampling_freq = nyquist_rate * 1.5;


%bandwidth is the same and for this one we choose the sampling frequency as
% 6 times the Nyquist rate

sampling_freq_delta = 6 * nyquist_rate;

%setting delta epsilon to the appropriate value in order to track
%the signal properly.The choice of delta epsilon is crucial in determining the trade-off between the accuracy 
% and the bit rate of the encoded signal. for this section i added "dm"
% part to variables in order to hinder confusion with the PCM

upsilon = 0.35;

time_dm = (0:(signal_duration * sampling_freq_delta - 1)) ./ sampling_freq_delta;

dm_sine_signal = amp_m_sin * sin(2 * pi * freq_m_sin * time_dm);
dm_cosine_signal = amp_m_cos * cos(2 * pi * freq_m_cos * time_dm);
dm_mesaj = dm_cosine_signal + dm_sine_signal;

%prediction of the upcoming value
guess = zeros(length(dm_mesaj),1); % adding ",1" provides so much ease in workload (found out experimentally)
eklenecek = zeros("like",guess);


%loop of the modulation which adds delta epsilon when difference id
%positive and vice versa

for j = 2:length(dm_mesaj)
    % if j == 2 
    %     if dm_mesaj(1) < 0 
    %         eklenecek(j) = - upsilon;
    %     elseif dm_mesaj(1) > 0
    %         eklenecek(j) = upsilon;
    %     end
    % end   
     diffs_dm = dm_mesaj(j)- guess(j-1);
     eklenecek(j) = (2 * double(diffs_dm > 0)-1) * upsilon;
     guess(j) = guess(j-1) + eklenecek(j);
end

%printing the first 20 value

 output = int32(eklenecek(2:21) > 0);
  fprintf('DM')
 fprintf('\n')

 fprintf('%d', output(1))
 fprintf('-%d', output(2:end))
 fprintf('\n')



 %interval which we are plotting is 0-0.1s

 plot_time = 0.1;

% plot of the message signal
subplot(2, 1, 1)
plot(time_dm, dm_mesaj, 'b')

% plot of the guesses 

hold on
stairs(time_dm, guess, 'Color',[0.95 0.2 0.32])
xlabel('time (s)')
ylabel('Amplitude(V)')
title('Message and Predicted Signals With Delta Epsilon = 0.35', 'Color', 'r')
legend('Message signal', 'Predicted signal', 'Location', 'Southwest')
axis([0, plot_time, -2, 2])
grid on