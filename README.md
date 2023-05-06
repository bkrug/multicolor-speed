# multicolor-speed

Multicolor mode on the TMS9918A chip is very rarely used.
Nevertheless, if it is to be used at all, it's main advantage is that there is relatively little data to write to refresh the screen.
Every one of the 3,072 4x4-pixel "boxes" can be updated by writing 1.5K to VDP RAM.

The purpose of this experiment, was to get an idea of what kind of frame-rate someone can get when engaging in fast-paced image updates.
In this example, we assume that some routine has a 3K region in CPU RAM, with each byte representing one of the multicolor mode boxes.
4-bits in every byte is being wasted, but that hypothetical routine can update the boxes in a random order.
That hypothetical routine probably is drawing lines and shapes.

The code in this experiment is taking that 3K image map, and compressing it down to 1.5K to send to the VDP RAM.
Once we try this with a routine stored in cartridge ROM.
In a second attempt we try this with a routine that has been copied to the scratch PAD RAM.

Unfortunately, the faster of these two approaches still takes about 3/60ths of a second, so we are already limited to 20 frmes-per-second.
Since that hypothetical line drawing routine would need time to set up the image in CPU RAM,
using multicolor mode in this way would probably only achieve 10 or 15 FPS.

Yes, with another algorithm, you could write multicolor data more quickly than 3/60ths of a second.
If you have a static background and just want to scroll very quickly,
I imagine you could create a faster algorithm.
Maybe you could scrunch it down to 1/60th of a second.
In such a case, you've probably already compressed the background down such that each byte represents two 4x4 boxes.
But such a practice would not be compatible with a dynamicly generated background. 
