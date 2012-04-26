/*websr
 *  websr.c
 *  TWI_Master
 *
 *  Created by Sysadmin on 10.02.08.
 *  Copyright 2008 Ruedi Heimlicher. All rights reserved.
 *
 */
 
// Von WebClient_server_8_B0_6 

#include <avr/io.h>
#include <util/delay.h>

#include "websr.h"


#define SR_DATA_PORT				PORTD // Clock und Data
#define SR_DATA_PORTPIN			PIND	// Data lesen
#define SR_DATA_PORTDIR			DDRD	// Data RICHTUNG
#define SR_CLK_PIN				3
#define SR_DATA_IO_PIN			4

#define SR_HANDSHAKE_PORT		PORTC // Talk, Listen
#define SR_HANDSHAKE_PORTPIN	PINC  // Listen lesen
#define SR_HANDSHAKE_PORTDIR	DDRC	// Handshake Richtung
#define SR_TALK_PIN				2
#define SR_LISTEN_PIN			3


#define SR_PULSE_DELAY			8

#define SR_LISTEN_BIT			7
#define SR_TALK_BIT				6
#define SR_ERR_BIT				5 // 

#define DATA_RECEIVE_BIT		3
#define SEND_REQUEST_BIT		2

#define WRITE_CONFIRM_BIT	1
#define SEND_SERIE_BIT			0

#define TIMER2_WERT				0xFF

#define DATENBREITE				8

extern volatile uint8_t rxdata;

static volatile uint8_t websrstatus=0;
static volatile uint8_t ByteCounter=0;
extern volatile uint16_t timer2_counter;
void websrdelay_ms(unsigned int ms)
/* delay for a minimum of <ms> */
{
	// we use a calibrated macro. This is more
	// accurate and not so much compiler dependent
	// as self made code.
	while(ms){
		_delay_ms(0.96);
		ms--;
	}
}


/*
 * Sets Pins
 *
*/
void websr_init(void)
{
			// PORTC0  als Ausgang fuer ISR
			SR_HANDSHAKE_PORTDIR |=(1<<0);
			SR_HANDSHAKE_PORT |=(1<<0); // Hi

			// Talk als Ausgang
			SR_HANDSHAKE_PORTDIR |=(1<<SR_TALK_PIN);
			SR_HANDSHAKE_PORT |=(1<<SR_TALK_PIN); // Hi

			// Listen als Eingang
			SR_HANDSHAKE_PORTDIR &= ~(1<<SR_LISTEN_PIN);
			SR_HANDSHAKE_PORT |=(1<<SR_LISTEN_PIN); // Hi

				// PIN 2 von PORTD als Ausgang: Ausgabe auf Clock
			SR_DATA_PORTDIR |=(1<<SR_CLK_PIN);
			SR_DATA_PORT |=(1<<SR_CLK_PIN);// HI


			SR_HANDSHAKE_PORTDIR |= (1<<0); // Kontroll-Led
			SR_HANDSHAKE_PORT &= ~(1<<0);
			ByteCounter=0;

}


