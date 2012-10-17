#line 1 "C:/Users/dsi/Desktop/Cozy Fire VisualTFT Project/CozyFire_Code/mikroC PRO for dsPIC/CozyFire_driver.c"
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
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/built_in.h"
#line 6 "C:/Users/dsi/Desktop/Cozy Fire VisualTFT Project/CozyFire_Code/mikroC PRO for dsPIC/CozyFire_driver.c"
sbit Mmc_Chip_Select at LATG9_bit;
sbit Mmc_Chip_Select_Direction at TRISG9_bit;


unsigned long currentSector = -1, res_file_size;





char TFT_DataPort at LATA;
sbit TFT_RST at LATC1_bit;
sbit TFT_BLED at LATD7_bit;
sbit TFT_RS at LATB15_bit;
sbit TFT_CS at LATC3_bit;
sbit TFT_RD at LATD12_bit;
sbit TFT_WR at LATD13_bit;
char TFT_DataPort_Direction at TRISA;
sbit TFT_RST_Direction at TRISC1_bit;
sbit TFT_BLED_Direction at TRISD7_bit;
sbit TFT_RS_Direction at TRISB15_bit;
sbit TFT_CS_Direction at TRISC3_bit;
sbit TFT_RD_Direction at TRISD12_bit;
sbit TFT_WR_Direction at TRISD13_bit;



sbit DRIVEX_LEFT at LATB13_bit;
sbit DRIVEX_RIGHT at LATB11_bit;
sbit DRIVEY_UP at LATB12_bit;
sbit DRIVEY_DOWN at LATB10_bit;
sbit DRIVEX_LEFT_DIRECTION at TRISB13_bit;
sbit DRIVEX_RIGHT_DIRECTION at TRISB11_bit;
sbit DRIVEY_UP_DIRECTION at TRISB12_bit;
sbit DRIVEY_DOWN_DIRECTION at TRISB10_bit;



unsigned int Xcoord, Ycoord;
const ADC_THRESHOLD = 800;
char PenDown;
typedef unsigned long TPointer;
TPointer PressedObject;
int PressedObjectType;
unsigned int caption_length, caption_height;
unsigned int display_width, display_height;

int _object_count;
unsigned short object_pressed;


void Set_Index(unsigned short index) {
 TFT_RS = 0;
  ((char *)&LATA)[0]  = index;
 TFT_WR = 0;
 TFT_WR = 1;
}


void Write_Command(unsigned short cmd) {
 TFT_RS = 1;
  ((char *)&LATA)[0]  = cmd;
 TFT_WR = 0;
 TFT_WR = 1;
}


void Write_Data(unsigned int _data) {
 TFT_RS = 1;
  ((char *)&LATE)[0]  =  ((char *)&_data)[1] ;
  ((char *)&LATA)[0]  =  ((char *)&_data)[0] ;
 TFT_WR = 0;
 TFT_WR = 1;
}


void Init_ADC() {
 AD1PCFGL = 0xCFFF;
 AD1PCFGH = 0xCFFF;
 ADC1_Init();
}

char* TFT_Get_Data(unsigned long offset, unsigned int count, unsigned int *num) {
unsigned long start_sector;
unsigned int pos;

 start_sector = Mmc_Get_File_Write_Sector() + offset/512;
 pos = (unsigned long)offset%512;

 if(start_sector == currentSector+1) {
 Mmc_Multi_Read_Sector(f16_sector.fSect);
 currentSector = start_sector;
 } else if (start_sector != currentSector) {
 if(currentSector != -1)
 Mmc_Multi_Read_Stop();
 Mmc_Multi_Read_Start(start_sector);
 Mmc_Multi_Read_Sector(f16_sector.fSect);
 currentSector = start_sector;
 }

 if(count>512-pos)
 *num = 512-pos;
 else
 *num = count;

 return f16_sector.fSect+pos;
}
static void InitializeTouchPanel() {
 Init_ADC();
 TFT_Set_Active(Set_Index, Write_Command, Write_Data);
 TFT_Init(320, 240);
 TFT_Set_Ext_Buffer(TFT_Get_Data);

 TP_TFT_Init(320, 240, 13, 12);
 TP_TFT_Set_ADC_Threshold(ADC_THRESHOLD);

 PenDown = 0;
 PressedObject = 0;
 PressedObjectType = -1;
}

