Let’s translate your FPGA/Verilator audio world into the **RtAudio world** cleanly, so you know exactly what parameters to use.

You already have the right instincts — you just need to match the *hardware timing* to the *RtAudio API expectations*.

---

# 🎧 **1. What your FPGA + CIC produces**
From our CIC setup:

- **PCM sample rate** ≈ 48 000 Hz  
  (because 2.5 MHz / 52 ≈ 48 076 Hz)
- **Sample format** = 24‑bit signed integer  
- **Channels** = 1 (mono PDM mic)  
- **Buffer size** = whatever you choose in C++ (e.g., 256 frames)

So your RtAudio stream must match:

- sampleRate = **48000**
- channels = **1**
- format = **RTAUDIO_FLOAT32** (after converting 24‑bit PCM to float)
- bufferSize = **256** (or whatever you want)

---

# 🎯 **2. The correct RtAudio openStream call**

Here is the correct equivalent for your FPGA → RtAudio pipeline:

```cpp
int channels = 1;          // PDM mic is mono
int sampleRate = 48000;    // CIC decimator output rate
int bufferSize = 256;      // frames per buffer
int nBuffers = 4;          // internal device buffers
int device = 0;            // default device

RtAudio *audio = nullptr;

try {
    audio = new RtAudio();
}
catch (RtError &error) {
    error.printMessage();
    exit(EXIT_FAILURE);
}

try {
    audio->openStream(
        device,            // output device
        channels,          // number of output channels
        0,                 // input device (none)
        0,                 // input channels (none)
        RTAUDIO_FLOAT32,   // sample format
        sampleRate,        // must match CIC output
        &bufferSize,       // frames per buffer
        nBuffers           // internal buffers
    );
}
catch (RtError &error) {
    error.printMessage();
    exit(EXIT_FAILURE);
}
```

---

# 🧠 **3. Why channels = 1?**
Your FPGA produces **one PCM stream** from the PDM microphone.

If you want stereo later, you must:

- use two PDM mics  
- or duplicate the mono signal into L/R in C++  
- or generate stereo in your synth engine  

But the hardware gives you **mono**, so RtAudio must match.

---

# 🎚️ **4. Why sampleRate = 48000?**
Because:

- CIC decimator outputs one sample every 52 PDM bits  
- PDM clock = 2.5 MHz  
- So PCM rate ≈ 48 076 Hz  

RtAudio expects a standard rate, so you use **48000**.

The tiny mismatch is harmless.

---

# 🎛️ **5. What about bufferSize?**
This is **your choice**.

Common values:

- 128  
- 256  
- 512  

Your FPGA doesn’t care — you just collect samples until you have `bufferSize` frames, then feed them to RtAudio.

---

# 🔄 **6. How to feed FPGA samples into RtAudio**
Inside your RtAudio callback, you do something like:

```cpp
int callback(void *outputBuffer, void * /*inputBuffer*/,
             unsigned int nFrames, double /*streamTime*/,
             RtAudioStreamStatus status, void *userData)
{
    float *out = (float *)outputBuffer;

    for (unsigned int i = 0; i < nFrames; i++) {
        // Wait for FPGA to assert pcm_valid
        while (!fpga->pcm_valid) {
            fpga->eval();   // advance Verilator
        }

        int32_t pcm24 = fpga->pcm_sample;  // 24-bit signed
        out[i] = pcm24 / float(1 << 23);   // convert to float [-1,1]
    }

    return 0;
}
```

This keeps everything synchronized.

---

# 🧩 **7. Summary of what RtAudio should use**

| Parameter | Value | Why |
|----------|--------|------|
| channels | **1** | PDM mic is mono |
| sampleRate | **48000** | CIC decimator output |
| bufferSize | **256** | your choice |
| format | **RTAUDIO_FLOAT32** | easiest for DSP |
| device | **0** | default output |

---

If you want, I can help you write:

- the full Verilator audio loop  
- the RtAudio callback  
- the PCM scaling code  
- a double‑buffered FIFO between FPGA and RtAudio  
- or even a full test harness that plays your FPGA audio live  

Just tell me what direction you want to go.