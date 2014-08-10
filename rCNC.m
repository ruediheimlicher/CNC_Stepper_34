//
//  rCNC.m
//  IOW_Stepper
//
//  Created by Sysadmin on 26.April.11.
//  Copyright 2011 Ruedi Heimlicher. All rights reserved.
//

#import "rCNC.h"
#include <math.h>
uint8_t vs[4]={9,5,6,10};	//Tabelle Vollschritt Rechtslauf 
uint8_t hs[8]={9,1,5,4,6,2,10,8}; //Tabelle Halbschritt Rechtslauf

float full_pwm = 1;

#define MOTOR_A 0
#define MOTOR_B 1
#define MOTOR_C 2
#define MOTOR_D 3



@implementation rCNC
- (id)init
{
if ((self = [super init]) != nil) 
{
	DatenArray = [[NSMutableArray alloc]init];
	[DatenArray retain];
	
	speed=10;
	steps=48;
   red_pwm = 0.4;

return self;
}
return NULL;
}

- (int)steps
{
 return steps;
}
- (void)setSteps:(int)dieSteps
{
	steps = dieSteps;
}

- (void)setSchalendicke:(float)dieDicke
{
   schalendicke = dieDicke;
}

- (float)schalendicke
{
   return schalendicke;
}


- (void)setDatenArray:(NSArray*)derDatenArray
{
	[DatenArray release];
	[derDatenArray retain];
	DatenArray = (NSMutableArray*)derDatenArray;
}
- (NSArray*)DatenArray
{
	return DatenArray;
}


- (float) EndleistenwinkelvonProfil:(NSArray*)profil
{
   float steigungo=0, steigungu=0;
   int i=0;
 // Oberseite
   int anzWerte=0;
   int anfangsindex=4;
   int endindex=7;
   int anzPunkte=5;
   for (i=anfangsindex;i<endindex;i++)
   {
      float deltax = [[[profil objectAtIndex:i]objectForKey:@"x"]floatValue] - [[[profil objectAtIndex:i-1]objectForKey:@"x"]floatValue];
      float deltay = [[[profil objectAtIndex:i]objectForKey:@"y"]floatValue] - [[[profil objectAtIndex:i-1]objectForKey:@"y"]floatValue];
      float steigung= atanf(deltay/deltax);
//      steigung *= -1;
      steigungo+=steigung;
      anzWerte++;
      //NSLog(@"start i: %d steigung o: %2.3f grad: %2.3f",i,steigung, steigung/M_PI*180);
   }

   // Unterseite
   for (i=anfangsindex;i<endindex;i++)
   {
      int endi=[profil count]-1-i;
      float deltax = [[[profil objectAtIndex:[profil count]-1-i-1]objectForKey:@"x"]floatValue] - [[[profil objectAtIndex:[profil count]-1-i]objectForKey:@"x"]floatValue];
      float deltay = [[[profil objectAtIndex:[profil count]-1-i-1]objectForKey:@"y"]floatValue] - [[[profil objectAtIndex:[profil count]-1-i]objectForKey:@"y"]floatValue];
      float steigung= atanf(deltay/deltax);
//      steigung *= -1;
      steigungu+= steigung;
      //NSLog(@"end i: %d steigung u: %2.3f grad: %2.3f",endi,steigung, steigung/M_PI*180);
   
   }
   steigungo /=anzWerte;
   steigungu /=anzWerte;
  // NSLog(@"steigungo: %1.2f steigungu: %2.2f",steigungo*180/M_PI,steigungu*180/M_PI);
   float mittelwert = (steigungo+steigungu)/2;
   return mittelwert;
}

- (void)setSpeed:(float)dieGeschwindigkeit
{
	speed = dieGeschwindigkeit; // Vorschubgeschwindigkeit
}

- (void)setredpwm:(float)red_pwmwert
{
	red_pwm = red_pwmwert; // reduzierte Heizleistung
}


- (int)speed
{
   return speed;
}

/*
Berechnet Angaben fuer den StepperController aus den Koordinaten von Startpunkt, Endpunkt, zoomfaktor.
 fuer einen linearen Abschnitt
Rueckgabe:
Dic mit Daten:
schrittex, schrittey: Schritte in x und y-Richtung
 
 Datenbreite ist 15 bit. 
 Negative Zahlen werden invertiert und 0x8000 dazugezaehlt 
 
delayx, delayy:	Zeit fuer einen Schritt in x/y-Richtung, Einheit 100us
*/
- (NSDictionary*)SteuerdatenVonDic:(NSDictionary*)derDatenDic
{

    //NSLog(@"SteuerdatenVonDic: %@",[derDatenDic description]);
	int  anzSchritte;
   int  anzaxplus=0;
   int  anzaxminus=0;
   int  anzayplus=0;
   int  anzayminus=0;

   int  anzbxplus=0;
   int  anzbxminus=0;
   int  anzbyplus=0;
   int  anzbyminus=0;
   

	if ([derDatenDic count]==0) 
	{
		return NULL;
	}
   
   // home detektieren
   int code=0;
   if ([derDatenDic objectForKey:@"code"])
        {
           code = [[derDatenDic objectForKey:@"code"]intValue];
        }
   
	float zoomfaktor = [[derDatenDic objectForKey:@"zoomfaktor"]floatValue];
	//NSLog(@"zoomfaktor: %.3f",zoomfaktor);
	zoomfaktor=1;
	NSPoint StartPunkt= NSPointFromString([derDatenDic objectForKey:@"startpunkt"]);
	NSPoint StartPunktA= NSPointFromString([derDatenDic objectForKey:@"startpunkta"]);
	NSPoint StartPunktB= NSPointFromString([derDatenDic objectForKey:@"startpunktb"]);
	//StartPunkt.x *=zoomfaktor;
	//StartPunkt.y *=zoomfaktor;
	
	NSPoint EndPunkt=NSPointFromString([derDatenDic objectForKey:@"endpunkt"]);
	NSPoint EndPunktA=NSPointFromString([derDatenDic objectForKey:@"endpunkta"]);
	NSPoint EndPunktB=NSPointFromString([derDatenDic objectForKey:@"endpunktb"]);
	//EndPunkt.x *=zoomfaktor;
	//EndPunkt.y *=zoomfaktor;
	//NSLog(@"StartPunkt x: %.2f y: %.2f EndPunkt.x: %.2f y: %.2f",StartPunkt.x,StartPunkt.y,EndPunkt.x, EndPunkt.y);
	
	//NSMutableDictionary* tempDatenDic=[[[NSMutableDictionary alloc]initWithDictionary:derDatenDic]autorelease];
	NSMutableDictionary* tempDatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [tempDatenDic addEntriesFromDictionary:derDatenDic];
	float DistanzX= EndPunkt.x - StartPunkt.x;
	float DistanzAX= EndPunktA.x - StartPunktA.x;
	float DistanzBX= EndPunktB.x - StartPunktB.x;

	float DistanzY= EndPunkt.y - StartPunkt.y;
	float DistanzAY= EndPunktA.y - StartPunktA.y;
	float DistanzBY= EndPunktB.y - StartPunktB.y;
   
   [tempDatenDic setObject:[NSNumber numberWithFloat:DistanzAX] forKey: @"distanzax"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:DistanzAY] forKey: @"distanzay"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:DistanzBX] forKey: @"distanzbx"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:DistanzBY] forKey: @"distanzby"];

   
	float Distanz= sqrt(pow(DistanzX,2)+ pow(DistanzY,2));	// effektive Distanz
	float DistanzA= hypotf(DistanzAX,DistanzAY);	// effektive Distanz A
	float DistanzB= hypotf(DistanzBX,DistanzBY);	// effektive Distanz B

   [tempDatenDic setObject:[NSNumber numberWithFloat:DistanzA] forKey: @"distanza"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:DistanzB] forKey: @"distanzb"];

   if (DistanzA< 0.5 || DistanzB < 0.5)
   {
   //   NSLog(@"i:  DistanzA: %2.2f DistanzB: %2.2f",DistanzA,DistanzB);
   }
	
   float Zeit = Distanz/speed;												//	Schnittzeit für Distanz
   float ZeitA = DistanzA/speed;												//	Schnittzeit für Distanz A
   float ZeitB = DistanzB/speed;												//	Schnittzeit für Distanz B
   int relevanteSeite=0; // seite A
   float relevanteZeit = 0;
   
   int motorstatus=0;
   
   if (ZeitB > ZeitA)
   {
      relevanteZeit = ZeitB;
      relevanteSeite=1; // Seite B
      if (abs(DistanzBY) > abs(DistanzBX))
      {
         
         motorstatus |= (1<<MOTOR_D);
      }
      else 
      {
         motorstatus |= (1<<MOTOR_C);
      }
   }
   else 
   {
      relevanteZeit = ZeitA;
      if (abs(DistanzAY) > abs(DistanzAX))
      {
          motorstatus |= (1<<MOTOR_B);
      }
      else 
      {
          motorstatus |= (1<<MOTOR_A);
      }

   }

   
   //NSLog(@"motorstatus: DistanzAX:\t%2.2f\t DistanzAY:\t%2.2f\t DistanzBX:\t%2.2f\t DistanzBY:\t%2.2f\tmotorstatus: %d",DistanzAX,DistanzAY,DistanzBX,DistanzBY,motorstatus);

