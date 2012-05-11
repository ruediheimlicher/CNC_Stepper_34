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


@implementation rCNC
- (id)init
{
if ((self = [super init]) != nil) 
{
	DatenArray = [[NSArray alloc]init];
	[DatenArray retain];
	
	speed=10;
	steps=48;

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
   
	float Distanz= sqrt(pow(DistanzX,2)+ pow(DistanzY,2));	// effektive Distanz
	float DistanzA= hypotf(DistanzAX,DistanzAY);	// effektive Distanz A
	float DistanzB= hypotf(DistanzBX,DistanzBY);	// effektive Distanz B
	
   float Zeit = Distanz/speed;												//	Schnittzeit für Distanz
   float ZeitA = DistanzA/speed;												//	Schnittzeit für Distanz A
   float ZeitB = DistanzB/speed;												//	Schnittzeit für Distanz B
   int relevanteSeite=0; // seite A
   if (ZeitB > ZeitA)
   {
      relevanteSeite=1; // Seite B
   }
   float relZeit= fmaxf(ZeitA,ZeitB);                             // relevante Zeit: grössere Zeit gibt korrekte max Schnittgeschwindigkeit 

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

   
   [tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteX] forKey: @"schrittex"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:(float)SchritteAX] forKey: @"schritteax"];

	//NSLog(@"SchritteX raw %d",SchritteX);
	
	int SchritteY=steps*DistanzY;	//	Schritte in Y-Richtung
	int SchritteAY=steps*DistanzAY;	//	Schritte in Y-Richtung A
	int SchritteBY=steps*DistanzBY;	//	Schritte in Y-Richtung B
   
   
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
		//NSLog(@"SchritteX nach  0x8000 %d",SchritteX);
		//NSLog(@"SchritteX negativ: %d",SchritteX);
	}
   
	if (SchritteAX < 0) // negative Zahl
	{
      anzaxminus += SchritteAX;
		SchritteAX *= -1;
		SchritteAX &= 0x7FFF;
		//NSLog(@"SchritteAX nach *-1 und 0x7FFFF %d",SchritteAX);
		SchritteAX |= 0x8000;
		//NSLog(@"SchritteAX nach  0x8000 %d",SchritteAX);
		//NSLog(@"SchritteAX negativ: %d",SchritteAX);
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
	
//	[tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteX & 0xFF)] forKey: @"schrittexl"];
//	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteX >> 8) & 0xFF)] forKey: @"schrittexh"];

	[tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteAX & 0xFF)] forKey: @"schritteaxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteAX >> 8) & 0xFF)] forKey: @"schritteaxh"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteBX & 0xFF)] forKey: @"schrittebxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteBX >> 8) & 0xFF)] forKey: @"schrittebxh"];
	


	// schritte y
//  [tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteY & 0xFF)] forKey: @"schritteyl"];
//	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteY >> 8) & 0xFF)] forKey: @"schritteyh"];

   [tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteAY & 0xFF)] forKey: @"schritteayl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteAY >> 8) & 0xFF)] forKey: @"schritteayh"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:(SchritteBY & 0xFF)] forKey: @"schrittebyl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:((SchritteBY >> 8) & 0xFF)] forKey: @"schrittebyh"];

   
	
//	float delayX= ((Zeit/(SchritteX & 0x7FFF))*100000)/10;							// Zeit fuer einen Schritt in 100us-Einheit
	float delayAX= ((relZeit/(SchritteAX & 0x7FFF))*100000)/10;							// Zeit fuer einen Schritt AX in 100us-Einheit
	float delayBX= ((relZeit/(SchritteBX & 0x7FFF))*100000)/10;							// Zeit fuer einen Schritt BX in 100us-Einheit
	
   
   
//   float delayY= ((Zeit/(SchritteY & 0x7FFF))*100000)/10;
   float delayAY= ((relZeit/(SchritteAY & 0x7FFF))*100000)/10;
   float delayBY= ((relZeit/(SchritteBY & 0x7FFF))*100000)/10;
	
	//NSLog(@"DistanzX: %.2f DistanzY: %.2f Distanz: %.2f Zeit: %.3f  delayX: %.1f  delayY: %.1f SchritteX: %d SchritteY: %d",DistanzX,DistanzY,Distanz, Zeit, delayX, delayY, SchritteX,SchritteY);
	
	
	
