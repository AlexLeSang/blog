---
title: "Manjaro; Clevo Laptop; No Sound"
date: 2020-04-27T12:23:40+02:00
draft: true
toc: true
images:
tags: ["clevo", "manjaro", "linux", "sound"]
---

## Symptoms

No sound in Linux. Reporting of `pavucontrol` shows that sound is being emitted to the device but nothing happens.

### Messages in `dmesg`

```
[   37.482138] snd_hda_codec_realtek hdaudioC0D0: Unable to sync register 0x1f0e00. -5
[   37.482235] snd_hda_codec_realtek hdaudioC0D0: Unable to sync register 0x1f0e00. -5
```

## Configuration

### Laptop

Clevo with `P95_96_97Ex,Rx`. Dual-boot Manjaro 20 with Windows 10.

#### `uname -v -r -o`

```
5.7.0-1-MANJARO #1 SMP PREEMPT Tue Apr 21 20:48:43 UTC 2020 GNU/Linux
```

`5.7.0-1-MANJARO`

#### `lsb_release`
```
LSB Version:	n/a
Distributor ID:	ManjaroLinux
Description:	Manjaro Linux
Release:	20.0
Codename:	Lysia
```

### `lspci -kk`

```
00:1f.3 Audio device: Intel Corporation Cannon Lake PCH cAVS (rev 10)
	Subsystem: CLEVO/KAPOK Computer Cannon Lake PCH cAVS
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel, snd_soc_skl, snd_sof_pci
```

#### `inxi -Fxxxza --no-host`

```
Audio:     Device-1: Intel Cannon Lake PCH cAVS vendor: CLEVO/KAPOK driver: snd_hda_intel v: kernel bus ID: 00:1f.3
           chip ID: 8086:a348
           Sound Server: ALSA v: k5.7.0-1-MANJARO
```
#### `aply -l`

```
**** List of PLAYBACK Hardware Devices ****
card 0: PCH [HDA Intel PCH], device 0: ALC1220 Analog [ALC1220 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 1: ALC1220 Digital [ALC1220 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

### `lsmod | grep snd_hda`

```
snd_hda_codec_realtek   126976  1
snd_hda_codec_generic    94208  1 snd_hda_codec_realtek
ledtrig_audio          16384  3 snd_hda_codec_generic,snd_hda_codec_realtek,snd_sof
snd_hda_ext_core       36864  4 snd_sof_intel_hda_common,snd_soc_hdac_hda,snd_soc_skl,snd_sof_intel_hda
snd_hda_intel          57344  3
snd_intel_dspcfg       28672  4 snd_hda_intel,snd_sof_pci,snd_sof_intel_hda_common,snd_soc_skl
snd_hda_codec         163840  4 snd_hda_codec_generic,snd_hda_intel,snd_hda_codec_realtek,snd_soc_hdac_hda
snd_hda_core          106496  9 snd_hda_codec_generic,snd_hda_intel,snd_hda_ext_core,snd_hda_codec,snd_hda_codec_realtek,snd_sof_intel_hda_common,snd_soc_hdac_hda,snd_soc_skl,snd_sof_intel_hda
snd_hwdep              16384  1 snd_hda_codec
snd_pcm               143360  9 snd_hda_intel,snd_hda_codec,snd_sof,snd_sof_intel_hda_common,snd_compress,snd_soc_core,snd_soc_skl,snd_hda_core,snd_pcm_dmaengine
snd                   114688  19 snd_hda_codec_generic,snd_seq,snd_seq_device,snd_hwdep,snd_hda_intel,snd_hda_codec,snd_hda_codec_realtek,snd_timer,snd_compress,snd_soc_core,snd_pcm
```


#### `snd_hda_codec_realtek`

```
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC1220: line_outs=1 (0x1b/0x0/0x0/0x0/0x0) type:speaker
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x14/0x0/0x0/0x0/0x0)
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x1e/0x0
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0:    inputs:
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0:      Mic=0x18
Apr 27 12:01:16 oleksandr-manjaro kernel: snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
Apr 27 12:01:16 oleksandr-manjaro kernel: input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input31
Apr 27 12:01:16 oleksandr-manjaro kernel: input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input32
Apr 27 12:01:16 oleksandr-manjaro kernel: input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input33
```

### Solution

Put the following configuration in `/etc/modprobe.d/alsa-base.conf`.
```
options snd-hda-intel model=clevo-p950 probe_mask=1
```

## Resources

- [HdaIntelSoundHowto](https://help.ubuntu.com/community/HdaIntelSoundHowto)
- [[SOLVED] Audio stopped working in linux 4.7](https://bbs.archlinux.org/viewtopic.php?id=216104)