//   NSLog(@"motorstatus: %d",motorstatus);
   /*
    Routine aus CNCSlave fuer Feststellung des rel Motors
    if (StepCounterA > StepCounterB) 
    {
    if (StepCounterA > StepCounterC)
    {
    if (StepCounterA > StepCounterD) // A max
    {
    motorstatus |= (1<<COUNT_A);
    //lcd_putc('A');
    }
    else //A>B A>C D>A
    {
    motorstatus |= (1<<COUNT_D);
    //lcd_putc('D');
    }
    
    }//A>C
    else // A>B A<C: A weg, B weg
    {
    if (StepCounterC > StepCounterD)
    {
    motorstatus |= (1<<COUNT_C);
    //lcd_putc('C');
    }
    else // A>B A<C D>C B weg, 
    {
    motorstatus |= (1<<COUNT_D);
    //lcd_putc('D');
    }
    
    
    }
    }// A>B
    
    else // B>A A weg
    {
    if (StepCounterB > StepCounterC) // C weg
    {
    if (StepCounterB > StepCounterD) // D weg
    {
    motorstatus |= (1<<COUNT_B);
    //lcd_putc('B');
    }
    else
    {
    motorstatus |= (1<<COUNT_D);
    //lcd_putc('D');
    }
    }
    else // B<C B weg
    {  
    if (StepCounterC > StepCounterD) // D weg
    {
    motorstatus |= (1<<COUNT_C);
    //lcd_putc('C');
    }
    else // D>C C weg
    {
    motorstatus |= (1<<COUNT_D);
    //lcd_putc('D');
    }
    
    }
    }
    // end relevanter Motor

    
    */
   
   float relZeit= fmaxf(ZeitA,ZeitB);                             // relevante Zeit: grössere Zeit gibt korrekte max Schnittgeschwindigkeit 
   
   [tempDatenDic setObject:[NSNumber numberWithFloat:relZeit] forKey: @"relevantezeit"];

   //NSLog(@"ZeitA: %2.4f ZeitB: %2.4f",ZeitA,ZeitB);
	int SchritteX=steps*DistanzX;													//	Schritte in X-Richtung
	int SchritteAX=steps*DistanzAX;													//	Schritte in X-Richtung A
	int SchritteBX=steps*DistanzBX;													//	Schritte in X-Richtung B
  
	/*
    int  anzayplus=0;
    int  anzayminus=0;
    int  anzaxplus=0;
    int  anzaxminus=0;
    
    int  anzbxplus=0;
    int  anzbxminus=0;
    int  anzbyplus=0;
    int  anzbyminus=0;
 
    */

   [tempDatenDic setObject:[NSNumber numberWithInt:motorstatus] forKey: @"motorstatus"];
   
   [tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteX] forKey: @"schrittex"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteAX] forKey: @"schritteax"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteBX] forKey: @"schrittebx"];

	//NSLog(@"SchritteX raw %d",SchritteX);
	
	int SchritteY=steps*DistanzY;	//	Schritte in Y-Richtung
	int SchritteAY=steps*DistanzAY;	//	Schritte in Y-Richtung A
	int SchritteBY=steps*DistanzBY;	//	Schritte in Y-Richtung B
   
    
   if (DistanzA< 0.5 || DistanzB < 0.5)
   {
      //NSLog(@"DistanzA: %2.2f DistanzB: %2.2f * SchritteAX: %d SchritteAY: %d * SchritteBX: %d SchritteBY: %d",DistanzAX,DistanzAY,SchritteAX,SchritteAY,SchritteBX,SchritteBY);
   }

	[tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteY] forKey: @"schrittey"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteAY] forKey: @"schritteay"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteBY] forKey: @"schritteby"];
   
	
   //NSLog(@"SchritteY raw %d",SchritteY);
	
	if (SchritteX < 0) // negative Zahl
	{
		SchritteX *= -1;
		SchritteX &= 0x7FFF;
		//NSLog(@"SchritteX nach *-1 und 0x7FFFF %d",SchritteX);
		SchritteX |= 0x8000;
	}
   
	if (SchritteAX < 0) // negative Zahl
	{
      anzaxminus += SchritteAX;
		SchritteAX *= -1;
		SchritteAX &= 0x7FFF;
		//NSLog(@"SchritteAX nach *-1 und 0x7FFFF %d",SchritteAX);
		SchritteAX |= 0x8000;
	}
   else
   {
      anzaxplus += SchritteAX;
   }
   
 	if (SchritteBX < 0) // negative Zahl
	{
      anzbxminus += SchritteBX;
		SchritteBX *= -1;
		SchritteBX &= 0x7FFF;
		SchritteBX |= 0x8000;
	}
   else
   {
      anzbxplus += SchritteBX;
   }
   
  
	
	 
	if (SchritteY < 0) // negative Zahl
	{
		SchritteY= SchritteY *-1;
		SchritteY &= 0x7FFF;
		SchritteY |= 0x8000;
		//NSLog(@"SchritteY negativ: %d",SchritteY);
	}
   
	if (SchritteAY < 0) // negative Zahl
	{
      anzayminus += SchritteAY;
		SchritteAY *= -1;
		SchritteAY &= 0x7FFF;
		SchritteAY |= 0x8000;
	}
   else
   {
      anzayplus += SchritteAY;
   }
   
	if (SchritteBY < 0) // negative Zahl
	{
      anzbyminus += SchritteBY;
		SchritteBY *= -1;
		SchritteBY &= 0x7FFF;
		SchritteBY |= 0x8000;
	}
   else
   {
      anzbyplus += SchritteBY;
   }
   
   [tempDatenDic setObject:[NSNumber numberWithInt:anzaxplus] forKey:@"anzaxplus"];
   [tempDatenDic setObject:[NSNumber numberWithInt:anzaxminus] forKey:@"anzaxminus"];
   [tempDatenDic setObject:[NSNumber numberWithInt:anzayplus] forKey:@"anzayplus"];
   [tempDatenDic setObject:[NSNumber numberWithInt:anzayminus] forKey:@"anzayminus"];
   
   [tempDatenDic setObject:[NSNumber numberWithInt:anzbxplus] forKey:@"anzbxplus"];
   [tempDatenDic setObject:[NSNumber numberWithInt:anzbxminus] forKey:@"anzbxminus"];
   [tempDatenDic setObject:[NSNumber numberWithInt:anzbyplus] forKey:@"anzbyplus"];
   [tempDatenDic setObject:[NSNumber numberWithInt:anzbyminus] forKey:@"anzbyminus"];

   
	// schritt x
	

	[tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteAX & 0xFF)] forKey: @"schritteaxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteAX >> 8) & 0xFF)] forKey: @"schritteaxh"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteBX & 0xFF)] forKey: @"schrittebxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteBX >> 8) & 0xFF)] forKey: @"schrittebxh"];
	


	// schritte y

   [tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteAY & 0xFF)] forKey: @"schritteayl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteAY >> 8) & 0xFF)] forKey: @"schritteayh"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteBY & 0xFF)] forKey: @"schrittebyl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteBY >> 8) & 0xFF)] forKey: @"schrittebyh"];

   
	
	float delayX= ((relZeit/(SchritteX & 0x7FFF))*100000)/10;							// Zeit fuer einen Schritt in 100us-Einheit
	float delayAX= ((relZeit/(SchritteAX & 0x7FFF))*100000)/10;							// Zeit fuer einen Schritt AX in 100us-Einheit
	float delayBX= ((relZeit/(SchritteBX & 0x7FFF))*100000)/10;							// Zeit fuer einen Schritt BX in 100us-Einheit
	
      
   float delayY= ((relZeit/(SchritteY & 0x7FFF))*100000)/10;
   float delayAY= ((relZeit/(SchritteAY & 0x7FFF))*100000)/10;
   float delayBY= ((relZeit/(SchritteBY & 0x7FFF))*100000)/10;
	
	//NSLog(@"DistanzX: \t%.2f \tDistanzY: \t%.2f \tDistanz: \t%.2f \tZeit: \t%.3f  \tdelayX: \t%.1f\t  delayY: \t%.1f \tSchritteX: \t%d \tSchritteY: \t%d",DistanzX,DistanzY,Distanz, Zeit, delayX, delayY, SchritteX,SchritteY);
	
	
	

   [tempDatenDic setObject:[NSNumber numberWithFloat:delayAX] forKey: @"delayax"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:delayAY] forKey: @"delayay"];

   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayAX & 0xFF)] forKey: @"delayaxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayAX >> 8) & 0xFF)] forKey: @"delayaxh"];

   [tempDatenDic setObject:[NSNumber numberWithFloat:delayBX] forKey: @"delaybx"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:delayBY] forKey: @"delayby"];
   
   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayBX & 0xFF)] forKey: @"delaybxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayBX >> 8) & 0xFF)] forKey: @"delaybxh"];



   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayAY & 0xFF)] forKey: @"delayayl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayAY >> 8) & 0xFF)] forKey: @"delayayh"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayBY & 0xFF)] forKey: @"delaybyl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayBY >> 8) & 0xFF)] forKey: @"delaybyh"];
   
	[tempDatenDic setObject:[NSNumber numberWithInt :code] forKey: @"code"];
	[tempDatenDic setObject:[NSNumber numberWithInt :code] forKey: @"codea"];
	[tempDatenDic setObject:[NSNumber numberWithInt :0] forKey: @"codeb"];
   
   // relevanter Motor
   
    
   // index
   int index=[[derDatenDic objectForKey:@"index"]intValue];
   int indexl, indexh;
   indexl=index & 0xFF;
   indexh=((index >> 8) & 0xFF);
   [tempDatenDic setObject:[NSNumber numberWithInt:(index & 0xFF)] forKey: @"indexl"];
	[tempDatenDic setObject:[NSNumber numberWithInt:((index >> 8) & 0xFF)] forKey: @"indexh"];
   //NSLog(@"SteuerdatenVonDic index: %d indexl: %d indexh: %d", index, indexl, indexh);
   //NSLog(@"SteuerdatenVonDic ZeitA: %1.5f  ZeitB: %1.5f relSeite: %d code: %d",ZeitA,ZeitB,relevanteSeite,code);
	//NSLog(@"SteuerdatenVonDic tempDatenDic: %@",[tempDatenDic description]);
	return tempDatenDic;
}




- (NSArray*)SteuerdatenArrayVonDic:(NSDictionary*)derDatenDic // Rampen am Anfang und Ende
{
      // CNC mit Rampe
   NSLog(@"SteuerdatenArrayVonDic: %@",[derDatenDic description]);
	int  anzSchritte;
	if ([derDatenDic count]==0) 
	{
		return NULL;
	}
	float zoomfaktor = [[derDatenDic objectForKey:@"zoomfaktor"]floatValue];
	//NSLog(@"zoomfaktor: %.3f",zoomfaktor);
	zoomfaktor=1;
	NSPoint StartPunkt= NSPointFromString([derDatenDic objectForKey:@"startpunkt"]);
	//StartPunkt.x *=zoomfaktor;
	//StartPunkt.y *=zoomfaktor;
	
	NSPoint EndPunkt=NSPointFromString([derDatenDic objectForKey:@"endpunkt"]);
	//EndPunkt.x *=zoomfaktor;
	//EndPunkt.y *=zoomfaktor;
	//NSLog(@"StartPunkt x: %.2f y: %.2f EndPunkt.x: %.2f y: %.2f",StartPunkt.x,StartPunkt.y,EndPunkt.x, EndPunkt.y);
	
	//NSMutableDictionary* tempDatenDic=[[[NSMutableDictionary alloc]initWithDictionary:derDatenDic]autorelease];
	NSMutableDictionary* tempDatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [tempDatenDic addEntriesFromDictionary:derDatenDic];
	float DistanzX= EndPunkt.x - StartPunkt.x;
	float DistanzY= EndPunkt.y - StartPunkt.y;
	//float Distanz= sqrt(pow(DistanzX,2)+ pow(DistanzY,2));         // effektive Distanz
   float Distanz = hypot(DistanzX,DistanzY);
	float Zeit = Distanz/speed;												//	Schnittzeit für Distanz
   
	int SchritteX=steps*DistanzX;												//	Schritte in X-Richtung
   int SchritteY=steps*DistanzY;                                  //	Schritte in Y-Richtung
   
   //NSLog(@"SchritteX raw %d",SchritteX);
   int relevanteSchritte = SchritteX;
   if (SchritteY > SchritteX)
   {
      relevanteSchritte = SchritteY;
   }
   NSLog(@"SteuerdatenVonDic relevanteSchritte: %d",relevanteSchritte);
	if (relevanteSchritte < 96) // Rampen lohnt sich nicht
   {
      return [NSArray arrayWithObject:[self SteuerdatenVonDic:derDatenDic]];
   }
   
   int teilabschnitt=24; // Abschnitt mit konstanter Geschwindigkeit
   
   int anzTeile=relevanteSchritte / teilabschnitt; // mindestens 4
   int Rampenstufen=anzTeile/2;                    // symmetrische Rampen, mindestens 2
   int stufe=0;
   NSMutableArray* tempArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   int i=0;
   for (i=0; i<relevanteSchritte; i++)
   {
      if (i<anzTeile) 
      {
         
         stufe++;
      }
   }
   
   [tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteX] forKey: @"schrittex"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteY] forKey: @"schrittey"];
	//NSLog(@"SchritteY raw %d",SchritteY);
}

// ohne Abbrand

