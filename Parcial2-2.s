;Trasladar lineas de azimut a coordenadas(x,y)
		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start  
	;Valores de Azimut 
	VLDR.F32 S0, =62.8				;Ingresar distancia horizontal.
	VLDR.F32 S1, =59.2				;Ingresar grados sexagesimal.
	VLDR.F32 S2, =195				;Ingresar minutos sexagesimal.
	VLDR.F32 S3, =496				;Ingresar segundos sexagesimal.
	
	;Constantes
	VLDR.F32 S4, =3.141592654		;Valor aproximado de pi.
	VLDR.F32 S5, =1.570796327		;Valor aproximado de pi/2.
	VLDR.F32 S6, =60				;constante.
	VLDR.F32 S7, =180				;constante.
	
;Trasladar a sistema decimal.		Gd=Gs+Ms/60+Ss/3600
Decimal
	VDIV.F32 S2, S2, S6		;Dividir minutos/60
	VMUL.F32 S6, S6, S6		;Obtener valor de 3600
	VDIV.F32 S3, S3, S6		;Dividir seguntos/3600
	VADD.F32 S1, S1, S2
	VADD.F32 S1, S1, S3
	B Angulo

Angulo
	;Transformar grados a radianes.
	VDIV.F32 S4, S4, S7 
	VMUL.F32 S1, S1, S4
	;Angulo real.
	VSUB.F32 S1, S5, S1
	VLDR.F32 S5,=0
	B Numerador1
	
;Serie de Taylor Coseno
	;cosx=((-1)^n*(x^(2n)))/2n!
Numerador1
	VLDR.F32 S3, =1 			;n=0    1  		+
	VMUL.F32 S4,S1,S1  			;n=1  	x^2		-
	VMUL.F32 S5,S4,S4  			;n=2  	x^4		+	 
	VMUL.F32 S6,S5,S4  			;n=3  	x^6		-
	VMUL.F32 S7,S5,S5  			;n=4  	x^8		+
	VMUL.F32 S8,S6,S5  			;n=5  	x^10	-
	VMUL.F32 S9,S6,S6  			;n=6  	x^12	+
	VMUL.F32 S10,S7,S6  		;n=7  	x^14	-
	B Denominador1
	
Denominador1
	VLDR.F32 S3, =1 			;n=0	1! 	
	VLDR.F32 S11, =2			;n=1	2!
	VLDR.F32 S12, =24			;n=2	4!
	VLDR.F32 S13, =720			;n=3	6!
	VLDR.F32 S14, =40320		;n=4	8!
	VLDR.F32 S15, =3628800		;n=5	10!
	VLDR.F32 S16, =479001600	;n=6	12!
	VLDR.F32 S17, =87178291200	;n=7	14!
	B Division1
	
Division1
	VDIV.F32 S18, S3, S3	;n=0
	VDIV.F32 S19, S4, S11	;n=1
	VDIV.F32 S20, S5, S12	;n=2
	VDIV.F32 S21, S6, S13	;n=3
	VDIV.F32 S22, S7, S14	;n=4
	VDIV.F32 S23, S8, S15	;n=5
	VDIV.F32 S24, S9, S16	;n=6
	VDIV.F32 S25, S10, S17	;n=7
	B Resultado1
	
Resultado1
	VSUB.F32 S2, S18, S19	
	VADD.F32 S2, S2, S20
	VSUB.F32 S2, S2, S21
	VADD.F32 S2, S2, S22
	VSUB.F32 S2, S2, S23
	VADD.F32 S2, S2, S24
	VSUB.F32 S2, S2, S25
	B EjeX
	
EjeX
	VMUL.F32 S2, S2, S0			;Almacena coordenada X en S2
	B Numerador2
	
;Serie de Taylor Seno
	;cosx=((-1)^n*(x^(2n+1)))/(2n+1)!
Numerador2
		;S1=Angulo=x	;n=0    x  		+
	VMUL.F32 S3,S1,S1
	VMUL.F32 S3,S3,S1	;n=1  	x^3		-
	VMUL.F32 S4,S3,S1  
	VMUL.F32 S4,S4,S1	;n=2  	x^5		+	 
	VMUL.F32 S5,S4,S1  	
	VMUL.F32 S5,S5,S1	;n=3  	x^7		-
	VMUL.F32 S6,S5,S1  	
	VMUL.F32 S6,S6,S1	;n=4  	x^9		+
	VMUL.F32 S7,S6,S1  	
	VMUL.F32 S7,S7,S1	;n=5  	x^11	-
	VMUL.F32 S8,S7,S1  	
	VMUL.F32 S8,S7,S1	;n=6  	x^13	+
	VMUL.F32 S9,S8,S1  	
	VMUL.F32 S9,S8,S1	;n=7  	x^15	-
	B Denominador2
	
Denominador2
	VLDR.F32 S10, =1 				;n=0	1! 	
	VLDR.F32 S11, =6				;n=1	3!
	VLDR.F32 S12, =120				;n=2	5!
	VLDR.F32 S13, =5040				;n=3	7!
	VLDR.F32 S14, =362880			;n=4	9!
	VLDR.F32 S15, =39916800			;n=5	11!
	VLDR.F32 S16, =6227020800		;n=5	13!
	VLDR.F32 S17, =1307674368000	;n=5	15!
	B Division2
	
Division2
	VDIV.F32 S18, S1, S10	;n=0
	VDIV.F32 S19, S3, S11	;n=1
	VDIV.F32 S20, S4, S12	;n=2
	VDIV.F32 S21, S5, S13	;n=3
	VDIV.F32 S22, S6, S14	;n=4
	VDIV.F32 S23, S7, S15	;n=5
	VDIV.F32 S24, S8, S16	;n=4
	VDIV.F32 S25, S9, S17	;n=5
	B Resultado2
	
Resultado2
	VSUB.F32 S3, S18, S19	
	VADD.F32 S3, S3, S20
	VSUB.F32 S3, S3, S21
	VADD.F32 S3, S3, S22
	VSUB.F32 S3, S3, S23
	VADD.F32 S3, S3, S24
	VSUB.F32 S3, S3, S25
	B EjeY
	
EjeY
	VMUL.F32 S3, S3, S0			;Almacena coordenada Y en S3.
	B Loop
	
Loop
	
	ALIGN      
	END	
	