void Calibrate() {
 TFT_Set_Pen(CL_WHITE, 3);
 TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
 TFT_Write_Text("Touch selected corners for calibration", 50, 100);
 TFT_Line(315, 1, 319, 1);
 TFT_Line(310, 10, 319, 1);
 TFT_Line(319, 5, 319, 1);
 TFT_Write_Text("first here", 250, 20);

 TP_TFT_Calibrate_Min();
 Delay_ms(500);

 TFT_Set_Pen(CL_BLACK, 3);
 TFT_Set_Font(TFT_defaultFont, CL_BLACK, FO_HORIZONTAL);
 TFT_Line(315, 1, 319, 1);
 TFT_Line(310, 10, 319, 1);
 TFT_Line(319, 5, 319, 1);
 TFT_Write_Text("first here", 250, 20);

 TFT_Set_Pen(CL_WHITE, 3);
 TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
 TFT_Line(0, 239, 0, 235);
 TFT_Line(0, 239, 5, 239);
 TFT_Line(0, 239, 10, 229);
 TFT_Write_Text("now here ", 15, 200);

 TP_TFT_Calibrate_Max();
 Delay_ms(500);
}



 TScreen* CurrentScreen;

 TScreen Screen1;




static void InitializeObjects() {
 Screen1.Color = 0x0000;
 Screen1.Width = 320;
 Screen1.Height = 240;
 Screen1.ObjectsCount = 0;

}

static char IsInsideObject (unsigned int X, unsigned int Y, unsigned int Left, unsigned int Top, unsigned int Width, unsigned int Height) {
 if ( (Left<= X) && (Left+ Width - 1 >= X) &&
 (Top <= Y) && (Top + Height - 1 >= Y) )
 return 1;
 else
 return 0;
}



 void DeleteTrailingSpaces(char* str){
 char i;
 i = 0;
 while(1) {
 if(str[0] == ' ') {
 for(i = 0; i < strlen(str); i++) {
 str[i] = str[i+1];
 }
 }
 else
 break;
 }
 }

void DrawScreen(TScreen *aScreen) {
 int order;
 char save_bled, save_bled_direction;

 object_pressed = 0;
 order = 0;
 CurrentScreen = aScreen;

 if ((display_width != CurrentScreen->Width) || (display_height != CurrentScreen->Height)) {
 save_bled = TFT_BLED;
 save_bled_direction = TFT_BLED_Direction;
 TFT_BLED_Direction = 0;
 TFT_BLED = 0;
 TFT_Set_Active(Set_Index, Write_Command, Write_Data);
 TFT_Init(CurrentScreen->Width, CurrentScreen->Height);
 TFT_Set_Ext_Buffer(TFT_Get_Data);
 TP_TFT_Init(CurrentScreen->Width, CurrentScreen->Height, 13, 12);
 TP_TFT_Set_ADC_Threshold(ADC_THRESHOLD);
 TFT_Fill_Screen(CurrentScreen->Color);
 display_width = CurrentScreen->Width;
 display_height = CurrentScreen->Height;
 TFT_BLED = save_bled;
 TFT_BLED_Direction = save_bled_direction;
 }
 else
 TFT_Fill_Screen(CurrentScreen->Color);


 while (order < CurrentScreen->ObjectsCount) {
 }
}

void Get_Object(unsigned int X, unsigned int Y) {
 _object_count = -1;
}


static void Process_TP_Press(unsigned int X, unsigned int Y) {

 Get_Object(X, Y);


 if (_object_count != -1) {
 }
}

static void Process_TP_Up(unsigned int X, unsigned int Y) {


 Get_Object(X, Y);


 if (_object_count != -1) {
 }
 PressedObject = 0;
 PressedObjectType = -1;
}

static void Process_TP_Down(unsigned int X, unsigned int Y) {

 object_pressed = 0;

 Get_Object(X, Y);

 if (_object_count != -1) {
 }
}

void Check_TP() {
 if (TP_TFT_Press_Detect()) {

 if (TP_TFT_Get_Coordinates(&Xcoord, &Ycoord) == 0) {
 Process_TP_Press(Xcoord, Ycoord);
 if (PenDown == 0) {
 PenDown = 1;
 Process_TP_Down(Xcoord, Ycoord);
 }
 }
 }
 else if (PenDown == 1) {
 PenDown = 0;
 Process_TP_Up(Xcoord, Ycoord);
 }
}

void Init_MCU() {
 TRISE = 0;
 TFT_DataPort_Direction = 0;
 CLKDIVbits.PLLPRE = 0;

 PLLFBD = 38;

 CLKDIVbits.PLLPOST = 0;

 Delay_ms(150);
 TP_TFT_Rotate_180(0);
 TFT_Set_Active(Set_Index,Write_Command,Write_Data);
}

void Init_Ext_Mem() {

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64,
 _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
 Delay_ms(10);


 if (!Mmc_Fat_Init()) {

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_4,
 _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);


 Mmc_Fat_Assign("CozyFire.RES", 0);
 Mmc_Fat_Reset(&res_file_size);
 }
}

void Start_TP() {
 Init_MCU();

 Init_Ext_Mem();

 InitializeTouchPanel();

 Delay_ms(1000);
 TFT_Fill_Screen(0);
 Calibrate();
 TFT_Fill_Screen(0);

 InitializeObjects();
 display_width = Screen1.Width;
 display_height = Screen1.Height;
 DrawScreen(&Screen1);
}