- (NSArray*)SchnittdatenVonDic:(NSDictionary*)derDatenDic
{
   
   /*
    Bereitet die Angaben im Steuerdatenarray für die Uebergabe an den USB vor.
    Alle 16Bit-Zahlen werden aufgeteilt in highbyte und lowbyte
    
    Aufbau:
    
    delayx = 269;
    delayy = 115;
    endpunkt = "{50, 50.2}";
    schrittex = "-18";
    schrittey = "-42";
    startpunkt = "{52, 54.9}";
    zoomfaktor = "0.19";
    
    Array:
    
    schritteax lb
    schritteax hb
    schritteay lb
    schritteay hb
    
    delayax lb
    delayax hb
    delayay lb
    delayay hb
    
    schrittebx lb
    schrittebx hb
    schritteby lb
    schritteby hb
    
    delaybx lb
    delaybx hb
    delayby lb
    delayby hb
    
    code
    position // first, last, ...
    indexh
    indexl
    
    pwm (pos 20)
    motorstatus (pos 21)
    */
   
   if ([[derDatenDic objectForKey:@"indexl"]intValue] < 3)
   {
      //NSLog(@"SchnittdatenVonDic derDatenDic: %@",[derDatenDic description]);
   }
   //NSLog(@"SchnittdatenVonDic index: %d",[[derDatenDic objectForKey:@"indexl"]intValue]);
   
	NSMutableArray* tempArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int tempDataL=0;
	int tempDataH=0;
	tempDataL=[[derDatenDic objectForKey:@"schrittex"]intValue]& 0xFF;
	tempDataH=([[derDatenDic objectForKey:@"schrittex"]intValue]>>8)&0xFF;
	//NSLog(@"tempData int: %d hex: %X tempDataL int: %d hex: %X tempDataH int: %d hex: %X",tempData,tempData,tempDataL,tempDataL,tempDataH,tempDataH);
   //NSLog(@"tempData int: %d tempDataL int: %d  tempDataH int: %d ",tempData,tempDataL,tempDataH);
   
   // Seite A
   [tempArray addObject:[derDatenDic objectForKey:@"schritteaxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schritteaxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schritteayl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schritteayh"]];
   
   
   [tempArray addObject:[derDatenDic objectForKey:@"delayaxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delayaxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delayayl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delayayh"]];
   
   
   // Seite B
   [tempArray addObject:[derDatenDic objectForKey:@"schrittebxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schrittebxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schrittebyl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schrittebyh"]];
   
   [tempArray addObject:[derDatenDic objectForKey:@"delaybxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delaybxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delaybyl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delaybyh"]];
   
   
	[tempArray addObject:[derDatenDic objectForKey:@"code"]];
   
   
   if ([derDatenDic objectForKey:@"position"])
   {
      [tempArray addObject:[derDatenDic objectForKey:@"position"]]; 
   }
   else
   {
      [tempArray addObject:[NSNumber numberWithInt:0]];
   }// Beschreibung der Lage innerhalb des Schnitt-Polygons: first, last, 
   
   
	[tempArray addObject:[derDatenDic objectForKey:@"indexh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"indexl"]];
   
   if ([derDatenDic objectForKey:@"pwm"])
   {
      [tempArray addObject:[derDatenDic objectForKey:@"pwm"]];
   }
   else 
   {
      [tempArray addObject:[NSNumber numberWithInt:0]];
   }
   
   if ([derDatenDic objectForKey:@"motorstatus"])
   {
      //NSLog(@"Schnittdaten motorstatus: %d",[[derDatenDic objectForKey:@"motorstatus"]intValue]);
      [tempArray addObject:[derDatenDic objectForKey:@"motorstatus"]];
   }
   else 
   {
      [tempArray addObject:[NSNumber numberWithInt:1]];
   }
   
   //NSLog(@"tempArray indexl: %d",[[derDatenDic objectForKey:@"indexl"]intValue]);
   //NSLog(@"SchnittdatenVonDic tempArray: %@",[tempArray description]);
   //NSLog(@"SchnittdatenVonDic tempArray count: %d",[tempArray count]);
   
   
   return tempArray;
}


// mit Abbrand

- (NSArray*)SchnittdatenVonDic:(NSDictionary*)derDatenDic mitAbbrand:(int)mitabbrand
{
   
   /*
    Bereitet die Angaben im Steuerdatenarray für die Uebergabe an den USB vor.
    Alle 16Bit-Zahlen werden aufgeteilt in highbyte und lowbyte
    
    Aufbau:
    
    delayx = 269;
    delayy = 115;
    endpunkt = "{50, 50.2}";
    schrittex = "-18";
    schrittey = "-42";
    startpunkt = "{52, 54.9}";
    zoomfaktor = "0.19";
    
    Array:
    
    schritteax lb
    schritteax hb
    schritteay lb
    schritteay hb
    
    delayax lb
    delayax hb
    delayay lb
    delayay hb

    schrittebx lb
    schrittebx hb
    schritteby lb
    schritteby hb
    
    delaybx lb
    delaybx hb
    delayby lb
    delayby hb

    code
    position // first, last, ...
    indexh
    indexl
    
    pwm (pos 20)
    motorstatus (pos 21)
    */
	//NSLog(@"SchnittdatenVonDic derDatenDic: %@",[derDatenDic description]);
   //NSLog(@"SchnittdatenVonDic index: %d",[[derDatenDic objectForKey:@"indexl"]intValue]);
   
	NSMutableArray* tempArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int tempDataL=0;
	int tempDataH=0;
	tempDataL=[[derDatenDic objectForKey:@"schrittex"]intValue]& 0xFF;
	tempDataH=([[derDatenDic objectForKey:@"schrittex"]intValue]>>8)&0xFF;
	//NSLog(@"tempData int: %d hex: %X tempDataL int: %d hex: %X tempDataH int: %d hex: %X",tempData,tempData,tempDataL,tempDataL,tempDataH,tempDataH);
   //NSLog(@"tempData int: %d tempDataL int: %d  tempDataH int: %d ",tempData,tempDataL,tempDataH);
   
    // Seite A
   [tempArray addObject:[derDatenDic objectForKey:@"schritteaxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schritteaxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schritteayl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schritteayh"]];
   
   
   [tempArray addObject:[derDatenDic objectForKey:@"delayaxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delayaxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delayayl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delayayh"]];
   
   
   // Seite B
   [tempArray addObject:[derDatenDic objectForKey:@"schrittebxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schrittebxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schrittebyl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"schrittebyh"]];

   [tempArray addObject:[derDatenDic objectForKey:@"delaybxl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delaybxh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delaybyl"]];
	[tempArray addObject:[derDatenDic objectForKey:@"delaybyh"]];
  
   
	[tempArray addObject:[derDatenDic objectForKey:@"code"]];
    
   
   if ([derDatenDic objectForKey:@"position"])
   {
      [tempArray addObject:[derDatenDic objectForKey:@"position"]]; 
   }
   else
   {
      [tempArray addObject:[NSNumber numberWithInt:0]];
   }// Beschreibung der Lage innerhalb des Schnitt-Polygons: first, last, 

	[tempArray addObject:[derDatenDic objectForKey:@"indexh"]];
	[tempArray addObject:[derDatenDic objectForKey:@"indexl"]];
   
   if ([derDatenDic objectForKey:@"pwm"])
   {
      [tempArray addObject:[derDatenDic objectForKey:@"pwm"]];
   }
   else 
   {
      [tempArray addObject:[NSNumber numberWithInt:0]];
   }

   if ([derDatenDic objectForKey:@"motorstatus"])
   {
      //NSLog(@"Schnittdaten motorstatus: %d",[[derDatenDic objectForKey:@"motorstatus"]intValue]);
      [tempArray addObject:[derDatenDic objectForKey:@"motorstatus"]];
   }
   else 
   {
      [tempArray addObject:[NSNumber numberWithInt:1]];
   }
   
   //NSLog(@"SchnittdatenVonDic tempArray: %@",[tempArray description]);
   //NSLog(@"SchnittdatenVonDic tempArray count: %d",[tempArray count]);
   
   return tempArray;
}

/*
- (void)makeVollschritt:(int)anzSchritte inRichtung:(int)richtung mitDelay:(int)delay
{
uint16_t	z;
uint8_t n
for (z=0; z<anzSchritte; z++)
{ 
PortA=vs[n & 3]; warte10ms(); n++;
}

}

//Schrittmotor-Steuerprogramm in C
//In C schreibt man die Folge der Bytewerte zum Ansteuern des Schrittmotor am besten in Arrays:
uint8_t vs[4]={9,5,6,10},	//Tabelle Vollschritt Rechtslauf 
hs[8]={9,1,5,4,6,2,10,8}; //Tabelle Halbschritt Rechtslauf
//Will man nun z.B. 1000 Schritte benötigt man eine Variable z zum Zählen der Anzahl der durchgeführten Schritte und eine Variable n für die Schrittnummer:
uint16_t	z, n=0;
//Das Programm für Vollschrittbetrieb kann dann so aussehen:
DDRA=0x0f; //Motor ist an Bit 0,1, 2 und 3 von Port A angeschlossen. 
for (z=0; z<1000; z++)
{ 
PortA=vs[n & 3]; warte10ms(); n++;
}
//Mit der Und-Verknüpfung n & 3 werden aus der Schrittvariablen n die letzten beiden Bits ausmaskiert. n & 3 durchläuft so beim Hochzählen von n periodisch die Werte 0, 1, 2 und 3. Mit PortA=vs[n & 3] wird der Bytewert aus der Tabelle vz gelesen und zum Schrittmotor übertragen.
//Die Funktion warte10ms() sorgt dann für notwendige die Schaltverzögerung von 10 ms.
*/

- (NSArray*)PfeilvonPunkt:(NSPoint) Startpunkt mitLaenge:(int)laenge inRichtung:(int)richtung
{
   int schritte=laenge*steps;
 	NSMutableArray* PfeilKoordinatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   /*
    richtung
    right: 0
    up:   1
    left:   2
    down:  3
    */
   
   // Schrittlaenge
	float schrittlaenge=1.0;
	
	// Anzahl Schritte:
	int anzSchritte =laenge/schrittlaenge;

   float deltaX=0.0;
   float deltaY=0.0;
   
  	switch (richtung) 
   {
      case 0: // rechts
      {
         deltaX = 1.0;
         deltaY = 0.0;
      }
         break;
         
      case 1: // up
      {
         deltaX = 0.0;
         deltaY = 1.0;
      }
         break;
         
      case 2: // left
      {
         //Startpunkt.x = laenge;    
         deltaX = -1.0;
         deltaY = 0.0;
      }
         break;
         
      case 3: // down
      {
         //Startpunkt.y = laenge;
         deltaX = 0.0;
         deltaY = -1.0;
      }
         break;
         
      default:
         break;
   } // switch

   float tempX= Startpunkt.x;
   float tempY= Startpunkt.y;
   
   int index;
	for(index = 0;index < anzSchritte;index++)
	{
      NSNumber* KoordinateX=[NSNumber numberWithFloat:tempX];
      NSNumber* KoordinateY=[NSNumber numberWithFloat:tempY];

      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateX, @"x",KoordinateY,@"y" ,[NSNumber numberWithInt:index],@"index",[NSNumber numberWithFloat:full_pwm], nil];
		[PfeilKoordinatenArray addObject:tempDic];

      tempX += deltaX;
      tempY += deltaY;
      
   }
   
   //NSLog(@"PfeilKoordinatenArray: %@",[PfeilKoordinatenArray description]);

   return PfeilKoordinatenArray;
}

- (NSArray*)LinieVonPunkt:(NSPoint)Anfangspunkt mitLaenge:(float)laenge mitWinkel:(int)winkel
{
   //Winkel 0 ist Richtung der x-Achse, CCW
   NSMutableArray* LinienKoordinatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   float deltaX = laenge * cos(winkel*(M_PI/180));
   float deltaY = laenge * sin(winkel*(M_PI/180));
   
   NSPoint Startpunkt = Anfangspunkt;
   NSPoint Endpunkt = Startpunkt;
   Endpunkt.x += deltaX;
   Endpunkt.y += deltaY;
   
   [LinienKoordinatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
                              NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1.0],@"zoomfaktor",[NSNumber numberWithInt:0],@"index" ,NULL]];

      return LinienKoordinatenArray;
}


- (NSArray*)QuadratVonPunkt:(NSPoint)EckeLinksUnten mitSeite:(float)Seite mitLage:(int)Lage
{
	NSLog(@"QuadratVonPunkt: EckeLinksUnten x: %2.2f y: %2.2f Seite: %2.2f",EckeLinksUnten.x, EckeLinksUnten.y, Seite);
	NSMutableArray* tempDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	// waagrecht rechts
	//NSPoint Startpunkt=NSMakePoint(0,0);
	NSPoint Startpunkt= EckeLinksUnten;
	NSPoint Endpunkt=EckeLinksUnten;//NSMakePoint(Seite,0);
	float X=EckeLinksUnten.x;
	float Y=EckeLinksUnten.y;
	
	int anzSchritte =4;
	
	NSMutableArray* PolygonpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	/*
	 Lage: 
	 0: rechts oben von Startpunkt		|_
	 
	 1: links oben von Startpunkt		  _|
    
    2: links unten von Startpunkt	  ¯|
	 
	 3: rechts unten von Startpunkt		|¯
	 */
	
	int index;
   
	switch (Lage)
	{
		case 0:
		{
			// waagrecht rechts
			Endpunkt.x = X+Seite;
			int anzDaten=0x20;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor",[NSNumber numberWithInt:0],@"index" ,NULL]];
			// senkrecht up
			Startpunkt=Endpunkt;
			Endpunkt.y=Y+Seite;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:1],@"index" ,NULL]];
			
			// waagrecht links
			Startpunkt=Endpunkt;
			Endpunkt.x=X;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:2],@"index" ,NULL]];
			
			// senkrecht down
			Startpunkt=Endpunkt;
			Endpunkt.y=Y;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:3],@"index" ,NULL]];
			
		}break;
         
      case 1:
		{
			// waagrecht links
			Endpunkt.x = X-Seite;
			int anzDaten=0x20;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:0],@"index" ,NULL]];
			// senkrecht up
			Startpunkt=Endpunkt;
			Endpunkt.y=Y+Seite;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:1],@"index" ,NULL]];
			
			// waagrecht rechts
			Startpunkt=Endpunkt;
			Endpunkt.x=X;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:2],@"index" ,NULL]];
			
			// senkrecht down
			Startpunkt=Endpunkt;
			Endpunkt.y=Y;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:3],@"index" ,NULL]];
		}break;
         
      case 2:
		{
			// waagrecht links
			Endpunkt.x = X-Seite;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:0],@"index" ,NULL]];
			// senkrecht down
			Startpunkt=Endpunkt;
			Endpunkt.y=Y-Seite;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:1],@"index" ,NULL]];
			
			// waagrecht rechts
			Startpunkt=Endpunkt;
			Endpunkt.x=X;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:2],@"index" ,NULL]];
			
			// senkrecht up
			Startpunkt=Endpunkt;
			Endpunkt.y=Y;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:3],@"index" ,NULL]];
		}break;
         
		case 3:
		{
			// waagrecht rechts
			Endpunkt.x = X+Seite;
			int anzDaten=0x20;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:0],@"index" ,NULL]];
			// senkrecht down
			Startpunkt=Endpunkt;
			Endpunkt.y=Y-Seite;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:1],@"index" ,NULL]];
			
			// waagrecht links
			Startpunkt=Endpunkt;
			Endpunkt.x=X;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:2],@"index" ,NULL]];
			
			// senkrecht up
			Startpunkt=Endpunkt;
			Endpunkt.y=Y;
			[tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromPoint(Startpunkt), @"startpunkt",
												NSStringFromPoint(Endpunkt), @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:3],@"index" ,NULL]];
		}break;
         
         
         
	}//switch lage
	
	
	
	
	
	return tempDatenArray;
}

- (NSArray*)QuadratKoordinatenMitSeite:(float)Seite mitWinkel:(float)Winkel
{
	NSLog(@"QuadratmitSeite: %2.2f  Winkel: %2.2f", Seite,Winkel);
	NSMutableArray* tempDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	// waagrecht rechts
	NSPoint Eckpunkt=NSMakePoint(0,0);
	
	int anzSchritte =4;
	int index=0;
	NSMutableArray* PolygonpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	/*
    Winkel: Grad, waagrecht nach rechts = 0°	CCW */
	//      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateX, @"x",KoordinateY,@"y" ,[NSNumber numberWithInt:index],@"index", nil];
   
   // Startpunkt
   [tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:Eckpunkt.x],@"x",[NSNumber numberWithFloat:Eckpunkt.y],@"y",[NSNumber numberWithInt:index],@"index" ,NULL]];

	
   float winkel=Winkel*M_PI/180;
   NSLog(@"QuadratmitSeite winkel rad: %2.2f", winkel);
   // waagrecht rechts
   
   Eckpunkt.x +=Seite*cos(winkel);
   Eckpunkt.y +=Seite*sin(winkel);

   [tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:Eckpunkt.x],@"x",[NSNumber numberWithFloat:Eckpunkt.y],@"y",[NSNumber numberWithInt:index],@"index" ,NULL]];

    // nach oben
   index++;
   Eckpunkt.x -= Seite*sin(winkel);
   Eckpunkt.y += Seite*cos(winkel);
   [tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:Eckpunkt.x],@"x",[NSNumber numberWithFloat:Eckpunkt.y],@"y",[NSNumber numberWithInt:index],@"index" ,NULL]];

   
   // nach links
   index++;
   Eckpunkt.x -= Seite*cos(winkel);
   Eckpunkt.y -= Seite*sin(winkel);
   [tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:Eckpunkt.x],@"x",[NSNumber numberWithFloat:Eckpunkt.y],@"y",[NSNumber numberWithInt:index],@"index" ,NULL]];

   
   // nach unten
   index++;
   
   Eckpunkt = NSMakePoint(0,0);;
   [tempDatenArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:Eckpunkt.x],@"x",[NSNumber numberWithFloat:Eckpunkt.y],@"y",[NSNumber numberWithInt:index],@"index" ,NULL]];

   
   
   

   NSLog(@"QuadratmitSeite: tempDatenArray: %@",[tempDatenArray description]);
	
	
	
	return tempDatenArray;
}



