_main:
;CozyFire_main.c,40 :: 		void main() {
ADDIU	SP, SP, -4
;CozyFire_main.c,41 :: 		int current_frame = 0;
MOVZ	R30, R0, R0
SH	R30, 0(SP)
;CozyFire_main.c,42 :: 		Start_TP();
JAL	_Start_TP+0
NOP	
;CozyFire_main.c,45 :: 		TFT_EXT_Image(0, 0, fireplacebg_bmp, 1);
ORI	R28, R0, 1
ORI	R27, R0, 4501
MOVZ	R26, R0, R0
MOVZ	R25, R0, R0
JAL	_TFT_Ext_Image+0
NOP	
;CozyFire_main.c,48 :: 		TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
MOVZ	R27, R0, R0
ORI	R26, R0, 65535
LUI	R25, #hi_addr(_TFT_defaultFont+0)
ORI	R25, R25, #lo_addr(_TFT_defaultFont+0)
JAL	_TFT_Set_Font+0
NOP	
;CozyFire_main.c,49 :: 		TFT_Write_Text("Cozy   Fire", 130, 20);
ORI	R27, R0, 20
ORI	R26, R0, 130
LUI	R25, #hi_addr(?lstr1_CozyFire_main+0)
ORI	R25, R25, #lo_addr(?lstr1_CozyFire_main+0)
JAL	_TFT_Write_Text+0
NOP	
;CozyFire_main.c,50 :: 		TFT_Write_Text("Created   By   Andrew   Hazelden   (c) 2012", 40, 220);
ORI	R27, R0, 220
ORI	R26, R0, 40
LUI	R25, #hi_addr(?lstr2_CozyFire_main+0)
ORI	R25, R25, #lo_addr(?lstr2_CozyFire_main+0)
JAL	_TFT_Write_Text+0
NOP	
;CozyFire_main.c,52 :: 		Delay_ms(2500);
LUI	R24, 1017
ORI	R24, R24, 16554
L_main0:
ADDIU	R24, R24, -1
BNE	R24, R0, L_main0
NOP	
;CozyFire_main.c,55 :: 		TFT_EXT_Image(0, 0, fireplacebg_bmp, 1);
ORI	R28, R0, 1
ORI	R27, R0, 4501
MOVZ	R26, R0, R0
MOVZ	R25, R0, R0
JAL	_TFT_Ext_Image+0
NOP	
;CozyFire_main.c,57 :: 		while (1) {
L_main2:
;CozyFire_main.c,58 :: 		Check_TP();
JAL	_Check_TP+0
NOP	
;CozyFire_main.c,61 :: 		TFT_EXT_Image(19, 64, animated_fire[current_frame], 1);
LH	R2, 0(SP)
SLL	R3, R2, 2
LUI	R2, #hi_addr(_animated_fire+0)
ORI	R2, R2, #lo_addr(_animated_fire+0)
ADDU	R2, R2, R3
LW	R2, 0(R2)
ORI	R28, R0, 1
MOVZ	R27, R2, R0
ORI	R26, R0, 64
ORI	R25, R0, 19
JAL	_TFT_Ext_Image+0
NOP	
;CozyFire_main.c,63 :: 		Delay_ms(25); //Keep the frame rate from going too high
LUI	R24, 10
ORI	R24, R24, 11306
L_main4:
ADDIU	R24, R24, -1
BNE	R24, R0, L_main4
NOP	
;CozyFire_main.c,66 :: 		current_frame++;
LH	R2, 0(SP)
ADDIU	R2, R2, 1
SH	R2, 0(SP)
;CozyFire_main.c,69 :: 		if(current_frame>=frame_range){
SEH	R2, R2
SLTI	R2, R2, 144
BEQ	R2, R0, L__main8
NOP	
J	L_main6
NOP	
L__main8:
;CozyFire_main.c,70 :: 		current_frame=0;
SH	R0, 0(SP)
;CozyFire_main.c,71 :: 		}
L_main6:
;CozyFire_main.c,73 :: 		}
J	L_main2
NOP	
;CozyFire_main.c,75 :: 		}
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
