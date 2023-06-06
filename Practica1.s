SYSCTL_RCGCGPIO_R  EQU 0x400FE608
GPIO_PORTB0        EQU 0x40005004
GPIO_PORTB3        EQU 0x40005020
GPIO_PORTB4        EQU 0x40005040
GPIO_PORTB5        EQU 0x40005080	
GPIO_PORTB6        EQU 0x40005100
GPIO_PORTB7        EQU 0x40005200	
GPIO_PORTB_DIR_R   EQU 0x40005400
GPIO_PORTB_AFSEL_R EQU 0x40005420
GPIO_PORTB_DEN_R   EQU 0x4000551C
GPIO_PORTB_LOCK_R  EQU 0x40005520
GPIO_PORTB_AMSEL_R EQU 0x40005528
GPIO_PORTB_PCTL_R  EQU 0x4000552C
GPIO_LOCK_KEY	   EQU 0x4C4F434B 
GPIO_PORTB_CR_R    EQU 0x40005524
C		   EQU 100000
	
		 AREA    codigo, CODE, READONLY,ALIGN=2
		 THUMB
		 EXPORT Start 

Start
	;activación de reloj para puerto B.
    LDR R1, =SYSCTL_RCGCGPIO_R
    LDR R0, [R1]                   
    ORR R0, R0, #0x02            
    STR R0, [R1]                   
    NOP
    NOP    
	; Paso 2: desbloqueo de pines.
	LDR R1, =GPIO_PORTB_LOCK_R	; uso de llave
	LDR R0, =GPIO_LOCK_KEY                     
    STR R0, [R1]
    LDR R1, =GPIO_PORTB_CR_R    ; "commit"
    MOV R0, #0xFF                   
    STR R0, [R1]   
	;deshabilitar función analógica.
    LDR R1, =GPIO_PORTB_AMSEL_R   
	LDR R0, [R1] 	
    BIC R0, #0xFF                      
    STR R0, [R1]
	;configurar como GPIO.
    LDR R1, =GPIO_PORTB_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, R0, #0x000000FF  
	BIC R0, R0, #0x00000F00	
    STR R0, [R1]      
	;especificar dirección de PB0.
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x01              
    STR R0, [R1]  
	;especificar dirección de PB3.
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x08              
    STR R0, [R1]  
	;especificar dirección de PB4.
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x10              
    STR R0, [R1] 
	;especificar dirección de PB5.
	LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                   
    BIC R0, R0, #0x20              
    STR R0, [R1]
	;especificar dirección de PB6.
	LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                   
    BIC R0, R0, #0x40              
    STR R0, [R1]
	;especificar dirección de PB7.
	LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                   
    BIC R0, R0, #0x80              
    STR R0, [R1]   	
	;limpiar bits en función alternativa.
    LDR R1, =GPIO_PORTB_AFSEL_R    
    LDR R0, [R1]                   
    BIC R0, R0, #0xFF             
    STR R0, [R1]    
	;habilitar como puerto digital.
    LDR R1, =GPIO_PORTB_DEN_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0xFF             
    STR R0, [R1]  
	
	LDR R3, =C
	B Loop 

Delay	; Rutina de retardo de 50ms.
	ADD R2, #1
	NOP
	NOP
	NOP
	NOP
	CMP R2, R3
	BNE Delay
	BX LR

Encender1 ; Rutina de encendido de PB0.
	LDR R5, =GPIO_PORTB0
	LDR R4, =0x01
	STR R4, [R5]
	B Loop
Encender2; Rutina de encendido de PB3.
	LDR R5, =GPIO_PORTB3
	LDR R4, =0x8
	STR R4, [R5]
	B Loop
Encender3 ; Rutina de encendido de PB4.
	LDR R5, =GPIO_PORTB4
	LDR R4, =0x10
	STR R4, [R5]
	B Loop
Apagar1	; Rutina de apagado de PB0, PB3 y PB4.
	LDR R5, =GPIO_PORTB0
	LDR R4, =0x0
	STR R4, [R5]
	LDR R5, =GPIO_PORTB3
	LDR R4, =0x0
	STR R4, [R5]
	LDR R5, =GPIO_PORTB4
	LDR R4, =0x0
	STR R4, [R5]
	B Loop

Loop	; Ciclo para lectura de switch.
	; Leer el valor del switch.
	LDR R1, =GPIO_PORTB5
	LDR R0, [R1]
	LDR R1, =GPIO_PORTB6
	LDR R0, [R1]
	LDR R1, =GPIO_PORTB7
	LDR R0, [R1]
	;Retardo antirrebote.
	LDR R2, =0
	BL Delay
	; Si PB6=1, encender LED. Si PB6=0, apagar LED.
	CMP R0, #0x80
	BEQ Encender1
	CMP R0, #0x40
	BEQ Encender2
	CMP R0, #0x20
	BEQ Encender3
	CMP R0, #0x0
	BEQ Apagar1
	
	B Loop
	
    ALIGN                           
    END  

