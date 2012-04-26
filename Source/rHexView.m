//
//  rErgebnisfeld.m
//  SndCalcII
//
//  Created by Sysadmin on 03.11.05.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rHexView.h"


@implementation rHexView
- (id)initWithFrame:(NSRect)frame
{
self=[super initWithFrame:frame];
//NSLog(@"rErgebnisView initWithFrame");
//NSLog(@"Rahmen: \nx: %d y: %d\nb: %d h: %d",frame.origin.x,frame.origin.y,frame.size.width, frame.size.height);
mark=-1;
NSString* HexString=@"0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f";
HexSet=[NSCharacterSet characterSetWithCharactersInString:HexString];
[HexSet retain];

return self;
}

- (void)awakeFromNib
{
//NSLog(@"rErgebnisView awakeFromNib");
//NSLog(@"rErgebnisView initWithFrame");
NSRect Rahmen=[self frame];
//NSLog(@"Rahmen: \nx: %d y: %d\nb: %d h: %d",Rahmen.origin.x,Rahmen.origin.y,Rahmen.size.width, Rahmen.size.height);

//[self setDelegate:self];

}

- (void)setHexView
{
//NSLog(@"setErgebnisView");
NSRect Rahmen=[self bounds];
//NSLog(@"setErgebnisView: Rahmen: \nx: %d y: %d\nb: %d h: %d",Rahmen.origin.x,Rahmen.origin.y,Rahmen.size.width, Rahmen.size.height);
//[self setFieldEditor:YES];
//[self setBackgroundColor:[NSColor greenColor]];
[self setTextColor:[NSColor blackColor]];
[self setAlignment:NSCenterTextAlignment];
//[self addToolTip:@"Ergebnis"];
NSFont* HexFont=[NSFont fontWithName:@"Helvetica" size: 28];
[self setEditable:NO];
[self setSelectable:NO];
[self setString:@""];
[self setFont:HexFont];
//[self setTag:1];
//NSLog(@"setErgebnisView Ende");
}

- (void)keyDown:(NSEvent *)theEvent
{
	NSString* c=[theEvent characters];
	NSLog(@"keyDown: c: %@  code: %d",c,[theEvent keyCode]);
	if ([theEvent keyCode]==36)//enter
	{
		if ([[self string]length]==2)
		{
			NSLog(@"keyDown:EnterKey");
			NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[NotificationDic setObject:[NSNumber numberWithInt:36] forKey:@"key"];
			[NotificationDic setObject:[[self string]uppercaseString] forKey:@"hexwert"];
			[self setString:[[self string]uppercaseString]];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"EingabeFertig" object:self userInfo:NotificationDic];
			//[self setEditable:NO];
			//[self setSelectable:NO];
		}
	}
	else	//nicht enter
	{
	if (([theEvent keyCode]==51)||[HexSet characterIsMember:[c characterAtIndex:0]])//Delete
		{
		[super keyDown:theEvent];
		}
		else
		{
		NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[NotificationDic setObject:[theEvent characters] forKey:@"falscheszeichen"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"FalschesZeichen" object:self userInfo:NotificationDic];

		NSSound* FalschesZeichenSnd=[NSSound soundNamed:@"FalschesZeichen"];
		if (FalschesZeichenSnd)
		{
			[FalschesZeichenSnd play];
			
		}
		
		NSAlert * FalschesZeichenAlert=[NSAlert alertWithMessageText:@"Falsches Zeichen!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Zeichen: %@\n%@",[theEvent characters],@"Es sind nur die Ziffern von 0 bis 9 erlaubt"];
		[FalschesZeichenAlert runModal];
		//NSLog(@"Falsches Zeichen");
		}
	}
}

/*
- (void)drawRect:(NSRect) rect
{

	//NSLog(@"drawRect: mark:%d",mark);
	[super drawRect:rect];
	//return;
	//[[NSColor whiteColor]set];
	NSRect RahmenRect=rect;
	NSPoint a=RahmenRect.origin;
	RahmenRect.origin.x+=1;
	RahmenRect.origin.y+=1;
	RahmenRect.size.width-=2;
	RahmenRect.size.height-=2;
	NSBezierPath* RahmenPath;
	RahmenPath=[NSBezierPath bezierPathWithRect:RahmenRect];
	[[NSColor grayColor]set];
	[RahmenPath stroke];
	return;
	switch (mark)
	{
	case 0://clear
	{
	[self setString:@""];
	NSLog(@"clear");
	[super drawRect:rect];

	
	[[NSColor grayColor]set];
	
	[RahmenPath stroke];
	[[NSColor blackColor]set];
	mark=-1;
	//
	}break;
	case 1://richtig
	{
	[super drawRect:rect];

	[[NSColor greenColor]set];
	[RahmenPath stroke];


	}break;
	case 2://falsch
	{
	[super drawRect:rect];

	NSPoint obenlinks=RahmenRect.origin;
	obenlinks.y+=RahmenRect.size.height-1;
	obenlinks.x+=1;
	NSPoint untenrechts=a;
	untenrechts.x+=RahmenRect.size.width-1;
	untenrechts.y+=1;
	NSPoint untenlinks=a;
	NSPoint obenrechts=a;
	obenrechts.x+=RahmenRect.size.width;
	obenrechts.y+=RahmenRect.size.height;
	NSBezierPath* KreuzPath=[NSBezierPath bezierPath];
	[[NSColor redColor]set];
	[KreuzPath moveToPoint:obenlinks];
	[KreuzPath lineToPoint:untenrechts];
	//
	[KreuzPath moveToPoint:untenlinks];
	[KreuzPath lineToPoint:obenrechts];
	
	[KreuzPath stroke];

	}break;
	default:
	{
	[super drawRect:rect];
	}
	}//switch
	

}

*/
- (void)ErgebnisFeldAktion:(id)sender
{
NSLog(@"rErgebnisView  ErgebnisFeldAktion");
//[OKTaste performClick:NULL];


[self setSelectable:NO];
[self setEditable:NO];
[self display];

}

- (void)textDidChange:(NSNotification *)aNotification

{
//- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
NSLog(@"ErgebnisView: textDidChange");

}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
NSLog(@"ErgebnisView: controlTextDidEndEditingd");
[self setSelectable:NO];
[self setEditable:NO];
[self display];


}

@end