/*
 * Sets the mode 
 *
*/
void websr_set_mode(uint8_t derMode)
{
	// HANDSHAKE_PORT
	
	// PIN 3 von PORTC als Ausgang: Ausgabe eines Request oder confirm
	SR_HANDSHAKE_PORTDIR |= (1<<SR_TALK_PIN);
	SR_HANDSHAKE_PORT |= (1<<SR_TALK_PIN); // HI
	
	// PIN 4 von PORTC als Eingang: Hoeren auf Partner
	SR_HANDSHAKE_PORTDIR &= ~(1<<SR_LISTEN_PIN);
	SR_HANDSHAKE_PORT |= (1<<SR_LISTEN_PIN); // HI
	
	// PIN 2 von PORTD als Ausgang: Ausgabe auf Clock
	SR_DATA_PORTDIR |=(1<<SR_CLK_PIN);
	SR_DATA_PORT |=(1<<SR_CLK_PIN);// HI

	// DATA_PORT
	switch (derMode)	
	{
		case 0:	// LISTEN
			
			/*
			// PIN 2 von PORTD als Eingang: Hoeren auf Clock des Partners
			SR_DATA_PORTDIR &= ~(1<<SR_CLK_PIN);
			SR_DATA_PORT |=(1<<SR_CLK_PIN);// HI
			*/
			
			// PIN 3 von PORTD als Eingang: Hoeren auf Data
			SR_DATA_PORTDIR &= ~(1<<SR_DATA_IO_PIN);
			SR_DATA_PORT |= (1<<SR_DATA_IO_PIN); // HI
			
	//		websrstatus &= ~(1<<SR_LISTEN_BIT);
			//websrstatus &= ~(1<<SR_TALK_BIT);

			break;
			
		case 1: //TALK
			
			// DATA_PORT
			
			/*
			// PIN 2 von PORTD als Ausgang: Ausgabe auf Clock
			SR_DATA_PORTDIR |=(1<<SR_CLK_PIN);
			SR_DATA_PORT |=(1<<SR_CLK_PIN);// HI
			*/
			
			// PIN 3 von PORTD als Ausgang: Sprechen auf Data
			SR_DATA_PORTDIR |=(1<<SR_DATA_IO_PIN);
			SR_DATA_PORT |= (1<<SR_DATA_IO_PIN); // HI
			
			break;
	}
	
}

/*
 * Pulse the shift clock
 *
*/
void websr_pulse(uint8_t delay)
{
		_delay_us(delay);
		SR_DATA_PORT &= ~_BV(SR_CLK_PIN);
		_delay_us(delay);
		SR_DATA_PORT |= _BV(SR_CLK_PIN);
	//	_delay_us(delay);
	
}

void websr_pulse_ms(uint8_t delay)
{

		SR_DATA_PORT &= ~_BV(SR_CLK_PIN);
		_delay_ms(delay);
		SR_DATA_PORT |= _BV(SR_CLK_PIN);
		_delay_ms(delay);
	
}

/*
 * Request fuer Hoeren


*/

uint8_t ready_for_send()
{
	if (websrstatus & (1<<DATA_RECEIVE_BIT)) // hoeren ist im Gang
	{
		return 0;
	}
	else	if ((websrstatus & (1<< SEND_REQUEST_BIT)))// kein Listen,  sendrequest da
	{
		return 1;
	}
	
	return 0;
}


/*
 * Sets the mode of the shift register (74'299)
 *
*/


/*
 * shifts a byte into the SR*
 * Parameters:
 *      out_byte        The byte to load .
*/
uint8_t websr_shift_byte_out(uint8_t out_byte)
{ 
	
	// Listen-Bit zuruecksetzen
	//	websrstatus &= ~(1<< SR_LISTEN_BIT); // Bit 7
	
	// Talk-Request an Partner senden, warten auf Antwort
	SR_HANDSHAKE_PORT &= ~(1<<SR_TALK_PIN);	// Bit 3
	
	// Talk-Bit setzen
	websrstatus |= (1<< SR_TALK_BIT); // Bit 6
	//_delay_ms(10);
	uint16_t z=1;
	uint16_t zz=0;
	while (((SR_HANDSHAKE_PORTPIN & (1<< SR_LISTEN_PIN)))) // noch keine Antwort vom Partner > warten
	{	
		// Timer2 zuruecksetzen
		TCNT2=0; 
		timer2_counter=0;
		//lcd_gotoxy(16,3);
		//lcd_putint1(z);
		_delay_us(10); // warten
		z++;
		if (z == 0) //
		{
			zz++;
		}
	}
	z &= 0xFF00;
	z >>= 8;
	//zz &= 0xFF00;
	//zz >>= 8;
	
	if (ByteCounter == 0xFF)
	{
		//lcd_gotoxy(16,3);
		//lcd_puthex(z);
		//lcd_puthex(zz);
		
		if (zz >= 0x0005)
		{
			lcd_gotoxy(19,2);
			lcd_putc('E');
			websrstatus |= (1<< SR_ERR_BIT); 
			websr_reset();
			return 2;
		}
		else
		{
			//lcd_putc('G');
		}
		
	}
	
	// Antwort da
	//lcd_gotoxy(18,3);
	//lcd_puts("OK\0");
	//_delay_ms(2); // Eventuell mehr
	//websrstatus |= (1<< SR_LISTEN_BIT); // Bit 7
	int i;
	//	lcd_gotoxy(10,2);
	//	lcd_putc('*');
	
	//lcd_gotoxy(11,2);
	//lcd_puts("        \0");
	//_delay_ms(1);
	//lcd_gotoxy(11,2);
	
	for(i=0; i<8; i++)
	{
		if (out_byte & 0x80)
		{
			//lcd_putc('1');
			/* this bit is high */
			SR_DATA_PORT |=_BV(SR_DATA_IO_PIN); 
		}
		else
		{
			//lcd_putc('0');
			/* this bit is low */
			SR_DATA_PORT &= ~_BV(SR_DATA_IO_PIN);						
		}
		//_delay_us(2*SR_PULSE_DELAY);
		//_delay_us(255);
		//		_delay_us(255);
		//		_delay_us(50);
		websr_pulse(SR_PULSE_DELAY);
		//_delay_ms(1);
		//_delay_us(2*SR_PULSE_DELAY);
		out_byte = out_byte << 1;	//	Byte um eine Stelle nach links schieben
		
	}
	//lcd_putc('*');
	
	// Talk-Request zuruecknehmen
	SR_HANDSHAKE_PORT |= (1<<SR_TALK_PIN);
	
	// +++ Partner Zeit lassen
	_delay_ms(8);
	return 0;
}