- (NSArray*)KreisVonPunkt:(NSPoint)Startpunkt mitRadius:(float)Radius mitLage:(int)Lage
{
	NSMutableArray* tempDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSPoint Mittelpunkt;
	/*
	 Lage: 0: ueber Startpunkt
	 1: links von Startpunkt
	 2: unter Startpunkt
	 3: rechts von Startpunkt
	 */
	switch (Lage)
	{
		case 0:
		{
			Mittelpunkt.x = Startpunkt.x;
			Mittelpunkt.y = Startpunkt.y + Radius;
		}break;
			
		case 1:
		{
			Mittelpunkt.x = Startpunkt.x - Radius;
			Mittelpunkt.y = Startpunkt.y;
		}break;
			
		case 2:
		{
			Mittelpunkt.x = Startpunkt.x;
			Mittelpunkt.y = Startpunkt.y - Radius;
		}break;
			
		case 3:
		{
			Mittelpunkt.x = Startpunkt.x + Radius;
			Mittelpunkt.y = Startpunkt.y;
		}break;
			
	}// switch Lage
	//NSLog(@"KreisVonPunkt: lage: %d Startpunkt x: %2.2f y: %2.2f Radius: %2.2f",Lage, Startpunkt.x, Startpunkt.y, Radius);
	
	// Schrittlaenge
	float Schrittlaenge=1.5;
	
	// Anzahl Schritte:
	float Umfang = Radius * M_PI;
	int anzSchritte =Umfang/Schrittlaenge;
   
 	//NSLog(@"Umfang: %2.2f anzSchritte: %d",Umfang, anzSchritte);
	
	NSMutableArray* KreispunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	int index;
	for(index=0;index<anzSchritte;index++)
	{
      float tempX=0;
      float tempY=0;
         switch (Lage)
      {
         case 3:
            tempX=Radius*cos(2*M_PI/anzSchritte*index)*-1;
            tempY=Radius*sin(2*M_PI/anzSchritte*index);
            break;
         case 1:
            tempX=Radius*cos(2*M_PI/anzSchritte*index);
            tempY=Radius*sin(2*M_PI/anzSchritte*index);
            break;

         case 2:
            tempX=Radius*sin(2*M_PI/anzSchritte*index);
            tempY=Radius*cos(2*M_PI/anzSchritte*index);
            break;
         case 0:
            tempX=Radius*sin(2*M_PI/anzSchritte*index);
            tempY=Radius*cos(2*M_PI/anzSchritte*index)*-1;
            break;
      }
		NSPoint tempKreisPunkt=NSMakePoint(tempX, tempY);
		[KreispunktArray addObject:NSStringFromPoint(tempKreisPunkt)];
		
	}// for index
	//NSLog(@"KreispunktArray: %@",[KreispunktArray description]);
	
	for(index=0;index<anzSchritte-1;index++)
	{
		NSMutableDictionary*	tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[KreispunktArray objectAtIndex:index], @"startpunkt",
										  [KreispunktArray objectAtIndex:index+1], @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" , [NSNumber numberWithInt:index],@"index",NULL];
		[tempDatenArray addObject:tempDic];
		
	}
	// Kreis schliessen zu Anfangspunkt
	NSMutableDictionary*	tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[KreispunktArray lastObject], @"startpunkt",
									  [KreispunktArray objectAtIndex:0], @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:anzSchritte-1],@"index",NULL];
	[tempDatenArray addObject:tempDic];
	
	//NSLog(@"tempDatenArray: %@",[tempDatenArray description]);
	
	return tempDatenArray;
}



- (NSArray*)KreisKoordinatenMitRadius:(float)Radius mitLage:(int)Lage
{
	NSMutableArray* tempDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSPoint Mittelpunkt = NSMakePoint(0, 0);
	/*
	 Lage: 0: ueber Startpunkt
	 1: links von Startpunkt
	 2: unter Startpunkt
	 3: rechts von Startpunkt
	 */
	switch (Lage)
	{
		case 0:
		{
			Mittelpunkt.y += Radius;
		}break;
			
		case 1:
		{
			Mittelpunkt.x -= Radius;
		}break;
			
		case 2:
		{
			Mittelpunkt.y -= Radius;
		}break;
			
		case 3:
		{
			Mittelpunkt.x +=  Radius;
		}break;
			
	}// switch Lage
	//NSLog(@"KreisVonPunkt: lage: %d Startpunkt x: %2.2f y: %2.2f Radius: %2.2f",Lage, Startpunkt.x, Startpunkt.y, Radius);
	
	// Schrittlaenge
	float Schrittlaenge=1.5;
	
	// Anzahl Schritte:
	float Umfang = Radius * M_PI;
	int anzSchritte =Umfang/Schrittlaenge;
   
 	//NSLog(@"Umfang: %2.2f anzSchritte: %d",Umfang, anzSchritte);
	
	NSMutableArray* KreispunktKoordinatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	int index;
	for(index=0;index<anzSchritte;index++)
	{
      float tempX=0;
      float tempY=0;
      float phi=2*M_PI/anzSchritte*index;
      switch (Lage)
      {
         case 3:
            tempX=Radius*cos(phi)*-1;
            tempY=Radius*sin(phi);
            break;
         case 1:
            tempX=Radius*cos(phi);
            tempY=Radius*sin(phi);
            break;
            
         case 2:
            tempX=Radius*sin(phi);
            tempY=Radius*cos(phi);
            break;
         case 0:
            tempX=Radius*sin(phi);
            tempY=Radius*cos(phi)*-1;
            break;
      }
      tempX += Mittelpunkt.x;
      tempY += Mittelpunkt.y;
      
      NSNumber* KoordinateX=[NSNumber numberWithFloat:tempX];
      NSNumber* KoordinateY=[NSNumber numberWithFloat:tempY];
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateX, @"x",KoordinateY,@"y" ,[NSNumber numberWithInt:index],@"index", nil];
		[KreispunktKoordinatenArray addObject:tempDic];
		
	}// for index
   
   [KreispunktKoordinatenArray addObject:[KreispunktKoordinatenArray objectAtIndex:0]];
   
	NSLog(@"KreispunktArray: %@",[KreispunktKoordinatenArray description]);
	
   return KreispunktKoordinatenArray;
   
}

- (NSArray*)KreisKoordinatenMitRadius:(float)Radius mitLage:(int)Lage  mitAnzahlPunkten:(int)anzahlPunkte;
{
	NSMutableArray* tempDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSPoint Mittelpunkt = NSMakePoint(0, 0);
	/*
	 Lage: 0: ueber Startpunkt
	 1: links von Startpunkt
	 2: unter Startpunkt
	 3: rechts von Startpunkt
	 */
	switch (Lage)
	{
		case 0:
		{
			Mittelpunkt.y += Radius;
		}break;
			
		case 1:
		{
			Mittelpunkt.x -= Radius;
		}break;
			
		case 2:
		{
			Mittelpunkt.y -= Radius;
		}break;
			
		case 3:
		{
			Mittelpunkt.x +=  Radius;
		}break;
			
	}// switch Lage
	//NSLog(@"KreisVonPunkt: lage: %d Startpunkt x: %2.2f y: %2.2f Radius: %2.2f",Lage, Startpunkt.x, Startpunkt.y, Radius);
	
	// Schrittlaenge
	float Schrittlaenge=1.5;
	
	// Anzahl Schritte:
	float Umfang = Radius * M_PI;
	int anzSchritte =0;
   if (anzahlPunkte == -1)
   {
      anzSchritte =Umfang/Schrittlaenge;
   }
   else
   {
      anzSchritte = anzahlPunkte;
   }

 	//NSLog(@"Umfang: %2.2f anzSchritte: %d",Umfang, anzSchritte);
	
	NSMutableArray* KreispunktKoordinatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	int index;
	for(index=0;index<anzSchritte;index++)
	{
      float tempX=0;
      float tempY=0;
      float phi=2*M_PI/anzSchritte*index;
      switch (Lage)
      {
         case 3:
            tempX=Radius*cos(phi)*-1;
            tempY=Radius*sin(phi);
            break;
         case 1:
            tempX=Radius*cos(phi);
            tempY=Radius*sin(phi);
            break;
            
         case 2:
            tempX=Radius*sin(phi);
            tempY=Radius*cos(phi);
            break;
         case 0:
            tempX=Radius*sin(phi);
            tempY=Radius*cos(phi)*-1;
            break;
      }
      tempX += Mittelpunkt.x;
      tempY += Mittelpunkt.y;
      
      NSNumber* KoordinateX=[NSNumber numberWithFloat:tempX];
      NSNumber* KoordinateY=[NSNumber numberWithFloat:tempY];
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateX, @"x",KoordinateY,@"y" ,[NSNumber numberWithInt:index],@"index", nil];
		[KreispunktKoordinatenArray addObject:tempDic];
		
	}// for index
   
   [KreispunktKoordinatenArray addObject:[KreispunktKoordinatenArray objectAtIndex:0]];
   
	//NSLog(@"KreispunktArray count: %d",[KreispunktKoordinatenArray count]);
	//NSLog(@"KreispunktArray: %@",[KreispunktKoordinatenArray description]);
	
   return KreispunktKoordinatenArray;
   
}

- (NSArray*)EllipsenKoordinatenMitRadiusA:(float)RadiusA mitRadiusB:(float)RadiusB mitLage:(int)Lage
{
	NSPoint Mittelpunkt = NSMakePoint(0, 0);
	/*
	 Lage: 0: ueber Startpunkt
	 1: links von Startpunkt
	 2: unter Startpunkt
	 3: rechts von Startpunkt
    
    www.mathematische-basteleien.de/ellipse.htm
    x=a*cos(t) /\ y=b*sin(t). 
    Der Umfang kann nicht durch eine elementare Funktion angegeben werden, nur als "elliptisches" Integral 
    Man kann das Integral näherungsweise über eine Reihenentwicklung des Integranden bestimmen. Man erhält  
    epsilon = (ra^2-rb^2)ra^2
    
	 */
   
   float epsilon = (powf(RadiusA,2)-powf(RadiusB,2))/powf(RadiusA,2);
	switch (Lage)
	{
		case 0:
		{
			Mittelpunkt.y += RadiusA;
		}break;
			
		case 1:
		{
			Mittelpunkt.x -= RadiusA;
		}break;
			
		case 2:
		{
			Mittelpunkt.y -= RadiusA;
		}break;
			
		case 3:
		{
			Mittelpunkt.x +=  RadiusA;
		}break;
			
	}// switch Lage
	//NSLog(@"KreisVonPunkt: lage: %d Startpunkt x: %2.2f y: %2.2f Radius: %2.2f",Lage, Startpunkt.x, Startpunkt.y, Radius);
	
	// Schrittlaenge
	float Schrittlaenge=1.5;
	
	// Anzahl Schritte:
	float Umfang = 2*M_PI*RadiusA*(1-powf(epsilon, 2)/4 -3*powf(epsilon,4)/64);
   //NSLog(@"Ellipsenumfang: %2.2f",Umfang);
	
   int anzSchritte =Umfang/Schrittlaenge;
   
 	//NSLog(@"Umfang: %2.2f anzSchritte: %d",Umfang, anzSchritte);
	
	NSMutableArray* EllipsenpunktKoordinatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	int index;
	for(index=0;index<anzSchritte;index++)
	{
      float tempX=0;
      float tempY=0;
      float phi=2*M_PI/anzSchritte*index;
      switch (Lage)
      {
         case 3:
            tempX=RadiusA*cos(phi)*-1;
            tempY=RadiusB*sin(phi);
            break;
         case 1:
            tempX=RadiusA*cos(phi);
            tempY=RadiusB*sin(phi);
            break;
            
         case 2:
            tempX=RadiusA*sin(phi);
            tempY=RadiusB*cos(phi);
            break;
         case 0:
            tempX=RadiusA*sin(phi);
            tempY=RadiusB*cos(phi)*-1;
            break;
      }
      tempX += Mittelpunkt.x;
      tempY += Mittelpunkt.y;
      
      NSNumber* KoordinateX=[NSNumber numberWithFloat:tempX];
      NSNumber* KoordinateY=[NSNumber numberWithFloat:tempY];
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateX, @"x",KoordinateY,@"y" ,[NSNumber numberWithInt:index],@"index", nil];
		[EllipsenpunktKoordinatenArray addObject:tempDic];
		
	}// for index
   
   [EllipsenpunktKoordinatenArray addObject:[EllipsenpunktKoordinatenArray objectAtIndex:0]];
   
	//NSLog(@"EllipsenKoordinaten: %@",[EllipsenpunktKoordinatenArray description]);
	
   return EllipsenpunktKoordinatenArray;
}

- (NSArray*)EllipsenKoordinatenMitRadiusA:(float)RadiusA mitRadiusB:(float)RadiusB mitLage:(int)Lage mitAnzahlPunkten:(int)anzahlPunkte
{
	NSPoint Mittelpunkt = NSMakePoint(0, 0);
	/*
    anzahlPunkte: wenn =-1: Masterform berechnen
    sonst: Slaveform 
	 Lage: 0: ueber Startpunkt
	 1: links von Startpunkt
	 2: unter Startpunkt
	 3: rechts von Startpunkt
    
    www.mathematische-basteleien.de/ellipse.htm
    x=a*cos(t) /\ y=b*sin(t). 
    Der Umfang kann nicht durch eine elementare Funktion angegeben werden, nur als "elliptisches" Integral 
    Man kann das Integral näherungsweise über eine Reihenentwicklung des Integranden bestimmen. Man erhält  
    epsilon = (ra2-rb2)ra2
    
	 */
   
   
	switch (Lage)
	{
		case 0:
		{
			Mittelpunkt.y += RadiusB;
		}break;
			
		case 1:
		{
			Mittelpunkt.x -= RadiusA;
		}break;
			
		case 2:
		{
			Mittelpunkt.y -= RadiusB;
		}break;
			
		case 3:
		{
			Mittelpunkt.x +=  RadiusA;
		}break;
			
	}// switch Lage
   
	//NSLog(@"KreisVonPunkt: lage: %d Startpunkt x: %2.2f y: %2.2f Radius: %2.2f",Lage, Startpunkt.x, Startpunkt.y, Radius);
	
	// Schrittlaenge
	float Schrittlaenge=1.5;
  // Berechnung Umfang:
   float epsilon = (powf(RadiusA,2)-powf(RadiusB,2))/powf(RadiusA,2);

	// Anzahl Schritte:
	float Umfang = 2*M_PI*RadiusA*(1-powf(epsilon, 2)/4 -3*powf(epsilon,4)/64);
   //NSLog(@"Ellipsenumfang: %2.2f",Umfang);
	int anzSchritte =0;
   if (anzahlPunkte == -1)
   {
      anzSchritte =Umfang/Schrittlaenge;
   }
   else
   {
      anzSchritte = anzahlPunkte;
   }
   
 	//NSLog(@"Umfang: %2.2f anzSchritte: %d",Umfang, anzSchritte);
	
	NSMutableArray* EllipsenpunktKoordinatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	int index;
	for(index=0;index<anzSchritte;index++)
	{
      float tempX=0;
      float tempY=0;
      float phi=2*M_PI/anzSchritte*index;
      switch (Lage)
      {
         case 3:
            tempX=RadiusA*cos(phi)*-1;
            tempY=RadiusB*sin(phi);
            break;
         case 1:
            tempX=RadiusA*cos(phi);
            tempY=RadiusB*sin(phi);
            break;
            
         case 2:
            tempX=RadiusA*sin(phi);
            tempY=RadiusB*cos(phi);
            break;
         case 0:
            tempX=RadiusA*sin(phi);
            tempY=RadiusB*cos(phi)*-1;
            break;
      }
      tempX += Mittelpunkt.x;
      tempY += Mittelpunkt.y;
      
      NSNumber* KoordinateX=[NSNumber numberWithFloat:tempX];
      NSNumber* KoordinateY=[NSNumber numberWithFloat:tempY];
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateX, @"x",KoordinateY,@"y" ,[NSNumber numberWithInt:index],@"index", nil];
		[EllipsenpunktKoordinatenArray addObject:tempDic];
		
	}// for index
   
   [EllipsenpunktKoordinatenArray addObject:[EllipsenpunktKoordinatenArray objectAtIndex:0]];
   
	//NSLog(@"EllipsenKoordinaten: %@",[EllipsenpunktKoordinatenArray description]);
	
   return EllipsenpunktKoordinatenArray;
}


