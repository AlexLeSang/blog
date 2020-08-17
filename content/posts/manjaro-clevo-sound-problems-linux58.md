---
title: "Manjaro 20.1 Clevo Sound Problems Linux 5.8.0-2-MANJARO"
date: 2020-08-17T08:45:43+02:00
draft: true
toc: true
images: 
tags: ["clevo", "manjaro", "linux", "sound"]
---

## Symptoms

No sound in Manjaro. Sounds works fine in Windows 10. The symptoms appeared after update from Linux `5.7` to `5.8.0-2`.

## Configuration

### Laptop

Clevo with `P95_96_97Ex,Rx`. Dual-boot Manjaro 20.1 with Windows 10.

#### `uname -v -r -o`

```
5.8.0-2-MANJARO #1 SMP PREEMPT Sat Aug 8 17:55:27 UTC 2020 GNU/Linux
```

#### `lsb_release -a`
```
LSB Version:	n/a
Distributor ID:	ManjaroLinux
Description:	Manjaro Linux
Release:	20.1
Codename:	Mikah
```

### `lspci -kk`

```
00:1f.3 Audio device: Intel Corporation Cannon Lake PCH cAVS (rev 10)
	Subsystem: CLEVO/KAPOK Computer Device 97e1
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel, snd_soc_skl, snd_sof_pci
```

### `lsmod | grep snd_hda`

```
snd_hda_codec_realtek   135168  1
snd_hda_codec_generic    98304  1 snd_hda_codec_realtek
ledtrig_audio          16384  3 snd_hda_codec_generic,snd_hda_codec_realtek,snd_sof
snd_hda_ext_core       36864  4 snd_sof_intel_hda_common,snd_soc_hdac_hda,snd_soc_skl,snd_sof_intel_hda
snd_hda_intel          57344  6
snd_intel_dspcfg       24576  4 snd_hda_intel,snd_sof_pci,snd_sof_intel_hda_common,snd_soc_skl
snd_hda_codec         167936  4 snd_hda_codec_generic,snd_hda_intel,snd_hda_codec_realtek,snd_soc_hdac_hda
snd_hda_core          106496  9 snd_hda_codec_generic,snd_hda_intel,snd_hda_ext_core,snd_hda_codec,snd_hda_codec_realtek,snd_sof_intel_hda_common,snd_soc_hdac_hda,snd_soc_skl,snd_sof_intel_hda
snd_hwdep              16384  1 snd_hda_codec
snd_pcm               147456  10 snd_hda_intel,snd_hda_codec,snd_sof,snd_sof_intel_hda_common,snd_compress,snd_soc_core,snd_soc_skl,snd_hda_core,snd_pcm_dmaengine
snd                   114688  24 snd_hda_codec_generic,snd_seq,snd_seq_device,snd_hwdep,snd_hda_intel,snd_hda_codec,snd_hda_codec_realtek,snd_timer,snd_compress,snd_soc_core,snd_pcm
```

## Solution

Put the following configuration in `/etc/modprobe.d/alsa-base.conf`.
```
options snd-hda-intel model=auto probe_mask=1
```

Select `Analog Stereo Duplex` device.

![Sound Device](/posts/images/sound_device.png) 
