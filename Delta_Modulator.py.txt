import math
import numpy as np
 
 # message signal properties
freq_cos = 125 
freq_sin = 35    
mesaj_freq  =  max(freq_cos, freq_sin)   
nyquist_rate = 2 * mesaj_freq# 2 times signal frequency
multiplier = 6
sampling_frequency = multiplier * nyquist_rate        #  signal is sampled at six times the Nyquist sample rate
interval_of_signal = 2     #in seconds        
time = np.arange(0,interval_of_signal * sampling_frequency) / sampling_frequency   #starting t=0 to t=2s
mesaj_signal = -1 * np.cos(2 * np.pi * freq_cos * time) + 1 * np.sin(2 * np.pi * freq_sin * time)
 
upsilon = 0.35   #upsilon can be choosed experimentally in order to avoid distortion in the modulated signal compared to the signal that is wanted
 
dm_signal = 0 #initial value
cikti = [] #empty array
for i in range(0,20):
     #print(message_signal[i],"sda")
     #print(modulated_signal)
     #print(i)
     #by trying, it is found out that the range should start from 1 because the there is no initial delta
    if mesaj_signal[i] > dm_signal:
        dm_signal+= upsilon
        cikti.extend("1")
    else:
        dm_signal-= upsilon
        cikti.extend("0")
 
print('-'.join(str(j) for j in (cikti))) #printing the first 20 delta values