- (NSArray*)KreisabschnitteVonKreiskoordinaten:(NSArray*)dieKreiskoordiaten  mitRadius:(float)Radius
{
   NSMutableArray* tempDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   // Schrittlaenge
	float Schrittlaenge=1.5;
	
	// Anzahl Schritte:
	float Umfang = Radius * M_PI;
	int anzSchritte =Umfang/Schrittlaenge;
   
   int index=0;
	for(index=0;index<anzSchritte-1;index++)
	{
		NSMutableDictionary*	tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dieKreiskoordiaten objectAtIndex:index], @"startpunkt",
                                      [dieKreiskoordiaten objectAtIndex:index+1], @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" , [NSNumber numberWithInt:index],@"index",NULL];
		[tempDatenArray addObject:tempDic];
		
	}
	// Kreis schliessen zu Anfangspunkt
	NSMutableDictionary*	tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dieKreiskoordiaten lastObject], @"startpunkt",
                                   [dieKreiskoordiaten objectAtIndex:0], @"endpunkt",[NSNumber numberWithFloat:1],@"zoomfaktor" ,[NSNumber numberWithInt:anzSchritte-1],@"index",NULL];
	[tempDatenArray addObject:tempDic];
	
	//NSLog(@"tempDatenArray: %@",[tempDatenArray description]);
	
	return tempDatenArray;
   
   
}

- (NSArray*)ProfilVonPunkt:(NSPoint)Startpunkt mitProfil:(NSDictionary*)ProfilDic mitProfiltiefe:(int)Profiltiefe mitScale:(int)Scale
{
   NSLog(@"AVR openProfil");
	
//	NSString* ProfilName;
	NSArray* ProfilArray;
	
   ProfilArray=[ProfilDic objectForKey:@"profilarray"];
//	ProfilName=[ProfilDic objectForKey:@"profilname"];
   
//	[ProfilNameFeldA setStringValue:ProfilName];
	//ProfilArray=[Utils readProfil];
	//KoordinatenTabelle=(NSMutableArray*)[Utils readProfil];
	//	[KoordinatenTabelle setArray:(NSMutableArray*)ProfilArray];
	//NSLog(@"AVR ProfilArray: %@",[ProfilArray description]);
	// Annahme fuer Nullpunkt des Profils
	
	// Listen leeren
	int i;
	int maxX = 100;
	maxX = Profiltiefe; // Profiltiefe in mm
   
   // Startpunkt ist an Endleiste
   Startpunkt.x -= Profiltiefe;
	float minX=1.0;	// Startwert fuer Suche nach vordestem Punkt des Profils. Muss nicht 0.0 sein.
	int minIndex=0;	// Index des vordersten Punktes im Array
	
   NSMutableArray* ProfilpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSMutableArray* ProfilOpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSMutableArray* ProfilUpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   for (i=0;i<[ProfilArray count];i++)
	{
		
		// Profildatenpaare aus Datei mit dem Offset des Profilnullpunktes versehen
		//NSLog(@"ProfilArray index: %d Data: %@",i,[[ProfilArray objectAtIndex:i]description]);
		// X-Achse, 
		float tempX = [[[ProfilArray objectAtIndex:i]objectForKey:@"x"]floatValue];
      //NSLog(@"tempX: %2.2f ",tempX);
      
      int seitenindex=0;// Oberseite
		if (tempX < minX) // Minimum noch nicht erreicht, Oberseite
      {
         minX = tempX;
         minIndex=i;
      }
      else
      {
         seitenindex=1; // Unterseite
      }
      //NSLog(@"minX: %2.2f ",minX);
      tempX *= maxX;						// Wert in mm 
      // NSLog(@"tempX: %2.2f ",tempX);
		tempX += Startpunkt.x;	// offset in mm
      
		//tempX *= Scale;
		NSNumber* tempNumberX=[NSNumber numberWithFloat:tempX];
		//NSLog(@"tempX: %2.2f tempNumberX: %@",tempX, tempNumberX);
		//Y-Achse
		float tempY = [[[ProfilArray objectAtIndex:i]objectForKey:@"y"]floatValue];
		tempY *= maxX;						// Wert in mm 
		tempY += Startpunkt.y;	// Offset in mm
		//tempY *= Scale;
		NSNumber* tempNumberY=[NSNumber numberWithFloat:tempY];
		
      //ProfilpunktArray fuellen
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:tempNumberX, @"x",tempNumberY,@"y" ,[NSNumber numberWithInt:i],@"index", nil];
      [ProfilpunktArray addObject: tempDic];
      if (seitenindex) // Unterseite
      {
         [ProfilUpunktArray addObject: tempDic];
      }
      else
      {
         [ProfilOpunktArray addObject: tempDic];
      }
      
      
   } // for i
   //NSLog(@"minIndex: %2.2f minX: %2.2f ",minIndex, minX);
   // Profillinie schliessen:
      
  // [ProfilpunktArray addObject: [ProfilpunktArray objectAtIndex:0]];
   
   return ProfilpunktArray;
}



