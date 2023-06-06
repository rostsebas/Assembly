; JUAN CARLOS SILLOY XICON				201602816
; CRISTIAN SEBASTIAN MARTINEZ AREVALO 	201700466

;Comentario: para esta practica, no contaba con un servomotor de 180, solo con uno de 360, por esto 
;mejor opte por realizar las pruebas en un motor DC, para que variara su velocidad y no se si los valores dados
;al PWM son necesarios para girar un servomotor 180. Segun se el SG90(servo azul) tiene un periodo de 20ms
;y para llegar a los 180 tiene que tener un ciclo de trabajo de 2ms. Tambien utilice el Pin PB6 como PWM ya que 
;segun yo el Pin PB0 no cuenta con PWM.

SYSCTL_RCGCGPIO_R  	EQU 0x400FE608
	
GPIO_PORTB6        	EQU 0x40005100		
GPIO_PORTB_DIR_R   	EQU 0x40005400
GPIO_PORTB_AFSEL_R 	EQU 0x40005420
GPIO_PORTB_DEN_R   	EQU 0x4000551C
GPIO_PORTB_AMSEL_R 	EQU 0x40005528
GPIO_PORTB_PCTL_R  	EQU 0x40005530
RCGCPWM				EQU 0x400FE640
RCGC0				EQU 0x400FE100
PWM0CTL				EQU 0x40028040
PWM0GENB			EQU 0x40028064
PWMENABLE			EQU 0x40028008
PWM0LOAD			EQU 0x40028050
	
GPIO_PORTD0        	EQU 0x40007004
GPIO_PORTD_DIR_R   	EQU 0x40007400
GPIO_PORTD_AFSEL_R 	EQU 0x40007420
GPIO_PORTD_DEN_R   	EQU 0x4000751C
GPIO_PORTD_AMSEL_R 	EQU 0x40007528
GPIO_PORTD_PCTL_R  	EQU 0x4000752C
GPIO_PORTD_DATA  	EQU 0x40007000	


C		   		  	EQU 100000

		 AREA    codigo, CODE, READONLY,ALIGN=2
		 THUMB
		 EXPORT Start 

Start
;Configuración del puerto B.
	;activación de reloj para puerto B.
    LDR R1, =SYSCTL_RCGCGPIO_R
    LDR R0, [R1]                   
    ORR R0, R0, #0x02            
    STR R0, [R1]                   
    NOP
    NOP
	;deshabilitar función analógica.
    LDR R1, =GPIO_PORTB_AMSEL_R   
	LDR R0, [R1] 	
    BIC R0, #0x40                     
    STR R0, [R1]	
	;configurar como GPIO.
    LDR R1, =GPIO_PORTB_PCTL_R      
    LDR R0, [R1]   	
    BIC R0, R0, #0x000000FF  
	BIC R0, R0, #0x00000F00	
    STR R0, [R1]   
	;especificar dirección de PB6.
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x40             
    STR R0, [R1]	
	;limpiar bits en función alternativa.
    LDR R1, =GPIO_PORTB_AFSEL_R    
    LDR R0, [R1]                   
    BIC R0, R0, #0x40          
    STR R0, [R1]    
	;habilitar como puerto digital.
    LDR R1, =GPIO_PORTB_DEN_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x40             
    STR R0, [R1] 

	;activación de reloj del PWM0.
    LDR R1, =RCGCPWM
    LDR R0, [R1]                   
    ORR R0, R0, #0x01        
    STR R0, [R1]                   
    NOP
    NOP
	;activación de reloj del PWM0.
    LDR R1, =RCGC0
    LDR R0, [R1]                   
    ORR R0, R0, #0x100000	            
    STR R0, [R1]   
	;habilitar modulo 0.
    LDR R1, =PWM0CTL	   
	LDR R0, [R1] 	
    BIC R0, #0x01                    
    STR R0, [R1]
	;habilitar modulo del PWM.
    LDR R1, =PWM0GENB	   
	LDR R0, [R1] 	
    BIC R0, #0x25C                    
    STR R0, [R1]
	;habilitar generador del PWM0.
    LDR R1, =PWMENABLE	   
	LDR R0, [R1] 	
    BIC R0, #0x01                    
    STR R0, [R1]

	
	
;Configuración del puerto D.
	;activación de reloj para puerto D.
    LDR R3, =SYSCTL_RCGCGPIO_R
    LDR R2, [R3]                   
    ORR R2, R2, #0x08            
    STR R2, [R3]                   
    NOP
    NOP
	;habilitar función analógica.
    LDR R3, =GPIO_PORTD_AMSEL_R   
	LDR R2, [R3] 	
    BIC R2, #0x01                     
    STR R2, [R3]	
	;configurar como GPIO.
    LDR R3, =GPIO_PORTD_PCTL_R      
    LDR R2, [R3]   	
    BIC R2, R2, #0x000000FF  
	BIC R2, R2, #0x00000F00	
    STR R2, [R3]   
	;especificar dirección de PD0.
    LDR R3, =GPIO_PORTD_DIR_R      
    LDR R2, [R3]                   
    ORR R2, R2, #0x01              
    STR R2, [R3]	
	;limpiar bits en función alternativa.
    LDR R3, =GPIO_PORTD_AFSEL_R    
    LDR R2, [R3]                   
    BIC R2, R2, #0x01          
    STR R2, [R3]    
	;deshabilitar como puerto digital.
    LDR R3, =GPIO_PORTD_DEN_R    				;0x0 deshabilitar funcion digital  
    LDR R2, [R3]                   
    ORR R2, R2, #0x00             
    STR R2, [R3]  

	LDR R7, =C
	B Loop 

Delay	; Rutina de retardo de 50ms.
	ADD R6, #1
	NOP
	NOP
	NOP
	NOP
	CMP R6, R7
	BNE Delay
	BX LR
	

Encendido1
	LDR R5, =PWM0LOAD      ;este dato es el que da el PWM
    LDR R4, =300                 
    STR R4, [R4] 
	B Loop
	
Encendido2
	LDR R5, =PWM0LOAD      
    LDR R4, =500                 
    STR R4, [R4] 
	B Loop
	
Encendido3
	LDR R5, =PWM0LOAD      
    LDR R4, =800                 
    STR R4, [R4] 
	B Loop
	
Encendido4
	LDR R5, =PWM0LOAD      
    LDR R4, =1500                  
    STR R4, [R4] 
	B Loop
	
Encendido5
	LDR R5, =PWM0LOAD      
    LDR R4, =4000                
    STR R4, [R4] 
	B Loop	
	
Encendido6
	LDR R5, =PWM0LOAD      
    LDR R4, =7500                
    STR R4, [R4] 
	B Loop
	
Encendido7
	LDR R5, =PWM0LOAD      
    LDR R4, =15000                
    STR R4, [R4] 
	B Loop
	
Encendido8
	LDR R5, =PWM0LOAD      
    LDR R4, =40000               
    STR R4, [R4] 
	B Loop
	
Loop
	LDR R3, =GPIO_PORTD_DATA
	LDR R2, [R3]
	;Retardo 
	LDR R6, =0
	BL Delay
	CMP R2, #10   ;este dato es la entrada que recibe del pot
	BEQ Encendido1
	CMP R2, #110
	BEQ Encendido2
	CMP R2, #210
	BEQ Encendido3
	CMP R2, #310
	BEQ Encendido4
	CMP R2, #410
	BEQ Encendido5
	CMP R2, #510
	BEQ Encendido6
	CMP R2, #600
	BEQ Encendido7
	CMP R2, #700
	BEQ Encendido8
	
	B Loop
	
	
	ALIGN
	END