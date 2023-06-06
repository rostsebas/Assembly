; JUAN CARLOS SILLOY XICON				201602816
; CRISTIAN SEBASTIAN MARTINEZ AREVALO 	201700466

;Comentario: segun como entendimos la practica, es que cuando el boton externo(segun la primera practica, supuse que era externo), 
;en nuestro caso el Pin PF4 no reciba una se?al se ejecutara la secuencia por defecto 
;Red-Green-Blue, y cuando esta termina y llega una se?al al Pin PF4 se activa la siguiente 
;secuencia Magenta-Yellow-SkyBlue-White. 

GPIO_PORTF4        EQU 0x40025040
GPIO_PORTF0        EQU 0x40025004
GPIO_PORTF1        EQU 0x40025008
GPIO_PORTF2        EQU 0x40025010
GPIO_PORTF3        EQU 0x40025020	
GPIO_PORTF12       EQU 0x40025018
GPIO_PORTF13       EQU 0x40025028	
GPIO_PORTF23       EQU 0x40025030
GPIO_PORTF123      EQU 0x40025038	

GPIO_PORTF_DIR_R   EQU 0x40025400
GPIO_PORTF_AFSEL_R EQU 0x40025420
GPIO_PORTF_DEN_R   EQU 0x4002551C
GPIO_PORTF_LOCK_R  EQU 0x40025520
GPIO_PORTF_AMSEL_R EQU 0x40025528
GPIO_PORTF_PCTL_R  EQU 0x4002552C
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
GPIO_LOCK_KEY	   EQU 0x4C4F434B 
GPIO_PORTF_CR_R    EQU 0x40025524
	
A				   EQU 50000	
C		   		   EQU 2000000
D				   EQU 6000000
	
		 AREA    codigo, CODE, READONLY,ALIGN=2
		 THUMB
		 EXPORT Start 

Start
	; Paso 1: activacion de reloj para puerto F.
    LDR R1, =SYSCTL_RCGCGPIO_R
    LDR R0, [R1]                   
    ORR R0, R0, #0x20            
    STR R0, [R1]                   
    NOP
    NOP                          
	;desbloqueo de pines.
	LDR R1, =GPIO_PORTF_LOCK_R	
	LDR R0, =GPIO_LOCK_KEY                     
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_CR_R    
    MOV R0, #0xFF                   
    STR R0, [R1]                    
	;deshabilitar funcion analogica.
    LDR R1, =GPIO_PORTF_AMSEL_R   
	LDR R0, [R1] 	
    BIC R0, #0xFF                      
    STR R0, [R1]
	;configurar como GPIO, PCTL=0.
    LDR R1, =GPIO_PORTF_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, R0, #0x000000FF  
	BIC R0, R0, #0x00000F00	
    STR R0, [R1]   
	;especificar direccion de PF1
    LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x02              
    STR R0, [R1]  
	;especificar direccion de PF2
    LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x04              
    STR R0, [R1] 
	;especificar direccion de PF3
    LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x08              
    STR R0, [R1] 
	;especificar direccion de PF4
	LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    BIC R0, R0, #0x10            
    STR R0, [R1] 
	;especificar direccion de PF12
	LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x06              
    STR R0, [R1] 
	;especificar direccion de PF13
	LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x0A              
    STR R0, [R1]
	;especificar direccion de PF23
	LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x0C              
    STR R0, [R1]
	;especificar direccion de PF123
	LDR R1, =GPIO_PORTF_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x0E              
    STR R0, [R1]
	;limpiar bits en funcion alternativa.
    LDR R1, =GPIO_PORTF_AFSEL_R    
    LDR R0, [R1]                   
    BIC R0, R0, #0xFF            
    STR R0, [R1]    
    ; habilitar como puerto digital.
    LDR R1, =GPIO_PORTF_DEN_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0xFF               
    STR R0, [R1]                        
	
	LDR R3, =A
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

Rutina1 
	;LedRed
	LDR R5, =GPIO_PORTF1
	LDR R4, =0x02
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =D
	BL Delay
	LDR R5, =GPIO_PORTF1
	LDR R4, =0x0
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =D
	BL Delay
	;LedGreen
	LDR R5, =GPIO_PORTF3
	LDR R4, =0x08
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =D
	BL Delay
	LDR R5, =GPIO_PORTF3
	LDR R4, =0x0
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =D
	BL Delay
	;LedBlue
	LDR R5, =GPIO_PORTF2
	LDR R4, =0x04
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =D
	BL Delay
	LDR R5, =GPIO_PORTF2
	LDR R4, =0x0
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =D
	BL Delay
	B Loop

	
Combinacion
	;LedMagenta
	LDR R5, =GPIO_PORTF12
	LDR R4, =0x06
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay
	LDR R5, =GPIO_PORTF12
	LDR R4, =0x0
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay
	;LedYellow
	LDR R5, =GPIO_PORTF13
	LDR R4, =0x0A
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay
	LDR R5, =GPIO_PORTF13
	LDR R4, =0x0
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay
	;LedCyan
	LDR R5, =GPIO_PORTF23
	LDR R4, =0x0C
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay
	LDR R5, =GPIO_PORTF23
	LDR R4, =0x0
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay
	;LedWhite
	LDR R5, =GPIO_PORTF123
	LDR R4, =0x0E
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay
	LDR R5, =GPIO_PORTF123
	LDR R4, =0x0
	STR R4, [R5]
	LDR R2, =0
	LDR R3, =C
	BL Delay	
	BL Rutina2
	
Rutina2
	ADD R6, #1
	CMP R6, #11
	BNE Combinacion
	BEQ Loop

Loop	; Ciclo para lectura de switch.
	; Leer el valor del switch.
	LDR R1, =GPIO_PORTF4
	LDR R0, [R1]
	;Retardo 
	LDR R2, =0
	BL Delay
	
	CMP R0, #0x10
	BEQ Rutina2
	CMP R0, #0x0
	BEQ Rutina1
	
	B Loop
	
    ALIGN                           
    END  
