#line 1 "C:/Users/dsi/Desktop/CozyFire PIC32/Development/mikroC PRO for PIC32/CozyFire_main.c"
#line 1 "c:/users/dsi/desktop/cozyfire pic32/development/mikroc pro for pic32/cozyfire_objects.h"
typedef enum {_taLeft, _taCenter, _taRight} TTextAlign;

typedef struct Screen TScreen;

struct Screen {
 unsigned int Color;
 unsigned int Width;
 unsigned int Height;
 unsigned short ObjectsCount;
};

extern TScreen Screen1;
#line 24 "c:/users/dsi/desktop/cozyfire pic32/development/mikroc pro for pic32/cozyfire_objects.h"
void DrawScreen(TScreen *aScreen);
void Check_TP();
void Start_TP();
#line 1 "c:/users/dsi/desktop/cozyfire pic32/development/mikroc pro for pic32/cozyfire_resources.h"
#line 1 "c:/users/dsi/desktop/cozyfire pic32/development/mikroc pro for pic32/cozyfire_image_sequence.h"
#line 12 "c:/users/dsi/desktop/cozyfire pic32/development/mikroc pro for pic32/cozyfire_image_sequence.h"
unsigned long animated_fire[ 144 ]= {
  0x00013F9B ,  0x0001E6ED ,  0x00028E3F ,  0x00033591 ,  0x0003DCE3 ,  0x00048435 ,  0x00052B87 ,  0x0005D2D9 ,  0x00067A2B ,  0x0007217D ,  0x0007C8CF ,  0x00087021 ,  0x00091773 ,  0x0009BEC5 ,  0x000A6617 ,  0x000B0D69 ,  0x000BB4BB ,  0x000C5C0D ,  0x000D035F ,  0x000DAAB1 ,  0x000E5203 ,  0x000EF955 ,  0x000FA0A7 ,  0x001047F9 ,  0x0010EF4B ,  0x0011969D ,  0x00123DEF ,  0x0012E541 ,  0x00138C93 ,  0x001433E5 ,  0x0014DB37 ,  0x00158289 ,  0x001629DB ,  0x0016D12D ,  0x0017787F ,  0x00181FD1 ,  0x0018C723 ,  0x00196E75 ,  0x001A15C7 ,  0x001ABD19 ,  0x001B646B ,  0x001C0BBD ,  0x001CB30F ,  0x001D5A61 ,  0x001E01B3 ,  0x001EA905 ,  0x001F5057 ,  0x001FF7A9 ,  0x00209EFB ,  0x0021464D ,  0x0021ED9F ,  0x002294F1 ,  0x00233C43 ,  0x0023E395 ,  0x00248AE7 ,  0x00253239 ,  0x0025D98B ,  0x002680DD ,  0x0027282F ,  0x0027CF81 ,  0x002876D3 ,  0x00291E25 ,  0x0029C577 ,  0x002A6CC9 ,  0x002B141B ,  0x002BBB6D ,  0x002C62BF ,  0x002D0A11 ,  0x002DB163 ,  0x002E58B5 ,  0x002F0007 ,  0x002FA759 ,  0x00304EAB ,  0x0030F5FD ,  0x00319D4F ,  0x003244A1 ,  0x0032EBF3 ,  0x00339345 ,  0x00343A97 ,  0x0034E1E9 ,  0x0035893B ,  0x0036308D ,  0x0036D7DF ,  0x00377F31 ,  0x00382683 ,  0x0038CDD5 ,  0x00397527 ,  0x003A1C79 ,  0x003AC3CB ,  0x003B6B1D ,  0x003C126F ,  0x003CB9C1 ,  0x003D6113 ,  0x003E0865 ,  0x003EAFB7 ,  0x003F5709 ,  0x003FFE5B ,  0x0040A5AD ,  0x00414CFF ,  0x0041F451 ,  0x00429BA3 ,  0x004342F5 ,  0x0043EA47 ,  0x00449199 ,  0x004538EB ,  0x0045E03D ,  0x0046878F ,  0x00472EE1 ,  0x0047D633 ,  0x00487D85 ,  0x004924D7 ,  0x0049CC29 ,  0x004A737B ,  0x004B1ACD ,  0x004BC21F ,  0x004C6971 ,  0x004D10C3 ,  0x004DB815 ,  0x004E5F67 ,  0x004F06B9 ,  0x004FAE0B ,  0x0050555D ,  0x0050FCAF ,  0x0051A401 ,  0x00524B53 ,  0x0052F2A5 ,  0x005399F7 ,  0x00544149 ,  0x0054E89B ,  0x00558FED ,  0x0056373F ,  0x0056DE91 ,  0x005785E3 ,  0x00582D35 ,  0x0058D487 ,  0x00597BD9 ,  0x005A232B ,  0x005ACA7D ,  0x005B71CF ,  0x005C1921 ,  0x005CC073 ,  0x005D67C5 ,  0x005E0F17 ,  0x005EB669 };
#line 40 "C:/Users/dsi/Desktop/CozyFire PIC32/Development/mikroC PRO for PIC32/CozyFire_main.c"
void main() {
 int current_frame = 0;
 Start_TP();


 TFT_EXT_Image(0, 0,  0x00001195 , 1);


 TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
 TFT_Write_Text("Cozy   Fire", 130, 20);
 TFT_Write_Text("Created   By   Andrew   Hazelden   (c) 2012", 40, 220);

 Delay_ms(2500);


 TFT_EXT_Image(0, 0,  0x00001195 , 1);

 while (1) {
 Check_TP();


 TFT_EXT_Image(19, 64, animated_fire[current_frame], 1);

 Delay_ms(25);


 current_frame++;


 if(current_frame>= 144 ){
 current_frame=0;
 }

 }

}