//	[tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayX & 0xFF)] forKey: @"delayxl"];
//	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayX >> 8) & 0xFF)] forKey: @"delayxh"];

   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayAX & 0xFF)] forKey: @"delayaxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayAX >> 8) & 0xFF)] forKey: @"delayaxh"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayBX & 0xFF)] forKey: @"delaybxl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayBX >> 8) & 0xFF)] forKey: @"delaybxh"];


	
//   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayY & 0xFF)] forKey: @"delayyl"];
//	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayY >> 8) & 0xFF)] forKey: @"delayyh"];

   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayAY & 0xFF)] forKey: @"delayayl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayAY >> 8) & 0xFF)] forKey: @"delayayh"];
   [tempDatenDic setObject:[NSNumber numberWithFloat:((int)delayBY & 0xFF)] forKey: @"delaybyl"];
	[tempDatenDic setObject:[NSNumber numberWithFloat:(((int)delayBY >> 8) & 0xFF)] forKey: @"delaybyh"];
   
	[tempDatenDic setObject:[NSNumber numberWithInt :code] forKey: @"code"];
	[tempDatenDic setObject:[NSNumber numberWithInt :code] forKey: @"codea"];
	[tempDatenDic setObject:[NSNumber numberWithInt :0] forKey: @"codeb"];
   
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
	if (relevanteSchritte < 80) // Rampen lohnt sich nicht
   {
      return [NSArray arrayWithObject:[self SteuerdatenVonDic:derDatenDic]];
   }
   
   int teilabschnitt=20; // Abschnitt mit konstanter Geschwindigkeit
   
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

- (NSArray*)SchnittdatenVonDic:(NSDictionary*)derDatenDic
{
   
   /*
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
    */
	//NSLog(@"SchnittdatenVonDic derDatenDic: %@",[derDatenDic description]);
   
	NSMutableArray* tempArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int tempDataL=0;
	int tempDataH=0;
	int tempData=[[derDatenDic objectForKey:@"schrittex"]intValue];
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

      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateX, @"x",KoordinateY,@"y" ,[NSNumber numberWithInt:index],@"index", nil];
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
   
 	NSLog(@"Umfang: %2.2f anzSchritte: %d",Umfang, anzSchritte);
	
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

 	NSLog(@"Umfang: %2.2f anzSchritte: %d",Umfang, anzSchritte);
	
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
   
	NSLog(@"KreispunktArray count: %d",[KreispunktKoordinatenArray count]);
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
   NSLog(@"Ellipsenumfang: %2.2f",Umfang);
	
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
   
	NSLog(@"EllipsenKoordinaten: %@",[EllipsenpunktKoordinatenArray description]);
	
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
   NSLog(@"Ellipsenumfang: %2.2f",Umfang);
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
   
	NSLog(@"EllipsenKoordinaten: %@",[EllipsenpunktKoordinatenArray description]);
	
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
      
		//tempX *= Scale;
		NSNumber* tempNumberX=[NSNumber numberWithFloat:tempX];
		//NSLog(@"tempX: %2.2f tempNumberX: %@",tempX, tempNumberX);
		//Y-Achse
		
		tempY *= Profiltiefe;						// Wert in mm 
		tempY += Startpunkt.y;	// Offset in mm
		//tempY *= Scale;
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
   NSMutableArray* EinlaufpunkteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];

   NSPoint Startpunkt = NSMakePoint(0,0);
   NSPoint Endpunkt = NSMakePoint(0,0);
   NSArray* tempEinlaufArray0 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray0];
  
   // Einstich
   Endpunkt.x +=tiefe * sinf(winkel);
   Endpunkt.y -=tiefe * cosf(winkel);
   NSArray* tempEinlaufArray1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray1];
   
   // Boden
   Endpunkt.x +=dicke * cosf(winkel);
   Endpunkt.y +=dicke * sinf(winkel);
   NSArray* tempEinlaufArray2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray2];
   
   // Ausstich
   Endpunkt.x -=tiefe * sinf(winkel);
   Endpunkt.y +=tiefe * cosf(winkel);
   NSArray* tempEinlaufArray3 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray3];

   // Einlauf
   Endpunkt.x +=laenge * cosf(winkel);
   Endpunkt.y +=laenge * sinf(winkel);
   NSArray* tempEinlaufArray4 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [EinlaufpunkteArray addObject:tempEinlaufArray4];

   return EinlaufpunkteArray;
}

