
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
L__TFT_Get_Data49:
	DEC	W4, W4
	BRA LT	L__TFT_Get_Data50
	LSR	W3, W3
	RRC	W2, W2
	BRA	L__TFT_Get_Data49
L__TFT_Get_Data50:
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
	BRA Z	L__TFT_Get_Data51
	GOTO	L_TFT_Get_Data0
L__TFT_Get_Data51:
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
	BRA NZ	L__TFT_Get_Data52
	GOTO	L_TFT_Get_Data2
L__TFT_Get_Data52:
;CozyFire_driver.c,99 :: 		if(currentSector != -1)
	MOV	#65535, W1
	MOV	#65535, W2
	MOV	#lo_addr(_currentSector), W0
	CP	W1, [W0++]
	CPB	W2, [W0--]
	BRA NZ	L__TFT_Get_Data53
	GOTO	L_TFT_Get_Data3
L__TFT_Get_Data53:
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
	BRA GTU	L__TFT_Get_Data54
	GOTO	L_TFT_Get_Data4
L__TFT_Get_Data54:
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

CozyFire_driver_InitializeObjects:

;CozyFire_driver.c,136 :: 		static void InitializeObjects() {
;CozyFire_driver.c,137 :: 		Screen1.Color                     = 0x0000;
	CLR	W0
	MOV	W0, _Screen1
;CozyFire_driver.c,138 :: 		Screen1.Width                     = 320;
	MOV	#320, W0
	MOV	W0, _Screen1+2
;CozyFire_driver.c,139 :: 		Screen1.Height                    = 240;
	MOV	#240, W0
	MOV	W0, _Screen1+4
;CozyFire_driver.c,140 :: 		Screen1.ObjectsCount              = 0;
	MOV	#lo_addr(_Screen1+6), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,142 :: 		}
L_end_InitializeObjects:
	RETURN
; end of CozyFire_driver_InitializeObjects

CozyFire_driver_IsInsideObject:
	LNK	#0

;CozyFire_driver.c,144 :: 		static char IsInsideObject (unsigned int X, unsigned int Y, unsigned int Left, unsigned int Top, unsigned int Width, unsigned int Height) { // static
;CozyFire_driver.c,145 :: 		if ( (Left<= X) && (Left+ Width - 1 >= X) &&
; Width start address is: 2 (W1)
	MOV	[W14-8], W1
; Height start address is: 4 (W2)
	MOV	[W14-10], W2
	CP	W12, W10
	BRA LEU	L_CozyFire_driver_IsInsideObject58
	GOTO	L_CozyFire_driver_IsInsideObject40
L_CozyFire_driver_IsInsideObject58:
	ADD	W12, W1, W0
; Width end address is: 2 (W1)
	DEC	W0
	CP	W0, W10
	BRA GEU	L_CozyFire_driver_IsInsideObject59
	GOTO	L_CozyFire_driver_IsInsideObject39
L_CozyFire_driver_IsInsideObject59:
;CozyFire_driver.c,146 :: 		(Top <= Y)  && (Top + Height - 1 >= Y) )
	CP	W13, W11
	BRA LEU	L_CozyFire_driver_IsInsideObject60
	GOTO	L_CozyFire_driver_IsInsideObject38
L_CozyFire_driver_IsInsideObject60:
	ADD	W13, W2, W0
; Height end address is: 4 (W2)
	DEC	W0
	CP	W0, W11
	BRA GEU	L_CozyFire_driver_IsInsideObject61
	GOTO	L_CozyFire_driver_IsInsideObject37
L_CozyFire_driver_IsInsideObject61:
L_CozyFire_driver_IsInsideObject36:
;CozyFire_driver.c,147 :: 		return 1;
	MOV.B	#1, W0
	GOTO	L_end_IsInsideObject
;CozyFire_driver.c,145 :: 		if ( (Left<= X) && (Left+ Width - 1 >= X) &&
L_CozyFire_driver_IsInsideObject40:
L_CozyFire_driver_IsInsideObject39:
;CozyFire_driver.c,146 :: 		(Top <= Y)  && (Top + Height - 1 >= Y) )
L_CozyFire_driver_IsInsideObject38:
L_CozyFire_driver_IsInsideObject37:
;CozyFire_driver.c,149 :: 		return 0;
	CLR	W0
;CozyFire_driver.c,150 :: 		}
L_end_IsInsideObject:
	ULNK
	RETURN
; end of CozyFire_driver_IsInsideObject

_DeleteTrailingSpaces:

;CozyFire_driver.c,154 :: 		void DeleteTrailingSpaces(char* str){
;CozyFire_driver.c,157 :: 		while(1) {
L_DeleteTrailingSpaces10:
;CozyFire_driver.c,158 :: 		if(str[0] == ' ') {
	MOV.B	[W10], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA Z	L__DeleteTrailingSpaces63
	GOTO	L_DeleteTrailingSpaces12
L__DeleteTrailingSpaces63:
;CozyFire_driver.c,159 :: 		for(i = 0; i < strlen(str); i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_DeleteTrailingSpaces13:
; i start address is: 4 (W2)
	CALL	_strlen
	ZE	W2, W1
	CP	W1, W0
	BRA LT	L__DeleteTrailingSpaces64
	GOTO	L_DeleteTrailingSpaces14
L__DeleteTrailingSpaces64:
;CozyFire_driver.c,160 :: 		str[i] = str[i+1];
	ZE	W2, W0
	ADD	W10, W0, W1
	ZE	W2, W0
	INC	W0
	ADD	W10, W0, W0
	MOV.B	[W0], [W1]
;CozyFire_driver.c,159 :: 		for(i = 0; i < strlen(str); i++) {
	INC.B	W2
;CozyFire_driver.c,161 :: 		}
; i end address is: 4 (W2)
	GOTO	L_DeleteTrailingSpaces13
L_DeleteTrailingSpaces14:
;CozyFire_driver.c,162 :: 		}
	GOTO	L_DeleteTrailingSpaces16
L_DeleteTrailingSpaces12:
;CozyFire_driver.c,164 :: 		break;
	GOTO	L_DeleteTrailingSpaces11
L_DeleteTrailingSpaces16:
;CozyFire_driver.c,165 :: 		}
	GOTO	L_DeleteTrailingSpaces10
L_DeleteTrailingSpaces11:
;CozyFire_driver.c,166 :: 		}
L_end_DeleteTrailingSpaces:
	RETURN
; end of _DeleteTrailingSpaces

_DrawScreen:
	LNK	#4

;CozyFire_driver.c,168 :: 		void DrawScreen(TScreen *aScreen) {
;CozyFire_driver.c,172 :: 		object_pressed = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#lo_addr(_object_pressed), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,173 :: 		order = 0;
	CLR	W0
	MOV	W0, [W14+0]
;CozyFire_driver.c,174 :: 		CurrentScreen = aScreen;
	MOV	W10, _CurrentScreen
;CozyFire_driver.c,176 :: 		if ((display_width != CurrentScreen->Width) || (display_height != CurrentScreen->Height)) {
	ADD	W10, #2, W0
	MOV	[W0], W1
	MOV	#lo_addr(_display_width), W0
	CP	W1, [W0]
	BRA Z	L__DrawScreen66
	GOTO	L__DrawScreen43
L__DrawScreen66:
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W0
	MOV	[W0], W1
	MOV	#lo_addr(_display_height), W0
	CP	W1, [W0]
	BRA Z	L__DrawScreen67
	GOTO	L__DrawScreen42
L__DrawScreen67:
	GOTO	L_DrawScreen19
L__DrawScreen43:
L__DrawScreen42:
;CozyFire_driver.c,177 :: 		save_bled = TFT_BLED;
	ADD	W14, #2, W0
	CLR.B	[W0]
	BTSC	LATC2_bit, BitPos(LATC2_bit+0)
	INC.B	[W0], [W0]
;CozyFire_driver.c,178 :: 		save_bled_direction = TFT_BLED_Direction;
	ADD	W14, #3, W0
	CLR.B	[W0]
	BTSC	TRISC2_bit, BitPos(TRISC2_bit+0)
	INC.B	[W0], [W0]
;CozyFire_driver.c,179 :: 		TFT_BLED_Direction = 0;
	BCLR	TRISC2_bit, BitPos(TRISC2_bit+0)
;CozyFire_driver.c,180 :: 		TFT_BLED           = 0;
	BCLR	LATC2_bit, BitPos(LATC2_bit+0)
;CozyFire_driver.c,181 :: 		TFT_Set_Active(Set_Index, Write_Command, Write_Data);
	PUSH	W10
	MOV	#lo_addr(_Write_Data), W12
	MOV	#lo_addr(_Write_Command), W11
	MOV	#lo_addr(_Set_Index), W10
	CALL	_TFT_Set_Active
;CozyFire_driver.c,182 :: 		TFT_Init(CurrentScreen->Width, CurrentScreen->Height);
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W1
	MOV	_CurrentScreen, W0
	INC2	W0
	MOV	[W1], W11
	MOV	[W0], W10
	CALL	_TFT_Init
;CozyFire_driver.c,183 :: 		TFT_Set_Ext_Buffer(TFT_Get_Data);
	MOV	#lo_addr(_TFT_Get_Data), W10
	CALL	_TFT_Set_Ext_Buffer
;CozyFire_driver.c,184 :: 		TP_TFT_Init(CurrentScreen->Width, CurrentScreen->Height, 13, 12);                                  // Initialize touch panel
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W1
	MOV	_CurrentScreen, W0
	INC2	W0
	MOV.B	#12, W13
	MOV.B	#13, W12
	MOV	[W1], W11
	MOV	[W0], W10
	CALL	_TP_TFT_Init
;CozyFire_driver.c,185 :: 		TP_TFT_Set_ADC_Threshold(ADC_THRESHOLD);                              // Set touch panel ADC threshold
	MOV	#800, W10
	CALL	_TP_TFT_Set_ADC_Threshold
;CozyFire_driver.c,186 :: 		TFT_Fill_Screen(CurrentScreen->Color);
	MOV	_CurrentScreen, W0
	MOV	[W0], W10
	CALL	_TFT_Fill_Screen
	POP	W10
;CozyFire_driver.c,187 :: 		display_width = CurrentScreen->Width;
	MOV	_CurrentScreen, W0
	INC2	W0
	MOV	[W0], W0
	MOV	W0, _display_width
;CozyFire_driver.c,188 :: 		display_height = CurrentScreen->Height;
	MOV	_CurrentScreen, W0
	ADD	W0, #4, W0
	MOV	[W0], W0
	MOV	W0, _display_height
;CozyFire_driver.c,189 :: 		TFT_BLED           = save_bled;
	ADD	W14, #2, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	BCLR	LATC2_bit, BitPos(LATC2_bit+0)
	BTSC	W0, #0
	BSET	LATC2_bit, BitPos(LATC2_bit+0)
;CozyFire_driver.c,190 :: 		TFT_BLED_Direction = save_bled_direction;
	ADD	W14, #3, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	BCLR	TRISC2_bit, BitPos(TRISC2_bit+0)
	BTSC	W0, #0
	BSET	TRISC2_bit, BitPos(TRISC2_bit+0)
;CozyFire_driver.c,191 :: 		}
	GOTO	L_DrawScreen20
L_DrawScreen19:
;CozyFire_driver.c,193 :: 		TFT_Fill_Screen(CurrentScreen->Color);
	MOV	_CurrentScreen, W0
	MOV	[W0], W10
	CALL	_TFT_Fill_Screen
L_DrawScreen20:
;CozyFire_driver.c,196 :: 		while (order < CurrentScreen->ObjectsCount) {
L_DrawScreen21:
	MOV	_CurrentScreen, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GT	L__DrawScreen68
	GOTO	L_DrawScreen22
L__DrawScreen68:
;CozyFire_driver.c,197 :: 		}
	GOTO	L_DrawScreen21
L_DrawScreen22:
;CozyFire_driver.c,198 :: 		}
L_end_DrawScreen:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _DrawScreen

_Get_Object:

;CozyFire_driver.c,200 :: 		void Get_Object(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,201 :: 		_object_count = -1;
	MOV	#65535, W0
	MOV	W0, __object_count
;CozyFire_driver.c,202 :: 		}
L_end_Get_Object:
	RETURN
; end of _Get_Object

CozyFire_driver_Process_TP_Press:

;CozyFire_driver.c,205 :: 		static void Process_TP_Press(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,207 :: 		Get_Object(X, Y);
	CALL	_Get_Object
;CozyFire_driver.c,210 :: 		if (_object_count != -1) {
	MOV	#65535, W1
	MOV	#lo_addr(__object_count), W0
	CP	W1, [W0]
	BRA NZ	L_CozyFire_driver_Process_TP_Press71
	GOTO	L_CozyFire_driver_Process_TP_Press23
L_CozyFire_driver_Process_TP_Press71:
;CozyFire_driver.c,211 :: 		}
L_CozyFire_driver_Process_TP_Press23:
;CozyFire_driver.c,212 :: 		}
L_end_Process_TP_Press:
	RETURN
; end of CozyFire_driver_Process_TP_Press

CozyFire_driver_Process_TP_Up:

;CozyFire_driver.c,214 :: 		static void Process_TP_Up(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,217 :: 		Get_Object(X, Y);
	CALL	_Get_Object
;CozyFire_driver.c,220 :: 		if (_object_count != -1) {
	MOV	#65535, W1
	MOV	#lo_addr(__object_count), W0
	CP	W1, [W0]
	BRA NZ	L_CozyFire_driver_Process_TP_Up73
	GOTO	L_CozyFire_driver_Process_TP_Up24
L_CozyFire_driver_Process_TP_Up73:
;CozyFire_driver.c,221 :: 		}
L_CozyFire_driver_Process_TP_Up24:
;CozyFire_driver.c,222 :: 		PressedObject = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _PressedObject
	MOV	W1, _PressedObject+2
;CozyFire_driver.c,223 :: 		PressedObjectType = -1;
	MOV	#65535, W0
	MOV	W0, _PressedObjectType
;CozyFire_driver.c,224 :: 		}
L_end_Process_TP_Up:
	RETURN
; end of CozyFire_driver_Process_TP_Up

CozyFire_driver_Process_TP_Down:

;CozyFire_driver.c,226 :: 		static void Process_TP_Down(unsigned int X, unsigned int Y) {
;CozyFire_driver.c,228 :: 		object_pressed      = 0;
	MOV	#lo_addr(_object_pressed), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,230 :: 		Get_Object(X, Y);
	CALL	_Get_Object
;CozyFire_driver.c,232 :: 		if (_object_count != -1) {
	MOV	#65535, W1
	MOV	#lo_addr(__object_count), W0
	CP	W1, [W0]
	BRA NZ	L_CozyFire_driver_Process_TP_Down75
	GOTO	L_CozyFire_driver_Process_TP_Down25
L_CozyFire_driver_Process_TP_Down75:
;CozyFire_driver.c,233 :: 		}
L_CozyFire_driver_Process_TP_Down25:
;CozyFire_driver.c,234 :: 		}
L_end_Process_TP_Down:
	RETURN
; end of CozyFire_driver_Process_TP_Down

_Check_TP:

;CozyFire_driver.c,236 :: 		void Check_TP() {
;CozyFire_driver.c,237 :: 		if (TP_TFT_Press_Detect()) {
	PUSH	W10
	PUSH	W11
	CALL	_TP_TFT_Press_Detect
	CP0.B	W0
	BRA NZ	L__Check_TP77
	GOTO	L_Check_TP26
L__Check_TP77:
;CozyFire_driver.c,239 :: 		if (TP_TFT_Get_Coordinates(&Xcoord, &Ycoord) == 0) {
	MOV	#lo_addr(_Ycoord), W11
	MOV	#lo_addr(_Xcoord), W10
	CALL	_TP_TFT_Get_Coordinates
	CP.B	W0, #0
	BRA Z	L__Check_TP78
	GOTO	L_Check_TP27
L__Check_TP78:
;CozyFire_driver.c,240 :: 		Process_TP_Press(Xcoord, Ycoord);
	MOV	_Ycoord, W11
	MOV	_Xcoord, W10
	CALL	CozyFire_driver_Process_TP_Press
;CozyFire_driver.c,241 :: 		if (PenDown == 0) {
	MOV	#lo_addr(_PenDown), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Check_TP79
	GOTO	L_Check_TP28
L__Check_TP79:
;CozyFire_driver.c,242 :: 		PenDown = 1;
	MOV	#lo_addr(_PenDown), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,243 :: 		Process_TP_Down(Xcoord, Ycoord);
	MOV	_Ycoord, W11
	MOV	_Xcoord, W10
	CALL	CozyFire_driver_Process_TP_Down
;CozyFire_driver.c,244 :: 		}
L_Check_TP28:
;CozyFire_driver.c,245 :: 		}
L_Check_TP27:
;CozyFire_driver.c,246 :: 		}
	GOTO	L_Check_TP29
L_Check_TP26:
;CozyFire_driver.c,247 :: 		else if (PenDown == 1) {
	MOV	#lo_addr(_PenDown), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Check_TP80
	GOTO	L_Check_TP30
L__Check_TP80:
;CozyFire_driver.c,248 :: 		PenDown = 0;
	MOV	#lo_addr(_PenDown), W1
	CLR	W0
	MOV.B	W0, [W1]
;CozyFire_driver.c,249 :: 		Process_TP_Up(Xcoord, Ycoord);
	MOV	_Ycoord, W11
	MOV	_Xcoord, W10
	CALL	CozyFire_driver_Process_TP_Up
;CozyFire_driver.c,250 :: 		}
L_Check_TP30:
L_Check_TP29:
;CozyFire_driver.c,251 :: 		}
L_end_Check_TP:
	POP	W11
	POP	W10
	RETURN
; end of _Check_TP

_Init_MCU:

;CozyFire_driver.c,253 :: 		void Init_MCU() {
;CozyFire_driver.c,254 :: 		TRISE = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CLR	TRISE
;CozyFire_driver.c,255 :: 		TFT_DataPort_Direction = 0;
	CLR.B	TRISA
;CozyFire_driver.c,256 :: 		CLKDIVbits.PLLPRE = 0;      // PLLPRE<4:0> = 0  ->  N1 = 2    8MHz / 2 = 4MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;CozyFire_driver.c,258 :: 		PLLFBD =   30;              // PLLDIV<8:0> = 30 ->  M = 32    4MHz * 32 = 128MHz
	MOV	#30, W0
	MOV	WREG, PLLFBD
;CozyFire_driver.c,260 :: 		CLKDIVbits.PLLPOST = 0;     // PLLPOST<1:0> = 0 ->  N2 = 2    128MHz / 2 = 64MHz
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;CozyFire_driver.c,262 :: 		Delay_ms(150);
	MOV	#25, W8
	MOV	#27143, W7
L_Init_MCU31:
	DEC	W7
	BRA NZ	L_Init_MCU31
	DEC	W8
	BRA NZ	L_Init_MCU31
;CozyFire_driver.c,263 :: 		TP_TFT_Rotate_180(0);
	CLR	W10
	CALL	_TP_TFT_Rotate_180
;CozyFire_driver.c,264 :: 		TFT_Set_Active(Set_Index,Write_Command,Write_Data);
	MOV	#lo_addr(_Write_Data), W12
	MOV	#lo_addr(_Write_Command), W11
	MOV	#lo_addr(_Set_Index), W10
	CALL	_TFT_Set_Active
;CozyFire_driver.c,265 :: 		}
L_end_Init_MCU:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Init_MCU

_Init_Ext_Mem:

;CozyFire_driver.c,267 :: 		void Init_Ext_Mem() {
;CozyFire_driver.c,269 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64,
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
;CozyFire_driver.c,270 :: 		_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
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
;CozyFire_driver.c,271 :: 		Delay_ms(10);
	MOV	#2, W8
	MOV	#41130, W7
L_Init_Ext_Mem33:
	DEC	W7
	BRA NZ	L_Init_Ext_Mem33
	DEC	W8
	BRA NZ	L_Init_Ext_Mem33
;CozyFire_driver.c,274 :: 		if (!Mmc_Fat_Init()) {
	CALL	_Mmc_Fat_Init
	CP0.B	W0
	BRA Z	L__Init_Ext_Mem83
	GOTO	L_Init_Ext_Mem35
L__Init_Ext_Mem83:
;CozyFire_driver.c,276 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_4,
	MOV	#2, W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
;CozyFire_driver.c,277 :: 		_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
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
;CozyFire_driver.c,280 :: 		Mmc_Fat_Assign("CozyFire.RES", 0);
	CLR	W11
	MOV	#lo_addr(?lstr1_CozyFire_driver), W10
	CALL	_Mmc_Fat_Assign
;CozyFire_driver.c,281 :: 		Mmc_Fat_Reset(&res_file_size);
	MOV	#lo_addr(_res_file_size), W10
	CALL	_Mmc_Fat_Reset
;CozyFire_driver.c,282 :: 		}
L_Init_Ext_Mem35:
;CozyFire_driver.c,283 :: 		}
L_end_Init_Ext_Mem:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Init_Ext_Mem

_Start_TP:

;CozyFire_driver.c,285 :: 		void Start_TP() {
;CozyFire_driver.c,286 :: 		Init_MCU();
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CALL	_Init_MCU
;CozyFire_driver.c,288 :: 		Init_Ext_Mem();
	CALL	_Init_Ext_Mem
;CozyFire_driver.c,290 :: 		InitializeTouchPanel();
	CALL	CozyFire_driver_InitializeTouchPanel
;CozyFire_driver.c,293 :: 		TP_TFT_Set_Calibration_Consts(149, 776, 68, 765);    // Set calibration constants
	MOV	#765, W13
	MOV	#68, W12
	MOV	#776, W11
	MOV	#149, W10
	CALL	_TP_TFT_Set_Calibration_Consts
;CozyFire_driver.c,295 :: 		InitializeObjects();
	CALL	CozyFire_driver_InitializeObjects
;CozyFire_driver.c,296 :: 		display_width = Screen1.Width;
	MOV	_Screen1+2, W0
	MOV	W0, _display_width
;CozyFire_driver.c,297 :: 		display_height = Screen1.Height;
	MOV	_Screen1+4, W0
	MOV	W0, _display_height
;CozyFire_driver.c,298 :: 		DrawScreen(&Screen1);
	MOV	#lo_addr(_Screen1), W10
	CALL	_DrawScreen
;CozyFire_driver.c,299 :: 		}
L_end_Start_TP:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Start_TP
