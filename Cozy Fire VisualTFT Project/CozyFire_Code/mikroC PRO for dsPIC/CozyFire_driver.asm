
_Set_Index:

;CozyFire_driver.c,57 :: 		void Set_Index(unsigned short index) {
;CozyFire_driver.c,58 :: 		TFT_RS = 0;
	BCLR	LATB15_bit, BitPos(LATB15_bit+0)
;CozyFire_driver.c,59 :: 		Lo(LATA) = index;
	MOV	#lo_addr(LATA), W0
	MOV.B	W10, [W0]
;CozyFire_driver.c,60 :: 		TFT_WR = 0;
	BCLR	LATD13_bit, BitPos(LATD13_bit+0)
;CozyFire_driver.c,61 :: 		TFT_WR = 1;
	BSET	LATD13_bit, BitPos(LATD13_bit+0)
;CozyFire_driver.c,62 :: 		}
L_end_Set_Index:
	RETURN
; end of _Set_Index

_Write_Command:

;CozyFire_driver.c,65 :: 		void Write_Command(unsigned short cmd) {
;CozyFire_driver.c,66 :: 		TFT_RS = 1;
	BSET	LATB15_bit, BitPos(LATB15_bit+0)
;CozyFire_driver.c,67 :: 		Lo(LATA) = cmd;
	MOV	#lo_addr(LATA), W0
	MOV.B	W10, [W0]
;CozyFire_driver.c,68 :: 		TFT_WR = 0;
	BCLR	LATD13_bit, BitPos(LATD13_bit+0)
;CozyFire_driver.c,69 :: 		TFT_WR = 1;
	BSET	LATD13_bit, BitPos(LATD13_bit+0)
;CozyFire_driver.c,70 :: 		}
L_end_Write_Command:
	RETURN
; end of _Write_Command

_Write_Data:

;CozyFire_driver.c,73 :: 		void Write_Data(unsigned int _data) {
;CozyFire_driver.c,74 :: 		TFT_RS = 1;
	BSET	LATB15_bit, BitPos(LATB15_bit+0)
;CozyFire_driver.c,75 :: 		Lo(LATE) = Hi(_data);
	MOV	#lo_addr(W10), W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(LATE), W0
	MOV.B	W1, [W0]
;CozyFire_driver.c,76 :: 		Lo(LATA) = Lo(_data);
	MOV	#lo_addr(LATA), W0
	MOV.B	W10, [W0]
;CozyFire_driver.c,77 :: 		TFT_WR = 0;
	BCLR	LATD13_bit, BitPos(LATD13_bit+0)
;CozyFire_driver.c,78 :: 		TFT_WR = 1;
	BSET	LATD13_bit, BitPos(LATD13_bit+0)
;CozyFire_driver.c,79 :: 		}
L_end_Write_Data:
	RETURN
; end of _Write_Data

_Init_ADC:

;CozyFire_driver.c,82 :: 		void Init_ADC() {
;CozyFire_driver.c,83 :: 		AD1PCFGL = 0xCFFF;
	MOV	#53247, W0
	MOV	WREG, AD1PCFGL
;CozyFire_driver.c,84 :: 		AD1PCFGH = 0xCFFF;
	MOV	#53247, W0
	MOV	WREG, AD1PCFGH
;CozyFire_driver.c,85 :: 		ADC1_Init();
	CALL	_ADC1_Init
;CozyFire_driver.c,86 :: 		}
L_end_Init_ADC:
	RETURN
; end of _Init_ADC

_TFT_Get_Data:
	LNK	#6

