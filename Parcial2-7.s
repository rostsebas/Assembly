

		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
		
Start
	VLDR.F32 S0, =7.40		;Tiempo de la llamada.
	;Constantes
	VLDR.F32 S1, =1			;Constante 1min.	
	VLDR.F32 S2, =3			;Constante 3min.
	VLDR.F32 S3, =0.50		;Constante Q0.50.
	VLDR.F32 S4, =0.10		;Constante Q0.10.
	VLDR.F32 S5, =0.60		;Constante 60seg.

Igualar
	VADD.F32 S6, S0
	VADD.F32 S7, S0
	B C50
	
;Intervalo de 3min constantes.
C50
	VCMP.F32 S6, S2
	VMRS APSR_nzcv, FPSCR
	BGT	Suma50
	BNE	Resta10
	
Suma50
	VADD.F32 S8, S8, S3        ;S8 0.50+
	VSUB.F32 S6, S6, S2
	BL C50
	
;Intervalo de tiempo de extra.				
Resta10
	VSUB.F32 S7, S7, S2
	B C10

C10
	VCMP.F32 S7, S1
	VMRS APSR_nzcv, FPSCR
	BGT	Suma10
	BNE Sumax
	
Suma10
	VADD.F32 S9, S9, S4			;S9 0.10+
	VSUB.F32 S7, S7, S1
	BL C10
	
;Intervalo de tiempo menor a 1min
Sumax
	VDIV.F32 S10, S4, S5
	VMUL.F32 S7, S7, S10
	VADD.F32 S9, S9, S7
	B SumaT
		
SumaT
	VLDR.F32 S1, =0
	VADD.F32 S1, S9, S8			;Almacena el costo en la S1.
	B Loop
			
Loop
	
	ALIGN      
	END	