//#import "rVertikalanzeige.h"

@implementation rVertikalanzeige

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		//NSLog(@"frameRect x: %f y: %f h: %f w: %f",frameRect.origin.x,frameRect.origin.y,frameRect.size.height,frameRect.size.width);

		AnzFelder=255;
		Grenze =AnzFelder/2.0;
		NSRect BalkenRect=[self frame];
		//NSLog(@"BalkenRect x: %f y: %f h: %f w: %f",BalkenRect.origin.x,BalkenRect.origin.y,BalkenRect.size.height,BalkenRect.size.width);

		float Breite=BalkenRect.size.width;
		Feldbreite=Breite;///(AnzFelder);
		float Hoehe=BalkenRect.size.height;
		Feldhoehe=Hoehe/(AnzFelder);
		max=0;
		lastLevel=0;
		fixTime=1.0;
		maxSet=NO;
		holdMax=-1;
		fixTimer=nil;
		Level=0;
		//NSLog(@"Breite: %2.2f  Feldbreite: %2.2f Hoehe: %2.2f Feldhoehe: %2.2f" ,Breite, Feldbreite,Hoehe,Feldhoehe);
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	[self drawAnzeige];
}

- (void)setStringLevel:(NSString*)derLevel
{
	NSScanner *scanner;
	int tempLevel;

	scanner = [NSScanner scannerWithString:derLevel];
	[scanner scanHexInt:&tempLevel];
	[self setLevel:tempLevel];
}

- (void)setLevel:(int) derLevel
{
	if (derLevel>255)
		Level=255.0;
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

- (void)drawAnzeige
{
	[self lockFocus];
	//NSLog(@"drawAnzeige");
	int i;
	NSRect f;
	NSPoint Nullpunkt=NSMakePoint(1,1);
	for (i=0;i<AnzFelder;i++)
	{
		f=NSMakeRect(Nullpunkt.x,Nullpunkt.y+(i*(Feldhoehe)),Feldbreite,Feldhoehe);
		[[NSColor blackColor]set];
		//[NSBezierPath strokeRect:f];
		{
			if ((i<Level-1)||(i==(holdMax-1)))
			{
				if (i<Grenze)
				{
					[[NSColor lightGrayColor] set];
				}
				else
				{
					[[NSColor greenColor] set];
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

- (void)setTag:(int)derTag
{
tag=derTag;
}
@end