;CozyFire_driver.c,88 :: 		char* TFT_Get_Data(unsigned long offset, unsigned int count, unsigned int *num) {
;CozyFire_driver.c,92 :: 		start_sector = Mmc_Get_File_Write_Sector() + offset/512;
	PUSH	W10
	PUSH	W11
	CALL	_Mmc_Get_File_Write_Sector
	MOV	#9, W4
	MOV.D	W10, W2
L__TFT_Get_Data55:
	DEC	W4, W4
	BRA LT	L__TFT_Get_Data56
	LSR	W3, W3
	RRC	W2, W2
	BRA	L__TFT_Get_Data55
L__TFT_Get_Data56:
	ADD	W0, W2, W2
	ADDC	W1, W3, W3
	MOV	W2, [W14+0]
	MOV	W3, [W14+2]
;CozyFire_driver.c,93 :: 		pos = (unsigned long)offset%512;
	MOV	#511, W0
	MOV	#0, W1
	AND	W10, W0, W0
	AND	W11, W1, W1
	MOV	W0, [W14+4]
;CozyFire_driver.c,95 :: 		if(start_sector == currentSector+1) {
	MOV	_currentSector, W0
	MOV	_currentSector+2, W1
	ADD	W0, #1, W0
	ADDC	W1, #0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__TFT_Get_Data57
	GOTO	L_TFT_Get_Data0
L__TFT_Get_Data57:
;CozyFire_driver.c,96 :: 		Mmc_Multi_Read_Sector(f16_sector.fSect);
	PUSH.D	W12
	MOV	#lo_addr(_f16_sector), W10
	CALL	_Mmc_Multi_Read_Sector
	POP.D	W12
;CozyFire_driver.c,97 :: 		currentSector = start_sector;
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	MOV	W0, _currentSector
	MOV	W1, _currentSector+2
;CozyFire_driver.c,98 :: 		} else if (start_sector != currentSector) {
	GOTO	L_TFT_Get_Data1
L_TFT_Get_Data0:
	MOV	[W14+0], W1
	MOV	[W14+2], W2
	MOV	#lo_addr(_currentSector), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA NZ	L__TFT_Get_Data58
	GOTO	L_TFT_Get_Data2
L__TFT_Get_Data58:
;CozyFire_driver.c,99 :: 		if(currentSector != -1)
	MOV	#65535, W1
	MOV	#65535, W2
	MOV	#lo_addr(_currentSector), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA NZ	L__TFT_Get_Data59
	GOTO	L_TFT_Get_Data3
L__TFT_Get_Data59:
;CozyFire_driver.c,100 :: 		Mmc_Multi_Read_Stop();
	PUSH.D	W12
	CALL	_Mmc_Multi_Read_Stop
	POP.D	W12
L_TFT_Get_Data3:
;CozyFire_driver.c,101 :: 		Mmc_Multi_Read_Start(start_sector);
	PUSH.D	W12
	MOV	[W14+0], W10
	MOV	[W14+2], W11
	CALL	_Mmc_Multi_Read_Start
;CozyFire_driver.c,102 :: 		Mmc_Multi_Read_Sector(f16_sector.fSect);
	MOV	#lo_addr(_f16_sector), W10
	CALL	_Mmc_Multi_Read_Sector
	POP.D	W12
;CozyFire_driver.c,103 :: 		currentSector = start_sector;
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	MOV	W0, _currentSector
	MOV	W1, _currentSector+2
;CozyFire_driver.c,104 :: 		}
L_TFT_Get_Data2:
L_TFT_Get_Data1:
;CozyFire_driver.c,106 :: 		if(count>512-pos)
	MOV	#512, W1
	ADD	W14, #4, W0
	SUB	W1, [W0], W0
	CP	W12, W0
	BRA GTU	L__TFT_Get_Data60
	GOTO	L_TFT_Get_Data4
L__TFT_Get_Data60:
;CozyFire_driver.c,107 :: 		*num = 512-pos;
	MOV	#512, W1
	ADD	W14, #4, W0
	SUB	W1, [W0], W0
	MOV	W0, [W13]
	GOTO	L_TFT_Get_Data5
L_TFT_Get_Data4:
;CozyFire_driver.c,109 :: 		*num = count;
	MOV	W12, [W13]
L_TFT_Get_Data5:
;CozyFire_driver.c,111 :: 		return f16_sector.fSect+pos;
	MOV	#lo_addr(_f16_sector), W1
	ADD	W14, #4, W0
	ADD	W1, [W0], W0
;CozyFire_driver.c,112 :: 		}
;CozyFire_driver.c,111 :: 		return f16_sector.fSect+pos;
;CozyFire_driver.c,112 :: 		}
L_end_TFT_Get_Data:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _TFT_Get_Data

CozyFire_driver_InitializeTouchPanel:

;CozyFire_driver.c,113 :: 		static void InitializeTouchPanel() {
;CozyFire_driver.c,114 :: 		Init_ADC();
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CALL	_Init_ADC
;CozyFire_driver.c,115 :: 		TFT_Set_Active(Set_Index, Write_Command, Write_Data);
	MOV	#lo_addr(_Write_Data), W12
	MOV	#lo_addr(_Write_Command), W11
	MOV	#lo_addr(_Set_Index), W10
	CALL	_TFT_Set_Active
;CozyFire_driver.c,116 :: 		TFT_Init(320, 240);
	MOV	#240, W11
	MOV	#320, W10
	CALL	_TFT_Init
;CozyFire_driver.c,117 :: 		TFT_Set_Ext_Buffer(TFT_Get_Data);
	MOV	#lo_addr(_TFT_Get_Data), W10
	CALL	_TFT_Set_Ext_Buffer
;CozyFire_driver.c,119 :: 		TP_TFT_Init(320, 240, 13, 12);                                  // Initialize touch panel
	MOV.B	#12, W13
	MOV.B	#13, W12
	MOV	#240, W11
	MOV	#320, W10
	CALL	_TP_TFT_Init
;CozyFire_driver.c,120 :: 		TP_TFT_Set_ADC_Threshold(ADC_THRESHOLD);                              // Set touch panel ADC threshold
	MOV	#800, W10
	CALL	_TP_TFT_Set_ADC_Threshold
;CozyFire_driver.c,122 :: 		PenDown = 0;
	MOV	#lo_addr(_PenDown), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,123 :: 		PressedObject = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _PressedObject
	MOV	W1, _PressedObject+2
;CozyFire_driver.c,124 :: 		PressedObjectType = -1;
	MOV	#65535, W0
	MOV	W0, _PressedObjectType
;CozyFire_driver.c,125 :: 		}
L_end_InitializeTouchPanel:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of CozyFire_driver_InitializeTouchPanel