- (NSArray*)NasenleistenauslaufMitLaenge:(float)laenge  mitTiefe:(float)tiefe
{
   //float tiefe=10;// Schlitztiefe
   float dicke=0.5; // Schlitzbreite
   NSMutableArray* AuslaufpunkteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];

   NSPoint Endpunkt = NSMakePoint(0,0);
   NSArray* tempEinlaufArray0 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray0];
  
   // Auslauf
   Endpunkt.x +=laenge;
   NSArray* tempEinlaufArray4 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray4];

   
   // Einstich
   Endpunkt.y -=tiefe;
   NSArray* tempEinlaufArray1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray1];
   
   // Boden
   Endpunkt.x +=dicke;
   NSArray* tempEinlaufArray2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray2];
   
   // Ausstich
   Endpunkt.y +=tiefe;
   NSArray* tempEinlaufArray3 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:Endpunkt.x],[NSNumber numberWithFloat:Endpunkt.y], nil];
   [AuslaufpunkteArray addObject:tempEinlaufArray3];
   
   
   return AuslaufpunkteArray;
}


- (NSMutableArray*)addAbbrandVonKoordinaten:(NSArray*)Koordinatentabelle mitAbbrand:(float)abbrand aufSeite:(int)seite von:(int)von bis:(int)bis
{
   /*
    seite = 0: abbrand oben, Negativform
    seite = 1: abbrand aussen, Positivform
    */
   NSLog(@"addAbbrand Mass: %2.4f von: %d bis: %d",abbrand,von,bis);
   int i=0;
   NSMutableArray* AbbrandArray = [[NSMutableArray alloc]initWithCapacity:0];
//   NSLog(@"addAbbrandVonKoordinaten ax: %@",[Koordinatentabelle valueForKey:@"ax"]);
//   NSLog(@"addAbbrandVonKoordinaten ay: %@",[Koordinatentabelle valueForKey:@"ay"]);
    
   //fprintf(stderr, "i \tprev x \tprev y \tnext x \tnexy \tprefhyp \tnexthyp \tprevnorm x \tprevnorm y \tnextnorm x  \tnextnorm y\n"); 
   for (i=0; i<[Koordinatentabelle count];i++)
   {
      NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithDictionary:[Koordinatentabelle objectAtIndex:i]];
      
      if (i>von-1 && i<bis) // von ist 1-basiert
      {
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
         
         float cosphi2a = 0; // cos des halben Winkels
         float cosphi2b = 0; // cos des halben Winkels
         float wha[2] = {}; // Vektor der Winkelhalbierenden a
         float whb[2] = {}; // Vektor der Winkelhalbierenden b
         
         if (i<bis-1) // naechsten Wert lesen
         {
            nextax = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"ax"]floatValue];
            nextay = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"ay"]floatValue];
            nextbx = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"bx"]floatValue];
            nextby = [[[Koordinatentabelle objectAtIndex:i+1]objectForKey:@"by"]floatValue];
         }

         
         if (i>von) // vorherigen Wert lesen
         {
            prevax = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"ax"]floatValue];
            prevay = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"ay"]floatValue];
            prevbx = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"bx"]floatValue];
            prevby = [[[Koordinatentabelle objectAtIndex:i-1]objectForKey:@"by"]floatValue];
         }
         
         if ((i<bis-1) && (i>von))
         {
            // Seite 1
            float preva[2]= {prevax-ax,prevay-ay};
            float nexta[2]= {nextax-ax,nextay-ay};
            float prevhypoa=hypot(preva[0],preva[1]);
            float nexthypoa=hypot(nexta[0],nexta[1]);
            
            float prevnorma[2]= {(preva[0])/prevhypoa,(preva[1])/prevhypoa};
            float nextnorma[2]= {(nexta[0])/nexthypoa,(nexta[1])/nexthypoa};
            
            // Winkel aus Skalarprodukt der Einheitsvektoren
            float cosphia=prevnorma[0]*nextnorma[0]+ prevnorma[1]*nextnorma[1];
            // Halbwinkelsatz: cos(phi/2)=sqrt((1+cos(phi))/2)
            cosphi2a=sqrtf((1-cosphia)/2);
            
            wha[0] = prevnorma[0]+ nextnorma[0];
            wha[1] = prevnorma[1]+ nextnorma[1];
         
            // Seite 2
            float prevb[2]= {prevbx-bx,prevby-by};
            float nextb[2]= {nextbx-bx,nextby-by};
            float prevhypob=hypotf(prevb[0],prevb[1]);
            float nexthypob=hypotf(nextb[0],nextb[1]);
            
            float prevnormb[2]= {prevb[0]/prevhypob,prevb[1]/prevhypob};
            float nextnormb[2]= {nextb[0]/nexthypob,nextb[1]/nexthypob};
            
            // Winkel aus Skalarprodukt der Einheitsvektoren
            float cosphib=prevnormb[0]*nextnormb[0]+ prevnormb[1]*nextnormb[1];
            // Halbwinkelsatz: cos(phi/2)=sqrt((1+cos(phi))/2)
            cosphi2b=sqrtf((1-cosphib)/2);
            
            whb[0] = prevnormb[0]+ nextnormb[0];
            whb[1] = prevnormb[1]+ nextnormb[1];
            
         
         }
         
         if (i==von) // erster Punkt, Abbrandvektor soll senkrecht stehen
         {
            NSLog(@"i=von");
            float deltaax=nextax-ax;
            float deltaay=nextay-ay;
            float normalenhypoa = hypotf(deltaax, deltaay);
            // Normalenvektor steht senkrecht
            wha[0] = deltaay/normalenhypoa*(-1);
            wha[1] = deltaax/normalenhypoa;
            cosphi2a=1;

            float deltabx=nextbx-bx;
            float deltaby=nextby-by;
            float normalenhypob = hypotf(deltabx, deltaby);
            // Normalenvektor steht senkrecht
            whb[0] = deltaby/normalenhypob*(-1);
            whb[1] = deltabx/normalenhypob;
            cosphi2b=1;

         
         
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
            
        
         
         }

         
         switch (seite)
         {
            case 0:
            {
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
               
            }break;
               
            case 1:
            {
               if (wha[1]) // falsche Richtung in Naehe von Wendepunkt
               {
                  wha[0] *= -1;
                  wha[1] *= -1;
               }
               if (whb[1]) // falsche Richtung in Naehe von Wendepunkt
               {
                  whb[0] *= -1;
                  whb[1] *= -1;
               }
               
            }break;
         }
         
         float whahypo = hypotf(wha[0],wha[1]);
        // NSLog(@"prevhypoa %2.2f nexthypoa %2.2f whahypo: %2.4f",prevhypoa,nexthypoa,whahypo);
         float abbranda[2]={wha[0]/whahypo*abbrand/cosphi2a,wha[1]/whahypo*abbrand/cosphi2a};
         
         float whbhypo = hypotf(whb[0],whb[1]);
         //NSLog(@"whbhypo: %2.4f",whbhypo);
         float abbrandb[2]= {whb[0]/whbhypo*abbrand,whb[1]/whbhypo*abbrand};

         //NSLog(@"i %d orig %2.2f %2.2f %2.2f %2.2f",i,ax,ay,bx,by);
         [tempDic setObject:[NSNumber numberWithFloat:ax+abbranda[0]] forKey:@"abrax"];
         [tempDic setObject:[NSNumber numberWithFloat:ay+abbranda[1]] forKey:@"abray"];
         [tempDic setObject:[NSNumber numberWithFloat:bx+abbrandb[0]] forKey:@"abrbx"];
         [tempDic setObject:[NSNumber numberWithFloat:by+abbrandb[1]] forKey:@"abrby"];
         //NSLog(@"i %d mod %2.2f %2.2f %2.2f %2.2f  %2.2f %2.2f %2.2f %f",i,ax,ay,bx,by,ax+abbranda[0],ay+abbranda[1],bx+abbrandb[0],by+abbrandb[1]);
         if (((i>10)&&(i<18)) || (i> 40))
         {
            //NSLog(@"i: %d tempDic: %@",i,[tempDic description]);
         }
      } // i im Bereich
      
      [AbbrandArray addObject:tempDic];
      
   } // for i
   return AbbrandArray;
}

@end
