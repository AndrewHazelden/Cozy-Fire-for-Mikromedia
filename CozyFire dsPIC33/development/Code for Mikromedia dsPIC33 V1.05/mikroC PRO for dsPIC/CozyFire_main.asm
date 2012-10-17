
_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68
	LNK	#2

;CozyFire_main.c,39 :: 		void main() {
;CozyFire_main.c,40 :: 		int current_frame = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#0, W0
	MOV	W0, [W14+0]
;CozyFire_main.c,41 :: 		Start_TP();
	CALL	_Start_TP
;CozyFire_main.c,44 :: 		TFT_EXT_Image(0, 0, fireplacebg_bmp, 1);
	MOV	#4501, W12
	MOV	#0, W13
	CLR	W11
	CLR	W10
	MOV	#1, W0
	PUSH	W0
	CALL	_TFT_Ext_Image
	SUB	#2, W15
;CozyFire_main.c,47 :: 		TFT_Set_Font(TFT_defaultFont, CL_WHITE, FO_HORIZONTAL);
	CLR	W13
	MOV	#65535, W12
	MOV	#lo_addr(_TFT_defaultFont), W10
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, W11
	CALL	_TFT_Set_Font
;CozyFire_main.c,48 :: 		TFT_Write_Text("Cozy   Fire", 130, 20);
	MOV	#20, W12
	MOV	#130, W11
	MOV	#lo_addr(?lstr1_CozyFire_main), W10
	CALL	_TFT_Write_Text
;CozyFire_main.c,49 :: 		TFT_Write_Text("Created   By   Andrew   Hazelden   (c) 2012", 40, 220);
	MOV	#220, W12
	MOV	#40, W11
	MOV	#lo_addr(?lstr2_CozyFire_main), W10
	CALL	_TFT_Write_Text
;CozyFire_main.c,51 :: 		Delay_ms(2500);
	MOV	#407, W8
	MOV	#59185, W7
L_main0:
	DEC	W7
	BRA NZ	L_main0
	DEC	W8
	BRA NZ	L_main0
;CozyFire_main.c,54 :: 		TFT_EXT_Image(0, 0, fireplacebg_bmp, 1);
	MOV	#4501, W12
	MOV	#0, W13
	CLR	W11
	CLR	W10
	MOV	#1, W0
	PUSH	W0
	CALL	_TFT_Ext_Image
	SUB	#2, W15
;CozyFire_main.c,56 :: 		while (1) {
L_main2:
;CozyFire_main.c,57 :: 		Check_TP();
	CALL	_Check_TP
;CozyFire_main.c,60 :: 		TFT_EXT_Image(19, 64, animated_fire[current_frame], 1);
	MOV	[W14+0], W0
	SL	W0, #2, W1
	MOV	#lo_addr(_animated_fire), W0
	ADD	W0, W1, W0
	MOV.D	[W0], W12
	MOV	#64, W11
	MOV	#19, W10
	MOV	#1, W0
	PUSH	W0
	CALL	_TFT_Ext_Image
	SUB	#2, W15
;CozyFire_main.c,62 :: 		Delay_ms(10); //Keep the frame rate from going too high
	MOV	#2, W8
	MOV	#41130, W7
L_main4:
	DEC	W7
	BRA NZ	L_main4
	DEC	W8
	BRA NZ	L_main4
;CozyFire_main.c,65 :: 		current_frame++;
	MOV	[W14+0], W0
	ADD	W0, #1, W1
	MOV	W1, [W14+0]
;CozyFire_main.c,68 :: 		if(current_frame>=frame_range){
	MOV	#144, W0
	CP	W1, W0
	BRA GE	L__main8
	GOTO	L_main6
L__main8:
;CozyFire_main.c,69 :: 		current_frame=0;
	CLR	W0
	MOV	W0, [W14+0]
;CozyFire_main.c,70 :: 		}
L_main6:
;CozyFire_main.c,72 :: 		}
	GOTO	L_main2
;CozyFire_main.c,74 :: 		}
L_end_main:
	ULNK
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
