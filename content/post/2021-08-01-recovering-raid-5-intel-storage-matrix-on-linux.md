---
title: "Recovering a RAID-5 Intel Storage Matrix on Linux (without the hardware)"
author: bramp
date: 2021-09-12T13:09:07-07:00
layout: post
categories:
  - Blog
tags:
  - raid
  - linux
  - intel
  - mdadm
---


I recently found hard drives from an old RAID array I stopped using over a decade ago. I wanted to [recover the data](https://raid.wiki.kernel.org/index.php/RAID_Recovery) from these disks, and that turned out to be more challenging than expected. This post outlines the steps, and hopefully helps someone else in future.

This was a four 750GB disk RAID-5 array using Intel Storage Matrix "fake-raid" (now called [Intel Rapid Storage Technology](https://en.wikipedia.org/wiki/Intel_Rapid_Storage_Technology)). This is a RAID solution that uses a mix of software and hardware. I no longer have this Intel hardware, and in fact I no longer have a machine that would accept four drives. Luckily `mdadm` seems to have a pure software implementation of Intel Storage Matrix, so I hatched a plan. I would:

1. Create disk images for each of the four drives,
2. Mount the images locally as block devices,
3. Use `mdadm` to construct an array,
4. Copy the data into my backups.

# 1. Create disk images

I have a [USB SATA adapter](https://www.google.com/search?q=usb+sata+adapter), and connected one drive at a time to my PC. This computer has a single local 12 TB drive, which I would store the disk images to. I start to create the disk images using:

```shell
$ sudo dd if=/dev/sdc of=1.raw
```

This worked great for the first disk, but the 2nd disk fail around the 600GB point. It seems this drive has developed bad blocks, but I kept my fingers crossed that this was still recoverable since this was RAID-5 after all. I switched up to using [`ddrescue`](https://www.gnu.org/software/ddrescue/).

```shell
$ sudo ddrescue /dev/sdc 2.raw 2.log --try-again --force --verbose
```

This worked great, and was able to create a full 750GB image, slowly retiring the failed blocks, recovering as much as possible. After about a week of copying I had four disk images, `1.raw`, `2.raw`, `3.raw`, `4.raw`, with only the 2nd disk having problems.

I now, `chmod -w *.raw` to remove write permissions to the images, helping to prevent a future step accidently altered the images.

# 2. Mounting the images

To mount the images I use `losetup` (roughly following instructions [here](https://askubuntu.com/questions/663027/create-raid-array-of-image-files)), specifically:

```shell
$ sudo losetup -r /dev/loop31 1.raw
$ sudo losetup -r /dev/loop32 2.raw
$ sudo losetup -r /dev/loop33 3.raw
$ sudo losetup -r /dev/loop34 4.raw
```

Later I would use `sudo losetup -d /dev/loop3[1234]` to unmount these images. I then decided to inspect these drives, to see what partitions were on them:

```shell
$ sudo fdisk -l /dev/loop31

Disk /dev/loop31: 698.65 GiB, 750156374016 bytes, 1465149168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xd204616a

Device        Boot Start        End    Sectors Size Id Type
/dev/loop31p1          1 4294967295 4294967295   2T ee GPT
```

```shell
$ sudo fdisk -l /dev/loop32

Disk /dev/loop32: 698.65 GiB, 750156374016 bytes, 1465149168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

```shell
$ sudo fdisk -l /dev/loop33

Disk /dev/loop33: 698.65 GiB, 750156374016 bytes, 1465149168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x899c1289

Device        Boot      Start        End    Sectors   Size Id Type
/dev/loop33p1        33488921 4294836216 4261347296     2T ee GPT
/dev/loop33p2        35651584   35651584          0     0B  0 Empty
/dev/loop33p3               0    1377535    1377536 672.6M 12 Compaq diagnostics
/dev/loop33p4      3071040408 3104693987   33653580    16G 64 Novell Netware 286
```

Disk 1 had a single partition, disk 2 and 4 had no partitions, and the 3rd disk had four! Those partitions looked a little weird, and I wondered for a minute if I mixed up my drives, or reformatted them at some point. I tried to mount them to no success, so I just assumed the RAID added something that looked like a real partition table. So I moved onto the next step.

# 3. Use `mdadm` to construct an array.

This is where it got difficult, due to limitations of mounting local disks, and the Intel Storage Matrix support.

I started by asking `mdadm` to examine the images (telling it to use `imsm`):

```shell
$ sudo mdadm --examine -e imsm /dev/loop31
mdadm: /dev/loop31 is not attached to Intel(R) RAID controller.
mdadm: Failed to retrieve serial for /dev/loop31
mdadm: Failed to load all information sections on /dev/loop31
```

Well that’s not a great start. If I understand the error `/dev/loop31 is not attached to Intel(R) RAID controller` it implies I need to connect my drive (or in this case loopback disk image) via a real RAID controller. Well that defeats my whole plan. After some googling, I found this [stackoverflow post](https://askubuntu.com/questions/1239082/reassemble-intel-rst-raid-on-another-mainboard) pointing out there is a `IMSM_NO_PLATFORM=1` environment various I could set. The messaging `is not attached to Intel(R) RAID controller` was really a warning, and had no actual bearing on the problem.


```shell
$ sudo IMSM_NO_PLATFORM=1 mdadm --examine -e imsm \
  /dev/loop31 /dev/loop32 /dev/loop33 /dev/loop34
mdadm: no recogniseable superblock on /dev/loop34
mdadm: Cannot assemble mbr metadata on /dev/loop33
mdadm: no recogniseable superblock on /dev/loop32
mdadm: Cannot assemble mbr metadata on /dev/loop31
```

A new set of errors, but they did not look promising. More head scratching, and I hit a bit of a dead end. I now wondered if the drives were corrupt, making the superblocks unreadable. I decided to start to read the source code for `mdadm` to try and understand the superblock format, and see what was wrong.

It indicated the [superblock](https://github.com/neilbrown/mdadm/blob/5f4184557a98bb641a7889e280265109c73e2f43/super-intel.c#L242) (the data structure containing information about the array) was two sectors from the end of the disk, starting with the string `Intel Raid ISM Cfg Sig. `.

Guessing that a sector is 512 bytes long, I did the following:

```shell
$ tail -c 1024 3.raw  | hd

00000000  49 6e 74 65 6c 20 52 61  69 64 20 49 53 4d 20 43  |Intel Raid ISM C|
00000010  66 67 20 53 69 67 2e 20  31 2e 33 2e 30 30 00 00  |fg Sig. 1.3.00..|
00000020  cc c0 3d de 48 02 00 00  40 d5 11 d4 09 ae 19 00  |..=.H...@.......|
00000030  f8 11 00 00 10 00 00 a0  04 01 02 00 00 00 00 00  |................|
00000040  40 d5 11 d4 00 00 00 00  00 00 00 00 00 00 00 00  |@...............|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000000d0  00 00 00 00 00 00 00 00  53 31 33 55 4a 31 4b 51  |........S13UJ1KQ|
000000e0  34 30 33 33 33 37 00 00  f0 66 54 57 00 00 01 00  |403337...fTW....|
000000f0  3a 01 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |:...............|
00000100  00 00 00 00 00 00 00 00  53 31 33 55 4a 44 57 51  |........S13UJDWQ|
00000110  33 34 36 34 35 37 00 00  f0 66 54 57 00 00 02 00  |346457...fTW....|
00000120  3a 01 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |:...............|
00000130  00 00 00 00 00 00 00 00  53 31 33 55 4a 44 57 51  |........S13UJDWQ|
00000140  33 34 36 36 36 38 00 00  f0 66 54 57 00 00 03 00  |346668...fTW....|
00000150  3a 01 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |:...............|
00000160  00 00 00 00 00 00 00 00  53 31 33 55 4a 31 4b 51  |........S13UJ1KQ|
00000170  34 30 33 33 32 34 3a 30  00 66 54 57 ff ff ff ff  |403324:0.fTW....|
00000180  02 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000190  00 00 00 00 00 00 00 00  52 41 49 44 00 00 00 00  |........RAID....|
000001a0  00 00 00 00 00 00 00 00  00 f8 fc 05 01 00 00 00  |................|
000001b0  8c 10 00 00 00 00 00 00  00 00 01 00 00 00 00 00  |................|
000001c0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001e0  00 00 00 00 00 00 00 00  a6 a8 ae 00 00 00 00 00  |................|
000001f0  00 02 00 ff 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000400
```

Boom, the super block was there, started with a valid header, and even had other fields that looked correct (e.g S13UJ1KQ being a serial number of the drive).

Ok, so now I’m confused about what is wrong, and I wondered if this was a bug in `mdadm`. Going back I remember the first error I got contained `Failed to retrieve serial`, and I noticed the serial numbers were in the super block (e.g S13UJ1KQ). It then occurred to me, that once I imaged the hard drives, the images don’t contain the serial numbers!

Inspecting the code some more, it would fail with that error if it was unable to read the drive’s serial number. The loopback device doesn’t support serial numbers, so this started to make sense. I did however found a undocumented environment variable `IMSM_DEVNAME_AS_SERIAL`, which would instead of reading the serial number from the hardware, just use the name of the device as the serial (e.g `/dev/loop31`). This feature seems explicitly designed to help testing the `mdadm` codebase.

```shell
$ sudo IMSM_DEVNAME_AS_SERIAL=1 IMSM_NO_PLATFORM=1 mdadm --examine -e imsm /dev/loop31 /dev/loop32 /dev/loop33 /dev/loop34
…
/dev/loop31:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : d411d540
         Family : d411d540
     Generation : 0019ae09
     Attributes : All supported
           UUID : ff44bc31:56060902:afb34379:b0faf183
       Checksum : de3dc0cc correct
    MPB Sectors : 2
          Disks : 4
   RAID Devices : 1

[RAID]:
           UUID : 676c222f:760eaf46:97bd30b8:989d2470
     RAID Level : 5
        Members : 4
          Slots : [UUU_]
    Failed disk : 3
      This Slot : ?
    Sector Size : 512
     Array Size : 4395431936 (2095.91 GiB 2250.46 GB)
   Per Dev Size : 1465144328 (698.64 GiB 750.15 GB)
  Sector Offset : 0
    Num Stripes : 11446438
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : degraded
    Dirty State : clean
     RWH Policy : off

  Disk00 Serial : S13UJ1KQ403337
          State : active
             Id : 00010000
    Usable Size : 1465138766 (698.63 GiB 750.15 GB)

  Disk01 Serial : S13UJDWQ346457
          State : active
             Id : 00020000
    Usable Size : 1465138766 (698.63 GiB 750.15 GB)

  Disk02 Serial : S13UJDWQ346668
          State : active
             Id : 00030000
    Usable Size : 1465138766 (698.63 GiB 750.15 GB)

  Disk03 Serial : S13UJ1KQ403324:0
          State : active
             Id : ffffffff
    Usable Size : 1465138526 (698.63 GiB 750.15 GB)

```

Ok, slowly making progress! Now it lists all the superblock information, and I was happy to see `Checksum : de3dc0cc correct`, etc. However, it listed `Failed disk : 3`, and `This Slot : ?`. It made me think without the valid serial numbers, it didn’t know which drive was which, and thus couldn’t assemble the array.

> This made me ponder that if I was ever going to create a RAID array implementation, I would not make it depend on information from the hardware. How do folks re-image disks? What is wrong with some GUID in the superblock to identify the disk? Ok digression aside.

To move forward, I needed to trick `mdadm` to think that serial `/dev/loop31` was actually the real hardware. I went back to my drives, and visibility inspected them to check the serial numbers.

```
  Disk00 Serial : S13UJ1KQ403337   1.raw
  Disk01 Serial : S13UJDWQ346457   2.raw
  Disk02 Serial : S13UJDWQ346668   4.raw
  Disk03 Serial : S13UJ1KQ403324   3.raw
```

At this point, I realised I had accidentally swapped drives 3 and 4. Quickly renaming them got them into the correct order.

Since I had already looked over the mdadm source code, it seemed a simple clean codebase, so I decided to change it to accept serial numbers. After a little while I did the hackiest thing possible:

```diff
diff --git a/super-intel.c b/super-intel.c
index da376251..d466d911 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3994,6 +3994,20 @@ static int nvme_get_serial(int fd, void *buf, size_t buf_len)
        if (!name)
                return 1;

+       if (strcmp(name, "loop31") == 0) {
+               strcpy((char *)buf, "S13UJ1KQ403337");
+               return 0;
+       } else if (strcmp(name, "loop32") == 0) {
+               strcpy((char *)buf, "S13UJDWQ346457");
+               return 0;
+       } else if (strcmp(name, "loop33") == 0) {
+               strcpy((char *)buf, "S13UJDWQ346668");
+               return 0;
+       } else if (strcmp(name, "loop34") == 0) {
+               strcpy((char *)buf, "S13UJ1KQ403324");
+               return 0;
+       }
+
        if (strncmp(name, "nvme", 4) != 0)
                return 1;
```

The `nvme_get_serial` function now had hard coded serial numbers when reading loop3[1234]. This obviously isn’t a generalised solution, but worked for me. Go open source!.

```shell
$ make mdadm
…

$ sudo IMSM_NO_PLATFORM=1 ./mdadm --examine -e imsm /dev/loop31 /dev/loop32 /dev/loop33 /dev/loop34
```

Examine looked good, so the moment of truth, let’s assemble.

```shell
$ sudo IMSM_NO_PLATFORM=1 ./mdadm --assemble --readonly -e imsm /dev/md0 /dev/loop31 /dev/loop32 /dev/loop33 /dev/loop34
mdadm: Container /dev/md0 has been assembled with 3 drives
```

Ok mixed success, it says 3 drives, but I would expect 4… But let’s keep going

```shell
$ sudo ./mdadm --assemble --scan
mdadm: Started /dev/md/RAID_0 with 3 devices
```

W00t! It Started without errors!

I now have a `/dev/md0`, `/dev/md127` and `/dev/md127p1` devices. 

```shell
$ sudo mount -o ro /dev/md127p1 /mnt/raid5

$ ls /mnt/raid5
… lots of old files...
```

YAY. Finished!

Ok, I’m not sure why it says three drives not four. 

```shell
$ sudo ./mdadm --detail /dev/md127
/dev/md127:
         Container : /dev/md0, member 0
        Raid Level : raid5
        Array Size : 2197715968 (2.05 TiB 2.25 TB)
     Used Dev Size : 732572032 (698.64 GiB 750.15 GB)
      Raid Devices : 4
     Total Devices : 3

             State : clean, degraded
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0

            Layout : left-asymmetric
        Chunk Size : 64K

Consistency Policy : resync


              UUID : 676c222f:760eaf46:97bd30b8:989d2470
    Number   Major   Minor   RaidDevice State
       2       7       31        0      active sync   /dev/loop31
       1       7       32        1      active sync   /dev/loop32
       0       7       33        2      active sync   /dev/loop33
       -       0        0        3      removed
```

This does seem to imply a drive is missing. Maybe it doesn’t matter, as it mounted successfully, and I can copy all my data off the array.

# Conclusion

This did not seem the easiest task, and there were a few road bumps along the way. Hopefully the hacks in here will help someone else out in a similar situation.

To finally clean up, you can run this:

```shell
$ sudo umount /mnt/raid5
$ sudo mdadm --stop /dev/md127
$ sudo mdadm --stop /dev/md0
$ sudo losetup -d /dev/loop3[1234]
```

