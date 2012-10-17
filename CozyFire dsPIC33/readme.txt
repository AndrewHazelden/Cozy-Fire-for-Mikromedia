Cozy Fire for Mikromedia dsPIC33
Version 1.1 - Released Oct 16, 2012

The Cozy Fire example creates an animated fireplace on the Milromedia dsPIC33 screen. The Cozy Fire example was created to show how the VisualTFT resource collection feature can be used to create animated sprites. The code was written using VisualTFT and MikroC Pro for dsPIC33.

This example is hosted on libstock.com

Mikromedia Image Sequence Tips: 
When creating an image sequence for use with VisualTFT use the file naming convention of image###.bmp   

eg. image001.bmp to image144.bmp

The images should be loaded in Visual TFT using the resource collection icon in the toolbar. Save the images to an external VisualTFT resource file.  

The CozyFire_image_sequence.h header file creates the pointer array named "animated_fire" that holds the names of each of the frames in the image sequence. 

I looked in the file CozyFire_resources.h to find out the names that VisualTFT / MikroC used for each BMP frame in the animation.

When VisualTFT saves an external image resource to the .res file it writes the images pointer address for the image fireplace001.bmp in the resource.h file as:
#define fireplace001_bmp 0x00013F9B

If you are creating a pointer array for the images keep in mind that C code arrays start at index position 0. This also means you have to be careful of off by one errors when looping the animation.

eg. The first frame in the array begins at animated_fire[0] and image number 144 is located at animated_fire[143].

There are two ways you can create an animation using MikroC and the TFT Library. You could either use the external TFT image drawing function:
TFT_EXT_Image(19, 64, animated_fire[current_frame], 1);

or your could use the VisualTFT centric workflow of swapping the current image in the picture name attribute. In the events_code.c file you could have a button press that causes an image to be animated.

eg. If you have a VisualTFT image on the current screen named "fireplace" you could swap the picture using:

void fireplaceOnPress() {
  current_frame++;

  //Keep the animation in the frame range of 0-143
  if(current_frame>=frame_range){
    current_frame=0;
  }
  fireplace.Picture_Name = animated_fire[current_frame];
  DrawImage(&fireplace);
}


------------------------------------------------------

Installation:

1. Install Firmware: Flash the CozyFire.hex firmware file to your Mikromedia dsPIC33 board. There are two versions of the Cozy Fire Hex firmware provided for the Mikromedia dsPIC33 hardware version 1.05 or 1.10 boards. 

2. Install resource file: Copy the resource file CozyFire.RES to the root folder of your Mikromedia board's Micro-SD memory card.

3. Enjoy the comfort of an animated cozy fireplace on your Mikromedia dsPIC33 screen.

------------------------------------------------------

Hardware Required:

Mikromedia for dsPIC33 v1.10
http://www.mikroe.com/mikromedia/dspic33/

------------------------------------------------------

Example Created by Andrew Hazelden. (c) Copyright 2012.

Email:
andrew@andrewhazelden.com

Blog:
http://www.andrewhazelden.com