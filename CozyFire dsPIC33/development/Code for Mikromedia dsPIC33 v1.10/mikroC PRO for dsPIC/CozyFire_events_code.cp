#line 1 "C:/Users/dsi/Desktop/Cozy Fire VisualTFT Project/CozyFire_Code/mikroC PRO for dsPIC/CozyFire_events_code.c"
#line 1 "c:/users/dsi/desktop/cozy fire visualtft project/cozyfire_code/mikroc pro for dspic/cozyfire_objects.h"
typedef enum {_taLeft, _taCenter, _taRight} TTextAlign;

typedef struct Screen TScreen;

struct Screen {
 unsigned int Color;
 unsigned int Width;
 unsigned int Height;
 unsigned short ObjectsCount;
};

extern TScreen Screen1;
#line 24 "c:/users/dsi/desktop/cozy fire visualtft project/cozyfire_code/mikroc pro for dspic/cozyfire_objects.h"
void DrawScreen(TScreen *aScreen);
void Check_TP();
void Start_TP();
