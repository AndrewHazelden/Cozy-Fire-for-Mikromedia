#line 1 "C:/Users/dsi/Desktop/CozyFire PIC32/Development/mikroC PRO for PIC32/CozyFire_events_code.c"
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
