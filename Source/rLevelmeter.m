#import "rLevelmeter.h"

@implementation rLevelmeter

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		AnzFelder=32.0;
		Grenze =AnzFelder/3*2;
		NSRect BalkenRect=[self frame];
		float Breite=BalkenRect.size.width;
		Feldbreite=Breite/(AnzFelder);
		int Hoehe=BalkenRect.size.height;
		Feldhoehe=Hoehe*0.8;
		max=0;
		lastLevel=0;
		fixTime=1.0;
		maxSet=NO;
		holdMax=-1;
		fixTimer=nil;
		Level=0;
		//NSLog(@"Breite: %d  Feldbreite: %f" ,Breite, Feldbreite);
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	[self drawLevelmeter];
}

- (void)setLevel:(int) derLevel
{
	if (derLevel>255)
		Level=255;
	else
	Level=derLevel;
	
	Level=Level/255.0*AnzFelder;
	BOOL startDelay=NO;
	BOOL startFix=NO;
	
	//Bedingung A
	//Peak: Level ist kleiner oder gleich als lastLevel
	
	if ((Level<=lastLevel)&&(Level>0)&&(maxSet==NO))
	{
		
			//NSLog(@"Bedingung A: lastLevel: %d   Level: %d  max: %d", lastLevel,Level,max);
		max=lastLevel;
		holdMax=lastLevel;//index des Segments
		maxSet=YES;
		startFix=YES;
		
	}
	
	//Bedingung B
	//max ist fixiert, Level ist höher, aber nicht maximal

	if ((Level>=max)&&(max>0))
	{
			//delaySet=NO;	
			maxSet=NO;
			max=Level;
			if (fixTimer)
			{
				[fixTimer fire];
			}
		holdMax=Level;	
	}
	
	lastLevel=Level;
	
	
	if (startFix)
	{
		fixTimer=[[NSTimer scheduledTimerWithTimeInterval:fixTime
												   target:self 
												 selector:@selector(fixTimerfunktion:) 
												 userInfo:nil 
												  repeats:NO]retain];
		maxSet=YES;//Timeout für Max
	}
	
	[self display];
}

- (void)drawLevelmeter
{
	[self lockFocus];

	int i;
	NSRect f;
	NSPoint Nullpunkt=NSMakePoint(1,1);
	for (i=0;i<AnzFelder;i++)
	{
		f=NSMakeRect(Nullpunkt.x+(i*(Feldbreite)),Nullpunkt.y,Feldbreite-2.0,Feldhoehe);
		[[NSColor blackColor]set];
		[NSBezierPath strokeRect:f];
		{
			if ((i<Level-1)||(i==(holdMax-1)))
			{
				if (i<Grenze)
				{
					[[NSColor greenColor] set];
				}
				else
				{
					[[NSColor redColor] set];
				}
				
			}
			else
			{
				[[NSColor whiteColor]set];

			}
		}
		
		[NSBezierPath fillRect:f];
	}//for i

	[self unlockFocus];

}
- (void)fixTimerfunktion:(NSTimer*)timer
{
//max=0;
maxSet=NO;
holdMax=-1;
}

@end