- (NSDictionary*)HolmDicVonPunkt:(NSPoint)Startpunkt mitProfil:(NSArray*)ProfilArray mitProfiltiefe:(int)Profiltiefe mitScale:(int)Scale
{
   float Holmposition = 0.66; // Lage des Holms von der Endleiste an gemessen
	float basisbreite = 10; // Breite der Basis unten in mm
      
   // basisbreite auf 1 normieren
   basisbreite /= Profiltiefe;
   
   // schalendicke auf 1 normieren
   schalendicke /= Profiltiefe;

   
   //NSArray* ProfilArrayA;
   NSMutableDictionary* HolmpunktDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   
    
   int holmpos = 0; // Position an Unterseite
   
   for (int i=0; i<[ProfilArray count]; i++)
   {
      //NSLog(@"i: %d x: %.3f",i,[[[Profil1Array objectAtIndex:i]objectForKey:@"x"]floatValue]);
      
      // Koord x laeuft auf der Unterseite von 1 an rueckwaerts. pruefen ob immer npch groesser als Holmposition
      if (i>[ProfilArray count]/2 && [[[ProfilArray objectAtIndex:i]objectForKey:@"x"]floatValue] > Holmposition)
      {
         holmpos = i;
      }
   }
   
   //       NSLog(@"holmpos: %d x: %.3f y: %.3f",holmpos,[[[ProfilArray objectAtIndex:holmpos]objectForKey:@"x"]floatValue],[[[ProfilArray objectAtIndex:holmpos]objectForKey:@"y"]floatValue] );
   //        NSLog(@"x0: %.5f x1: %.5f",[[[ProfilArray objectAtIndex:holmpos-2]objectForKey:@"x"]floatValue],[[[ProfilArray objectAtIndex:holmpos+2]objectForKey:@"x"]floatValue]);
   //        NSLog(@"y0: %.5f y1: %.5f",[[[ProfilArray objectAtIndex:holmpos-2]objectForKey:@"y"]floatValue],[[[ProfilArray objectAtIndex:holmpos+2]objectForKey:@"y"]floatValue]);
   
   // Startpunkte der Diagonalen auf der unteren Profillinie
   NSPoint Startpunktnachvorn = NSMakePoint([[[ProfilArray objectAtIndex:holmpos]objectForKey:@"x"]floatValue], [[[ProfilArray objectAtIndex:holmpos]objectForKey:@"y"]floatValue]);
   NSPoint Startpunktnachhinten = Startpunktnachvorn; // Ausgangspunkt fuer Suche nach Punkt in genuegender Distanz
   NSPoint tempStartpunktnachhinten = Startpunktnachvorn; // Ausgangspunkt fuer Suche nach Punkt in genuegender Distanz
   
   
   int schritte; // Anzahl Koordinatenpunkte, welche fuer eine ausreichende Breite der Grundflaeche notwendig sind.
   float distanzreal = 0;
   
   schritte=0; // mindestens eine Schrittweite
   
   while ((holmpos + schritte) < [ProfilArray count] && distanzreal < 8)
   {
      schritte++;

      Startpunktnachhinten = NSMakePoint([[[ProfilArray objectAtIndex:(holmpos + schritte)]objectForKey:@"x"]floatValue], [[[ProfilArray objectAtIndex:(holmpos + schritte)]objectForKey:@"y"]floatValue]);
      //NSLog(@"schritte: %d temppunkt.x: %.3f temppunkt.y: %.3f",schritte,Startpunktnachhinten.x*Profiltiefe,Startpunktnachhinten.y*Profiltiefe);
      distanzreal = (Startpunktnachvorn.x-Startpunktnachhinten.x)*Profiltiefe;
      //NSLog(@"schritte: %d distanzreal: %.2fmm", schritte,distanzreal);
   }
   
   
   //NSLog(@"schritte: %d distanzreal: %.2fmm",schritte,distanzreal);
   // Holmansatzpunkte unten
   int holmposvorn = holmpos;
   int holmposhinten = holmpos + schritte;
   
   // neu
   //holmposhinten = holmposvorn + 2;
   
   // Koordinatenunterschiede
   float deltay = [[[ProfilArray objectAtIndex:holmposhinten]objectForKey:@"y"]floatValue]-[[[ProfilArray objectAtIndex:holmposvorn]objectForKey:@"y"]floatValue]; // index verlaeuft gegen Endleiste zu
   float deltax = [[[ProfilArray objectAtIndex:holmposhinten]objectForKey:@"x"]floatValue]-[[[ProfilArray objectAtIndex:holmposvorn]objectForKey:@"x"]floatValue];
   //NSLog(@"deltax : %.5f deltay: %.5f",deltax,deltay);
   //NSLog(@"deltax real: %.5fmm ",deltax*Profiltiefe);
   
   // Steigung der Tangente und Einheitsvektor
   float steigungunten = deltay/deltax; // tangente
   
   // Berechnung Startpunktnachhinten im Abstand basisbreite aus Startpunkt nachvorn und steigungunten 
   
   
  // NSLog(@"alt: Startpunktnachvorn.x: %.3f Startpunktnachvorn.y: %.5f",Startpunktnachvorn.x,Startpunktnachvorn.y);
  // NSLog(@"alt: Startpunktnachhinten.x: %.3f Startpunktnachhinten.y: %.5f",Startpunktnachhinten.x,Startpunktnachhinten.y);
   Startpunktnachhinten.x = Startpunktnachvorn.x - basisbreite;
   Startpunktnachhinten.y = Startpunktnachvorn.y - basisbreite * steigungunten;
  // NSLog(@"neu: Startpunktnachhinten.x: %.3f Startpunktnachhinten.y: %.5f",Startpunktnachhinten.x,Startpunktnachhinten.y);
 
   // schalendicke zu Startpunkten 2* addieren
   Startpunktnachvorn.y += 2*schalendicke;
   Startpunktnachhinten.y += 2*schalendicke;
   
   
   NSPoint vektortang = NSMakePoint(cos(steigungunten), sin(steigungunten));
   
  
   // Steigung der Senkrechten und Einheitvektor
   float steigungsenkrecht = -deltax/deltay; // senkrechte
   NSPoint vektorsenkr = NSMakePoint(cos(steigungsenkrecht), sin(steigungsenkrecht));
   
   // Vektor der Winkelhalbierenden nach vorn
   NSPoint vektornachvorn = NSMakePoint(cos(steigungunten) + cos(steigungsenkrecht), sin(steigungunten) + sin(steigungsenkrecht));
   
   // Vektor der Winkelhalbiernenden nach hinten
   //NSPoint vektornachhinten = NSMakePoint(-1*(cos(steigungunten) + cos(steigungsenkrecht)), sin(steigungunten) + sin(steigungsenkrecht));
   
   //NSLog(@"t0: %.4f t1: %.4f",vektortang.x,vektortang.y);
   //NSLog(@"s0: %.4f s1: %.4f",vektorsenkr.x,vektorsenkr.y);
   //NSLog(@"u0: %.4f v1: %.4f",vektornachvorn.x,vektornachvorn.y);
   
   float holm1lage=[[[ProfilArray objectAtIndex:holmpos]objectForKey:@"x"]floatValue]*Profiltiefe;
   //float winkelnachvorn = steigungunten + M_PI/4;
   //float winkelnachhinten = steigungunten + 3*M_PI/4;
   //NSLog(@"holm1lage: %.4f steigungunten: %.4f steigungsenkrecht: %.4f",holm1lage,steigungunten,steigungsenkrecht);
   
   float xnachvorn = 0;
   float ynachvorn = Startpunktnachvorn.y + vektornachvorn.y/vektornachvorn.x * (xnachvorn - Startpunktnachvorn.x);
   
   float zielsteigungnachvorn = 1-steigungunten; // Soll der Steigung des vorderen Teils
   float minvornfehler = FLT_MAX; // abweichung vom Soll
   int minvornpos =0; // index des des Fehlerminimums
   
   float zielsteigungnachhinten = -(1-steigungunten);
   float minhintenfehler = FLT_MAX;
   int minhintenpos =0;
   
   
   for (int k=0;k<[ProfilArray count]/2;k++) // nur Oberseite
   {
      NSPoint tempOberseitenpunkt = NSMakePoint([[[ProfilArray objectAtIndex:k]objectForKey:@"x"]floatValue], [[[ProfilArray objectAtIndex:k]objectForKey:@"y"]floatValue]);
      
      // Bildet der Punkt an pos k mit Endpunktnachvorn einen Winkel von 45°?
      float tempsteigungvorn = (tempOberseitenpunkt.y - Startpunktnachvorn.y)/(tempOberseitenpunkt.x - Startpunktnachvorn.x);
      //NSLog(@"k: %d tempsteigungvorn: %.3f fehler: %.3f",k,tempsteigungvorn,fabs(tempsteigungvorn - zielsteigungnachvorn));
      float tempfehler = fabs(tempsteigungvorn - zielsteigungnachvorn);
      if (tempfehler < minvornfehler)
      {
         minvornfehler = tempfehler;
         minvornpos = k ;
      }
      
      float tempsteigunghinten = (tempOberseitenpunkt.y - Startpunktnachhinten.y)/(tempOberseitenpunkt.x - Startpunktnachhinten.x);
      //NSLog(@"k: %d tempsteigunghinten: %.3f fehler: %.3f",k,tempsteigunghinten,fabs(tempsteigunghinten - zielsteigungnachhinten));
      
      tempfehler = fabs(tempsteigunghinten - zielsteigungnachhinten);
      if (tempfehler < minhintenfehler)
      {
         minhintenfehler = tempfehler;
         minhintenpos = k ;
      }
      
   }
   //NSLog(@"holmposvorn: %d minvornpos: %d steigungvorn ok minvornfehler: %.3f",holmposvorn,minvornpos,minvornfehler);
   //NSLog(@"holmposhinten: %d minhintenpos: %d steigunghinten ok minhintenfehler: %.3f",holmposhinten,minhintenpos,minhintenfehler);
   //NSLog(@"Startpunkt.x: %.3f Startpunkt.y: %.3f",Startpunkt.x,Startpunkt.y);
   NSMutableArray* HolmpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   //HolmpunktArray fuellen
   
   //Anfang setzen: Koord von Endpunktnachhinten - schritte
   int aktuellepos= minhintenpos-schritte;
   int aktuellerindex=0;
   
   //Steigung der Profillinie von minhintenpos bis 2 Schritte nach hinten:
   float deltaxh = [[[ProfilArray objectAtIndex:minhintenpos-2]objectForKey:@"x"]floatValue] - [[[ProfilArray objectAtIndex:minhintenpos]objectForKey:@"x"]floatValue];
   
   float deltayh = [[[ProfilArray objectAtIndex:minhintenpos-2]objectForKey:@"y"]floatValue] - [[[ProfilArray objectAtIndex:minhintenpos]objectForKey:@"y"]floatValue];
   float steigungh = deltayh/deltaxh;

   //Steigung der Profillinie von minvornpos bis 2 Schritte nach vorn:
   float deltaxv = [[[ProfilArray objectAtIndex:minvornpos+2]objectForKey:@"x"]floatValue] - [[[ProfilArray objectAtIndex:minvornpos]objectForKey:@"x"]floatValue];
   float deltayv = [[[ProfilArray objectAtIndex:minvornpos+2]objectForKey:@"y"]floatValue] - [[[ProfilArray objectAtIndex:minvornpos]objectForKey:@"y"]floatValue];
   float steigungv = deltayv/deltaxv;
   //NSLog(@"steigungh: %.3f steigungv: %.3f",steigungh,steigungv);

   
   //Breite des Streifens: 10mm
   int l0 = 10;

   // start bei minhintenpos
   float startX = [[[ProfilArray objectAtIndex:minhintenpos]objectForKey:@"x"]floatValue];
   startX *= Profiltiefe;
   float startY = [[[ProfilArray objectAtIndex:minhintenpos]objectForKey:@"y"]floatValue];
   startY *= Profiltiefe;
   
   //Koord des Anfangs des Streifens berechnen: 10 mm nach hinten
   startX -= l0;// Wert in mm
   startY -= l0*steigungh;
   
   // Offset in mm fuer alle Punkte: Position des ersten Punktes
   float offsetx = startX; 
   float offsety = startY;
   
   // Offset subtrahieren
   startX -= offsetx;
   startY -= offsety;
   
   // Koord des Startpunktes addieren
   startX += Startpunkt.x;
   startY += Startpunkt.y;	// offset in mm
   
    
   NSNumber* startNumberY=[NSNumber numberWithFloat:startY];
   NSNumber* startNumberX=[NSNumber numberWithFloat:startX];
   
    NSDictionary* startDic=[NSDictionary dictionaryWithObjectsAndKeys:startNumberX, @"x",startNumberY,@"y" ,[NSNumber numberWithInt:aktuellerindex],@"index",[NSNumber numberWithInt:0],@"seitenindex", nil];
   [HolmpunktArray addObject: startDic];
   
   //erster Knickpunkt oben setzen: Koord von Endpunktnachhinten
   
   aktuellepos= minhintenpos;
   aktuellerindex++;
   float tempX = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"x"]floatValue];
   
   tempX *= Profiltiefe;						// Wert in mm
   tempX -= offsetx;
   tempX += Startpunkt.x;	// offset in mm
   NSNumber* tempNumberX1=[NSNumber numberWithFloat:tempX];
   
   float tempY = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"y"]floatValue];
   
   tempY *= Profiltiefe;						// Wert in mm
   tempY -= offsety;
   tempY += Startpunkt.y;	// offset in mm
   NSNumber* tempNumberY1=[NSNumber numberWithFloat:tempY];
    
   NSDictionary* tempDic1=[NSDictionary dictionaryWithObjectsAndKeys:tempNumberX1, @"x",tempNumberY1,@"y" ,[NSNumber numberWithInt:aktuellerindex],@"index",[NSNumber numberWithInt:0],@"seitenindex", nil];
   [HolmpunktArray addObject: tempDic1];
   
   //zweiter Knickpunkt unten setzen: Koord von Startpunktnachhinten
   aktuellepos= holmposhinten;
   aktuellerindex++;
   tempX = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"x"]floatValue];
   
   // neu: Startpunktnachvorn aus Berechnung
   tempX = Startpunktnachhinten.x;
   
   tempX *= Profiltiefe;						// Wert in mm
   tempX -= offsetx;
   tempX += Startpunkt.x;	// offset in mm
   
   NSNumber* tempNumberX2=[NSNumber numberWithFloat:tempX];
   
   tempY = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"y"]floatValue];
   
   // neu: Startpunktnachvorn aus Berechnung
   tempY = Startpunktnachhinten.y;
   
   tempY *= Profiltiefe;						// Wert in mm
   tempY -= offsety;
   tempY += Startpunkt.y;	// offset in mm
   
   NSNumber* tempNumberY2=[NSNumber numberWithFloat:tempY];
   
   NSDictionary* tempDic2=[NSDictionary dictionaryWithObjectsAndKeys:tempNumberX2, @"x",tempNumberY2,@"y" ,[NSNumber numberWithInt:aktuellerindex],@"index",[NSNumber numberWithInt:0],@"seitenindex", nil];
   [HolmpunktArray addObject: tempDic2];
   
   //dritter Knickpunkt unten setzen: Koord von Startpunktnachvorn
   aktuellepos= holmposvorn;
   aktuellerindex++;
   tempX = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"x"]floatValue];
   
   // neu: Startpunktnachvorn aus Berechnung
   tempX = Startpunktnachvorn.x;
   
   tempX *= Profiltiefe;						// Wert in mm
   tempX -= offsetx;
   tempX += Startpunkt.x;	// offset in mm
   NSNumber* tempNumberX3=[NSNumber numberWithFloat:tempX];
   
   tempY = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"y"]floatValue];
   
   // neu: Startpunktnachvorn aus Berechnung
   tempY = Startpunktnachvorn.y;
   
   tempY *= Profiltiefe;						// Wert in mm
   tempY -= offsety;
   tempY += Startpunkt.y;	// offset in mm
   NSNumber* tempNumberY3=[NSNumber numberWithFloat:tempY];
   
   NSDictionary* tempDic3=[NSDictionary dictionaryWithObjectsAndKeys:tempNumberX3, @"x",tempNumberY3,@"y" ,[NSNumber numberWithInt:aktuellerindex],@"index",[NSNumber numberWithInt:0],@"seitenindex", nil];
   [HolmpunktArray addObject: tempDic3];
   
   
   //dritter Knickpunkt oben setzen: Koord von Endpunktnachvorn
   aktuellepos= minvornpos;
   aktuellerindex++;
   tempX = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"x"]floatValue];
   
   tempX *= Profiltiefe;						// Wert in mm
   tempX -= offsetx;
   tempX += Startpunkt.x;	// offset in mm
   NSNumber* tempNumberX4=[NSNumber numberWithFloat:tempX];
   
   tempY = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"y"]floatValue];
   
   tempY *= Profiltiefe;						// Wert in mm
   tempY -= offsety;
   tempY += Startpunkt.y;	// offset in mm
   NSNumber* tempNumberY4=[NSNumber numberWithFloat:tempY];
   
   NSDictionary* tempDic4=[NSDictionary dictionaryWithObjectsAndKeys:tempNumberX4, @"x",tempNumberY4,@"y" ,[NSNumber numberWithInt:aktuellerindex],@"index",[NSNumber numberWithInt:0],@"seitenindex", nil];
   [HolmpunktArray addObject: tempDic4];
   
   //Endpunkt oben setzen: Koord von Endpunktnachvorn+schritte
   aktuellepos= minvornpos+schritte;
   aktuellerindex++;
   tempX = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"x"]floatValue];
   
   tempX *= Profiltiefe;						// Wert in mm
   tempX -= offsetx;
   tempX += Startpunkt.x;	// offset in mm
   NSNumber* tempNumberX5=[NSNumber numberWithFloat:tempX];
   
   tempY = [[[ProfilArray objectAtIndex:aktuellepos]objectForKey:@"y"]floatValue];
   
   tempY *= Profiltiefe;						// Wert in mm
   tempY -= offsety;
   tempY += Startpunkt.y;	// offset in mm
   NSNumber* tempNumberY5=[NSNumber numberWithFloat:tempY];
   
   NSDictionary* tempDic5=[NSDictionary dictionaryWithObjectsAndKeys:tempNumberX5, @"x",tempNumberY5,@"y" ,[NSNumber numberWithInt:aktuellerindex],@"index",[NSNumber numberWithInt:0],@"seitenindex", nil];
   [HolmpunktArray addObject: tempDic5];
   
   //NSLog(@"HolmpunktArray %@",[HolmpunktArray description]);
   
   [HolmpunktDic setObject:HolmpunktArray forKey:@"holmpunktarray"];
   
   return HolmpunktDic;
   
}

- (NSDictionary*)ProfilDicVonPunkt:(NSPoint)Startpunkt mitProfil:(NSArray*)ProfilArray mitProfiltiefe:(int)Profiltiefe mitScale:(int)Scale
{
   //NSLog(@"AVR ProfilDicVonPunkt");
   
   float x = [self EndleistenwinkelvonProfil:ProfilArray];
   
   //	[ProfilNameFeldA setStringValue:ProfilName];
	//ProfilArray=[Utils readProfil];
	//KoordinatenTabelle=(NSMutableArray*)[Utils readProfil];
	//	[KoordinatenTabelle setArray:(NSMutableArray*)ProfilArray];
	//NSLog(@"AVR ProfilArray: %@",[ProfilArray description]);
	// Annahme fuer Nullpunkt des Profils
	
	// Listen leeren
	int i;
	//int maxX = 100;
	//maxX = Profiltiefe; // Profiltiefe in mm
   
   // Startpunkt ist an Endleiste
   //Startpunkt.x -= Profiltiefe;
	
   //float minX=1.1;	// Startwert fuer Suche nach vordestem Punkt des Profils. Muss nicht 0.0 sein.
   float maxX=0;	// Startwert fuer Suche nach vordestem Punkt des Profils. Muss nicht 0.0 sein.
	int minIndex=0;	// Index des vordersten Punktes im Array
	
   NSMutableArray* ProfilpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSMutableArray* ProfilOpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSMutableArray* ProfilUpunktArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSMutableArray* MittellinieArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];

   float oberseiteweg=0;
   float unterseiteweg=0;
   
   float lastX=0;
   float lastY=0;
   NSMutableDictionary* ProfilpunktDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];

   for (i=0;i<[ProfilArray count];i++)
	{
		
		// Profildatenpaare aus Datei mit dem Offset des Profilnullpunktes versehen
		
      //NSLog(@"ProfilArray index: %d Data: %@",i,[[ProfilArray objectAtIndex:i]description]);
		// X-Achse, 
		float tempX = [[[ProfilArray objectAtIndex:i]objectForKey:@"x"]floatValue];
      //NSLog(@"tempX: %2.2f ",tempX);
      float tempY = [[[ProfilArray objectAtIndex:i]objectForKey:@"y"]floatValue];
     
      
       
      // Mittellinie
      if ((i<5)|| (i> [ProfilArray count]-5))
      {
         float mittelwinkel = atanf(tempY/tempX);
         
         NSDictionary* tempMittellinienDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:mittelwinkel],@"m",[NSNumber numberWithInt:i],@"index", nil];
         [MittellinieArray addObject:tempMittellinienDic];
      
      }
      
      // Maximum von x bestimmen: Nase
      int seitenindex=0;// Oberseite
      