// Listen-PIN  pollen, warten auf Request: PIN wird LO
uint8_t  ListenForRequest()
{
	if (websrstatus & (1<< SR_TALK_BIT))
	{
	 // ich sende selber
	 return 0;
	}

	// Signal fuer Oszi
	//	PORTD |= (1<<PB0);
	//	_delay_ms(2);
	//	PORTD &= ~(1<<PB0);

	// 
	if ((SR_HANDSHAKE_PORTPIN & (1<<SR_LISTEN_PIN))) // PIN ist  HI
	{
		if (websrstatus &(1<<SR_LISTEN_BIT)) // Listen-Bit ist noch gesetzt, Partner hat fertig gesendet
		{
			//	Signal fuer Oszi
//			PORTD |= (1<<PB0);
//			_delay_ms(2);
//			PORTD &= ~(1<<PB0);
			
			//lcd_gotoxy(16,2);
			//lcd_putc('E');
			
			//_delay_ms(40);
			// Listen-Bereitschaft an Partner zuruecknehmen
			SR_HANDSHAKE_PORT |= (1<<SR_TALK_PIN);
			
			// Listen-Bit zuruecksetzen
			websrstatus &= ~(1<<SR_LISTEN_BIT);
			
		}
		else
		{
		// Talk-Bit zuruecksetzen
		
//		 websrstatus &= ~(1<< SR_TALK_BIT); // Bit 6

//		 websrstatus &= ~(1<<SR_LISTEN_BIT);
		}
		
	}
	else // SR_LISTEN_PIN ist LO, Request vom Partner
	{
		//*******************
		// Talk-Bit zuruecksetzen
		 websrstatus &= ~(1<< SR_TALK_BIT); // Bit 6
		//*******************
		
		// Ist LISTEN-BIT im websrstatus schon gesetzt?
		if (websrstatus & (1<<SR_LISTEN_BIT)) // Bit 7
		{
			// Senden ist eingeleitet, nichts tun
			
		}
		else // neuer Request, Listen-Bit setzen
		{
			//lcd_clr_line(0);
			//lcd_gotoxy(15,2);
			//lcd_putc('A');
		
	//		websr_set_mode(0); // sicher ist sicher
			
			// ++++++++++++++++++++++++++++++++++++++
			if (ByteCounter == 0xFF)
			{
			// Schleife fuer Verzoegerung
			/*
				uint8_t i=0;
				for (i=0;i< 0 ;i++)
				{
				_delay_ms(20);
				_delay_ms(20);
				_delay_ms(20);
				_delay_ms(20);
				_delay_ms(20);
				}
			*/
			}
			
			// ++++++++++++++++++++++++++++++++++++++
			
			// Listen-Bereitschaft an Partner senden
			SR_HANDSHAKE_PORT &= ~(1<<SR_TALK_PIN);
			_delay_ms(1);
			// Listen-Status-Bit setzen
			websrstatus |= (1<<SR_LISTEN_BIT);
			//_delay_ms(200);
			return 1; // Bereit zum Lesen
		}
		
		
		
	}
	return 0;
	
}

