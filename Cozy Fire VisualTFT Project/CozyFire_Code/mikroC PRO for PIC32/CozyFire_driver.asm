_PMPWaitBusy:
;CozyFire_driver.c,56 :: 		void PMPWaitBusy() {
;CozyFire_driver.c,57 :: 		while(PMMODEbits.BUSY);
L_PMPWaitBusy0:
LBU	R2, Offset(PMMODEbits+1)(GP)
EXT	R2, R2, 7, 1
BNE	R2, R0, L__PMPWaitBusy46
NOP	
J	L_PMPWaitBusy1
NOP	
L__PMPWaitBusy46:
J	L_PMPWaitBusy0
NOP	
L_PMPWaitBusy1:
;CozyFire_driver.c,58 :: 		}
L_end_PMPWaitBusy:
JR	RA
NOP	
; end of _PMPWaitBusy
_Set_Index:
;CozyFire_driver.c,60 :: 		void Set_Index(unsigned short index) {
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,61 :: 		TFT_RS = 0;
LBU	R2, Offset(LATB15_bit+1)(GP)
INS	R2, R0, 7, 1
SB	R2, Offset(LATB15_bit+1)(GP)
;CozyFire_driver.c,62 :: 		PMDIN = index;
ANDI	R2, R25, 255
SW	R2, Offset(PMDIN+0)(GP)
;CozyFire_driver.c,63 :: 		PMPWaitBusy();
JAL	_PMPWaitBusy+0
NOP	
;CozyFire_driver.c,64 :: 		}
L_end_Set_Index:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _Set_Index
_Write_Command:
;CozyFire_driver.c,66 :: 		void Write_Command( unsigned short cmd ) {
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,67 :: 		TFT_RS = 1;
LBU	R2, Offset(LATB15_bit+1)(GP)
ORI	R2, R2, 128
SB	R2, Offset(LATB15_bit+1)(GP)
;CozyFire_driver.c,68 :: 		PMDIN = cmd;
ANDI	R2, R25, 255
SW	R2, Offset(PMDIN+0)(GP)
;CozyFire_driver.c,69 :: 		PMPWaitBusy();
JAL	_PMPWaitBusy+0
NOP	
;CozyFire_driver.c,70 :: 		}
L_end_Write_Command:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _Write_Command
_Write_Data:
;CozyFire_driver.c,72 :: 		void Write_Data(unsigned int _data) {
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,73 :: 		TFT_RS = 1;
LBU	R2, Offset(LATB15_bit+1)(GP)
ORI	R2, R2, 128
SB	R2, Offset(LATB15_bit+1)(GP)
;CozyFire_driver.c,74 :: 		PMDIN = _data;
ANDI	R2, R25, 65535
SW	R2, Offset(PMDIN+0)(GP)
;CozyFire_driver.c,75 :: 		PMPWaitBusy();
JAL	_PMPWaitBusy+0
NOP	
;CozyFire_driver.c,76 :: 		}
L_end_Write_Data:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _Write_Data
_Init_ADC:
;CozyFire_driver.c,79 :: 		void Init_ADC() {
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,80 :: 		AD1PCFG = 0xFFFF;
ORI	R2, R0, 65535
SW	R2, Offset(AD1PCFG+0)(GP)
;CozyFire_driver.c,81 :: 		PCFG12_bit = 0;
LBU	R2, Offset(PCFG12_bit+1)(GP)
INS	R2, R0, 4, 1
SB	R2, Offset(PCFG12_bit+1)(GP)
;CozyFire_driver.c,82 :: 		PCFG13_bit = 0;
LBU	R2, Offset(PCFG13_bit+1)(GP)
INS	R2, R0, 5, 1
SB	R2, Offset(PCFG13_bit+1)(GP)
;CozyFire_driver.c,84 :: 		ADC1_Init();
JAL	_ADC1_Init+0
NOP	
;CozyFire_driver.c,85 :: 		}
L_end_Init_ADC:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _Init_ADC
_TFT_Get_Data:
;CozyFire_driver.c,87 :: 		char* TFT_Get_Data(unsigned long offset, unsigned long count, unsigned long *num) {
ADDIU	SP, SP, -24
SW	RA, 0(SP)
;CozyFire_driver.c,91 :: 		start_sector = Mmc_Get_File_Write_Sector() + offset/512;
SW	R25, 4(SP)
JAL	_Mmc_Get_File_Write_Sector+0
NOP	
SRL	R3, R25, 9
ADDU	R3, R2, R3
SW	R3, 16(SP)
;CozyFire_driver.c,92 :: 		pos = (unsigned long)offset%512;
ANDI	R2, R25, 511
SW	R2, 20(SP)
;CozyFire_driver.c,94 :: 		if(start_sector == currentSector+1) {
LW	R2, Offset(_currentSector+0)(GP)
ADDIU	R2, R2, 1
BEQ	R3, R2, L__TFT_Get_Data52
NOP	
J	L_TFT_Get_Data2
NOP	
L__TFT_Get_Data52:
;CozyFire_driver.c,95 :: 		Mmc_Multi_Read_Sector(f16_sector.fSect);
SW	R27, 8(SP)
SW	R26, 12(SP)
LUI	R25, #hi_addr(_f16_sector+0)
ORI	R25, R25, #lo_addr(_f16_sector+0)
JAL	_Mmc_Multi_Read_Sector+0
NOP	
LW	R26, 12(SP)
LW	R27, 8(SP)
;CozyFire_driver.c,96 :: 		currentSector = start_sector;
LW	R2, 16(SP)
SW	R2, Offset(_currentSector+0)(GP)
;CozyFire_driver.c,97 :: 		} else if (start_sector != currentSector) {
J	L_TFT_Get_Data3
NOP	
L_TFT_Get_Data2:
LW	R3, Offset(_currentSector+0)(GP)
LW	R2, 16(SP)
BNE	R2, R3, L__TFT_Get_Data54
NOP	
J	L_TFT_Get_Data4
NOP	
L__TFT_Get_Data54:
;CozyFire_driver.c,98 :: 		if(currentSector != -1)
LW	R3, Offset(_currentSector+0)(GP)
LUI	R2, 65535
ORI	R2, R2, 65535
BNE	R3, R2, L__TFT_Get_Data56
NOP	
J	L_TFT_Get_Data5
NOP	
L__TFT_Get_Data56:
;CozyFire_driver.c,99 :: 		Mmc_Multi_Read_Stop();
SW	R27, 8(SP)
SW	R26, 12(SP)
JAL	_Mmc_Multi_Read_Stop+0
NOP	
LW	R26, 12(SP)
LW	R27, 8(SP)
L_TFT_Get_Data5:
;CozyFire_driver.c,100 :: 		Mmc_Multi_Read_Start(start_sector);
SW	R27, 8(SP)
SW	R26, 12(SP)
LW	R25, 16(SP)
JAL	_Mmc_Multi_Read_Start+0
NOP	
;CozyFire_driver.c,101 :: 		Mmc_Multi_Read_Sector(f16_sector.fSect);
LUI	R25, #hi_addr(_f16_sector+0)
ORI	R25, R25, #lo_addr(_f16_sector+0)
JAL	_Mmc_Multi_Read_Sector+0
NOP	
LW	R26, 12(SP)
LW	R27, 8(SP)
;CozyFire_driver.c,102 :: 		currentSector = start_sector;
LW	R2, 16(SP)
SW	R2, Offset(_currentSector+0)(GP)
;CozyFire_driver.c,103 :: 		}
L_TFT_Get_Data4:
L_TFT_Get_Data3:
;CozyFire_driver.c,105 :: 		if(count>512-pos)
LW	R3, 20(SP)
ORI	R2, R0, 512
SUBU	R2, R2, R3
SLTU	R2, R2, R26
BNE	R2, R0, L__TFT_Get_Data57
NOP	
J	L_TFT_Get_Data6
NOP	
L__TFT_Get_Data57:
;CozyFire_driver.c,106 :: 		*num = 512-pos;
LW	R3, 20(SP)
ORI	R2, R0, 512
SUBU	R2, R2, R3
SW	R2, 0(R27)
J	L_TFT_Get_Data7
NOP	
L_TFT_Get_Data6:
;CozyFire_driver.c,108 :: 		*num = count;
SW	R26, 0(R27)
L_TFT_Get_Data7:
;CozyFire_driver.c,110 :: 		return f16_sector.fSect+pos;
LW	R3, 20(SP)
LUI	R2, #hi_addr(_f16_sector+0)
ORI	R2, R2, #lo_addr(_f16_sector+0)
ADDU	R2, R2, R3
;CozyFire_driver.c,111 :: 		}
;CozyFire_driver.c,110 :: 		return f16_sector.fSect+pos;
;CozyFire_driver.c,111 :: 		}
L_end_TFT_Get_Data:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 24
JR	RA
NOP	
; end of _TFT_Get_Data
CozyFire_driver_InitializeTouchPanel:
;CozyFire_driver.c,112 :: 		static void InitializeTouchPanel() {
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;CozyFire_driver.c,113 :: 		Init_ADC();
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
JAL	_Init_ADC+0
NOP	
;CozyFire_driver.c,114 :: 		TFT_Set_Active(Set_Index, Write_Command, Write_Data);
LUI	R27, #hi_addr(_Write_Data+0)
ORI	R27, R27, #lo_addr(_Write_Data+0)
LUI	R26, #hi_addr(_Write_Command+0)
ORI	R26, R26, #lo_addr(_Write_Command+0)
LUI	R25, #hi_addr(_Set_Index+0)
ORI	R25, R25, #lo_addr(_Set_Index+0)
JAL	_TFT_Set_Active+0
NOP	
;CozyFire_driver.c,115 :: 		TFT_Init(320, 240);
ORI	R26, R0, 240
ORI	R25, R0, 320
JAL	_TFT_Init+0
NOP	
;CozyFire_driver.c,116 :: 		TFT_Set_Ext_Buffer(TFT_Get_Data);
LUI	R25, #hi_addr(_TFT_Get_Data+0)
ORI	R25, R25, #lo_addr(_TFT_Get_Data+0)
JAL	_TFT_Set_Ext_Buffer+0
NOP	
;CozyFire_driver.c,118 :: 		TP_TFT_Init(320, 240, 13, 12);                                  // Initialize touch panel
ORI	R28, R0, 12
ORI	R27, R0, 13
ORI	R26, R0, 240
ORI	R25, R0, 320
JAL	_TP_TFT_Init+0
NOP	
;CozyFire_driver.c,119 :: 		TP_TFT_Set_ADC_Threshold(ADC_THRESHOLD);                              // Set touch panel ADC threshold
ORI	R25, R0, 1000
JAL	_TP_TFT_Set_ADC_Threshold+0
NOP	
;CozyFire_driver.c,121 :: 		PenDown = 0;
SB	R0, Offset(_PenDown+0)(GP)
;CozyFire_driver.c,122 :: 		PressedObject = 0;
SW	R0, Offset(_PressedObject+0)(GP)
;CozyFire_driver.c,123 :: 		PressedObjectType = -1;
ORI	R2, R0, 65535
SH	R2, Offset(_PressedObjectType+0)(GP)
;CozyFire_driver.c,124 :: 		}
L_end_InitializeTouchPanel:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of CozyFire_driver_InitializeTouchPanel
CozyFire_driver_InitializeObjects:
;CozyFire_driver.c,135 :: 		static void InitializeObjects() {
;CozyFire_driver.c,136 :: 		Screen1.Color                     = 0x0000;
SH	R0, Offset(_Screen1+0)(GP)
;CozyFire_driver.c,137 :: 		Screen1.Width                     = 320;
ORI	R2, R0, 320
SH	R2, Offset(_Screen1+2)(GP)
;CozyFire_driver.c,138 :: 		Screen1.Height                    = 240;
ORI	R2, R0, 240
SH	R2, Offset(_Screen1+4)(GP)
;CozyFire_driver.c,139 :: 		Screen1.ObjectsCount              = 0;
SB	R0, Offset(_Screen1+6)(GP)
;CozyFire_driver.c,141 :: 		}
L_end_InitializeObjects:
JR	RA
NOP	
; end of CozyFire_driver_InitializeObjects
CozyFire_driver_IsInsideObject:
;CozyFire_driver.c,143 :: 		static char IsInsideObject (unsigned int X, unsigned int Y, unsigned int Left, unsigned int Top, unsigned int Width, unsigned int Height) { // static
;CozyFire_driver.c,144 :: 		if ( (Left<= X) && (Left+ Width - 1 >= X) &&
; Width start address is: 16 (R4)
LHU	R4, 0(SP)
; Height start address is: 20 (R5)
LHU	R5, 2(SP)
ANDI	R3, R27, 65535
ANDI	R2, R25, 65535
SLTU	R2, R2, R3
BEQ	R2, R0, L_CozyFire_driver_IsInsideObject61
NOP	
J	L_CozyFire_driver_IsInsideObject40
NOP	
L_CozyFire_driver_IsInsideObject61:
ADDU	R2, R27, R4
; Width end address is: 16 (R4)
ADDIU	R2, R2, -1
ANDI	R3, R2, 65535
ANDI	R2, R25, 65535
SLTU	R2, R3, R2
BEQ	R2, R0, L_CozyFire_driver_IsInsideObject62
NOP	
J	L_CozyFire_driver_IsInsideObject39
NOP	
L_CozyFire_driver_IsInsideObject62:
;CozyFire_driver.c,145 :: 		(Top <= Y)  && (Top + Height - 1 >= Y) )
ANDI	R3, R28, 65535
ANDI	R2, R26, 65535
SLTU	R2, R2, R3
BEQ	R2, R0, L_CozyFire_driver_IsInsideObject63
NOP	
J	L_CozyFire_driver_IsInsideObject38
NOP	
L_CozyFire_driver_IsInsideObject63:
ADDU	R2, R28, R5
; Height end address is: 20 (R5)
ADDIU	R2, R2, -1
ANDI	R3, R2, 65535
ANDI	R2, R26, 65535
SLTU	R2, R3, R2
BEQ	R2, R0, L_CozyFire_driver_IsInsideObject64
NOP	
J	L_CozyFire_driver_IsInsideObject37
NOP	
L_CozyFire_driver_IsInsideObject64:
L_CozyFire_driver_IsInsideObject36:
;CozyFire_driver.c,146 :: 		return 1;
ORI	R2, R0, 1
J	L_end_IsInsideObject
NOP	
;CozyFire_driver.c,144 :: 		if ( (Left<= X) && (Left+ Width - 1 >= X) &&
L_CozyFire_driver_IsInsideObject40:
L_CozyFire_driver_IsInsideObject39:
;CozyFire_driver.c,145 :: 		(Top <= Y)  && (Top + Height - 1 >= Y) )
L_CozyFire_driver_IsInsideObject38:
L_CozyFire_driver_IsInsideObject37:
;CozyFire_driver.c,148 :: 		return 0;
MOVZ	R2, R0, R0
;CozyFire_driver.c,149 :: 		}
L_end_IsInsideObject:
JR	RA
NOP	
; end of CozyFire_driver_IsInsideObject
_DeleteTrailingSpaces:
;CozyFire_driver.c,153 :: 		void DeleteTrailingSpaces(char* str){
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,156 :: 		while(1) {
L_DeleteTrailingSpaces12:
;CozyFire_driver.c,157 :: 		if(str[0] == ' ') {
LBU	R2, 0(R25)
ANDI	R3, R2, 255
ORI	R2, R0, 32
BEQ	R3, R2, L__DeleteTrailingSpaces66
NOP	
J	L_DeleteTrailingSpaces14
NOP	
L__DeleteTrailingSpaces66:
;CozyFire_driver.c,158 :: 		for(i = 0; i < strlen(str); i++) {
; i start address is: 20 (R5)
MOVZ	R5, R0, R0
; i end address is: 20 (R5)
L_DeleteTrailingSpaces15:
; i start address is: 20 (R5)
JAL	_strlen+0
NOP	
ANDI	R3, R5, 255
SEH	R2, R2
SLT	R2, R3, R2
BNE	R2, R0, L__DeleteTrailingSpaces67
NOP	
J	L_DeleteTrailingSpaces16
NOP	
L__DeleteTrailingSpaces67:
;CozyFire_driver.c,159 :: 		str[i] = str[i+1];
ANDI	R2, R5, 255
ADDU	R3, R25, R2
ANDI	R2, R5, 255
ADDIU	R2, R2, 1
SEH	R2, R2
ADDU	R2, R25, R2
LBU	R2, 0(R2)
SB	R2, 0(R3)
;CozyFire_driver.c,158 :: 		for(i = 0; i < strlen(str); i++) {
ADDIU	R2, R5, 1
ANDI	R5, R2, 255
;CozyFire_driver.c,160 :: 		}
; i end address is: 20 (R5)
J	L_DeleteTrailingSpaces15
NOP	
L_DeleteTrailingSpaces16:
;CozyFire_driver.c,161 :: 		}
J	L_DeleteTrailingSpaces18
NOP	
L_DeleteTrailingSpaces14:
;CozyFire_driver.c,163 :: 		break;
J	L_DeleteTrailingSpaces13
NOP	
L_DeleteTrailingSpaces18:
;CozyFire_driver.c,164 :: 		}
J	L_DeleteTrailingSpaces12
NOP	
L_DeleteTrailingSpaces13:
;CozyFire_driver.c,165 :: 		}
L_end_DeleteTrailingSpaces:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _DeleteTrailingSpaces
_DrawScreen:
;CozyFire_driver.c,167 :: 		void DrawScreen(TScreen *aScreen) {
ADDIU	SP, SP, -28
SW	RA, 0(SP)
;CozyFire_driver.c,171 :: 		object_pressed = 0;
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
SB	R0, Offset(_object_pressed+0)(GP)
;CozyFire_driver.c,172 :: 		order = 0;
SH	R0, 24(SP)
;CozyFire_driver.c,173 :: 		CurrentScreen = aScreen;
SW	R25, Offset(_CurrentScreen+0)(GP)
;CozyFire_driver.c,175 :: 		if ((display_width != CurrentScreen->Width) || (display_height != CurrentScreen->Height)) {
ADDIU	R2, R25, 2
LHU	R2, 0(R2)
ANDI	R3, R2, 65535
LHU	R2, Offset(_display_width+0)(GP)
BEQ	R2, R3, L__DrawScreen69
NOP	
J	L__DrawScreen43
NOP	
L__DrawScreen69:
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 4
LHU	R2, 0(R2)
ANDI	R3, R2, 65535
LHU	R2, Offset(_display_height+0)(GP)
BEQ	R2, R3, L__DrawScreen70
NOP	
J	L__DrawScreen42
NOP	
L__DrawScreen70:
J	L_DrawScreen21
NOP	
L__DrawScreen43:
L__DrawScreen42:
;CozyFire_driver.c,176 :: 		save_bled = TFT_BLED;
LBU	R2, Offset(LATA9_bit+1)(GP)
EXT	R2, R2, 1, 1
SB	R2, 26(SP)
;CozyFire_driver.c,177 :: 		save_bled_direction = TFT_BLED_Direction;
LBU	R2, Offset(TRISA9_bit+1)(GP)
EXT	R2, R2, 1, 1
SB	R2, 27(SP)
;CozyFire_driver.c,178 :: 		TFT_BLED_Direction = 0;
LBU	R2, Offset(TRISA9_bit+1)(GP)
INS	R2, R0, 1, 1
SB	R2, Offset(TRISA9_bit+1)(GP)
;CozyFire_driver.c,179 :: 		TFT_BLED           = 0;
LBU	R2, Offset(LATA9_bit+1)(GP)
INS	R2, R0, 1, 1
SB	R2, Offset(LATA9_bit+1)(GP)
;CozyFire_driver.c,180 :: 		TFT_Set_Active(Set_Index, Write_Command, Write_Data);
SW	R25, 20(SP)
LUI	R27, #hi_addr(_Write_Data+0)
ORI	R27, R27, #lo_addr(_Write_Data+0)
LUI	R26, #hi_addr(_Write_Command+0)
ORI	R26, R26, #lo_addr(_Write_Command+0)
LUI	R25, #hi_addr(_Set_Index+0)
ORI	R25, R25, #lo_addr(_Set_Index+0)
JAL	_TFT_Set_Active+0
NOP	
;CozyFire_driver.c,181 :: 		TFT_Init(CurrentScreen->Width, CurrentScreen->Height);
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 4
LHU	R3, 0(R2)
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 2
LHU	R2, 0(R2)
ANDI	R26, R3, 65535
ANDI	R25, R2, 65535
JAL	_TFT_Init+0
NOP	
;CozyFire_driver.c,182 :: 		TFT_Set_Ext_Buffer(TFT_Get_Data);
LUI	R25, #hi_addr(_TFT_Get_Data+0)
ORI	R25, R25, #lo_addr(_TFT_Get_Data+0)
JAL	_TFT_Set_Ext_Buffer+0
NOP	
;CozyFire_driver.c,183 :: 		TP_TFT_Init(CurrentScreen->Width, CurrentScreen->Height, 13, 12);                                  // Initialize touch panel
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 4
LHU	R3, 0(R2)
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 2
LHU	R2, 0(R2)
ORI	R28, R0, 12
ORI	R27, R0, 13
ANDI	R26, R3, 65535
ANDI	R25, R2, 65535
JAL	_TP_TFT_Init+0
NOP	
;CozyFire_driver.c,184 :: 		TP_TFT_Set_ADC_Threshold(ADC_THRESHOLD);                              // Set touch panel ADC threshold
ORI	R25, R0, 1000
JAL	_TP_TFT_Set_ADC_Threshold+0
NOP	
;CozyFire_driver.c,185 :: 		TFT_Fill_Screen(CurrentScreen->Color);
LW	R2, Offset(_CurrentScreen+0)(GP)
LHU	R25, 0(R2)
JAL	_TFT_Fill_Screen+0
NOP	
LW	R25, 20(SP)
;CozyFire_driver.c,186 :: 		display_width = CurrentScreen->Width;
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 2
LHU	R2, 0(R2)
SH	R2, Offset(_display_width+0)(GP)
;CozyFire_driver.c,187 :: 		display_height = CurrentScreen->Height;
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 4
LHU	R2, 0(R2)
SH	R2, Offset(_display_height+0)(GP)
;CozyFire_driver.c,188 :: 		TFT_BLED           = save_bled;
LBU	R3, 26(SP)
LBU	R2, Offset(LATA9_bit+1)(GP)
INS	R2, R3, 1, 1
SB	R2, Offset(LATA9_bit+1)(GP)
;CozyFire_driver.c,189 :: 		TFT_BLED_Direction = save_bled_direction;
LBU	R3, 27(SP)
LBU	R2, Offset(TRISA9_bit+1)(GP)
INS	R2, R3, 1, 1
SB	R2, Offset(TRISA9_bit+1)(GP)
;CozyFire_driver.c,190 :: 		}
J	L_DrawScreen22
NOP	
L_DrawScreen21:
;CozyFire_driver.c,192 :: 		TFT_Fill_Screen(CurrentScreen->Color);
LW	R2, Offset(_CurrentScreen+0)(GP)
LHU	R25, 0(R2)
JAL	_TFT_Fill_Screen+0
NOP	
L_DrawScreen22:
;CozyFire_driver.c,195 :: 		while (order < CurrentScreen->ObjectsCount) {
L_DrawScreen23:
LW	R2, Offset(_CurrentScreen+0)(GP)
ADDIU	R2, R2, 6
LBU	R2, 0(R2)
ANDI	R3, R2, 255
LH	R2, 24(SP)
SLT	R2, R2, R3
BNE	R2, R0, L__DrawScreen71
NOP	
J	L_DrawScreen24
NOP	
L__DrawScreen71:
;CozyFire_driver.c,196 :: 		}
J	L_DrawScreen23
NOP	
L_DrawScreen24:
;CozyFire_driver.c,197 :: 		}
L_end_DrawScreen:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 28
JR	RA
NOP	
; end of _DrawScreen
_Get_Object:
;CozyFire_driver.c,199 :: 		void Get_Object(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,200 :: 		_object_count = -1;
ORI	R2, R0, 65535
SH	R2, Offset(__object_count+0)(GP)
;CozyFire_driver.c,201 :: 		}
L_end_Get_Object:
JR	RA
NOP	
; end of _Get_Object
CozyFire_driver_Process_TP_Press:
;CozyFire_driver.c,204 :: 		static void Process_TP_Press(unsigned int X, unsigned int Y) {
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,206 :: 		Get_Object(X, Y);
JAL	_Get_Object+0
NOP	
;CozyFire_driver.c,209 :: 		if (_object_count != -1) {
LH	R3, Offset(__object_count+0)(GP)
LUI	R2, 65535
ORI	R2, R2, 65535
BNE	R3, R2, L_CozyFire_driver_Process_TP_Press75
NOP	
J	L_CozyFire_driver_Process_TP_Press25
NOP	
L_CozyFire_driver_Process_TP_Press75:
;CozyFire_driver.c,210 :: 		}
L_CozyFire_driver_Process_TP_Press25:
;CozyFire_driver.c,211 :: 		}
L_end_Process_TP_Press:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of CozyFire_driver_Process_TP_Press
CozyFire_driver_Process_TP_Up:
;CozyFire_driver.c,213 :: 		static void Process_TP_Up(unsigned int X, unsigned int Y) {
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,216 :: 		Get_Object(X, Y);
JAL	_Get_Object+0
NOP	
;CozyFire_driver.c,219 :: 		if (_object_count != -1) {
LH	R3, Offset(__object_count+0)(GP)
LUI	R2, 65535
ORI	R2, R2, 65535
BNE	R3, R2, L_CozyFire_driver_Process_TP_Up78
NOP	
J	L_CozyFire_driver_Process_TP_Up26
NOP	
L_CozyFire_driver_Process_TP_Up78:
;CozyFire_driver.c,220 :: 		}
L_CozyFire_driver_Process_TP_Up26:
;CozyFire_driver.c,221 :: 		PressedObject = 0;
SW	R0, Offset(_PressedObject+0)(GP)
;CozyFire_driver.c,222 :: 		PressedObjectType = -1;
ORI	R2, R0, 65535
SH	R2, Offset(_PressedObjectType+0)(GP)
;CozyFire_driver.c,223 :: 		}
L_end_Process_TP_Up:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of CozyFire_driver_Process_TP_Up
CozyFire_driver_Process_TP_Down:
;CozyFire_driver.c,225 :: 		static void Process_TP_Down(unsigned int X, unsigned int Y) {
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;CozyFire_driver.c,227 :: 		object_pressed      = 0;
SB	R0, Offset(_object_pressed+0)(GP)
;CozyFire_driver.c,229 :: 		Get_Object(X, Y);
JAL	_Get_Object+0
NOP	
;CozyFire_driver.c,231 :: 		if (_object_count != -1) {
LH	R3, Offset(__object_count+0)(GP)
LUI	R2, 65535
ORI	R2, R2, 65535
BNE	R3, R2, L_CozyFire_driver_Process_TP_Down81
NOP	
J	L_CozyFire_driver_Process_TP_Down27
NOP	
L_CozyFire_driver_Process_TP_Down81:
;CozyFire_driver.c,232 :: 		}
L_CozyFire_driver_Process_TP_Down27:
;CozyFire_driver.c,233 :: 		}
L_end_Process_TP_Down:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of CozyFire_driver_Process_TP_Down
_Check_TP:
;CozyFire_driver.c,235 :: 		void Check_TP() {
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;CozyFire_driver.c,236 :: 		if (TP_TFT_Press_Detect()) {
SW	R25, 4(SP)
SW	R26, 8(SP)
JAL	_TP_TFT_Press_Detect+0
NOP	
BNE	R2, R0, L__Check_TP84
NOP	
J	L_Check_TP28
NOP	
L__Check_TP84:
;CozyFire_driver.c,238 :: 		if (TP_TFT_Get_Coordinates(&Xcoord, &Ycoord) == 0) {
LUI	R26, #hi_addr(_Ycoord+0)
ORI	R26, R26, #lo_addr(_Ycoord+0)
LUI	R25, #hi_addr(_Xcoord+0)
ORI	R25, R25, #lo_addr(_Xcoord+0)
JAL	_TP_TFT_Get_Coordinates+0
NOP	
ANDI	R2, R2, 255
BEQ	R2, R0, L__Check_TP85
NOP	
J	L_Check_TP29
NOP	
L__Check_TP85:
;CozyFire_driver.c,239 :: 		Process_TP_Press(Xcoord, Ycoord);
LHU	R26, Offset(_Ycoord+0)(GP)
LHU	R25, Offset(_Xcoord+0)(GP)
JAL	CozyFire_driver_Process_TP_Press+0
NOP	
;CozyFire_driver.c,240 :: 		if (PenDown == 0) {
LBU	R2, Offset(_PenDown+0)(GP)
BEQ	R2, R0, L__Check_TP86
NOP	
J	L_Check_TP30
NOP	
L__Check_TP86:
;CozyFire_driver.c,241 :: 		PenDown = 1;
ORI	R2, R0, 1
SB	R2, Offset(_PenDown+0)(GP)
;CozyFire_driver.c,242 :: 		Process_TP_Down(Xcoord, Ycoord);
LHU	R26, Offset(_Ycoord+0)(GP)
LHU	R25, Offset(_Xcoord+0)(GP)
JAL	CozyFire_driver_Process_TP_Down+0
NOP	
;CozyFire_driver.c,243 :: 		}
L_Check_TP30:
;CozyFire_driver.c,244 :: 		}
L_Check_TP29:
;CozyFire_driver.c,245 :: 		}
J	L_Check_TP31
NOP	
L_Check_TP28:
;CozyFire_driver.c,246 :: 		else if (PenDown == 1) {
LBU	R3, Offset(_PenDown+0)(GP)
ORI	R2, R0, 1
BEQ	R3, R2, L__Check_TP87
NOP	
J	L_Check_TP32
NOP	
L__Check_TP87:
;CozyFire_driver.c,247 :: 		PenDown = 0;
SB	R0, Offset(_PenDown+0)(GP)
;CozyFire_driver.c,248 :: 		Process_TP_Up(Xcoord, Ycoord);
LHU	R26, Offset(_Ycoord+0)(GP)
LHU	R25, Offset(_Xcoord+0)(GP)
JAL	CozyFire_driver_Process_TP_Up+0
NOP	
;CozyFire_driver.c,249 :: 		}
L_Check_TP32:
L_Check_TP31:
;CozyFire_driver.c,250 :: 		}
L_end_Check_TP:
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of _Check_TP
_Init_MCU:
;CozyFire_driver.c,252 :: 		void Init_MCU() {
ADDIU	SP, SP, -16
SW	RA, 0(SP)
;CozyFire_driver.c,253 :: 		PMMODE = 0;
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R0, Offset(PMMODE+0)(GP)
;CozyFire_driver.c,254 :: 		PMAEN  = 0;
SW	R0, Offset(PMAEN+0)(GP)
;CozyFire_driver.c,255 :: 		PMCON  = 0;  // WRSP: Write Strobe Polarity bit
SW	R0, Offset(PMCON+0)(GP)
;CozyFire_driver.c,256 :: 		PMMODEbits.MODE = 2;     // Master 2
ORI	R3, R0, 2
LHU	R2, Offset(PMMODEbits+0)(GP)
INS	R2, R3, 8, 2
SH	R2, Offset(PMMODEbits+0)(GP)
;CozyFire_driver.c,257 :: 		PMMODEbits.WAITB = 0;
LBU	R2, Offset(PMMODEbits+0)(GP)
INS	R2, R0, 6, 2
SB	R2, Offset(PMMODEbits+0)(GP)
;CozyFire_driver.c,258 :: 		PMMODEbits.WAITM = 1;
ORI	R3, R0, 1
LBU	R2, Offset(PMMODEbits+0)(GP)
INS	R2, R3, 2, 4
SB	R2, Offset(PMMODEbits+0)(GP)
;CozyFire_driver.c,259 :: 		PMMODEbits.WAITE = 0;
LBU	R2, Offset(PMMODEbits+0)(GP)
INS	R2, R0, 0, 2
SB	R2, Offset(PMMODEbits+0)(GP)
;CozyFire_driver.c,260 :: 		PMMODEbits.MODE16 = 1;   // 16 bit mode
LBU	R2, Offset(PMMODEbits+1)(GP)
ORI	R2, R2, 4
SB	R2, Offset(PMMODEbits+1)(GP)
;CozyFire_driver.c,261 :: 		PMCONbits.CSF = 0;
LBU	R2, Offset(PMCONbits+0)(GP)
INS	R2, R0, 6, 2
SB	R2, Offset(PMCONbits+0)(GP)
;CozyFire_driver.c,262 :: 		PMCONbits.PTRDEN = 1;
LBU	R2, Offset(PMCONbits+1)(GP)
ORI	R2, R2, 1
SB	R2, Offset(PMCONbits+1)(GP)
;CozyFire_driver.c,263 :: 		PMCONbits.PTWREN = 1;
LBU	R2, Offset(PMCONbits+1)(GP)
ORI	R2, R2, 2
SB	R2, Offset(PMCONbits+1)(GP)
;CozyFire_driver.c,264 :: 		PMCONbits.PMPEN = 1;
LBU	R2, Offset(PMCONbits+1)(GP)
ORI	R2, R2, 128
SB	R2, Offset(PMCONbits+1)(GP)
;CozyFire_driver.c,265 :: 		TP_TFT_Rotate_180(0);
MOVZ	R25, R0, R0
JAL	_TP_TFT_Rotate_180+0
NOP	
;CozyFire_driver.c,266 :: 		TFT_Set_Active(Set_Index,Write_Command,Write_Data);
LUI	R27, #hi_addr(_Write_Data+0)
ORI	R27, R27, #lo_addr(_Write_Data+0)
LUI	R26, #hi_addr(_Write_Command+0)
ORI	R26, R26, #lo_addr(_Write_Command+0)
LUI	R25, #hi_addr(_Set_Index+0)
ORI	R25, R25, #lo_addr(_Set_Index+0)
JAL	_TFT_Set_Active+0
NOP	
;CozyFire_driver.c,267 :: 		}
L_end_Init_MCU:
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 16
JR	RA
NOP	
; end of _Init_MCU
_Init_Ext_Mem:
;CozyFire_driver.c,269 :: 		void Init_Ext_Mem() {
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;CozyFire_driver.c,271 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, 64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
MOVZ	R28, R0, R0
ORI	R27, R0, 64
MOVZ	R26, R0, R0
ORI	R25, R0, 32
ADDIU	SP, SP, -8
SH	R0, 4(SP)
ORI	R2, R0, 64
SH	R2, 2(SP)
SH	R0, 0(SP)
JAL	_SPI2_Init_Advanced+0
NOP	
ADDIU	SP, SP, 8
;CozyFire_driver.c,272 :: 		Delay_ms(10);
LUI	R24, 4
ORI	R24, R24, 4522
L_Init_Ext_Mem33:
ADDIU	R24, R24, -1
BNE	R24, R0, L_Init_Ext_Mem33
NOP	
;CozyFire_driver.c,275 :: 		if (!Mmc_Fat_Init()) {
JAL	_Mmc_Fat_Init+0
NOP	
BEQ	R2, R0, L__Init_Ext_Mem90
NOP	
J	L_Init_Ext_Mem35
NOP	
L__Init_Ext_Mem90:
;CozyFire_driver.c,277 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, 4, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
MOVZ	R28, R0, R0
ORI	R27, R0, 4
MOVZ	R26, R0, R0
ORI	R25, R0, 32
ADDIU	SP, SP, -8
SH	R0, 4(SP)
ORI	R2, R0, 64
SH	R2, 2(SP)
SH	R0, 0(SP)
JAL	_SPI2_Init_Advanced+0
NOP	
ADDIU	SP, SP, 8
;CozyFire_driver.c,280 :: 		Mmc_Fat_Assign("CozyFire.RES", 0);
MOVZ	R26, R0, R0
LUI	R25, #hi_addr(?lstr1_CozyFire_driver+0)
ORI	R25, R25, #lo_addr(?lstr1_CozyFire_driver+0)
JAL	_Mmc_Fat_Assign+0
NOP	
;CozyFire_driver.c,281 :: 		Mmc_Fat_Reset(&res_file_size);
LUI	R25, #hi_addr(_res_file_size+0)
ORI	R25, R25, #lo_addr(_res_file_size+0)
JAL	_Mmc_Fat_Reset+0
NOP	
;CozyFire_driver.c,282 :: 		}
L_Init_Ext_Mem35:
;CozyFire_driver.c,283 :: 		}
L_end_Init_Ext_Mem:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _Init_Ext_Mem
_Start_TP:
;CozyFire_driver.c,285 :: 		void Start_TP() {
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;CozyFire_driver.c,286 :: 		Init_MCU();
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
JAL	_Init_MCU+0
NOP	
;CozyFire_driver.c,288 :: 		Init_Ext_Mem();
JAL	_Init_Ext_Mem+0
NOP	
;CozyFire_driver.c,290 :: 		InitializeTouchPanel();
JAL	CozyFire_driver_InitializeTouchPanel+0
NOP	
;CozyFire_driver.c,293 :: 		TP_TFT_Set_Calibration_Consts(76, 907, 77, 915);    // Set calibration constants
ORI	R28, R0, 915
ORI	R27, R0, 77
ORI	R26, R0, 907
ORI	R25, R0, 76
JAL	_TP_TFT_Set_Calibration_Consts+0
NOP	
;CozyFire_driver.c,295 :: 		InitializeObjects();
JAL	CozyFire_driver_InitializeObjects+0
NOP	
;CozyFire_driver.c,296 :: 		display_width = Screen1.Width;
LHU	R2, Offset(_Screen1+2)(GP)
SH	R2, Offset(_display_width+0)(GP)
;CozyFire_driver.c,297 :: 		display_height = Screen1.Height;
LHU	R2, Offset(_Screen1+4)(GP)
SH	R2, Offset(_display_height+0)(GP)
;CozyFire_driver.c,298 :: 		DrawScreen(&Screen1);
LUI	R25, #hi_addr(_Screen1+0)
ORI	R25, R25, #lo_addr(_Screen1+0)
JAL	_DrawScreen+0
NOP	
;CozyFire_driver.c,299 :: 		}
L_end_Start_TP:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _Start_TP