//		if (tempX < minX) // Minimum noch nicht erreicht, Oberseite
		if (tempX > maxX) // Maximum noch nicht erreicht, Oberseite
      {
         maxX = tempX;
         minIndex=i;
      }
      else
      {
         seitenindex=1; // Unterseite
         // TODO: Ersten Punkt einfuegen
         
      }
      [ProfilpunktDic setObject:[NSNumber numberWithInt:minIndex] forKey:@"nase"];
      //NSLog(@"maxX: %2.2f ",maxX);
      tempX *= Profiltiefe;						// Wert in mm 
      // NSLog(@"tempX: %2.2f ",tempX);
		tempX += Startpunkt.x;	// offset in mm
      
		
		NSNumber* tempNumberX=[NSNumber numberWithFloat:tempX];
		//NSLog(@"tempX: %2.2f tempNumberX: %@",tempX, tempNumberX);
		//Y-Achse
		
		tempY *= Profiltiefe;						// Wert in mm 
		tempY += Startpunkt.y;	// Offset in mm
		
      // Weg berechnen
      if (i==0)
      {
         lastX = tempX;
         lastY = tempY;
      }
      else
      {
         float tempweg = hypotf((tempY - lastY),(tempX - lastX));
         
      }
		
      NSNumber* tempNumberY=[NSNumber numberWithFloat:tempY];
		
      //ProfilpunktArray fuellen
      
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:tempNumberX, @"x",tempNumberY,@"y" ,[NSNumber numberWithInt:i],@"index",[NSNumber numberWithInt:seitenindex],@"seitenindex", nil];
      
      [ProfilpunktArray addObject: tempDic];
      if (seitenindex) // Unterseite
      {
         [ProfilUpunktArray addObject: tempDic];
         
      }
      else
      {
         [ProfilOpunktArray addObject: tempDic];
      }
      
   } // for i
   [ProfilUpunktArray insertObject: [ProfilOpunktArray lastObject] atIndex:0];
   
   //NSLog(@"minIndex: %d minX: %2.2f ",minIndex, minX);
   // Profillinie schliessen:
   
   // [ProfilpunktArray addObject: [ProfilpunktArray objectAtIndex:0]];
   
   [ProfilpunktDic setObject:ProfilpunktArray forKey:@"profilpunktarray"];
   [ProfilpunktDic setObject:ProfilUpunktArray forKey:@"profilupunktarray"];
   [ProfilpunktDic setObject:ProfilOpunktArray forKey:@"profilopunktarray"];
   //NSLog(@"ProfilUpunktArray x: %@",[[ProfilUpunktArray valueForKey:@"x"]description]);
   //NSLog(@"ProfilOpunktArray x: %@",[[ProfilOpunktArray valueForKey:@"x"]description]);
   //NSLog(@"MittellinieArray x: %@",[MittellinieArray description]);

   //NSLog(@"ProfilpunktArray x: %@",[[ProfilpunktArray valueForKey:@"x"]description]);
   return ProfilpunktDic;
}

- (NSArray*)EndleisteneinlaufMitWinkel:(float)winkel mitLaenge:(float)laenge mitTiefe:(float)tiefe 
{
   //float tiefe=10;// Schlitztiefe
   float dicke=0.5; // Schlitzbreite
   float full_pwm = 1;
   //red_pwm = 0.4;
   NSMutableArray* EinlaufpunkteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];

   NSPoint Startpunkt = NSMakePoint(0,0);
   NSPoint Endpunkt = NSMakePoint(0,0);
   NSArray* tempEinlaufArray0 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y],[NSNumber numberWithFloat:full_pwm], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray0];
  
   // Einstich
   Endpunkt.x +=tiefe * sinf(winkel);
   Endpunkt.y -=tiefe * cosf(winkel);
   NSArray* tempEinlaufArray1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y],[NSNumber numberWithFloat:full_pwm], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray1];
 
   /*
   // Boden
   Endpunkt.x +=dicke * cosf(winkel);
   Endpunkt.y +=dicke * sinf(winkel);
   NSArray* tempEinlaufArray2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray2];
   */
   // Ausstich
   Endpunkt.x -=tiefe * sinf(winkel);
   Endpunkt.y +=tiefe * cosf(winkel);
   NSArray* tempEinlaufArray3 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y],[NSNumber numberWithFloat:red_pwm], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray3];

   // Einlauf
   Endpunkt.x +=laenge * cosf(winkel);
   Endpunkt.y +=laenge * sinf(winkel);
   NSArray* tempEinlaufArray4 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y],[NSNumber numberWithFloat:full_pwm], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray4];

   return EinlaufpunkteArray;
}

- (NSArray*)NasenleistenauslaufMitLaenge:(float)laenge  mitTiefe:(float)tiefe
{
   //float tiefe=10;// Schlitztiefe
   float dicke=0.5; // Schlitzbreite
   float full_pwm = 1;
   

   NSMutableArray* AuslaufpunkteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];

   NSPoint Endpunkt = NSMakePoint(0,0);
   NSArray* tempEinlaufArray0 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], [NSNumber numberWithFloat:full_pwm],nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray0];
  
   // Auslauf
   Endpunkt.x +=laenge;
   NSArray* tempEinlaufArray4 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], [NSNumber numberWithFloat:full_pwm],nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray4];

   
   // Einstich
   Endpunkt.y -=tiefe;
   NSArray* tempEinlaufArray1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y],[NSNumber numberWithFloat:full_pwm], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray1];
 
   /*
   // Boden
   Endpunkt.x +=dicke;
   NSArray* tempEinlaufArray2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray2];
   */
   // Ausstich
   Endpunkt.y +=tiefe;
   NSArray* tempEinlaufArray3 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y],[NSNumber numberWithFloat:red_pwm], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray3];
   
   return AuslaufpunkteArray;
}