/*
 * shift a byte from the SR into the processor.  
 *
 * Parameters:
 *      in_byte        The byte to shift in from the '299.
*/ 
uint8_t websr_shift_byte_in()
{
	// Request vom Partner testen, warten auf Antwort
	// Listen-Bit zuruecksetzen
	uint8_t in_byte=0;
	//websr_pulse_ms(4);
	if (websrstatus &(1<< SR_LISTEN_BIT)); // Bit 7 Listen-Bit gesetzt, Data wird gesendet
	{
		
		//lcd_clr_line(3);
		//lcd_gotoxy(4,3);
		//lcd_puts("in: \0");
		//lcd_putint(out_byte);
		//_delay_ms(4);
		//lcd_clr_line(1);
		uint8_t i=0;
		_delay_us(SR_PULSE_DELAY);
		while (i<8)
		{
			//lcd_gotoxy(5,3);
			//lcd_putint1(i);
			
			// Clock senden
			//websr_pulse_ms(1);
	//		websr_pulse(100);
			//_delay_us(100);
			//_delay_ms(2);
					
					// PIN lesen
					if (SR_DATA_PORTPIN & (1<<SR_DATA_IO_PIN)) // bit ist H
					{
						//in_byte |= (1<<(8-1-i));
						in_byte |= (1<<i);
						//lcd_gotoxy(6,2);
						//lcd_puts("1");
						
					}
					else
					{
						//in_byte &=~(1<<(8-1-i));
						in_byte |= (0<<i);
						//lcd_gotoxy(6,2);
						//lcd_puts("0");
					}
					
					//i++;
					
				
				websr_pulse(SR_PULSE_DELAY);
				
			
			
			
			/* read bit Q7 */
			//	lcd_gotoxy(6,3);
			//lcd_puts("B: \0");
			//lcd_putint(i);
			//_delay_ms(10);
			i++;
		} // while i
		
	//	SR_DATA_PORT |= _BV(SR_CLK_PIN);
		
	
	} // if SR_LISTEN_BIT
	//	lcd_clr_line(1);
	
	
	// Listen-Bit zuruecksetzen
//	websrstatus &= ~(1<<SR_LISTEN_BIT);						// nur noch in ListenForRequest
	//_delay_ms(10);
	
	// Listen-Bereitschaft an Partner zuruecknehmen
//	SR_HANDSHAKE_PORT |= (1<<SR_TALK_PIN);					// nur noch in ListenForRequest
	
	return in_byte;
}

void websr_reset()
{
	// Aufraeumen, zu lange warten auf Partner
	websrstatus &= ~(1<< SEND_SERIE_BIT); // Bit 0
	websrstatus &= ~(1<< DATA_RECEIVE_BIT);
	//websrstatus &= ~(1<< WRITE_CONFIRM_BIT);
	websrstatus &= ~(1<< SR_LISTEN_BIT);
	websrstatus &= ~(1<< SEND_REQUEST_BIT); // Send-Request zuruecksetzen
	rxdata=0;
	// nur in Testphase:
	websrstatus &= ~(1<< SR_ERR_BIT); 
	// Muss erst in Err-Routine zurueckgesetzt werden
	
	// TALK zuruecknehmen
	SR_HANDSHAKE_PORT |= (1<<SR_TALK_PIN);
	TCNT2 =0;
	timer2_counter=0;
	ByteCounter = 0xFF;
	websr_set_mode(0);
	
	// Timer2 stop
	TCCR2A=0;

}
