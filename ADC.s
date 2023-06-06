;RCGCGPIO			EQU	0x400FE608					;Habilita el clock para el PORTE


RCGC2				EQU	0x400FE108
GPIODIR_PE			EQU 0x40024400					;Registro donde indica cuales pines seran entradas o salidas
GPIOAFSEL			EQU	0x40024420					;Habilita la función especial para el pin PE4
GPIODEN				EQU 0x4002451C					;Habilita o deshabilita la función digital en los pines
GPIOAMSEL			EQU 0x40024528					;Habilita el pin como analogo
RCGC0				EQU	0x400FE100					;Registro para activar el ADC0 y las muestras del ADC
ADCSSPRI			EQU	0x40038020					;Prioridades de los secuenciadores
ADCACTSS			EQU	0x40038000					;Controla la activación de los secuenciadores
ADCEMUX				EQU	0x40038014					;Selecciona el trigger con el cuál se iniciara la secuencia de muestreo
ADCSSMUX3			EQU	0x400380A0					;Secuenciador sera activado por software
ADCSSCTL3			EQU	0x400380A4					;Interrupciones
ADCPSSI				EQU 0x40038028					;Inicialización SS3
ADCRIS				EQU	0x4003800C

		AREA	|.text|, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT Start
			
GPIO_Init
	;Habilita el clock para el PORTE
	LDR		R1, =RCGC2			;R1 = RCGC2 (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	ORR		R0, R0, #0x00000010	;R0 = R0 | 0x00000010 (Habilita el clock para el puerto E)
	STR		R0, [R1]			;[R1] = R0
	NOP
	NOP
	NOP							;Tiempo para que el clock del PORTE se estabilice
	;Establece las I/O del puerto E, en este caso PE4 es una entrada
	LDR		R1, =GPIODIR_PE		;R1 = GPIODIR_PE (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0xFFFFFFFB	;R0 = R0 | 0xFFFFFFFB
	STR		R0, [R1]			;[R1] = R0
	;Habilita la función especial para el pin en el puerto E
	LDR		R1, =GPIOAFSEL		;R1 = GPIOAFSEL (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	ORR		R0, R0, #0x00000004	;R0 = R0 | 0x00000004 (Habilita la función especial para el PE2)
	STR		R0, [R1]			;[R1] = R0
	;Habilita el pin para su uso
	LDR		R1, =GPIODEN		;R1 = GPIODEN (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0xFFFFFFFB	;R0 = R0 | 0xFFFFFFFB (Habilita el pin PE2)
	STR		R0, [R1]			;[R1] = R0
	;Habilita el pin como analogo
	LDR		R1, =GPIOAMSEL		;R1 = GPIOAMSEL (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	ORR		R0, R0, #0x00000004	;R0 = R0 | 0x00000004 (Habilita el pin PE4 como analogo)
	STR		R0, [R1]			;[R1] = R0
	;Activa ADC0
	LDR		R1, =RCGC0			;R1 = RCGC0 (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	ORR		R0, R0, #0x00010000	;R0 = R0 | 0x00010000 (Habilita el clock para el puerto E)
	STR		R0, [R1]			;[R1] = R0
	NOP
	NOP
	NOP
	;Configura para 125K
	LDR		R1, =RCGC0			;R1 = RCGC0 (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0xFFFFFCFF	;R0 = R0 | 0xFFFFFCFF
	STR		R0, [R1]			;[R1] = R0
	;Establece la prioridad de los secuenciadores para el módulo ADC0
	LDR		R1, =ADCSSPRI		;R1 = ADCSSPRI (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0x00000000
	MOV		R0, #0x00000123		;R0 = 0x00000123 (Máxima prioridad SS3)
	STR		R0, [R1]			;[R1] = R0
	;Desactiva el SS3
	LDR		R1, =ADCACTSS		;R1 = ADCACTSS (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0xFFFFFFF7	;R0 = 0xFFFFFFF7 (Desactiva SS3)
	STR		R0, [R1]			;[R1] = R0
	;Selecciona el trigger por software para el SS3
	LDR		R1, =ADCEMUX		;R1 = ADCEMUX (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0xFFFF0FFF	;R0 = 0xFFFF0FFF (Trigger es por medio de software)
	STR		R0, [R1]			;[R1] = R0
	;Limpia el campo de SS3 y activa el canal
	LDR		R1, =ADCSSMUX3		;R1 = ADCSSMUX3 (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0xFFFFFFF0	;R0 = R0 & 0xFFFFFFF0
	ADD		R0, R0, #0x00000001	;R0 = R0 + 0x00000009
	STR		R0, [R1]			;[R1] = R0
	;Deshabilita TS0 y D0, habilita IE0 y END0
	LDR		R1, =ADCSSCTL3		;R1 = ADCSSCTL3 (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0x00000000	;R0 = R0 & 0x00000000
	ORR		R0, R0, #0x00000006	;R0 = R0 | 0x00000006
	STR		R0, [R1]			;[R1] = R0
	;Activa el SS3
	LDR		R1, =ADCACTSS		;R1 = ADCACTSS (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	ORR		R0, R0, #0x00000008	;R0 = R0 | 0x00000008
	STR		R0, [R1]
	BX		LR
	
Start
	BL		GPIO_Init
loop
	;Inicia SS3
	LDR		R1, =ADCPSSI		;R1 = ADCPSSI (dirección)
	LDR		R0, [R1]			;R0 = [R1] (valor)
	AND		R0, R0, #0x00000000	;R0 = R0 & 0x00000000
	ORR		R0, R0, #0x00000008	;R0 = R0 | 0X00000008
	STR		R0, [R1]			;[R1] = R0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	LDR		R1, =ADCRIS
	LDR		R0, [R1]
	MOV		R0, #0x00000008
	STR		R0, [R1]
	B		loop
	
	ALIGN
	END