_Calibrate:

;CozyFire_driver.c,127 :: 		void Calibrate() {
;CozyFire_driver.c,128 :: 		TFT_Set_Pen(CL_WHITE, 3);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#3, W11
	MOV	#65535, W10
	CALL	_TFT_Set_Pen
;CozyFire_driver.c,129 :: 		TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
	CLR	W13
	MOV	#65535, W12
	MOV	#lo_addr(_TFT_defaultFont), W10
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, W11
	CALL	_TFT_Set_Font
;CozyFire_driver.c,130 :: 		TFT_Write_Text("Touch selected corners for calibration", 50, 100);
	MOV	#100, W12
	MOV	#50, W11
	MOV	#lo_addr(?lstr1_CozyFire_driver), W10
	CALL	_TFT_Write_Text
;CozyFire_driver.c,131 :: 		TFT_Line(315, 1, 319, 1);
	MOV	#1, W13
	MOV	#319, W12
	MOV	#1, W11
	MOV	#315, W10
	CALL	_TFT_Line
;CozyFire_driver.c,132 :: 		TFT_Line(310, 10, 319, 1);
	MOV	#1, W13
	MOV	#319, W12
	MOV	#10, W11
	MOV	#310, W10
	CALL	_TFT_Line
;CozyFire_driver.c,133 :: 		TFT_Line(319, 5, 319, 1);
	MOV	#1, W13
	MOV	#319, W12
	MOV	#5, W11
	MOV	#319, W10
	CALL	_TFT_Line
;CozyFire_driver.c,134 :: 		TFT_Write_Text("first here", 250, 20);
	MOV	#20, W12
	MOV	#250, W11
	MOV	#lo_addr(?lstr2_CozyFire_driver), W10
	CALL	_TFT_Write_Text
;CozyFire_driver.c,136 :: 		TP_TFT_Calibrate_Min();                      // Calibration of bottom left corner
	CALL	_TP_TFT_Calibrate_Min
;CozyFire_driver.c,137 :: 		Delay_ms(500);
	MOV	#102, W8
	MOV	#47563, W7
L_Calibrate6:
	DEC	W7
	BRA NZ	L_Calibrate6
	DEC	W8
	BRA NZ	L_Calibrate6
	NOP
;CozyFire_driver.c,139 :: 		TFT_Set_Pen(CL_BLACK, 3);
	MOV	#3, W11
	CLR	W10
	CALL	_TFT_Set_Pen
;CozyFire_driver.c,140 :: 		TFT_Set_Font(TFT_defaultFont, CL_BLACK, FO_HORIZONTAL);
	CLR	W13
	CLR	W12
	MOV	#lo_addr(_TFT_defaultFont), W10
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, W11
	CALL	_TFT_Set_Font
;CozyFire_driver.c,141 :: 		TFT_Line(315, 1, 319, 1);
	MOV	#1, W13
	MOV	#319, W12
	MOV	#1, W11
	MOV	#315, W10
	CALL	_TFT_Line
;CozyFire_driver.c,142 :: 		TFT_Line(310, 10, 319, 1);
	MOV	#1, W13
	MOV	#319, W12
	MOV	#10, W11
	MOV	#310, W10
	CALL	_TFT_Line
;CozyFire_driver.c,143 :: 		TFT_Line(319, 5, 319, 1);
	MOV	#1, W13
	MOV	#319, W12
	MOV	#5, W11
	MOV	#319, W10
	CALL	_TFT_Line
;CozyFire_driver.c,144 :: 		TFT_Write_Text("first here", 250, 20);
	MOV	#20, W12
	MOV	#250, W11
	MOV	#lo_addr(?lstr3_CozyFire_driver), W10
	CALL	_TFT_Write_Text
;CozyFire_driver.c,146 :: 		TFT_Set_Pen(CL_WHITE, 3);
	MOV	#3, W11
	MOV	#65535, W10
	CALL	_TFT_Set_Pen
;CozyFire_driver.c,147 :: 		TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
	CLR	W13
	MOV	#65535, W12
	MOV	#lo_addr(_TFT_defaultFont), W10
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, W11
	CALL	_TFT_Set_Font
;CozyFire_driver.c,148 :: 		TFT_Line(0, 239, 0, 235);
	MOV	#235, W13
	CLR	W12
	MOV	#239, W11
	CLR	W10
	CALL	_TFT_Line
;CozyFire_driver.c,149 :: 		TFT_Line(0, 239, 5, 239);
	MOV	#239, W13
	MOV	#5, W12
	MOV	#239, W11
	CLR	W10
	CALL	_TFT_Line
;CozyFire_driver.c,150 :: 		TFT_Line(0, 239, 10, 229);
	MOV	#229, W13
	MOV	#10, W12
	MOV	#239, W11
	CLR	W10
	CALL	_TFT_Line
;CozyFire_driver.c,151 :: 		TFT_Write_Text("now here ", 15, 200);
	MOV	#200, W12
	MOV	#15, W11
	MOV	#lo_addr(?lstr4_CozyFire_driver), W10
	CALL	_TFT_Write_Text
;CozyFire_driver.c,153 :: 		TP_TFT_Calibrate_Max();                      // Calibration of bottom left corner
	CALL	_TP_TFT_Calibrate_Max
;CozyFire_driver.c,154 :: 		Delay_ms(500);
	MOV	#102, W8
	MOV	#47563, W7
L_Calibrate8:
	DEC	W7
	BRA NZ	L_Calibrate8
	DEC	W8
	BRA NZ	L_Calibrate8
	NOP
;CozyFire_driver.c,155 :: 		}
L_end_Calibrate:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Calibrate