- (NSMutableArray*)addAbbrandVonKoordinaten:(NSArray*)Koordinatentabelle mitAbbrandA:(float)abbrandmassa  mitAbbrandB:(float)abbrandmassb aufSeite:(int)seite von:(int)von bis:(int)bis
{
   /*
    seite = 0: abbrandmassa oben, Negativform
    seite = 1: abbrandmassa aussen, Positivform
    */
   //NSLog(@"addAbbrand MassA: %2.2f MassB: %2.2f von: %d bis: %d",abbrandmassa,abbrandmassb,von,bis);
   int i=0;
   NSMutableArray* AbbrandArray = [[NSMutableArray alloc]initWithCapacity:0];
   
   float lastwha[2] = {}; // WH des letzten berechneten Punktes. Wird fuer Check gebraucht, ob die Kruemmung gewechselt hat
   float lastwhb[2] = {}; // WH des letzten berechneten Punktes. Wird fuer Check gebraucht, ob die Kruemmung gewechselt hat
   
   
   float wegobena=0, weguntena=0;
   float wegobenb=0, weguntenb=0;
   
   int prevseitea=1;
   int prevseiteb=1;
   
   int prevseitenkorrektura=1;
   int prevseitenkorrekturb=1;

   float prevhypoa = 0;
   float nexthypoa= 0;
   
   //   NSLog(@"addAbbrandVonKoordinaten ax: %@",[Koordinatentabelle valueForKey:@"ax"]);
   //   NSLog(@"addAbbrandVonKoordinaten ay: %@",[Koordinatentabelle valueForKey:@"ay"]);
   //NSLog(@"addAbbrandVonKoordinaten start: %@",[Koordinatentabelle  description]);
   //NSLog(@"addAbbrandVonKoordinaten start: %@",[[Koordinatentabelle objectAtIndex:0] description]);
   
   //fprintf(stderr, "i \tprev x \tprev y \tnext x \tnexy \tprefhyp \tnexthyp \tprevnorm x \tprevnorm y \tnextnorm x  \tnextnorm y\n");
   
   /*
    Fuer jeden Punkt:
    -Winkelhalbierende zwischen vorherigem (prev) und naechstem (next) Stueck berechnen.
    -Mit Determinante Aussenseite bestimmen.
    -Winkelhalbierende mit Laenge 'abbrand' bestimmen. Wert ist fuer a und b verschieden, je nach Profiltiefe.
    -Neue Koordinaten in Dic einsetzen: abrax, abray, abrbx, abrby.
    
    */
   fprintf(stderr,"i\t ax\tay\tpreva[0]\tpreva[1]\tnexta[0]\tnexta[1]\twha[0]\twha[1]\t prevnorma[0]\tprevnorma[1]\tnextnorma[0]\tnextnorma[1]\tcosphia\tlastwha[0]\tlastwha[1]\tprevhypoa\tnexthypoa\tcospsia\n");

   for (i=0; i<[Koordinatentabelle count];i++)
   {
      int seitenkorrektura = 1;
      int seitenkorrekturb = 1;
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithDictionary:[Koordinatentabelle objectAtIndex:i]];
      if (i>von-1 && i<bis) // Abbrandbereich, von ist 1-basiert
      {
         //fprintf(stderr,"*** Punkt %d\n",i);
         float ax = [[[Koordinatentabelle objectAtIndex:i]objectForKey:@"ax"]floatValue];
         float ay = [[[Koordinatentabelle objectAtIndex:i]objectForKey:@"ay"]floatValue];
         float bx = [[[Koordinatentabelle objectAtIndex:i]objectForKey:@"bx"]floatValue];
         float by = [[[Koordinatentabelle objectAtIndex:i]objectForKey:@"by"]floatValue];
         
         float nextax = 0;
         float nextay = 0;
         float nextbx = 0;
         float nextby = 0;
         
         float prevax = 0;
         float prevay = 0;
         float prevbx = 0;
         float prevby = 0;
         
         float cosphia = 0; // cos des halben Winkels
         float cosphib = 0; // cos des halben Winkels
         float cosphi2a = 0; // cos des halben Winkels
         float cosphi2b = 0; // cos des halben Winkels
         float wha[2] = {}; // Vektor der Winkelhalbierenden a
         float whb[2] = {}; // Vektor der Winkelhalbierenden b
         
         if (i<bis-1) //  Noch im Abbrandbereich bis-1: naechsten Wert lesen
         {
            nextax = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"ax"]floatValue];
            nextay = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"ay"]floatValue];
            nextbx = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"bx"]floatValue];
            nextby = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"by"]floatValue];
         }
         
         
         if (i>von) // Schon im Abbrandbereich von: vorherigen Wert lesen
         {
            prevax = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"ax"]floatValue];
            prevay = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"ay"]floatValue];
            prevbx = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"bx"]floatValue];
            prevby = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"by"]floatValue];
         }
         
         if ((i<bis-1) && (i>von)) // Punkt im Abbrandbereich
         {
            //NSLog(@" ");
            // ********
            // Seite 1
            // ********
            
            // Vektoren vorher, nachher
            //float preva[2] = {prevax-ax,prevay-ay};
            //float preva[2] = {prevax-ax,prevay-ay};
            
            float preva[2] = {ax-prevax,ay-prevay};
            float nexta[2] = {nextax-ax,nextay-ay};
            //NSLog(@"i: %d  preva[0]: %2.4f preva[1]: %2.4f nexta[0]: %1.4f nexta[1]: %2.4f",i,preva[0],preva[1],nexta[0],nexta[1]);
            
            /*
            float prevhypoa=hypot(preva[0],preva[1]); // Laenge des vorherigen Weges
            float nexthypoa=hypot(nexta[0],nexta[1]); // Laenge des naechsten Weges
            
            float prevnorma[2]= {(preva[0])/prevhypoa,(preva[1])/prevhypoa}; // vorheriger Normalenvektor
            float nextnorma[2]= {(nexta[0])/nexthypoa,(nexta[1])/nexthypoa}; // naechster Normalenvektor
            */
            
            // Laengen der Vektoren bestimmen
            
            
            if (preva[0] || preva[1])
            {
               prevhypoa=hypot(preva[0],preva[1]); // Laenge des vorherigen Weges
            }
            else
            {
               NSLog(@"%d kein prevhypoa",i);
            }
            
            
            
            
            
            if (nexta[0] || nexta[1])
            {
               nexthypoa = hypot(nexta[0],nexta[1]); // Laenge des naechsten Weges
            }
            else
            {
               NSLog(@"%d  kein nexthypoa",i);
            }

            
            //NSLog(@"i: %d  prevhypoa: %2.4f nexthypoa: %2.4f",i,prevhypoa,nexthypoa);
            
            float prevnorma[2] = {0.0,0.0};
            if (prevhypoa)
            {
               prevnorma[0]= -(preva[1])/prevhypoa;
               prevnorma[1] = (preva[0])/prevhypoa; // vorheriger Normalenvektor
            }
            else
            {
               NSLog(@"%d kein prevnorma",i);
            }
            
            
            
            float nextnorma[2] = {0.0,0.0};
            if (nexthypoa)
            {
               nextnorma[0]= -(nexta[1])/nexthypoa;
               nextnorma[1] = (nexta[0])/nexthypoa; // vorheriger Normalenvektor
            }
            else
            {
               NSLog(@"%d kein nextnorma",i);
            }
           

            
            
            // Winkel aus Skalarprodukt der Einheitsvektoren
            cosphia=prevnorma[0]*nextnorma[0]+ prevnorma[1]*nextnorma[1]; // cosinus des Zwischenwinkels
            
            
            // Halbwinkelsatz: cos(phi/2)=sqrt((1+cos(phi))/2)
            
            // Vorzeichen von cosphia
            if (cosphia >=0)
            {
               // kleine Winkelunterschiede eliminieren
               if (cosphia >0.999)
               {
                  NSLog(@"cosphia korr+");
                  cosphia=1.0;
                  cosphi2a=1.0;
               }
               else
               {
                  cosphi2a=sqrtf((1+cosphia)/2);                       // cosinus des halben Zwischenwinkels
               }
            }
            
            else
            {
               // kleine Winkelunterschiede eliminieren
               if (cosphia < (-0.999))
               {
                  NSLog(@"cosphia korr-");
                  cosphia=-1.0;
                  cosphi2a=-1.0;
               }
               else
               {
                  cosphi2a=-sqrtf((1+cosphia)/2);                       // cosinus des halben Zwischenwinkels
               }
               
            }
            
            
            
            
           
            
            //            NSLog(@"i: %d  prevhypoa: %2.4f nexthypoa: %2.4f cosphia: %1.8f",i,prevhypoa,nexthypoa,cosphia);
            
     //       cosphi2a=sqrtf((1-cosphia)/2);                       // cosinus des halben Zwischenwinkels
            //NSLog(@"i: %d cosphia: %2.4f",i,cosphia*1000);
            
            if (cosphia <0)
            {
               //NSLog(@"Wendepunkt bei: %d",i);
            }
            
            // Winkelhalbierende
          
            wha[0] = prevnorma[0]+ nextnorma[0];                // Winkelhalbierende als Vektorsumme der Normalenvektoren
            wha[1] = prevnorma[1]+ nextnorma[1];
            
            // Determinante. Vorzeichen gibt die Seite der WH an
            /*
             Determinante:
             Erste Gerade:
             preva[0] preva[1]
             zweite Gerade:
             wha[0] wha[1]
             det = preva[0]*wha[1]-preva[1]*wha[0]
             */
            
            float deta = preva[0]*wha[1]-preva[1]*wha[0];
            
            if (deta < 0)
            {
               seitenkorrektura *= -1;
            }
            //NSLog(@"i: %d deta: %2.4f cosphia: %2.4f seitenkorrektura: %d",i,deta,cosphia,seitenkorrektura);
            
            // Fehler: wenn winkel zwischen prevnorma und nextnorma = 180°: wha ist (0,0) > wha = (1,0)
            if (wha[0]==0 && wha[1]==0)
            {
               //NSLog(@"wha[0]==0 && wha[1]==0 wha[0]: %2.4f wha[1]: %2.4f",wha[0],wha[1]);
               //wha[0] = prevnorma[0]*seitenkorrektura;
               //wha[1] = prevnorma[1]*seitenkorrektura;
               
               wha[0] = lastwha[0]*seitenkorrektura;
               wha[1] = lastwha[1]*seitenkorrektura;
            }
            
            
            
            //           NSLog(@"i: %d  wha[0]: %2.4f wha[1]: %2.4f cosphi: %1.8f",i,wha[0],wha[1],cosphia);
            
            
            // *******
            // Seite 2
            // *******
            float prevb[2]= {bx-prevbx,by-prevby};
            float nextb[2]= {nextbx-bx,nextby-by};
            
            /*
            float prevhypob=hypotf(prevb[0],prevb[1]);
            float nexthypob=hypotf(nextb[0],nextb[1]);
            
            float prevnormb[2]= {prevb[0]/prevhypob,prevb[1]/prevhypob};
            float nextnormb[2]= {nextb[0]/nexthypob,nextb[1]/nexthypob};
            */
            
            float prevhypob = 0;
            
            if (prevb[0] || prevb[1])
            {
               prevhypob=hypot(prevb[0],prevb[1]); // Laenge des vorherigen Weges
            }
            
            float nexthypob= 0;
            
            if (nextb[0] || nextb[1])
            {
               nexthypob = hypot(nextb[0],nextb[1]); // Laenge des naechsten Weges
            }
            
            float prevnormb[2] = {0.0,0.0};
            
            if (prevhypoa)
            {
               prevnormb[0]= -(prevb[1])/prevhypob;
               prevnormb[1] = (prevb[0])/prevhypob; // vorheriger Normalenvektor
            }
            
            
            
            float nextnormb[2] = {0.0,0.0};
            if (nexthypoa)
            {
               nextnormb[0]= -(nextb[1])/nexthypob;
               nextnormb[1] = (nextb[0])/nexthypob; // vorheriger Normalenvektor
            }

            // Winkel aus Skalarprodukt der Einheitsvektoren
            float cosphib=prevnormb[0]*nextnormb[0]+ prevnormb[1]*nextnormb[1];
            
            if (cosphib >=0)
            {
               // kleine Winkelunterschiede eliminieren
               if (cosphib >0.999)
               {
                  NSLog(@"cosphia korr+");
                  cosphib=1.0;
                  cosphi2b=1.0;
               }
               else
               {
                  cosphi2b=sqrtf((1+cosphib)/2);                       // cosinus des halben Zwischenwinkels
               }
            }
            
            else
            {
               // kleine Winkelunterschiede eliminieren
               if (cosphib < (-0.999))
               {
                  NSLog(@"cosphib korr-");
                  cosphib=-1.0;
                  cosphi2b=-1.0;
               }
               else
               {
                  cosphi2b=-sqrtf((1+cosphib)/2);                       // cosinus des halben Zwischenwinkels
               }
               
            }
            

            
            
            // Halbwinkelsatz: cos(phi/2)=sqrt((1+cos(phi))/2)
            //cosphi2b=sqrtf((1-cosphib)/2);
            
            // Winkelhalbierende
            whb[0] = prevnormb[0]+ nextnormb[0];
            whb[1] = prevnormb[1]+ nextnormb[1];
            
            float detb = prevb[0]*whb[1]-prevb[1]*whb[0];
            
            if (detb < 0)
            {
               seitenkorrekturb *= -1;
            }
            //NSLog(@"i: %d detb: %2.4f cosphib: %2.4f seitenkorrekturb: %d",i,detb,cosphib,seitenkorrekturb);
            
            if (whb[0]==0 && whb[1]==0)
            {
               //NSLog(@"whb[0]==0 && whb[1]==0 whb[0]: %2.4f whb[1]: %2.4f",whb[0],whb[1]);
               whb[0] = lastwhb[0]*seitenkorrekturb;
               whb[1] = lastwhb[1]*seitenkorrekturb;
               
            }
            
            
            // letzte wh : lastwha, lastwhb gespeichert in vorherigem Durchgang
            //  Seite A
            float lasthypoa = hypotf(lastwha[0],lastwha[1]);   // Laenge der vorherigen WH
            float currhypoa = hypotf(wha[0],wha[1]);           // Laenge der aktuellen WH
            
            // cosinussatz
            float cospsia = (wha[0]*lastwha[0]+wha[1]*lastwha[1])/(lasthypoa*currhypoa);
            
         if (i>[Koordinatentabelle count]-20)
         {
            fprintf(stderr,"%d\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.6f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.6f\n",i, ax,ay,preva[0],preva[1],nexta[0],nexta[1],wha[0],wha[1], prevnorma[0],prevnorma[1],nextnorma[0],nextnorma[1],cosphia,lastwha[0],lastwha[1],prevhypoa,nexthypoa,cospsia);
         }
            //            NSLog(@"i: %d  lasthypoa: %2.4f currhypoa: %2.4f cospsia: %1.8f",i,lasthypoa,currhypoa,cospsia);
            
            if (cospsia < 0) // Winkel ist > 90°
            {
               //NSLog(@"Winkel ist > 90°");
               // Ersetzt duch Ermittlung der Determinante zur Bestimmung der richtigen Seite
               //              wha[0] *= -1;
               //              wha[1] *= -1;
               
            }
            //  Seite B
            float lasthypob = hypotf(lastwhb[0],lastwhb[1]);
            float currhypob = hypotf(whb[0],whb[1]);
            float cospsib = (whb[0]*lastwhb[0]+whb[1]*lastwhb[1])/(lasthypob*currhypob);
            //NSLog(@"lasthypob: %2.4f currhypob: %2.4f cospsib: %1.8f",lasthypob,currhypob,cospsib);
            
            if (cospsib<0)
            {
               //              whb[0] *= -1;
               //              whb[1] *= -1;
            }
         }
         
         
         
         
         
         
         
         if (i==von) // erster Punkt, Abbrandvektor soll senkrecht stehen
         {
            //NSLog(@"i=von: %d",i);
            float deltaax=nextax-ax;
            float deltaay=nextay-ay;
            float normalenhypoa = hypotf(deltaax, deltaay);
            
            // Normalenvektor steht senkrecht
            wha[0] = deltaay/normalenhypoa*(-1);      // erster Punkt, wha speichern
            wha[1] = deltaax/normalenhypoa;
            cosphi2a=1;
            //NSLog(@"deltaax: %2.4f deltaay: %2.4f normalenhypoa: %2.4f wha[0]: %2.4f wha[1]: %2.4f cosphi2a: %2.4f",deltaax,deltaay,normalenhypoa,wha[0],wha[1],cosphi2a);
            
            float deltabx=nextbx-bx;
            float deltaby=nextby-by;
            float normalenhypob = hypotf(deltabx, deltaby);
            // Normalenvektor steht senkrecht
            whb[0] = deltaby/normalenhypob*(-1);
            whb[1] = deltabx/normalenhypob;
            cosphi2b=1;
            
            
            // test
            if (wha[1]<0 ) // falsche Richtung in Naehe von Wendepunkt
            {
               wha[0] *= -1;
               wha[1] *= -1;
            }
            if (whb[1]<0 ) // falsche Richtung in Naehe von Wendepunkt
            {
               whb[0] *= -1;
               whb[1] *= -1;
            }
            
            
         }
         
         if (i==bis-1) // letzter Punkt, Abbrandvektor soll senkrecht stehen
         {
            NSLog(@"i=bis-1");
            float deltaax=prevax-ax;
            float deltaay=prevay-ay;
            float normalenhypoa = hypotf(deltaax, deltaay);
            // Normalenvektor steht senkrecht
            wha[0] = deltaay/normalenhypoa*(-1);
            wha[1] = deltaax/normalenhypoa;
            cosphi2a=1;
            
            float deltabx=prevbx-bx;
            float deltaby=prevby-by;
            float normalenhypob = hypotf(deltabx, deltaby);
            // Normalenvektor steht senkrecht
            whb[0] = deltaby/normalenhypob*(-1);
            whb[1] = deltabx/normalenhypob;
            cosphi2b=1;
            
            
            // test
            if (wha[1]<0 ) // falsche Richtung in Naehe von Wendepunkt
            {
               wha[0] *= -1;
               wha[1] *= -1;
            }
            
            if (whb[1]<0 ) // falsche Richtung in Naehe von Wendepunkt
            {
               whb[0] *= -1;
               whb[1] *= -1;
            }
            
         }
         
         // ++++++++++++++++++++++++++++++++++
         // wh speichern fuer naechsten Punkt
         
         lastwha[0] = wha[0]*seitenkorrektura;
         lastwha[1] = wha[1]*seitenkorrektura;
         
         lastwhb[0] = whb[0]*seitenkorrekturb;
         lastwhb[1] = whb[1]*seitenkorrekturb;
         // ++++++++++++++++++++++++++++++++++
         
         float whahypo = hypotf(wha[0],wha[1]);
          //fprintf(stderr,"i:\t %d \tprevhypoa \t%2.2f\t nexthypoa \t%2.2f \twhahypo: \t%2.4f \tcosphia: \t%2.4f\tcosphi2a: \t%2.4f\n",i,prevhypoa,nexthypoa,whahypo,cosphia,cosphi2a);
         
         float abbranda[2]={wha[0]*seitenkorrektura/whahypo*abbrandmassa/cosphi2a,wha[1]*seitenkorrektura/whahypo*abbrandmassa/cosphi2a};
         
         float profilabbrandbmass = abbrandmassa;
         if ((i<(bis-2)) &&  (i>(von+1)))
            //if (i>von+1)
            //if (i<bis-2)
         {
            
            profilabbrandbmass = abbrandmassb;
         }
         //NSLog(@"i: %d profilabbrandbmass: %2.2f",i,profilabbrandbmass);
         float whbhypo = hypotf(whb[0],whb[1]);
         //NSLog(@"whbhypo: %2.4f",whbhypo);
         float abbrandb[2]= {whb[0]*seitenkorrekturb/whbhypo*profilabbrandbmass/cosphi2b,whb[1]*seitenkorrekturb/whbhypo*profilabbrandbmass/cosphi2b};
         
         //NSLog(@"i %d orig %2.2f %2.2f %2.2f %2.2f",i,ax,ay,bx,by);
         [tempDic setObject:[NSNumber numberWithFloat:ax+abbranda[0]] forKey:@"abrax"];
         [tempDic setObject:[NSNumber numberWithFloat:ay+abbranda[1]] forKey:@"abray"];
         [tempDic setObject:[NSNumber numberWithFloat:bx+abbrandb[0]] forKey:@"abrbx"];
         [tempDic setObject:[NSNumber numberWithFloat:by+abbrandb[1]] forKey:@"abrby"];
         
         float hypa = hypotf(ax, ay);
         float hypb = hypotf(bx, by);
         float abrhypa = hypotf(ax+abbranda[0], ay+abbranda[1]);
         float abrhypb = hypotf(bx+abbrandb[0], by+abbrandb[1]);
         
         if (i<25)
         {
            // NSLog(@"i %d mod %2.2f %2.2f %2.2f %2.2f  %2.2f %2.2f %2.2f %f",i,ax,ay,bx,by,ax+abbranda[0],ay+abbranda[1],bx+abbrandb[0],by+abbrandb[1]);
            //fprintf(stderr,"i \t%d  \t%2.2f \t%2.2f \t%2.2f \t%2.2f\n",i,hypa,abrhypa,hypb,abrhypb);
         }
         
         if (((i>10)&&(i<18)) || (i> 40))
         {
            //NSLog(@"i: %d tempDic: %@",i,[tempDic description]);
            // fprintf(stderr,"i %d  \t%2.2f \t%2.2f \t%2.2f \t%2.2f\n",i,hypa,abrhypa,hypb,abrhypb);
            
         }
      } // i im Bereich
      
      [AbbrandArray addObject:tempDic];
      
   } // for i
   //NSLog(@"addAbbrandVonKoordinaten end: %@",[AbbrandArray  description]);
   //NSLog(@"addAbbrandVonKoordinaten end: %@",[[AbbrandArray  objectAtIndex:0] description]);
   return AbbrandArray;
   
}



@end
