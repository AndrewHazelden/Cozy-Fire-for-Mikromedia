/*
* Project name:
    CozyFire.vtft
* Generated by:
    Visual TFT
* Date of creation
    10/14/2012
* Time of creation
    3:42:47 PM
* Created By:
    Andrew Hazelden
* Email:
    andrew@andrewhazelden.com
* Blog:
    http://www.andrewhazelden.com
* Test configuration:
    MCU:             P32MX460F512L
    Dev.Board:       MikroMMB_for_PIC32_hw_rev_1.10
                      http://www.mikroe.com/eng/products/view/595/mikrommb-for-pic32-board/
    Oscillator:      80000000 Hz
    SW:              mikroC PRO for PIC32
                      http://www.mikroe.com/eng/products/view/623/mikroc-pro-for-pic32/
                      
    Tips: When creating an image sequence in VisualTFT use the naming convention image###.bmp
          The images should be loaded in Visual TFT using the resource collection icon in the
          toolbar. Save the images as an external resource file.
          
          The CozyFire_image_sequence.h header file creates the pointer array named "animated_fire"
          that holds the names of each of the frames in the image sequence. I looked in the file 
          CozyFire_resources.h to find out the names that VisualTFT / MikroC used for each 
          BMP frame in the animation.

*/

#include "CozyFire_objects.h"
#include "CozyFire_resources.h"
#include "CozyFire_image_sequence.h"


void main() {
  int current_frame = 0;
  Start_TP();

  //Show the whole fireplace image
  TFT_EXT_Image(0, 0, fireplacebg_bmp, 1);  
  
  //Display the title
  TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
  TFT_Write_Text("Cozy   Fire", 130, 20);
  TFT_Write_Text("Created   By   Andrew   Hazelden   (c) 2012", 40, 220);

  Delay_ms(2500);
  
  //Show the whole fireplace image
  TFT_EXT_Image(0, 0, fireplacebg_bmp, 1);
  
  while (1) {
    Check_TP();
    
    //Play the cropped fireplace image sequence
    TFT_EXT_Image(19, 64, animated_fire[current_frame], 1);
    
    Delay_ms(25); //Keep the frame rate from going too high
    
    //Increment the frame counter
    current_frame++; 
    
    //Keep the animation in the frame range of 0-143
    if(current_frame>=frame_range){
      current_frame=0;
    }
    
  }

}