CozyFire_driver_InitializeObjects:

;CozyFire_driver.c,166 :: 		static void InitializeObjects() {
;CozyFire_driver.c,167 :: 		Screen1.Color                     = 0x0000;
	CLR	W0
	MOV	W0, _Screen1
;CozyFire_driver.c,168 :: 		Screen1.Width                     = 320;
	MOV	#320, W0
	MOV	W0, _Screen1+2
;CozyFire_driver.c,169 :: 		Screen1.Height                    = 240;
	MOV	#240, W0
	MOV	W0, _Screen1+4
;CozyFire_driver.c,170 :: 		Screen1.ObjectsCount              = 0;
	MOV	#lo_addr(_Screen1+6), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,172 :: 		}
L_end_InitializeObjects:
	RETURN
; end of CozyFire_driver_InitializeObjects

CozyFire_driver_IsInsideObject:
	LNK	#0

;CozyFire_driver.c,174 :: 		static char IsInsideObject (unsigned int X, unsigned int Y, unsigned int Left, unsigned int Top, unsigned int Width, unsigned int Height) { // static
;CozyFire_driver.c,175 :: 		if ( (Left<= X) && (Left+ Width - 1 >= X) &&
; Width start address is: 2 (W1)
	MOV	[W14-8], W1
; Height start address is: 4 (W2)
	MOV	[W14-10], W2
	CP	W12, W10
	BRA LEU	L_CozyFire_driver_IsInsideObject65
	GOTO	L_CozyFire_driver_IsInsideObject46
L_CozyFire_driver_IsInsideObject65:
	ADD	W12, W1, W0
; Width end address is: 2 (W1)
	DEC	W0
	CP	W0, W10
	BRA GEU	L_CozyFire_driver_IsInsideObject66
	GOTO	L_CozyFire_driver_IsInsideObject45
L_CozyFire_driver_IsInsideObject66:
;CozyFire_driver.c,176 :: 		(Top <= Y)  && (Top + Height - 1 >= Y) )
	CP	W13, W11
	BRA LEU	L_CozyFire_driver_IsInsideObject67
	GOTO	L_CozyFire_driver_IsInsideObject44
L_CozyFire_driver_IsInsideObject67:
	ADD	W13, W2, W0
; Height end address is: 4 (W2)
	DEC	W0
	CP	W0, W11
	BRA GEU	L_CozyFire_driver_IsInsideObject68
	GOTO	L_CozyFire_driver_IsInsideObject43
L_CozyFire_driver_IsInsideObject68:
L_CozyFire_driver_IsInsideObject42:
;CozyFire_driver.c,177 :: 		return 1;
	MOV.B	#1, W0
	GOTO	L_end_IsInsideObject
;CozyFire_driver.c,175 :: 		if ( (Left<= X) && (Left+ Width - 1 >= X) &&
L_CozyFire_driver_IsInsideObject46:
L_CozyFire_driver_IsInsideObject45:
;CozyFire_driver.c,176 :: 		(Top <= Y)  && (Top + Height - 1 >= Y) )
L_CozyFire_driver_IsInsideObject44:
L_CozyFire_driver_IsInsideObject43:
;CozyFire_driver.c,179 :: 		return 0;
	CLR	W0
;CozyFire_driver.c,180 :: 		}
L_end_IsInsideObject:
	ULNK
	RETURN
; end of CozyFire_driver_IsInsideObject

_DeleteTrailingSpaces:

;CozyFire_driver.c,184 :: 		void DeleteTrailingSpaces(char* str){
;CozyFire_driver.c,187 :: 		while(1) {
L_DeleteTrailingSpaces14:
;CozyFire_driver.c,188 :: 		if(str[0] == ' ') {
	MOV.B	[W10], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA Z	L__DeleteTrailingSpaces70
	GOTO	L_DeleteTrailingSpaces16
L__DeleteTrailingSpaces70:
;CozyFire_driver.c,189 :: 		for(i = 0; i < strlen(str); i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_DeleteTrailingSpaces17:
; i start address is: 4 (W2)
	CALL	_strlen
	ZE	W2, W1
	CP	W1, W0
	BRA LT	L__DeleteTrailingSpaces71
	GOTO	L_DeleteTrailingSpaces18
L__DeleteTrailingSpaces71:
;CozyFire_driver.c,190 :: 		str[i] = str[i+1];
	ZE	W2, W0
	ADD	W10, W0, W1
	ZE	W2, W0
	INC	W0
	ADD	W10, W0, W0
	MOV.B	[W0], [W1]
;CozyFire_driver.c,189 :: 		for(i = 0; i < strlen(str); i++) {
	INC.B	W2
;CozyFire_driver.c,191 :: 		}
; i end address is: 4 (W2)
	GOTO	L_DeleteTrailingSpaces17
L_DeleteTrailingSpaces18:
;CozyFire_driver.c,192 :: 		}
	GOTO	L_DeleteTrailingSpaces20
L_DeleteTrailingSpaces16:
;CozyFire_driver.c,194 :: 		break;
	GOTO	L_DeleteTrailingSpaces15
L_DeleteTrailingSpaces20:
;CozyFire_driver.c,195 :: 		}
	GOTO	L_DeleteTrailingSpaces14
L_DeleteTrailingSpaces15:
;CozyFire_driver.c,196 :: 		}
L_end_DeleteTrailingSpaces:
	RETURN
; end of _DeleteTrailingSpaces

_DrawScreen:
	LNK	#4

;CozyFire_driver.c,198 :: 		void DrawScreen(TScreen *aScreen) {
;CozyFire_driver.c,202 :: 		object_pressed = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#lo_addr(_object_pressed), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,203 :: 		order = 0;
	CLR	W0
	MOV	W0, [W14+0]
;CozyFire_driver.c,204 :: 		CurrentScreen = aScreen;
	MOV	W10, _CurrentScreen
;CozyFire_driver.c,206 :: 		if ((display_width != CurrentScreen->Width) || (display_height != CurrentScreen->Height)) {
	ADD	W10, #2, W0
	MOV	[W0], W1
	MOV	#lo_addr(_display_width), W0
	CP	W1, [W0]
	BRA Z	L__DrawScreen73
	GOTO	L__DrawScreen49
L__DrawScreen73:
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W0
	MOV	[W0], W1
	MOV	#lo_addr(_display_height), W0
	CP	W1, [W0]
	BRA Z	L__DrawScreen74
	GOTO	L__DrawScreen48
L__DrawScreen74:
	GOTO	L_DrawScreen23
L__DrawScreen49:
L__DrawScreen48:
;CozyFire_driver.c,207 :: 		save_bled = TFT_BLED;
	ADD	W14, #2, W0
	CLR.B	[W0]
	BTSC	LATD7_bit, BitPos(LATD7_bit+0)
	INC.B	[W0], [W0]
;CozyFire_driver.c,208 :: 		save_bled_direction = TFT_BLED_Direction;
	ADD	W14, #3, W0
	CLR.B	[W0]
	BTSC	TRISD7_bit, BitPos(TRISD7_bit+0)
	INC.B	[W0], [W0]
;CozyFire_driver.c,209 :: 		TFT_BLED_Direction = 0;
	BCLR	TRISD7_bit, BitPos(TRISD7_bit+0)
;CozyFire_driver.c,210 :: 		TFT_BLED           = 0;
	BCLR	LATD7_bit, BitPos(LATD7_bit+0)
;CozyFire_driver.c,211 :: 		TFT_Set_Active(Set_Index, Write_Command, Write_Data);
	PUSH	W10
	MOV	#lo_addr(_Write_Data), W12
	MOV	#lo_addr(_Write_Command), W11
	MOV	#lo_addr(_Set_Index), W10
	CALL	_TFT_Set_Active
;CozyFire_driver.c,212 :: 		TFT_Init(CurrentScreen->Width, CurrentScreen->Height);
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W1
	MOV	_CurrentScreen, W0
	INC2	W0
	MOV	[W1], W11
	MOV	[W0], W10
	CALL	_TFT_Init
;CozyFire_driver.c,213 :: 		TFT_Set_Ext_Buffer(TFT_Get_Data);
	MOV	#lo_addr(_TFT_Get_Data), W10
	CALL	_TFT_Set_Ext_Buffer
;CozyFire_driver.c,214 :: 		TP_TFT_Init(CurrentScreen->Width, CurrentScreen->Height, 13, 12);                                  // Initialize touch panel
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W1
	MOV	_CurrentScreen, W0
	INC2	W0
	MOV.B	#12, W13
	MOV.B	#13, W12
	MOV	[W1], W11
	MOV	[W0], W10
	CALL	_TP_TFT_Init
;CozyFire_driver.c,215 :: 		TP_TFT_Set_ADC_Threshold(ADC_THRESHOLD);                              // Set touch panel ADC threshold
	MOV	#800, W10
	CALL	_TP_TFT_Set_ADC_Threshold
;CozyFire_driver.c,216 :: 		TFT_Fill_Screen(CurrentScreen->Color);
	MOV	_CurrentScreen, W0
	MOV	[W0], W10
	CALL	_TFT_Fill_Screen
	POP	W10
;CozyFire_driver.c,217 :: 		display_width = CurrentScreen->Width;
	MOV	_CurrentScreen, W0
	INC2	W0
	MOV	[W0], W0
	MOV	W0, _display_width
;CozyFire_driver.c,218 :: 		display_height = CurrentScreen->Height;
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W0
	MOV	[W0], W0
	MOV	W0, _display_height
;CozyFire_driver.c,219 :: 		TFT_BLED           = save_bled;
	ADD	W14, #2, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	BCLR	LATD7_bit, BitPos(LATD7_bit+0)
	BTSC	W0, #0
	BSET	LATD7_bit, BitPos(LATD7_bit+0)
;CozyFire_driver.c,220 :: 		TFT_BLED_Direction = save_bled_direction;
	ADD	W14, #3, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	BCLR	TRISD7_bit, BitPos(TRISD7_bit+0)
	BTSC	W0, #0
	BSET	TRISD7_bit, BitPos(TRISD7_bit+0)
;CozyFire_driver.c,221 :: 		}
	GOTO	L_DrawScreen24
L_DrawScreen23:
;CozyFire_driver.c,223 :: 		TFT_Fill_Screen(CurrentScreen->Color);
	MOV	_CurrentScreen, W0
	MOV	[W0], W10
	CALL	_TFT_Fill_Screen
L_DrawScreen24:
;CozyFire_driver.c,226 :: 		while (order < CurrentScreen->ObjectsCount) {
L_DrawScreen25:
	MOV	_CurrentScreen, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GT	L__DrawScreen75
	GOTO	L_DrawScreen26
L__DrawScreen75:
;CozyFire_driver.c,227 :: 		}
	GOTO	L_DrawScreen25
L_DrawScreen26:
;CozyFire_driver.c,228 :: 		}
L_end_DrawScreen:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _DrawScreen

_Get_Object:

;CozyFire_driver.c,230 :: 		void Get_Object(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,231 :: 		_object_count = -1;
	MOV	#65535, W0
	MOV	W0, __object_count
;CozyFire_driver.c,232 :: 		}
L_end_Get_Object:
	RETURN
; end of _Get_Object

CozyFire_driver_Process_TP_Press:

;CozyFire_driver.c,235 :: 		static void Process_TP_Press(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,237 :: 		Get_Object(X, Y);
	CALL	_Get_Object
;CozyFire_driver.c,240 :: 		if (_object_count != -1) {
	MOV	#65535, W1
	MOV	#lo_addr(__object_count), W0
	CP	W1, [W0]
	BRA NZ	L_CozyFire_driver_Process_TP_Press78
	GOTO	L_CozyFire_driver_Process_TP_Press27
L_CozyFire_driver_Process_TP_Press78:
;CozyFire_driver.c,241 :: 		}
L_CozyFire_driver_Process_TP_Press27:
;CozyFire_driver.c,242 :: 		}
L_end_Process_TP_Press:
	RETURN
; end of CozyFire_driver_Process_TP_Press

CozyFire_driver_Process_TP_Up:

;CozyFire_driver.c,244 :: 		static void Process_TP_Up(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,247 :: 		Get_Object(X, Y);
	CALL	_Get_Object
;CozyFire_driver.c,250 :: 		if (_object_count != -1) {
	MOV	#65535, W1
	MOV	#lo_addr(__object_count), W0
	CP	W1, [W0]
	BRA NZ	L_CozyFire_driver_Process_TP_Up80
	GOTO	L_CozyFire_driver_Process_TP_Up28
L_CozyFire_driver_Process_TP_Up80:
;CozyFire_driver.c,251 :: 		}
L_CozyFire_driver_Process_TP_Up28:
;CozyFire_driver.c,252 :: 		PressedObject = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _PressedObject
	MOV	W1, _PressedObject+2
;CozyFire_driver.c,253 :: 		PressedObjectType = -1;
	MOV	#65535, W0
	MOV	W0, _PressedObjectType
;CozyFire_driver.c,254 :: 		}
L_end_Process_TP_Up:
	RETURN
; end of CozyFire_driver_Process_TP_Up

CozyFire_driver_Process_TP_Down:

;CozyFire_driver.c,256 :: 		static void Process_TP_Down(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,258 :: 		object_pressed      = 0;
	MOV	#lo_addr(_object_pressed), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,260 :: 		Get_Object(X, Y);
	CALL	_Get_Object
;CozyFire_driver.c,262 :: 		if (_object_count != -1) {
	MOV	#65535, W1
	MOV	#lo_addr(__object_count), W0
	CP	W1, [W0]
	BRA NZ	L_CozyFire_driver_Process_TP_Down82
	GOTO	L_CozyFire_driver_Process_TP_Down29
L_CozyFire_driver_Process_TP_Down82:
;CozyFire_driver.c,263 :: 		}
L_CozyFire_driver_Process_TP_Down29:
;CozyFire_driver.c,264 :: 		}
L_end_Process_TP_Down:
	RETURN
; end of CozyFire_driver_Process_TP_Down

_Check_TP:

;CozyFire_driver.c,266 :: 		void Check_TP() {
;CozyFire_driver.c,267 :: 		if (TP_TFT_Press_Detect()) {
	PUSH	W10
	PUSH	W11
	CALL	_TP_TFT_Press_Detect
	CP0.B	W0
	BRA NZ	L__Check_TP84
	GOTO	L_Check_TP30
L__Check_TP84:
;CozyFire_driver.c,269 :: 		if (TP_TFT_Get_Coordinates(&Xcoord, &Ycoord) == 0) {
	MOV	#lo_addr(_Ycoord), W11
	MOV	#lo_addr(_Xcoord), W10
	CALL	_TP_TFT_Get_Coordinates
	CP.B	W0, #0
	BRA Z	L__Check_TP85
	GOTO	L_Check_TP31
L__Check_TP85:
;CozyFire_driver.c,270 :: 		Process_TP_Press(Xcoord, Ycoord);
	MOV	_Ycoord, W11
	MOV	_Xcoord, W10
	CALL	CozyFire_driver_Process_TP_Press
;CozyFire_driver.c,271 :: 		if (PenDown == 0) {
	MOV	#lo_addr(_PenDown), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Check_TP86
	GOTO	L_Check_TP32
L__Check_TP86:
;CozyFire_driver.c,272 :: 		PenDown = 1;
	MOV	#lo_addr(_PenDown), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,273 :: 		Process_TP_Down(Xcoord, Ycoord);
	MOV	_Ycoord, W11
	MOV	_Xcoord, W10
	CALL	CozyFire_driver_Process_TP_Down
;CozyFire_driver.c,274 :: 		}
L_Check_TP32:
;CozyFire_driver.c,275 :: 		}
L_Check_TP31:
;CozyFire_driver.c,276 :: 		}
	GOTO	L_Check_TP33
L_Check_TP30:
;CozyFire_driver.c,277 :: 		else if (PenDown == 1) {
	MOV	#lo_addr(_PenDown), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Check_TP87
	GOTO	L_Check_TP34
L__Check_TP87:
;CozyFire_driver.c,278 :: 		PenDown = 0;
	MOV	#lo_addr(_PenDown), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,279 :: 		Process_TP_Up(Xcoord, Ycoord);
	MOV	_Ycoord, W11
	MOV	_Xcoord, W10
	CALL	CozyFire_driver_Process_TP_Up
;CozyFire_driver.c,280 :: 		}
L_Check_TP34:
L_Check_TP33:
;CozyFire_driver.c,281 :: 		}
L_end_Check_TP:
	POP	W11
	POP	W10
	RETURN
; end of _Check_TP

_Init_MCU:

;CozyFire_driver.c,283 :: 		void Init_MCU() {
;CozyFire_driver.c,284 :: 		TRISE = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CLR	TRISE
;CozyFire_driver.c,285 :: 		TFT_DataPort_Direction = 0;
	CLR.B	TRISA
;CozyFire_driver.c,286 :: 		CLKDIVbits.PLLPRE = 0;      // PLLPRE<4:0> = 0  ->  N1 = 2    8MHz / 2 = 4MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;CozyFire_driver.c,288 :: 		PLLFBD =   38;              // PLLDIV<8:0> = 38 ->  M = 40    4MHz * 40 = 160MHz
	MOV	#38, W0
	MOV	WREG, PLLFBD
;CozyFire_driver.c,290 :: 		CLKDIVbits.PLLPOST = 0;     // PLLPOST<1:0> = 0 ->  N2 = 2    160MHz / 2 = 80MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;CozyFire_driver.c,292 :: 		Delay_ms(150);
	MOV	#31, W8
	MOV	#33929, W7
L_Init_MCU35:
	DEC	W7
	BRA NZ	L_Init_MCU35
	DEC	W8
	BRA NZ	L_Init_MCU35
;CozyFire_driver.c,293 :: 		TP_TFT_Rotate_180(0);
	CLR	W10
	CALL	_TP_TFT_Rotate_180
;CozyFire_driver.c,294 :: 		TFT_Set_Active(Set_Index,Write_Command,Write_Data);
	MOV	#lo_addr(_Write_Data), W12
	MOV	#lo_addr(_Write_Command), W11
	MOV	#lo_addr(_Set_Index), W10
	CALL	_TFT_Set_Active
;CozyFire_driver.c,295 :: 		}
L_end_Init_MCU:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Init_MCU

_Init_Ext_Mem:

;CozyFire_driver.c,297 :: 		void Init_Ext_Mem() {
;CozyFire_driver.c,299 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64,
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
;CozyFire_driver.c,300 :: 		_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
	MOV	#256, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;CozyFire_driver.c,301 :: 		Delay_ms(10);
	MOV	#3, W8
	MOV	#2261, W7
L_Init_Ext_Mem37:
	DEC	W7
	BRA NZ	L_Init_Ext_Mem37
	DEC	W8
	BRA NZ	L_Init_Ext_Mem37
;CozyFire_driver.c,304 :: 		if (!Mmc_Fat_Init()) {
	CALL	_Mmc_Fat_Init
	CP0.B	W0
	BRA Z	L__Init_Ext_Mem90
	GOTO	L_Init_Ext_Mem39
L__Init_Ext_Mem90:
;CozyFire_driver.c,306 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_4,
	MOV	#2, W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
;CozyFire_driver.c,307 :: 		_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
	MOV	#256, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;CozyFire_driver.c,310 :: 		Mmc_Fat_Assign("CozyFire.RES", 0);
	CLR	W11
	MOV	#lo_addr(?lstr5_CozyFire_driver), W10
	CALL	_Mmc_Fat_Assign
;CozyFire_driver.c,311 :: 		Mmc_Fat_Reset(&res_file_size);
	MOV	#lo_addr(_res_file_size), W10
	CALL	_Mmc_Fat_Reset
;CozyFire_driver.c,312 :: 		}
L_Init_Ext_Mem39:
;CozyFire_driver.c,313 :: 		}
L_end_Init_Ext_Mem:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Init_Ext_Mem

_Start_TP:

;CozyFire_driver.c,315 :: 		void Start_TP() {
;CozyFire_driver.c,316 :: 		Init_MCU();
	PUSH	W10
	CALL	_Init_MCU
;CozyFire_driver.c,318 :: 		Init_Ext_Mem();
	CALL	_Init_Ext_Mem
;CozyFire_driver.c,320 :: 		InitializeTouchPanel();
	CALL	CozyFire_driver_InitializeTouchPanel
;CozyFire_driver.c,322 :: 		Delay_ms(1000);
	MOV	#204, W8
	MOV	#29592, W7
L_Start_TP40:
	DEC	W7
	BRA NZ	L_Start_TP40
	DEC	W8
	BRA NZ	L_Start_TP40
;CozyFire_driver.c,323 :: 		TFT_Fill_Screen(0);
	CLR	W10
	CALL	_TFT_Fill_Screen
;CozyFire_driver.c,324 :: 		Calibrate();
	CALL	_Calibrate
;CozyFire_driver.c,325 :: 		TFT_Fill_Screen(0);
	CLR	W10
	CALL	_TFT_Fill_Screen
;CozyFire_driver.c,327 :: 		InitializeObjects();
	CALL	CozyFire_driver_InitializeObjects
;CozyFire_driver.c,328 :: 		display_width = Screen1.Width;
	MOV	_Screen1+2, W0
	MOV	W0, _display_width
;CozyFire_driver.c,329 :: 		display_height = Screen1.Height;
	MOV	_Screen1+4, W0
	MOV	W0, _display_height
;CozyFire_driver.c,330 :: 		DrawScreen(&Screen1);
	MOV	#lo_addr(_Screen1), W10
	CALL	_DrawScreen
;CozyFire_driver.c,331 :: 		}
L_end_Start_TP:
	POP	W10
	RETURN
; end of _Start_TP
