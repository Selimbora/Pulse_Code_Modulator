close all

%defining here the message signal we want to convey

freq_m_cos = 125;  %in Hertz
freq_m_sin = 35;  %in Hertz
amp_m_cos = -1;  % Volts
amp_m_sin = 1;  % Volts

%taking the highest frequency component as the bandwidth

BW = max([freq_m_sin,freq_m_cos]);
nyquist_rate = 2 * BW;


sampling_freq = nyquist_rate * 1.5;
sampling_period = 1/sampling_freq;

signal_duration = 2; % in seconds
no_of_samples = signal_duration/sampling_period; %we will only focus on the first 10

time = (0:signal_duration*sampling_freq - 1)./ sampling_freq;


%defining the message signal

sine_signal = amp_m_sin * sin(2*pi*freq_m_sin * time);
cosine_signal = amp_m_cos * cos(2 * pi * freq_m_cos * time);
mesaj = sine_signal + cosine_signal;

%determining the max and min of the message to find quantization levels
pos_peak = abs(amp_m_cos) + abs(amp_m_sin);
neg_peak = -pos_peak;
%defining the PCM specifications needed

L = 64;
n = log2(L);
quantization_limits = linspace(pos_peak, neg_peak, L+1);
quantization_levels = (quantization_limits(1:L) + quantization_limits(2:end)) / 2;
quantized_mesaj = zeros('like', mesaj);

%for loop to modulate 
for i = 1:length(mesaj)
    amplitude_diffs = abs(mesaj(i) - quantization_levels);

    %finding and returning the index that the message value and one of the
    %quantization limits are equal, if exists (i added this part because
    %there was a problem when message signal is equal to one of the
    %quantization limits
    zz= find(mesaj(i)== quantization_limits,1);
   
    %finding the first index that difference of amplitude is higher or equal
   %to the one before itself
    level_decided = find(amplitude_diffs(2:end) >= amplitude_diffs(1:(L - 1)), 1);
     
    if isempty(level_decided)== true
        quantized_mesaj(i) = L - 1;
    elseif  isempty(zz)== false
        quantized_mesaj(i) = zz - 1 ;
    elseif level_decided > 1
        quantized_mesaj(i) = level_decided - 1 ;
    end
end

%printing the output of the pcm
%to label the top level as 64th level, L-quantized_mesaj(1:10) should be
%used, to label the top leves as the 1st level, quantized_mesaj(1:10)
%should be used

output = arrayfun(@(x) dec2bin(x, n), quantized_mesaj(1:10), 'UniformOutput', false);
  fprintf('PCM')
fprintf('\n')
fprintf('%s', output{1})
fprintf('-%s', output{2:end})
 fprintf('\n')

%selimboragencoglu




