//
//  rEinstellungen.m
//  WebInterface
//
//  Created by Sysadmin on 12.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rEinstellungen.h"


@implementation rGraph

- (id)initWithFrame:(NSRect)frame 

{
	//NSLog(@"Graph init");
   self = [super initWithFrame:frame];
   if (self) 
   {
      DatenDic=[[[NSArray alloc ]init]autorelease];
      oldMauspunkt = NSMakePoint(0,0);
      scale = 1;
      mausistdown=0;
      klickpunkt=-1;
      startklickpunkt=-1;
      klickset = [NSMutableIndexSet indexSet];
      NSRect Diagrammfeld=frame;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
      Mittelpunkt = NSMakePoint(frame.size.width/2, frame.size.height/2);
      StartPunkt = Mittelpunkt;
      EndPunkt = Mittelpunkt;
		Graph=[NSBezierPath bezierPath];
		[Graph retain];
		//[Graph moveToPoint:Mittelpunkt];
		//lastPunkt=Mittelpunkt;
		GraphFarbe=[NSColor blueColor]; 
		//NSLog(@"rProfilGitterlinien Diagrammfeldhoehe: %2.2f ",(frame.size.height-15));
      
      

      
   }
   return self;
}

- (void)setScale:(int)derScalefaktor
{
	scale = derScalefaktor;
   
}

- (BOOL)canBecomeKeyView
{
   //NSLog(@"canBecomeKeyView");
   return YES;
}

- (BOOL)acceptsFirstResponder 
{
	//NSLog(@"acceptsFirstResponder");
   return YES;
}

- (void)setDaten:(NSDictionary*)datenDic
{
   //NSLog(@"graph setDaten daten: %@",[datenDic description]);
 	[datenDic retain];
	DatenDic=datenDic;
	[DatenDic release];
   //[NSColor clearColor];
   [Graph removeAllPoints];
   
   float deltaX=0;
   float deltaY=0;
   if ([DatenDic objectForKey:@"startpunkt"])
   {
      StartPunkt =NSPointFromString([DatenDic objectForKey:@"startpunkt"]);
   }
   else
   {
      StartPunkt = NSMakePoint(0, 0);
   }
   
   if ([DatenDic objectForKey:@"endpunkt"])
   {
      EndPunkt =NSPointFromString([DatenDic objectForKey:@"endpunkt"]);
   }
   else if ([DatenDic objectForKey:@"elementarray"])
   {
      float tempstartx=[[[[DatenDic objectForKey:@"elementarray"]objectAtIndex:0]objectForKey:@"x"]floatValue];
      float tempstarty=[[[[DatenDic objectForKey:@"elementarray"]objectAtIndex:0]objectForKey:@"y"]floatValue];
      EndPunkt.x= [[[[DatenDic objectForKey:@"elementarray"]lastObject]objectForKey:@"x"]floatValue]-tempstartx;
      EndPunkt.y= [[[[DatenDic objectForKey:@"elementarray"]lastObject]objectForKey:@"x"]floatValue]-tempstarty;
   
   }
   
   
   deltaX = EndPunkt.x - StartPunkt.x;
   deltaY = EndPunkt.y - StartPunkt.y;
   StartPunkt = Mittelpunkt;
   EndPunkt.x = Mittelpunkt.x + deltaX;
   EndPunkt.y = Mittelpunkt.y + deltaY;
}

- (void)GitterZeichnen
{	
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	[HorizontaleLinie setLineWidth:0.3];
   float breite=[self bounds].size.width;
   float hoehe=[self bounds].size.height-1;
   NSPoint MitteLinks= NSMakePoint([self bounds].origin.x, Mittelpunkt.y);
   NSPoint MitteRechts= NSMakePoint([self bounds].origin.x + breite, Mittelpunkt.y);
   [HorizontaleLinie moveToPoint:MitteLinks];
   [HorizontaleLinie lineToPoint:MitteRechts];
	[[NSColor whiteColor]set];
	[HorizontaleLinie stroke];
   
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
   NSPoint MitteUnten= NSMakePoint( Mittelpunkt.x,[self bounds].origin.y);
   NSPoint MitteOben= NSMakePoint(Mittelpunkt.x,[self bounds].origin.y + hoehe);
   
   
   [VertikaleLinie moveToPoint:MitteUnten];
   [VertikaleLinie lineToPoint:MitteOben];
	
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor whiteColor]set];
	[VertikaleLinie stroke];
	
	
}

- (void)drawRect:(NSRect)rect
{
   [[NSColor whiteColor]set];
   NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=2;
	NetzBoxRahmen.size.width-=2;
	[[NSColor greenColor]set];
	[NSBezierPath strokeRect:NetzBoxRahmen];
   
   
   [self GitterZeichnen];
   [Graph moveToPoint:StartPunkt];
   [Graph lineToPoint:EndPunkt];
   [[NSColor blueColor]set];
   [Graph stroke];
   
}



@end


@implementation rLibGraph

- (id)initWithFrame:(NSRect)frame 

{
	//NSLog(@"LibGraph init");
   self = [super initWithFrame:frame];
   if (self) 
   {
      DatenDic=[[[NSDictionary alloc ]init]retain];
      oldMauspunkt = NSMakePoint(0,0);
      scale = 1;
      mausistdown=0;
      klickpunkt=-1;
      startklickpunkt=-1;
      klickset = [[NSMutableIndexSet indexSet]retain];
      NSRect Diagrammfeld=frame;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
      Mittelpunkt = NSMakePoint(frame.size.width/2, frame.size.height/2);
      StartPunkt = Mittelpunkt;
      EndPunkt = Mittelpunkt;
		Graph=[NSBezierPath bezierPath];
		[Graph retain];
		//[Graph moveToPoint:Mittelpunkt];
		//lastPunkt=Mittelpunkt;
		GraphFarbe=[NSColor blueColor]; 
		//NSLog(@"rProfilGitterlinien Diagrammfeldhoehe: %2.2f ",(frame.size.height-15));
      ElementArray = [[NSMutableArray alloc]initWithCapacity:0];
      
   }
   return self;
}


- (void)setScale:(int)derScalefaktor
{
	scale = derScalefaktor;
   
}

- (BOOL)canBecomeKeyView
{
   //NSLog(@"canBecomeKeyView");
   return YES;
}

- (BOOL)acceptsFirstResponder 
{
	//NSLog(@"acceptsFirstResponder");
   return YES;
}

- (void)setDaten:(NSDictionary*)datenDic
{
   
   //NSLog(@"Libgraph setDaten daten: %@",[datenDic description]);
 	[datenDic retain];
	DatenDic=datenDic;
	[DatenDic release];
   //[NSColor clearColor];
   [Graph removeAllPoints];
   //[ElementArray removeAllObjects];
   float deltaX=0;
   float deltaY=0;
   
   if ([DatenDic objectForKey:@"startpunkt"])
   {
      StartPunkt =NSPointFromString([DatenDic objectForKey:@"startpunkt"]);
   }
   
   if ([DatenDic objectForKey:@"endpunkt"])
   {
      EndPunkt =NSPointFromString([DatenDic objectForKey:@"endpunkt"]);
  }
   
   
   deltaX = EndPunkt.x - StartPunkt.x;
   deltaY = EndPunkt.y - StartPunkt.y;
   StartPunkt = Mittelpunkt;
   EndPunkt.x = Mittelpunkt.x + deltaX;
   EndPunkt.y = Mittelpunkt.y + deltaY;
   
   
   if ([DatenDic objectForKey:@"elementarray"])
   {
      if (ElementArray)
      {
         [ElementArray removeAllObjects];
         //NSLog(@"Libgraph ElementArray da");
         [ElementArray addObjectsFromArray:[DatenDic objectForKey:@"elementarray"]];
      }
      else
      {
         NSLog(@"Libgraph ElementArray nicht da");
      }
   }
   
   
}

- (void)GitterZeichnen
{	
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	[HorizontaleLinie setLineWidth:0.3];
   float breite=[self bounds].size.width;
   float hoehe=[self bounds].size.height-1;
   NSPoint MitteLinks= NSMakePoint([self bounds].origin.x, Mittelpunkt.y);
   NSPoint MitteRechts= NSMakePoint([self bounds].origin.x + breite, Mittelpunkt.y);
   [HorizontaleLinie moveToPoint:MitteLinks];
   [HorizontaleLinie lineToPoint:MitteRechts];
	[[NSColor whiteColor]set];
	[HorizontaleLinie stroke];
   
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
   NSPoint MitteUnten= NSMakePoint( Mittelpunkt.x,[self bounds].origin.y);
   NSPoint MitteOben= NSMakePoint(Mittelpunkt.x,[self bounds].origin.y + hoehe);
   
   
   [VertikaleLinie moveToPoint:MitteUnten];
   [VertikaleLinie lineToPoint:MitteOben];
	
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor whiteColor]set];
	[VertikaleLinie stroke];
	
	
}

- (void)GitterZeichnenMitUrsprung:(NSPoint)ursprung
{	
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	[HorizontaleLinie setLineWidth:0.3];
   float breite=[self bounds].size.width;
   float hoehe=[self bounds].size.height-1;
   NSPoint MitteLinks= NSMakePoint([self bounds].origin.x, ursprung.y);
   NSPoint MitteRechts= NSMakePoint([self bounds].origin.x + breite, ursprung.y);
   [HorizontaleLinie moveToPoint:MitteLinks];
   [HorizontaleLinie lineToPoint:MitteRechts];
	[[NSColor greenColor]set];
	[HorizontaleLinie stroke];
   
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
   NSPoint MitteUnten= NSMakePoint( ursprung.x,[self bounds].origin.y);
   NSPoint MitteOben= NSMakePoint(ursprung.x,[self bounds].origin.y + hoehe);
   
   
   [VertikaleLinie moveToPoint:MitteUnten];
   [VertikaleLinie lineToPoint:MitteOben];
	
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor greenColor]set];
	[VertikaleLinie stroke];
	
	
}

- (void)drawRect:(NSRect)rect
{
   //NSLog(@"LibGraph drawRect");
   [[NSColor whiteColor]set];
   NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=2;
	NetzBoxRahmen.size.width-=2;
	[[NSColor greenColor]set];
	[NSBezierPath strokeRect:NetzBoxRahmen];
   float maxX=0,  maxY=0, minX=1000, minY=1000;
   
   if (ElementArray)//&&[ElementArray count])
   {
      //NSLog(@"LibGraph drawRect 1 ElementArray: %@",[ElementArray description]);
      //NSLog(@"LibGraph drawRect ElementArray da");
   }
   else
   {
      //NSLog(@"LibGraph drawRect kein ElementArray");
   }
   //return;
   if (ElementArray&&[ElementArray count])
   {
      //NSLog(@"LibGraph drawRect 1 ElementArray: %@",[ElementArray description]);
      int i;
      for(i=0;i<[ElementArray count];i++)
      {
         float tempX = [[[ElementArray objectAtIndex:i]objectForKey:@"x"]floatValue];
         float tempY = [[[ElementArray objectAtIndex:i]objectForKey:@"y"]floatValue];
         
         //NSLog(@"index: %d tempX: %1.1f tempY: %1.1f *** minX: %1.1f maxX: %1.1f minY: %1.1f maxY: %1.1f",i,tempX,tempY,minX, maxY, minY, maxY);
         //NSLog(@"index: %d tempX: %1.1f tempY: %1.1f",i,tempX,tempY);
         if (tempX > maxX)
         {
            maxX = tempX;
         }
         if (tempY > maxY)
         {
            maxY = tempY;
         }
         if (tempX < minX)
         {
            minX = tempX;
         }
         if (tempY < minY)
         {
            minY = tempY;
         }
         
      }
      
      
      //NSLog(@"minX: %1.1f maxX: %1.1f minY: %1.1f maxY: %1.1f",minX, maxX, minY, maxY);
      float feldbreite = [self bounds].size.width;
      float feldhoehe = [self bounds].size.height;
      float elementbreite=(maxX-minX);
      float elementhoehe = (maxY-minY);
      float scalex=feldbreite/elementbreite;
      float scaley=feldhoehe/elementhoehe;
      
      
      //NSLog(@"laenge: %1.1f hoehe: %1.1f elementbreite: %1.3f elementhoehe: %1.3f",feldbreite, feldhoehe, elementbreite, elementhoehe);
      //NSLog(@" scalex: %1.3f scaley: %1.3f", scalex, scaley);
      if (scalex >= scaley)
      {
         scale = scaley;
      }
      else
      {
         scale = scalex;
      }
      //NSLog(@"scale: %1.1f",scale);
      scale *= 0.8;
      //Mittelpunkt des Elements suchen
      float offsetX= (maxX+minX)/2;
      float offsetY= (maxY+minY)/2;
      //NSLog(@" offsetX: %1.1f offsetY: %1.1f", offsetX, offsetY);
      
      
      
      NSPoint scaleStartPunkt= NSMakePoint(([[[ElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
      NSPoint scaleEndPunkt= NSMakePoint(([[[ElementArray lastObject]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray lastObject]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
      
      [self GitterZeichnenMitUrsprung:scaleStartPunkt];
      
      //NSLog(@"StartPunkt.x: %1.3f StartPunkt.y: %1.3f EndPunkt.x: %1.3f EndPunkt.y: %1.3f",scaleStartPunkt.x, scaleStartPunkt.y, scaleEndPunkt.x, scaleEndPunkt.y);
      
      //[Graph moveToPoint:scaleStartPunkt];
      for (i=0;i<[ElementArray count];i++)
      {
         NSPoint tempPunkt= NSMakePoint(([[[ElementArray objectAtIndex:i]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray objectAtIndex:i]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
         // NSLog(@"index: %d tempPunkt.x: %1.3f tempPunkt.y: %1.3f",i,tempPunkt.x, tempPunkt.y);
         if (i)
         {
            [Graph lineToPoint:tempPunkt];
         }
         else
         {
            [Graph moveToPoint:tempPunkt];
         }
      }
      //[Graph lineToPoint:scaleEndPunkt];
      [[NSColor blueColor]set];
      [Graph stroke];
      
   }// if count
   
}

- (void)clearGraph
{
   [Graph removeAllPoints];
   [ElementArray removeAllObjects];
   [self setNeedsDisplay:YES];
   
}

- (void)dealloc
{
   [ElementArray release];
}


@end

@implementation rProfilLibGraph

- (id)initWithFrame:(NSRect)frame 

{
	//NSLog(@"LibGraph init");
   self = [super initWithFrame:frame];
   if (self) 
   {
      DatenDic=[[[NSArray alloc ]init]retain];
      oldMauspunkt = NSMakePoint(0,0);
      scale = 1;
      mausistdown=0;
      klickpunkt=-1;
      startklickpunkt=-1;
      klickset = [[NSMutableIndexSet indexSet]retain];
      NSRect Diagrammfeld=frame;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
      Mittelpunkt = NSMakePoint(frame.size.width*0.1, frame.size.height/2);
      StartPunkt = Mittelpunkt;
      EndPunkt = Mittelpunkt;
		Graph=[NSBezierPath bezierPath];
		[Graph retain];
		//[Graph moveToPoint:Mittelpunkt];
		//lastPunkt=Mittelpunkt;
		GraphFarbe=[NSColor blueColor]; 
		//NSLog(@"rProfilGitterlinien Diagrammfeldhoehe: %2.2f ",(frame.size.height-15));
      ElementArray = [[NSMutableArray alloc]initWithCapacity:0];
      Profil1Array = [[NSMutableArray alloc]initWithCapacity:0];
      Profil2Array = [[NSMutableArray alloc]initWithCapacity:0];
      
   }
   return self;
}


- (void)setScale:(int)derScalefaktor
{
	scale = derScalefaktor;
   
}

- (BOOL)canBecomeKeyView
{
   //NSLog(@"canBecomeKeyView");
   return YES;
}

- (BOOL)acceptsFirstResponder 
{
	//NSLog(@"acceptsFirstResponder");
   return YES;
}

- (void)setDaten:(NSDictionary*)datenDic
{
   //NSLog(@"graph setDaten daten: %@",[datenDic description]);
   float faktor = [self bounds].size.width;
   faktor *= 0.8;

 	[datenDic retain];
	DatenDic=datenDic;
	[DatenDic release];
   //[NSColor clearColor];
   [Graph removeAllPoints];
   [ElementArray  removeAllObjects];
   //[Profil1Array  removeAllObjects];
   //[Profil2Array  removeAllObjects];
  // NSMutableArray* tempElementArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];

    if ([DatenDic objectForKey:@"profil1array"])
    {
       [Profil1Array  removeAllObjects];
       NSArray* tempElementArray = [DatenDic objectForKey:@"profil1array"];
       
       int i=0;
       for (i=0;i< [tempElementArray count]; i++)
       {
          NSDictionary* tempZeilenDic = [tempElementArray objectAtIndex:i];
          float tempx=[[tempZeilenDic objectForKey:@"x"]floatValue]*faktor;
          float tempy=[[tempZeilenDic objectForKey:@"y"]floatValue]*faktor;
          NSDictionary* faktorZeilenDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempx],@"x",[NSNumber numberWithFloat:tempy],@"y", nil];
         [ElementArray addObject:faktorZeilenDic];
          [Profil1Array addObject:faktorZeilenDic];
       }
    }
   if ([DatenDic objectForKey:@"profil2array"])
   {
      NSDictionary* trennDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0],@"x",[NSNumber numberWithFloat:0],@"y", nil];
      [Profil2Array  removeAllObjects];
      NSArray* tempElementArray = [DatenDic objectForKey:@"profil2array"];
      
      int i=0;
      for (i=0;i< [tempElementArray count]; i++)
      {
         NSDictionary* tempZeilenDic = [tempElementArray objectAtIndex:i];
         float tempx=[[tempZeilenDic objectForKey:@"x"]floatValue]*faktor;
         float tempy=[[tempZeilenDic objectForKey:@"y"]floatValue]*faktor;
         NSDictionary* faktorZeilenDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempx],@"x",[NSNumber numberWithFloat:tempy],@"y", nil];
         [Profil2Array addObject:faktorZeilenDic];
//         [ElementArray addObject:faktorZeilenDic];
      }
   }
  
    
}

- (void)GitterZeichnen
{	
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	[HorizontaleLinie setLineWidth:0.3];
   float breite=[self bounds].size.width;
   float hoehe=[self bounds].size.height-1;
   NSPoint MitteLinks= NSMakePoint([self bounds].origin.x, Mittelpunkt.y);
   NSPoint MitteRechts= NSMakePoint([self bounds].origin.x + breite, Mittelpunkt.y);
   [HorizontaleLinie moveToPoint:MitteLinks];
   [HorizontaleLinie lineToPoint:MitteRechts];
	[[NSColor whiteColor]set];
	[HorizontaleLinie stroke];
   
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
   NSPoint MitteUnten= NSMakePoint( Mittelpunkt.x,[self bounds].origin.y);
   NSPoint MitteOben= NSMakePoint(Mittelpunkt.x,[self bounds].origin.y + hoehe);
   
   
   [VertikaleLinie moveToPoint:MitteUnten];
   [VertikaleLinie lineToPoint:MitteOben];
	
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor whiteColor]set];
	[VertikaleLinie stroke];
	
	
}


- (void)drawRect:(NSRect)rect
{
   //NSLog(@"ProfilLibGraph drawRect");
   [[NSColor whiteColor]set];
   NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=2;
	NetzBoxRahmen.size.width-=2;
	[[NSColor greenColor]set];
	[NSBezierPath strokeRect:NetzBoxRahmen];
   
   if (Profil1Array&&[Profil1Array count])
   {
      float maxX=0,  maxY=0, minX=1000, minY=1000;
      //NSLog(@"LibGraph drawRect 1 Profil1Array: %@",[Profil1Array description]);
      int i;
      for(i=0;i<[Profil1Array count];i++)
      {
         float tempX = [[[Profil1Array objectAtIndex:i]objectForKey:@"x"]floatValue];
         float tempY = [[[Profil1Array objectAtIndex:i]objectForKey:@"y"]floatValue];
         
         //NSLog(@"index: %d tempX: %1.1f tempY: %1.1f *** minX: %1.1f maxX: %1.1f minY: %1.1f maxY: %1.1f",i,tempX,tempY,minX, maxY, minY, maxY);
         //NSLog(@"index: %d tempX: %1.1f tempY: %1.1f",i,tempX,tempY);
         if (tempX > maxX)
         {
            maxX = tempX;
         }
         if (tempY > maxY)
         {
            maxY = tempY;
         }
         if (tempX < minX)
         {
            minX = tempX;
         }
         if (tempY < minY)
         {
            minY = tempY;
         }
         
      } // for i
      
      
      //NSLog(@"minX: %1.1f maxX: %1.1f minY: %1.1f maxY: %1.1f",minX, maxX, minY, maxY);
      float feldbreite = [self bounds].size.width;
      float feldhoehe = [self bounds].size.height;
      float elementbreite=(maxX-minX);
      float elementhoehe = (maxY-minY);
      float scalex=feldbreite/elementbreite;
      float scaley=feldhoehe/elementhoehe;
      
      
      //NSLog(@"laenge: %1.1f hoehe: %1.1f elementbreite: %1.3f elementhoehe: %1.3f",feldbreite, feldhoehe, elementbreite, elementhoehe);
      //NSLog(@" scalex: %1.3f scaley: %1.3f", scalex, scaley);
      if (scalex >= scaley)
      {
         scale = scaley;
      }
      else
      {
         scale = scalex;
      }
      //NSLog(@"scale: %1.1f",scale);
      scale *= 0.8;
      //Startpunkt des Elements suchen
      float offsetX= (maxX+minX)/2;
      float offsetY= (maxY+minY)/2;
      
      //NSLog(@"offsetX: %1.1f offsetY: %1.1f", offsetX, offsetY);
      offsetX=elementbreite * 0.1;
      offsetY=0;
      
      NSPoint scaleStartPunkt= NSMakePoint(([[[ElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
      NSPoint scaleEndPunkt= NSMakePoint(([[[ElementArray lastObject]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray lastObject]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
      
      //     [self GitterZeichnenMitUrsprung:scaleStartPunkt];
      
      //NSLog(@"StartPunkt.x: %1.3f StartPunkt.y: %1.3f EndPunkt.x: %1.3f EndPunkt.y: %1.3f",scaleStartPunkt.x, scaleStartPunkt.y, scaleEndPunkt.x, scaleEndPunkt.y);
      
      //[Graph moveToPoint:scaleStartPunkt];
      int lageY = feldhoehe/2;
      if ([Profil2Array count])
      {
         lageY = feldhoehe/5;
      }
      for (i=0;i<[Profil1Array count];i++)
      {
         NSPoint tempPunkt= NSMakePoint(([[[Profil1Array objectAtIndex:i]objectForKey:@"x"]floatValue])*scale+offsetX , ([[[Profil1Array objectAtIndex:i]objectForKey:@"y"]floatValue]- offsetY)*scale+lageY );
         // NSLog(@"index: %d tempPunkt.x: %1.3f tempPunkt.y: %1.3f",i,tempPunkt.x, tempPunkt.y);
         if (i)
         {
            [Graph lineToPoint:tempPunkt];
         }
         else
         {
            [Graph moveToPoint:tempPunkt];
         }
      }
      [[NSColor blueColor]set];
      [Graph stroke];
      
      if (Profil2Array&&[Profil2Array count])
      {
      lageY = feldhoehe*3/5;
         for (i=0;i<[Profil2Array count];i++)
         {
            NSPoint tempPunkt= NSMakePoint(([[[Profil2Array objectAtIndex:i]objectForKey:@"x"]floatValue])*scale+offsetX , ([[[Profil2Array objectAtIndex:i]objectForKey:@"y"]floatValue]- offsetY)*scale+lageY );
            // NSLog(@"index: %d tempPunkt.x: %1.3f tempPunkt.y: %1.3f",i,tempPunkt.x, tempPunkt.y);
            if (i)
            {
               [Graph lineToPoint:tempPunkt];
            }
            else
            {
               [Graph moveToPoint:tempPunkt];
            }
         }
         [[NSColor blueColor]set];

      }
      
      [Graph stroke];
   }// if count
   
}

- (void)clearGraph
{
   [Graph removeAllPoints];
   [ElementArray removeAllObjects];
   [Profil1Array removeAllObjects];
  [Profil2Array removeAllObjects];
   [self setNeedsDisplay:YES];
   
}
@end


@implementation rFigGraph

- (id)initWithFrame:(NSRect)frame 

{
	//NSLog(@"rFigGraph init");
   self = [super initWithFrame:frame];
   if (self) 
   {
      DatenDic=[[[NSDictionary alloc ]init]retain];
      oldMauspunkt = NSMakePoint(0,0);
      scale = 1;
      mausistdown=0;
      klickpunkt=-1;
      startklickpunkt=-1;
      klickset = [[NSMutableIndexSet indexSet]retain];
      NSRect Diagrammfeld=frame;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
      Mittelpunkt = NSMakePoint(frame.size.width/2, frame.size.height/2);
      StartPunkt = Mittelpunkt;
      EndPunkt = Mittelpunkt;
		Graph=[NSBezierPath bezierPath];
		[Graph retain];
		//[Graph moveToPoint:Mittelpunkt];
		//lastPunkt=Mittelpunkt;
		GraphFarbe=[NSColor blueColor]; 
		//NSLog(@"rProfilGitterlinien Diagrammfeldhoehe: %2.2f ",(frame.size.height-15));
      ElementArray = [[[NSMutableArray alloc]initWithCapacity:0]retain];
      
   }
   return self;
}


- (void)setScale:(int)derScalefaktor
{
	scale = derScalefaktor;
   
}

- (BOOL)canBecomeKeyView
{
   //NSLog(@"canBecomeKeyView");
   return YES;
}

- (BOOL)acceptsFirstResponder 
{
	//NSLog(@"acceptsFirstResponder");
   return YES;
}

- (void)setDaten:(NSDictionary*)datenDic
{
   
   //NSLog(@"Figgraph setDaten daten: %@",[datenDic description]);
 	[datenDic retain];
	DatenDic=datenDic;
	[DatenDic release];
   //[NSColor clearColor];
   [Graph removeAllPoints];
   //[ElementArray removeAllObjects];
   float deltaX=0;
   float deltaY=0;
   
   if ([DatenDic objectForKey:@"startpunkt"])
   {
      StartPunkt =NSPointFromString([DatenDic objectForKey:@"startpunkt"]);
   }
   
   if ([DatenDic objectForKey:@"endpunkt"])
   {
      EndPunkt =NSPointFromString([DatenDic objectForKey:@"endpunkt"]);
   }
   
   
   deltaX = EndPunkt.x - StartPunkt.x;
   deltaY = EndPunkt.y - StartPunkt.y;
   StartPunkt = Mittelpunkt;
   EndPunkt.x = Mittelpunkt.x + deltaX;
   EndPunkt.y = Mittelpunkt.y + deltaY;
   
   
   if ([DatenDic objectForKey:@"elementarray"])
   {
      if (ElementArray)
      {
         [ElementArray removeAllObjects];
         //NSLog(@"Libgraph ElementArray da");
         [ElementArray addObjectsFromArray:[DatenDic objectForKey:@"elementarray"]];
      }
      else
      {
         NSLog(@"Libgraph ElementArray nicht da");
      }
   }
   
   
}

- (void)GitterZeichnen
{	
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	[HorizontaleLinie setLineWidth:0.3];
   float breite=[self bounds].size.width;
   float hoehe=[self bounds].size.height-1;
   NSPoint MitteLinks= NSMakePoint([self bounds].origin.x, Mittelpunkt.y);
   NSPoint MitteRechts= NSMakePoint([self bounds].origin.x + breite, Mittelpunkt.y);
   [HorizontaleLinie moveToPoint:MitteLinks];
   [HorizontaleLinie lineToPoint:MitteRechts];
	[[NSColor whiteColor]set];
	[HorizontaleLinie stroke];
   
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
   NSPoint MitteUnten= NSMakePoint( Mittelpunkt.x,[self bounds].origin.y);
   NSPoint MitteOben= NSMakePoint(Mittelpunkt.x,[self bounds].origin.y + hoehe);
   
   
   [VertikaleLinie moveToPoint:MitteUnten];
   [VertikaleLinie lineToPoint:MitteOben];
	
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor whiteColor]set];
	[VertikaleLinie stroke];
	
	
}

- (void)GitterZeichnenMitUrsprung:(NSPoint)ursprung
{	
	NSBezierPath* HorizontaleLinie=[NSBezierPath bezierPath];
	[HorizontaleLinie setLineWidth:0.3];
   float breite=[self bounds].size.width;
   float hoehe=[self bounds].size.height-1;
   NSPoint MitteLinks= NSMakePoint([self bounds].origin.x, ursprung.y);
   NSPoint MitteRechts= NSMakePoint([self bounds].origin.x + breite, ursprung.y);
   [HorizontaleLinie moveToPoint:MitteLinks];
   [HorizontaleLinie lineToPoint:MitteRechts];
	[[NSColor greenColor]set];
	[HorizontaleLinie stroke];
   
	NSBezierPath* VertikaleLinie=[NSBezierPath bezierPath];
   NSPoint MitteUnten= NSMakePoint( ursprung.x,[self bounds].origin.y);
   NSPoint MitteOben= NSMakePoint(ursprung.x,[self bounds].origin.y + hoehe);
   
   
   [VertikaleLinie moveToPoint:MitteUnten];
   [VertikaleLinie lineToPoint:MitteOben];
	
	[VertikaleLinie setLineWidth:0.3];
	[[NSColor greenColor]set];
	[VertikaleLinie stroke];
	
	
}

- (void)drawRect:(NSRect)rect
{
   //NSLog(@"LibGraph drawRect");
   [[NSColor whiteColor]set];
   NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=2;
	NetzBoxRahmen.size.width-=2;
	[[NSColor greenColor]set];
	[NSBezierPath strokeRect:NetzBoxRahmen];
   float maxX=0,  maxY=0, minX=1000, minY=1000;
   
   if (ElementArray)//&&[ElementArray count])
   {
      //NSLog(@"LibGraph drawRect 1 ElementArray: %@",[ElementArray description]);
      //NSLog(@"LibGraph drawRect ElementArray da");
   }
   else
   {
      //NSLog(@"LibGraph drawRect kein ElementArray");
   }
   //return;
   if (ElementArray&&[ElementArray count])
   {
      //NSLog(@"LibGraph drawRect 1 ElementArray: %@",[ElementArray description]);
      int i;
      for(i=0;i<[ElementArray count];i++)
      {
         float tempX = [[[ElementArray objectAtIndex:i]objectForKey:@"x"]floatValue];
         float tempY = [[[ElementArray objectAtIndex:i]objectForKey:@"y"]floatValue];
         
         //NSLog(@"index: %d tempX: %1.1f tempY: %1.1f *** minX: %1.1f maxX: %1.1f minY: %1.1f maxY: %1.1f",i,tempX,tempY,minX, maxY, minY, maxY);
         //NSLog(@"index: %d tempX: %1.1f tempY: %1.1f",i,tempX,tempY);
         if (tempX > maxX)
         {
            maxX = tempX;
         }
         if (tempY > maxY)
         {
            maxY = tempY;
         }
         if (tempX < minX)
         {
            minX = tempX;
         }
         if (tempY < minY)
         {
            minY = tempY;
         }
         
      }
      
      
      //NSLog(@"minX: %1.1f maxX: %1.1f minY: %1.1f maxY: %1.1f",minX, maxX, minY, maxY);
      float feldbreite = [self bounds].size.width;
      float feldhoehe = [self bounds].size.height;
      float elementbreite=(maxX-minX);
      float elementhoehe = (maxY-minY);
      float scalex=feldbreite/elementbreite;
      float scaley=feldhoehe/elementhoehe;
      
      
      //NSLog(@"laenge: %1.1f hoehe: %1.1f elementbreite: %1.3f elementhoehe: %1.3f",feldbreite, feldhoehe, elementbreite, elementhoehe);
      //NSLog(@" scalex: %1.3f scaley: %1.3f", scalex, scaley);
      if (scalex >= scaley)
      {
         scale = scaley;
      }
      else
      {
         scale = scalex;
      }
      //NSLog(@"scale: %1.1f",scale);
      scale *= 0.8;
      //Mittelpunkt des Elements suchen
      float offsetX= (maxX+minX)/2;
      float offsetY= (maxY+minY)/2;
      //NSLog(@" offsetX: %1.1f offsetY: %1.1f", offsetX, offsetY);
      
      
      
      NSPoint scaleStartPunkt= NSMakePoint(([[[ElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
      NSPoint scaleEndPunkt= NSMakePoint(([[[ElementArray lastObject]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray lastObject]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
      
      [self GitterZeichnenMitUrsprung:scaleStartPunkt];
      
      //NSLog(@"StartPunkt.x: %1.3f StartPunkt.y: %1.3f EndPunkt.x: %1.3f EndPunkt.y: %1.3f",scaleStartPunkt.x, scaleStartPunkt.y, scaleEndPunkt.x, scaleEndPunkt.y);
      
      //[Graph moveToPoint:scaleStartPunkt];
      for (i=0;i<[ElementArray count];i++)
      {
         NSPoint tempPunkt= NSMakePoint(([[[ElementArray objectAtIndex:i]objectForKey:@"x"]floatValue]- offsetX)*scale+feldbreite/2 , ([[[ElementArray objectAtIndex:i]objectForKey:@"y"]floatValue]- offsetY)*scale+feldhoehe/2 );
         // NSLog(@"index: %d tempPunkt.x: %1.3f tempPunkt.y: %1.3f",i,tempPunkt.x, tempPunkt.y);
         if (i)
         {
            [Graph lineToPoint:tempPunkt];
         }
         else
         {
            [Graph moveToPoint:tempPunkt];
         }
      }
      //[Graph lineToPoint:scaleEndPunkt];
      [[NSColor blueColor]set];
      [Graph stroke];
      
   }// if count
   
}

- (void)clearGraph
{
   [Graph removeAllPoints];
   [ElementArray removeAllObjects];
   [self setNeedsDisplay:YES];
   
}

- (void)dealloc
{
   [ElementArray release];
}


@end


@implementation rEinstellungen
- (id) init
{
   //NSLog(@"Einstellungen init");
	self=[super initWithWindowNibName:@"CNC_Eingabe"];
   
   NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	
   [nc addObserver:self
          selector:@selector(EingabedatenAktion:)
              name:@"eingabedaten"
            object:nil];
   
	
   zoom=1;
   /*  
    ElementLibArray = [[self readLib]retain];
    NSLog(@"Einstellungen init ElementLibArray: %@",[ElementLibArray valueForKey:@"name"]);
    LibElementName = [[NSString string]retain];
    LibElementArray = [[[NSMutableArray alloc]initWithCapacity:0]retain];
    */
   
   FormNamenArray = [NSArray arrayWithObjects:@"Kreis",@"Ellipse",@"Quadrat",@"Rechteck", nil];
   PList = [[[NSMutableDictionary alloc]initWithCapacity:0]retain];
   flipH =0;
   flipV =0;
   reverse =0;

	return self;
}

- (void)awakeFromNib
{
	//NSLog(@"Einstellungen awake");
	NSFont* Tablefont;
	Tablefont=[NSFont fontWithName:@"Helvetica" size: 12];
   NSNumberFormatter* Eingabeformatter=[[[NSNumberFormatter alloc] init] autorelease];
   [Eingabeformatter setFormat:@"###.0;0.0;(##0.0)"];//#,###.00;0.00;($#,##0.00
   [Eingabeformatter setNumberStyle:NSNumberFormatterDecimalStyle];
//   [StartpunktX setDelegate:self];
   [StartpunktX setAlignment:NSRightTextAlignment];
   [StartpunktX setFormatter:Eingabeformatter];
   
   [StartpunktY setDelegate:self];
   [StartpunktY setAlignment:NSRightTextAlignment];
   [StartpunktY setFormatter:Eingabeformatter];
   
   [EndpunktX setDelegate:self];
   [EndpunktX setAlignment:NSRightTextAlignment];
   [EndpunktX setFormatter:Eingabeformatter];
   
   [EndpunktY setDelegate:self];
   [EndpunktY setAlignment:NSRightTextAlignment];
   [EndpunktY setFormatter:Eingabeformatter];
   
   [deltaX setDelegate:self];
   [deltaX setAlignment:NSRightTextAlignment];
   [deltaX setFormatter:Eingabeformatter];
   
   [deltaY setDelegate:self];
   [deltaY setAlignment:NSRightTextAlignment];
   [deltaY setFormatter:Eingabeformatter];
   
   
   [Laenge  setDelegate:self];
   [Laenge setAlignment:NSRightTextAlignment];
   [Laenge setFormatter:Eingabeformatter];
   
   [Winkel  setDelegate:self];
   [Winkel setAlignment:NSRightTextAlignment];
   [Winkel setFormatter:Eingabeformatter];
   
   
   //[LaengeSlider setNumberOfTickMarks:101];
   
   [Graph setNeedsDisplay:YES];
   
   
   [LibStartpunktX setDelegate:self];
   [LibStartpunktX setAlignment:NSRightTextAlignment];
   [LibStartpunktX setFormatter:Eingabeformatter];
   
   [LibStartpunktY setDelegate:self];
   [LibStartpunktY setAlignment:NSRightTextAlignment];
   [LibStartpunktY setFormatter:Eingabeformatter];
   
   [LibEndpunktX setDelegate:self];
   [LibEndpunktX setAlignment:NSRightTextAlignment];
   [LibEndpunktX setFormatter:Eingabeformatter];
   
   [LibEndpunktY setDelegate:self];
   [LibEndpunktY setAlignment:NSRightTextAlignment];
   [LibEndpunktY setFormatter:Eingabeformatter];
   //   ElementLibArray = (NSMutableArray*)[[self readLib]retain];
   //NSLog(@"Einstellungen awake ElementLibArray: %@",[ElementLibArray valueForKey:@"name"]);
   LibElementName = [[NSString string]retain];
   LibElementArray = [[[NSMutableArray alloc]initWithCapacity:0]retain];
   
   FigElementArray = [[[NSMutableArray alloc]initWithCapacity:0]retain];
   
   //NSLog(@"Einstellungen awake end");
   NSArray* MatrixArray=[WinkelMatrix subviews];
   //NSLog(@"MatrixArray: %d desc: %@",[MatrixArray count],[MatrixArray description]);
   int i;
   for(i=0;i<[MatrixArray count];i++)
   {
      //NSLog(@"i: %d tag: %d",i,[[MatrixArray objectAtIndex:i]tag]);
      [[MatrixArray objectAtIndex:i]setAction:@selector(reportWinkelMatrixknopf:) ] ;
   }
   Utils = [[[rUtils alloc]init]retain];
   
   // Profil
   [Profil1Tiefe setDelegate:self];
   [Profil1Tiefe setAlignment:NSRightTextAlignment];
   [Profil1Tiefe setIntValue:100];
   //[ProfilStartpunktX setFormatter:Eingabeformatter];
   [Profil2Tiefe setDelegate:self];
   [Profil2Tiefe setAlignment:NSRightTextAlignment];
   [Profil2Tiefe setIntValue:90];
   //[ProfilStartpunktX setFormatter:Eingabeformatter];
   
   [ProfilStartpunktX setDelegate:self];
   [ProfilStartpunktX setAlignment:NSRightTextAlignment];
   [ProfilStartpunktX setFormatter:Eingabeformatter];
   
   [ProfilStartpunktY setDelegate:self];
   [ProfilStartpunktY setAlignment:NSRightTextAlignment];
   [ProfilStartpunktY setFormatter:Eingabeformatter];
   
   [ProfilEndpunktX setDelegate:self];
   [ProfilEndpunktX setAlignment:NSRightTextAlignment];
   [ProfilEndpunktX setFormatter:Eingabeformatter];
   
   [ProfilEndpunktY setDelegate:self];
   [ProfilEndpunktY setAlignment:NSRightTextAlignment];
   [ProfilEndpunktY setFormatter:Eingabeformatter];
   Profil1Name = [[NSString string]retain];
   Profil2Name = [[NSString string]retain];
   Profil1Array = [[[NSMutableArray alloc]initWithCapacity:0]retain];
   Profil2Array = [[[NSMutableArray alloc]initWithCapacity:0]retain];
   
   [Einlauflaenge  setDelegate:self];
   [Einlauflaenge setAlignment:NSRightTextAlignment];
   [Einlauflaenge setFormatter:Eingabeformatter];
   
   [Einlauftiefe  setDelegate:self];
   [Einlauftiefe setAlignment:NSRightTextAlignment];
   [Einlauftiefe setFormatter:Eingabeformatter];
 
   [Auslauflaenge  setDelegate:self];
   [Auslauflaenge setAlignment:NSRightTextAlignment];
   [Auslauflaenge setFormatter:Eingabeformatter];
   [Auslauflaenge setFloatValue:10];

   [Auslauftiefe  setDelegate:self];
   [Auslauftiefe setAlignment:NSRightTextAlignment];
   [Auslauftiefe setFormatter:Eingabeformatter];
   
   [Einlauflaenge setFloatValue:15];
   [Einlauftiefe setFloatValue:15];
   [Auslauflaenge setFloatValue:10];
   [Auslauftiefe setFloatValue:15];

   // Form
   CNC = [[[rCNC alloc]init]retain];
 //  [SeiteA1 setDelegate:self];
   [SeiteA1 setAlignment:NSRightTextAlignment];
   [SeiteA1 setFormatter:Eingabeformatter];
   
   [SeiteB1 setDelegate:self];
   [SeiteB1 setAlignment:NSRightTextAlignment];
   [SeiteB1 setFormatter:Eingabeformatter];
   
//   [Winkel1 setDelegate:self];
   [Winkel1 setAlignment:NSRightTextAlignment];
   [Winkel1 setFormatter:Eingabeformatter];
   
//   [SeiteA2 setDelegate:self];
   [SeiteA2 setAlignment:NSRightTextAlignment];
   [SeiteA2 setFormatter:Eingabeformatter];
   
//   [SeiteB2 setDelegate:self];
   [SeiteB2 setAlignment:NSRightTextAlignment];
   [SeiteB2 setFormatter:Eingabeformatter];
   
//   [Winkel2 setDelegate:self];
   [Winkel2 setAlignment:NSRightTextAlignment];
   [Winkel2 setFormatter:Eingabeformatter];
   
   [Form1Pop removeAllItems];
   [Form1Pop addItemsWithTitles:FormNamenArray];
   [Form2Pop removeAllItems];
   [Form2Pop addItemsWithTitles:FormNamenArray];

   NSArray* FormArray = [NSArray arrayWithObjects:@"oben",@"links",@"unten",@"rechts", nil];
   [LagePop removeAllItems];
   [LagePop addItemsWithTitles:FormArray];

   [Blockoberkante setAlignment:NSRightTextAlignment];
   [Blockoberkante setIntValue:50];
   //[Blockoberkante  setFormatter:Eingabeformatter];
   
   [Auslaufkote setAlignment:NSRightTextAlignment];
   [Auslaufkote setIntValue:50];
   //[Auslaufkote  setFormatter:Eingabeformatter];
   
   [Blockbreite setAlignment:NSRightTextAlignment];
   [Blockbreite setIntValue:200];
   //[Blockbreite  setFormatter:Eingabeformatter];
   
   [Blockdicke setAlignment:NSRightTextAlignment];
   [Blockdicke setIntValue:50];
   //[Blockdicke  setFormatter:Eingabeformatter];

}

- (float)calcWinkel
{
   float deltax=[EndpunktX floatValue]- [StartpunktX floatValue];
   float deltay=[EndpunktY floatValue]- [StartpunktY floatValue];
   float newWinkel= atanf(deltay/deltax);
   newWinkel *= 180.0;
   newWinkel /= M_PI;
   //NSLog(@"calcWinkel deltax: %2.1f deltay: %2.1f newWinkel: %2.2f",deltax, deltay, newWinkel);
   return newWinkel;
}

- (float)calcLaenge
{
   float deltax=[EndpunktX floatValue]- [StartpunktX floatValue];
   float deltay=[EndpunktY floatValue]- [StartpunktY floatValue];
   float newLaenge=sqrtf(powf(deltax,2) + powf(deltay,2));
   return newLaenge;
}

- (float)calcX
{
   float arc = [Winkel floatValue]/180*M_PI;
   float l=[Laenge floatValue];
   float deltax = l*cosf(arc);
   float newX = [StartpunktX floatValue]+ deltax;
   //NSLog(@"calcX cos %2.3f laenge: %2.1f newX: %2.2f",cosf(arc), l, newX);
   
   return newX;
}

- (float)calcY
{
   float arc = [Winkel floatValue]/180*M_PI;
   float l=[Laenge floatValue];
   float deltay = l*sinf(arc);
   float newY = [StartpunktY floatValue]+ deltay;
   //NSLog(@"calcY sin %2.3f laenge: %2.1f newY: %2.2f",sinf(arc), l, newY);
   return newY;
}

// set
- (void)setDeltaX
{
   float deltax=[EndpunktX floatValue]-[StartpunktX floatValue];
   [deltaX setFloatValue: deltax];
   [deltaXStepper setFloatValue: deltax];
   [deltaXSlider setFloatValue: deltax];
}

- (void)setDeltaY
{
   float deltay=[EndpunktY floatValue]-[StartpunktY floatValue];
   [deltaY setFloatValue: deltay];
   [deltaYStepper setFloatValue: deltay];
   [deltaYSlider setFloatValue: deltay];
}

- (void)setEndXvar
{
   float endx = [EndpunktX floatValue];
   [EndpunktXStepper setFloatValue:endx];
   [EndpunktXSlider setFloatValue:endx];
   
}

- (void)setEndYvar
{
   [EndpunktYStepper setFloatValue:[EndpunktY floatValue]];
   [EndpunktYSlider setFloatValue:[EndpunktY floatValue]];
}

- (void)setEndXYfix
{
   [EndpunktX setFloatValue: [self calcX]];
   [EndpunktY setFloatValue: [self calcY]];
}

- (void)setLaengeUndWinkelvar
{
   [LaengeStepper setFloatValue:[Laenge floatValue]];
   [LaengeSlider setFloatValue:[Laenge floatValue]];
   
   [WinkelStepper setFloatValue:[Winkel floatValue]];
   [WinkelSlider setFloatValue:[Winkel floatValue]];
}

- (void)setLaengeUndWinkelfix
{
   [Laenge setFloatValue:[self calcLaenge]];
   [Winkel setFloatValue:[self calcWinkel]];
}
// end set


- (void)setDaten:(NSDictionary*)daten
{
   //NSLog(@"setDaten daten: %@",[daten description]);
   
   if ([daten objectForKey:@"element"])
   {
      [Element setStringValue:[daten objectForKey:@"element"]];
   }
   else
   {
      [Element setStringValue:@"Element"];
   }
   
   if ([daten objectForKey:@"startx"])
   {
      //[StartpunktX setFloatValue:[[daten objectForKey:@"startx"]floatValue]];// 
      startx = [[daten objectForKey:@"startx"]floatValue];
   }
   else
   {
      //[StartpunktX setFloatValue:25.0];
      startx=0;
   }
   [StartpunktX setFloatValue:0.0];
   // [StartpunktXSlider setFloatValue:[StartpunktX floatValue]];
   // [StartpunktXStepper setFloatValue:[StartpunktX floatValue]];
   
   
   
   if ([daten objectForKey:@"starty"])
   {
      //[StartpunktY setFloatValue:[[daten objectForKey:@"starty"]floatValue]];// 
      starty = [[daten objectForKey:@"starty"]floatValue];
   }
   else
   {
      //[StartpunktY setFloatValue:25.0];
      starty=0;
   }
   [StartpunktY setFloatValue:0.0];
   //[StartpunktYSlider setFloatValue:[StartpunktY floatValue]];
   //[StartpunktYStepper setFloatValue:[StartpunktY floatValue]];
   
   if ([daten objectForKey:@"endx"])
   {
      [EndpunktX setFloatValue:[[daten objectForKey:@"endx"]floatValue]];// 
   }
   else
   {
      [EndpunktX setFloatValue:10.0];
   }
   //[EndpunktX setFloatValue:20.0];
   [EndpunktXSlider setFloatValue:[EndpunktX floatValue]];
   [EndpunktXStepper setFloatValue:[EndpunktX floatValue]];
   
   
   if ([daten objectForKey:@"endy"])
   {
      [EndpunktY setFloatValue:[[daten objectForKey:@"endy"]floatValue]];// 
   }
   else
   {
      [EndpunktY setFloatValue:0.0];
   }
   //[EndpunktY setFloatValue:0.0];
   [EndpunktYSlider setFloatValue:[EndpunktY floatValue]];
   [EndpunktYStepper setFloatValue:[EndpunktY floatValue]];
   ;
   /*
    if ([daten objectForKey:@"laenge"])
    {
    [Laenge setFloatValue:[[daten objectForKey:@"laenge"]floatValue]];// 
    }
    else
    {
    [Laenge setFloatValue:50.0];
    }
    */
   [Laenge setFloatValue:[self calcLaenge]];
   [LaengeStepper setFloatValue:[Laenge floatValue]];
   [LaengeSlider setFloatValue:[Laenge floatValue]];

   if ([daten objectForKey:@"einlaufrand"])
   {
      [Einlaufrand  setIntValue:[[daten objectForKey:@"einlaufrand"]intValue]];// 
      
   }
   else
   {
      [Einlaufrand setIntValue:15];
   }
//   [Blockrand setIntValue:[Einlaufrand  intValue]];
   
   if ([daten objectForKey:@"einlauflaenge"])
   {
      [Einlauflaenge  setIntValue:[[daten objectForKey:@"einlaufrand"]intValue]];// 
   }
   else
   {
      [Einlauflaenge setIntValue:15];
   }
   if ([daten objectForKey:@"einlauftiefe"])
   {
      [Einlauftiefe  setIntValue:[[daten objectForKey:@"einlauftiefe"]intValue]];// 
   }
   else
   {
      [Einlauftiefe setIntValue:15];
   }

   
   
   if ([daten objectForKey:@"auslaufrand"])
   {
      [Auslaufrand  setIntValue:[[daten objectForKey:@"auslaufrand"]intValue]];// 
   }
   else
   {
      [Auslaufrand setIntValue:15];
   }
   
   if ([daten objectForKey:@"auslauflaenge"])
   {
      [Auslauflaenge  setIntValue:[[daten objectForKey:@"auslauflaenge"]intValue]];// 
   }
   else
   {
      [Auslauflaenge setIntValue:15];
      
   }
   if ([daten objectForKey:@"auslauftiefe"])
   {
      [Auslauftiefe  setIntValue:[[daten objectForKey:@"auslauftiefe"]intValue]];// 
   }
   else
   {
      [Auslauftiefe setIntValue:15];
   }

   /*
    if ([daten objectForKey:@"winkel"])
    {
    [Winkel  setFloatValue:[[daten objectForKey:@"winkel"]floatValue]];// 
    }
    else
    {
    [Winkel setFloatValue:0.0];
    }
    */
   [Winkel setFloatValue:[self calcWinkel]];
   [WinkelStepper setFloatValue:[Winkel floatValue]];
   //float phi=360-[Winkel floatValue];
   float phi=[Winkel floatValue];
   if (phi == 360)
   {
      phi=0;
   }
   [WinkelSlider setFloatValue:phi];
   
   [self setDeltaX];
   [self setDeltaY];
   
   ElementLibArray = (NSMutableArray*)[[self readLib]retain];
   [self SetLibElemente:[ElementLibArray valueForKey:@"name"]];
   [self setGraphDaten];
   //NSLog(@"Einstellungen setDaten LibElemente %@ ElementLibArray: %@",[LibElemente description],[[ElementLibArray valueForKey:@"name"]description]);
   [LibGraph clearGraph];
   
   // Profil
   [self SetLibProfile:[self readProfilLib]];
   [ProfilEinfuegenTaste setEnabled:0];
   
}




- (void)setGraphDaten
{
   //return;
   NSMutableDictionary* datenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   NSPoint Startpunkt = NSMakePoint([StartpunktX floatValue]*zoom, [StartpunktY floatValue]*zoom);
   NSPoint Endpunkt = NSMakePoint([EndpunktX floatValue]*zoom, [EndpunktY floatValue]*zoom);
   [datenDic setObject:NSStringFromPoint(Startpunkt) forKey:@"startpunkt"];
   [datenDic setObject:NSStringFromPoint(Endpunkt) forKey:@"endpunkt"];
   [Graph setDaten:datenDic];
   [Graph setNeedsDisplay:YES];
   [LibGraph setDaten:datenDic];
   [LibGraph setNeedsDisplay:YES];
   
}


- (IBAction)reportStartpunktXStepper:(id)sender
{
   [StartpunktX setFloatValue:[sender floatValue]];
   [StartpunktXSlider setFloatValue:[sender floatValue]];
   
   float deltax=[EndpunktX floatValue]-[StartpunktX floatValue];
   [deltaX setFloatValue: deltax];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   
   [self setGraphDaten];
}

- (IBAction)reportStartpunktXSlider:(id)sender
{
	[StartpunktX setFloatValue: [sender floatValue]];
   [StartpunktXStepper setFloatValue:[sender floatValue]];   
   
   //float deltax=[EndpunktX floatValue]-[StartpunktX floatValue];
   //[deltaX setFloatValue:deltax];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
   
}


- (IBAction)reportStartpunktYStepper:(id)sender
{
	[StartpunktY setFloatValue: [sender floatValue]];
   [StartpunktYSlider setFloatValue:[sender floatValue]];
   
   float deltay=[EndpunktY floatValue]-[StartpunktY floatValue];
   [deltaY setFloatValue: deltay];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
}
- (IBAction)reportStartpunktYSlider:(id)sender
{
	[StartpunktY setFloatValue: [sender floatValue]];
   [StartpunktYStepper setFloatValue:[sender floatValue]];
   
   float deltay=[EndpunktY floatValue]-[StartpunktY floatValue];
   [deltaY setFloatValue: deltay];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
}


- (IBAction)reportEndpunktXStepper:(id)sender
{
	[EndpunktX setFloatValue: [sender floatValue]];
   [EndpunktXSlider setFloatValue:[sender floatValue]];
   
   [self setDeltaX];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
}

- (IBAction)reportEndpunktXSlider:(id)sender
{
	[EndpunktX setFloatValue: [sender floatValue]];
   [EndpunktXStepper setFloatValue:[sender floatValue]];
   
   [self setDeltaX];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
}


- (IBAction)reportEndpunktYStepper:(id)sender
{
	[EndpunktY setFloatValue: [sender floatValue]];
   [EndpunktYSlider setFloatValue:[sender floatValue]];
   
   
   [self setDeltaY];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
   
}
- (IBAction)reportEndpunktYSlider:(id)sender
{
	[EndpunktY setFloatValue: [sender floatValue]];
   [EndpunktYStepper setFloatValue:[sender floatValue]];
   
   
   [self setDeltaY];
   
   [self setLaengeUndWinkelfix];
   
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
}

- (IBAction)reportDeltaXStepper:(id)sender
{
   NSLog(@"reportDeltaXStepper wert: %2.1f",[sender floatValue]);
	[deltaX setFloatValue: [sender floatValue]];
   [deltaXSlider setFloatValue:[sender floatValue]];
   float endx=[EndpunktX floatValue];
   [EndpunktX setFloatValue:(startx+[sender floatValue])];
   [self setEndXvar];
   // [self setEndXYfix];
   [self setLaengeUndWinkelfix];
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
   
}

- (IBAction)reportDeltaXSlider:(id)sender
{
   
	[deltaX setFloatValue: [sender floatValue]];
   [deltaXStepper setFloatValue:[sender floatValue]];
   float endx=[EndpunktX floatValue];
   [EndpunktX setFloatValue:(startx+[sender floatValue])];
   
   [self setEndXvar];
   [self setEndXYfix];
   [self setLaengeUndWinkelfix];
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
   
}

- (IBAction)reportDeltaYStepper:(id)sender
{
	[deltaY setFloatValue: [sender floatValue]];
   [deltaYSlider setFloatValue:[sender floatValue]];
   float endy=[EndpunktY floatValue];
   [EndpunktY setFloatValue:(endy+[sender floatValue])];
   
   [self setEndYvar];
   [self setEndXYfix];
   [self setLaengeUndWinkelfix];
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
   
}

- (IBAction)reportDeltaYSlider:(id)sender
{
	[deltaY setFloatValue: [sender floatValue]];
   [deltaYStepper setFloatValue:[sender floatValue]];
   float endy=[EndpunktY floatValue];
   [EndpunktY setFloatValue:(endy+[sender floatValue])];
   
   [self setEndYvar];
   [self setEndXYfix];
   [self setLaengeUndWinkelfix];
   [self setLaengeUndWinkelvar];
   
   [self setGraphDaten];
   
}



- (IBAction)reportWinkelStepper:(id)sender
{
   NSLog(@"reportWinkelStepper winkel: %2.1f  ",[sender floatValue]);
   
	[Winkel setFloatValue: [sender floatValue]];
   [WinkelSlider setFloatValue:[Winkel floatValue]];
   
   [self setEndXYfix];
   
   [self setEndXvar];
   [self setEndYvar];
   
   [self setDeltaX];
   [self setDeltaY];
   
   [self setGraphDaten];
   
}
- (IBAction)reportWinkelSlider:(id)sender
{
   float reverseWinkel = 360 - [sender floatValue];
   if (reverseWinkel == 360)
   {
      reverseWinkel =0;
   }
   //NSLog(@"reportWinkelSlider winkel: %2.1f reverseWinkel: %2.1f ",[sender floatValue],reverseWinkel);
	[Winkel setFloatValue: [sender floatValue]];
   [WinkelStepper setFloatValue:[sender floatValue]];
   
   //[Winkel setFloatValue: reverseWinkel];
   //[WinkelStepper setFloatValue:reverseWinkel];
   
   [self setEndXYfix];
   
   [self setEndXvar];
   [self setEndYvar];
   
   [self setDeltaX];
   [self setDeltaY];
   
   [self setGraphDaten];
}

- (IBAction)reportWinkelMatrixknopf:(id)sender
{
   //NSLog(@"reportWinkelMatrixknopf tag: %d",[sender tag]);
   int winkelwert=0;
   if ([sender tag]&&[sender tag]<8)
   {
      winkelwert=(8-[sender tag])*45;
   }
   //NSLog(@"reportWinkelMatrixknopf winkelwert: %d",winkelwert);
   
	
   [Winkel setFloatValue: winkelwert];
   [WinkelStepper setFloatValue:winkelwert];
   
   //[Winkel setFloatValue: reverseWinkel];
   //[WinkelStepper setFloatValue:reverseWinkel];
   
   [self setEndXYfix];
   
   [self setEndXvar];
   [self setEndYvar];
   
   [self setDeltaX];
   [self setDeltaY];
   
   [self setGraphDaten];
}



- (IBAction)reportLaengeStepper:(id)sender
{
   //NSLog(@"reportLaengeStepper laenge: %2.1f",[sender floatValue]);
	[Laenge setFloatValue: [sender floatValue]];
   [LaengeSlider setFloatValue:[sender floatValue]];
   
   [self setEndXYfix];
   
   [self setEndXvar];
   [self setEndYvar];
   
   [self setDeltaX];
   [self setDeltaY];
   
   
   [self setGraphDaten];
}


- (IBAction)reportLaengeSlider:(id)sender
{
   //NSLog(@"reportLaengeSlider laenge: %2.1f",[sender floatValue]);
   
	[Laenge setFloatValue: [sender floatValue]];
   [LaengeStepper setFloatValue:[sender floatValue]];
   
   [self setEndXYfix];
   
   [self setEndXvar];
   [self setEndYvar];
   
   [self setDeltaX];
   [self setDeltaY];
   
   [self setGraphDaten];
}


- (void)EingabedatenAktion:(NSNotification*)note
{
   //NSLog(@"EingabedatenAktion note: %@",[[note userInfo] description]);
   
   [StartpunktX setFloatValue:0.0];
   [StartpunktY setFloatValue:0.0];
   startx=0;
   starty=0;
   /*
   if ([[note userInfo]objectForKey:@"startx"])
   {
      [StartpunktX setFloatValue:[[[note userInfo]objectForKey:@"startx"]floatValue]];
      startx=[StartpunktX floatValue];
      //libstartx = startx;
   }
   else
   {
      [StartpunktX setFloatValue:25.0];
   }
   
   if ([[note userInfo]objectForKey:@"starty"])
   {
      [StartpunktY setFloatValue:[[[note userInfo]objectForKey:@"starty"]floatValue]];
      starty=[StartpunktY floatValue];
   }
   else
   {
      [StartpunktX setFloatValue:25.0];
   }
   
   if ([[note userInfo]objectForKey:@"endx"])
   {
      [StartpunktX setFloatValue:[[[note userInfo]objectForKey:@"endx"]floatValue]];
   }
   else
   {
      [StartpunktX setFloatValue:25.0];
   }
   
   if ([[note userInfo]objectForKey:@"endy"])
   {
      [StartpunktX setFloatValue:[[[note userInfo]objectForKey:@"endy"]floatValue]];
   }
   else
   {
      [StartpunktX setFloatValue:25.0];
   }
   */
}


- (void)controlTextDidEndEditing:(NSNotification *)note

{
   //NSLog(@"AVR: controlTextDidEndEditing tag: %d",[[note object]tag]);
   
   int TextfeldTag=[[note object]tag];
   float Feldwert=[[note object]floatValue];
   switch (TextfeldTag)
   {
         // Tab Linie
      case 200: // Elementname      
      {
         
      }break;
         
      case 201: // EndXX
      {
         [EndpunktXSlider setFloatValue:Feldwert];
         [EndpunktXStepper setFloatValue:Feldwert];
         
         float deltax=[EndpunktX floatValue]-[StartpunktX floatValue];
         [deltaX setFloatValue: deltax];
         [deltaXStepper setFloatValue: deltax];
         [deltaXSlider setFloatValue: deltax];
         
         
         [Laenge setFloatValue:[self calcLaenge]];
         [Winkel setFloatValue:[self calcWinkel]];
         
         [LaengeStepper setFloatValue:[Laenge floatValue]];
         [LaengeSlider setFloatValue:[Laenge floatValue]];
         
         [WinkelStepper setFloatValue:[Winkel floatValue]];
         [WinkelSlider setFloatValue:[Winkel floatValue]];
         [self setGraphDaten];
         
      }break;
         
      case 202: // deltaX
      {
         [deltaXStepper setFloatValue:Feldwert];
         [deltaXSlider setFloatValue:Feldwert];
         [EndpunktX setFloatValue:Feldwert];
         
         
         [Laenge setFloatValue:[self calcLaenge]];
         [Winkel setFloatValue:[self calcWinkel]];
         
         [LaengeStepper setFloatValue:[Laenge floatValue]];
         [LaengeSlider setFloatValue:[Laenge floatValue]];
         
         [WinkelStepper setFloatValue:[Winkel floatValue]];
         [WinkelSlider setFloatValue:[Winkel floatValue]];
         
         
      }break;
         
      case 203: // EndY
      {
         [EndpunktYSlider setFloatValue:Feldwert];
         [EndpunktYStepper setFloatValue:Feldwert];
         
         float deltay=[EndpunktX floatValue]-[StartpunktX floatValue];
         [deltaY setFloatValue: deltay];
         [deltaYStepper setFloatValue: deltay];
         [deltaYSlider setFloatValue: deltay];
         
         [Laenge setFloatValue:[self calcLaenge]];
         [Winkel setFloatValue:[self calcWinkel]];
         
         [LaengeStepper setFloatValue:[Laenge floatValue]];
         [LaengeSlider setFloatValue:[Laenge floatValue]];
         
         [WinkelStepper setFloatValue:[Winkel floatValue]];
         [WinkelSlider setFloatValue:[Winkel floatValue]];
         [self setGraphDaten];
      }break;
         
      case 204: // deltaY
      {
         [self setGraphDaten];
      }break;
         
      case 210: // Laenge
      {
         //NSLog(@"controlTextDidEndEditing 210:%2.2f",Feldwert);
         [LaengeSlider setFloatValue:Feldwert];
         
         [self setEndXYfix];
         
         [self setEndXvar];
         [self setEndYvar];
         
         [self setDeltaX];
         [self setDeltaY];
         
         [self setGraphDaten];
         
      }break;
         
      case 220: // Winkel
      {
         [WinkelSlider setFloatValue:Feldwert];
         
         [self setEndXYfix];
         
         [self setEndXvar];
         [self setEndYvar];
         
         [self setDeltaX];
         [self setDeltaY];
         
         [self setGraphDaten];
      }break;
         
         // Tab Lib
         
      case 301: // StartX
      {
         
      }break;
         
      case 302: // StartY
      {
         
      }break;
         
      case 303: // EndX
      {
         
      }break;
         
      case 304: // EndY
      {
         
      }break;
         
      default:
         return;
         
         
   } // switch Tag
   
}

- (void)windowDidLoad 
{
	//NSLog(@"Einstellungen did load: Title: %@",[[self window] title]);
   //NSLog(@"Einstellungen windowDidLoad ElementLibArray: %@",[ElementLibArray valueForKey:@"name"]);
   //[LibStartpunktX setFloatValue:2.5];
   //NSLog(@"Einstellungen windowDidLoad LibElemente %@",[LibElemente description]);
   // [self SetLibElemente:[ElementLibArray valueForKey:@"name"]];
   
   
} // end windowDidLoad

- (BOOL)windowShouldClose:(id)sender
{
	NSLog(@"rEinstellungen windowShouldClose");
   /*	
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    NSMutableDictionary* BeendenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    
    [nc postNotificationName:@"IOWarriorBeenden" object:self userInfo:BeendenDic];
    
    */
	
	return YES;
}


- (IBAction)reportLinieEinfuegen:(id)sender
{
   //NSLog(@"reportLinieEinfuegen");
   
   NSString* StartpunktString = NSStringFromPoint(NSMakePoint(startx,starty));
   //NSLog(@"reportLinieEinfuegen start x: %2.2f start y: %2.2f ",startx,starty);
   float endx = [EndpunktX floatValue];
   
   float endy = [EndpunktY floatValue];
   //NSLog(@"endx: %2.2f endy: %2.2f",endx, endy);
   
   NSString* EndpunktString = NSStringFromPoint(NSMakePoint(endx,endy));
   //NSDictionary* EndpunktDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:endx], @"x" , [NSNumber numberWithFloat:endy], @"y", [NSNumber numberWithInt:1], @"index", nil];
   
   float laenge = [Laenge floatValue];
   float winkel = [Winkel floatValue];
   //NSLog(@"EingabeErgebnis: start x: %2.2f start y: %2.2f end x: % 2.2f end y: %2.2f laenge: %2.2f winkel: %2.2f", startx, starty, endx, endy, laenge, winkel);
   NSArray* tempElementArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:endx ], [NSNumber numberWithFloat:endy ], nil];
   NSArray* ElementArray = [NSArray arrayWithObject:tempElementArray];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* ErgebnisDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [ErgebnisDic setObject:StartpunktString forKey:@"startpunkt"];
   [ErgebnisDic setObject:EndpunktString forKey:@"endpunkt"];
	[ErgebnisDic setObject:ElementArray forKey:@"koordinatentabelle"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:endx]  forKey:@"endx"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:endy]  forKey:@"endy"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:laenge]  forKey:@"laenge"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:winkel]  forKey:@"winkel"];

 
   
   [ErgebnisDic setObject:@"LinieEinfuegen"  forKey:@"quelle"];
   [nc postNotificationName:@"Elementeingabe" object:self userInfo:ErgebnisDic];
   startx=endx+startx;
   [StartpunktX setFloatValue:0];
   starty=endy+starty;
   [StartpunktY setFloatValue:0];
   [EndpunktX setFloatValue:10.0];
   [EndpunktXSlider setFloatValue:[EndpunktX floatValue]];
   [EndpunktXStepper setFloatValue:[EndpunktX floatValue]];
   
   [EndpunktY setFloatValue:0.0];
   [EndpunktYSlider setFloatValue:[EndpunktY floatValue]];
   [EndpunktYStepper setFloatValue:[EndpunktY floatValue]];
   
   [Laenge setFloatValue:[self calcLaenge]];
   [LaengeStepper setFloatValue:[Laenge floatValue]];
   [LaengeSlider setFloatValue:[Laenge floatValue]];
   
   [Winkel setFloatValue:[self calcWinkel]];
   [WinkelStepper setFloatValue:[Winkel floatValue]];
   
   float deltax=[EndpunktX floatValue]-[StartpunktX floatValue];
   [deltaX setFloatValue: deltax];
   float deltay=[EndpunktY floatValue]-[StartpunktY floatValue];
   [deltaY setFloatValue: deltay];
   [self setGraphDaten];
   
   
}

- (IBAction)reportCancel:(id)sender
{
   NSLog(@"reportCancel");
   [NSApp stopModalWithCode:0];
   [[self window]orderOut:NULL];
   
}

- (IBAction)reportClose:(id)sender
{
   
   //NSLog(@"reportClose");
   
   NSString* StartpunktString = NSStringFromPoint(NSMakePoint(startx,starty));
   float endx = [EndpunktX floatValue];
   
   float endy = [EndpunktY floatValue];
   
   NSString* EndpunktString = NSStringFromPoint(NSMakePoint(endx,endy));
   //NSDictionary* EndpunktDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:endx], @"x" , [NSNumber numberWithFloat:endy], @"y", [NSNumber numberWithInt:1], @"index", nil];
   
   float laenge = [Laenge floatValue];
   float winkel = [Winkel floatValue];
   //NSLog(@"EingabeErgebnis: start x: %2.2f start y: %2.2f end x: % 2.2f end y: %2.2f laenge: %2.2f winkel: %2.2f", startx, starty, endx, endy, laenge, winkel);
   NSArray* tempElementArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:(endx+startx) ], [NSNumber numberWithFloat:(endy+starty) ], nil];
   NSArray* ElementArray = [NSArray arrayWithObject:tempElementArray];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* ErgebnisDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [ErgebnisDic setObject:StartpunktString forKey:@"startpunkt"];
   [ErgebnisDic setObject:EndpunktString forKey:@"endpunkt"];
	[ErgebnisDic setObject:ElementArray forKey:@"koordinatentabelle"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:endx]  forKey:@"endx"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:endy]  forKey:@"endy"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:laenge]  forKey:@"laenge"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:winkel]  forKey:@"winkel"];
   [ErgebnisDic setObject:@"Schliessen"  forKey:@"quelle"];
   //[nc postNotificationName:@"Elementeingabe" object:self userInfo:ErgebnisDic];
   [self clearProfilGraphDaten];
   [FlipHTaste setState:0];
   [FlipVTaste setState:0];
   [ReverseTaste setState:0];

   [OberseiteCheck setState:1];
   [UnterseiteCheck setState:1];
   [EinlaufCheck setState:1];
   [AuslaufCheck setState:1];

   [NSApp stopModalWithCode:1];
   [[self window]orderOut:NULL];
}

#pragma mark Profiltask

- (void)doProfilSpiegelnVertikalTask
{
   if ([Profil1Array count]==0)
   {
      return;
   }
   
   NSLog(@"reportProfilSpiegelnVertikal");
   int i;
   flipV = [FlipVTaste state];
   for (i=0;i< [Profil1Array count];i++)
   {
      NSMutableDictionary* tempZeilenDic = [NSMutableDictionary dictionaryWithDictionary:[Profil1Array objectAtIndex:i]];
      float tempy=[[tempZeilenDic objectForKey:@"y"]floatValue];
      tempy *= -1;
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempy]forKey:@"y"];
      [Profil1Array replaceObjectAtIndex:i withObject:tempZeilenDic];
   }
   [ProfilStartpunktY setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"y"]floatValue]];
   [ProfilEndpunktY setFloatValue:[[[Profil1Array lastObject]objectForKey:@"y"]floatValue]];
   
   [self setProfilGraphDaten];
   [ProfilGraph setNeedsDisplay:YES];
   
   
}




- (void)doSchliessenTask
{
   
   //NSLog(@"setSchliessenTask");
   
   NSString* StartpunktString = NSStringFromPoint(NSMakePoint(startx,starty));
   float endx = [EndpunktX floatValue];
   
   float endy = [EndpunktY floatValue];
   
   NSString* EndpunktString = NSStringFromPoint(NSMakePoint(endx,endy));
   //NSDictionary* EndpunktDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:endx], @"x" , [NSNumber numberWithFloat:endy], @"y", [NSNumber numberWithInt:1], @"index", nil];
   
   float laenge = [Laenge floatValue];
   float winkel = [Winkel floatValue];
   //NSLog(@"EingabeErgebnis: start x: %2.2f start y: %2.2f end x: % 2.2f end y: %2.2f laenge: %2.2f winkel: %2.2f", startx, starty, endx, endy, laenge, winkel);
   NSArray* tempElementArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:(endx+startx) ], [NSNumber numberWithFloat:(endy+starty) ], nil];
   NSArray* ElementArray = [NSArray arrayWithObject:tempElementArray];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* ErgebnisDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [ErgebnisDic setObject:StartpunktString forKey:@"startpunkt"];
   [ErgebnisDic setObject:EndpunktString forKey:@"endpunkt"];
	[ErgebnisDic setObject:ElementArray forKey:@"koordinatentabelle"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:endx]  forKey:@"endx"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:endy]  forKey:@"endy"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:laenge]  forKey:@"laenge"];
   [ErgebnisDic setObject:[NSNumber numberWithFloat:winkel]  forKey:@"winkel"];
   [ErgebnisDic setObject:@"Schliessen"  forKey:@"quelle"];
   //[nc postNotificationName:@"Elementeingabe" object:self userInfo:ErgebnisDic];
   
   [NSApp stopModalWithCode:1];
   [[self window]orderOut:NULL];
}


- (void)doProfil1PopTaskMitProfil:(int)profil1
{
   [FlipHTaste setState:0];
   [FlipVTaste setState:0];
   [ReverseTaste setState:0];
   
   if (profil1)
   {
      
      int index=profil1; // Item 0 ist Titel
      [Profile2 selectItemAtIndex:index];    // Profil 2 ist wahrscheinlich gleich
      //NSLog(@"reportProfilPop Profil aus Pop: %@",[Profile1 itemTitleAtIndex:index]);
      Profil1Name=[Profile1 itemTitleAtIndex:index];
      NSString* Profilname = [Profil1Name stringByAppendingPathExtension:@"txt"];
      NSString* Profilpfad = [ProfilLibPfad stringByAppendingPathComponent:Profilname];
      //NSLog(@"reportProfilPop Profilpfad: %@",Profilpfad);
      NSFileManager *Filemanager = [NSFileManager defaultManager];
      int ProfilOK= [Filemanager fileExistsAtPath:Profilpfad];
      if (ProfilOK)
      {
         NSDictionary* ProfilDic = [Utils ProfilDatenAnPfad:Profilpfad];
         
         //NSLog(@"reportProfilPop ProfilDic: %@",[ProfilDic description]);
         //Profil1Array = [ProfilDic objectForKey:@"profilarray"];
         //NSLog(@"SplinekoeffizientenVonArray profilarray: %@",[[ProfilDic objectForKey:@"profilarray"] description]);
         
         
         if ([ProfilDic objectForKey:@"name"])
         {
            Profil1Name = [NSString stringWithString:[[ElementLibArray objectAtIndex:index]objectForKey:@"name"]];
         }
         //NSLog(@"ProfilName1: %@",Profil1Name);
         if ([ProfilDic objectForKey:@"profilarray"])
         {
            [Profil1Array removeAllObjects];
            [Profil1Array addObjectsFromArray:[ProfilDic objectForKey:@"profilarray"]];
            
            
            if ([Profil1Array count])
            {
               [ProfilStartpunktX setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"x"]floatValue]];
               [ProfilStartpunktY setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"y"]floatValue]];
               [ProfilEndpunktX setFloatValue:[[[Profil1Array lastObject]objectForKey:@"x"]floatValue]];
               [ProfilEndpunktY setFloatValue:[[[Profil1Array lastObject]objectForKey:@"y"]floatValue]];
               
            }
            //NSLog(@"reportProfilPop Profil1Array LAST: %@",[[Profil1Array lastObject]description]);
         }
         [ProfilEinfuegenTaste setEnabled:1]; 
      } // if ProfilOK
      
      
      [self setProfilGraphDaten];
      [ProfilGraph setNeedsDisplay:YES];
      
   }
}

- (void)doProfilEinfuegenTask
{
   //NSLog(@"reportProfilEinfuegen");
   if ([Profil1Array count])
   {
      NSMutableDictionary* ProfilDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [ProfilDic setObject:@"LibProfil"  forKey:@"quelle"];
      //NSLog(@"reportLibElementEinfuegen LibElementArray: %@",[LibElementArray description]);
      [ProfilDic setObject:Profil1Name forKey:@"profilname"];
      [ProfilDic setObject:Profil1Name forKey:@"profil1name"];
      
      //NSLog(@"reportProfilEinfuegen Profil1Array: %@",[Profil1Array description]);
      [ProfilDic setObject:Profil1Array forKey:@"profilarray"];
      [ProfilDic setObject:Profil1Array forKey:@"profil1array"];
      if ([Profil2Array count]) // verschiedene Profile
      {
         [ProfilDic setObject:Profil2Name forKey:@"profil2name"];
         [ProfilDic setObject:Profil2Array forKey:@"profil2array"];
      }
      else // gleiches Profil
      {
         [ProfilDic setObject:Profil1Name forKey:@"profil2name"];
         [ProfilDic setObject:Profil1Array forKey:@"profil2array"];
      }
      
      [ProfilDic setObject:[NSNumber numberWithInt:[OberseiteCheck state]] forKey:@"oberseite"];
      [ProfilDic setObject:[NSNumber numberWithInt:[UnterseiteCheck state]] forKey:@"unterseite"];
      
      [ProfilDic setObject:[NSNumber numberWithInt:[EinlaufCheck state]] forKey:@"einlauf"];
      [ProfilDic setObject:[NSNumber numberWithInt:[AuslaufCheck state]] forKey:@"auslauf"];
      
      [ProfilDic setObject:[NSNumber numberWithFloat:[Einlauflaenge floatValue]] forKey:@"einlauflaenge"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Einlauftiefe floatValue]] forKey:@"einlauftiefe"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Auslauflaenge floatValue]] forKey:@"auslauflaenge"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Auslauftiefe floatValue]] forKey:@"auslauftiefe"];
      [ProfilDic setObject:[NSNumber numberWithInt:flipH] forKey:@"fliph"];
      [ProfilDic setObject:[NSNumber numberWithInt:flipV] forKey:@"flipv"];
      [ProfilDic setObject:[NSNumber numberWithInt:reverse] forKey:@"reverse"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Einlaufrand floatValue]] forKey:@"einlaufrand"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Auslaufrand floatValue]] forKey:@"auslaufrand"];
      
      [PList setObject:[NSNumber numberWithFloat:[Einlauflaenge floatValue]] forKey:@"einlauflaenge"];
      [PList setObject:[NSNumber numberWithFloat:[Einlauftiefe floatValue]] forKey:@"einlauftiefe"];
      [PList setObject:[NSNumber numberWithFloat:[Auslauflaenge floatValue]] forKey:@"auslauflaenge"];
      [PList setObject:[NSNumber numberWithFloat:[Auslauftiefe floatValue]] forKey:@"auslauftiefe"];
      
      [PList setObject:[NSNumber numberWithFloat:[Einlaufrand floatValue]] forKey:@"einlaufrand"];
      [PList setObject:[NSNumber numberWithFloat:[Auslaufrand floatValue]] forKey:@"auslaufrand"];
      
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"LibProfileingabe" object:self userInfo:ProfilDic];
   }
}

- (void)doEdgeTask
{
   
}

- (void)setOberseite:(int) ein
{
   [OberseiteCheck setState:ein];
}

- (void)setUnterseite:(int) ein
{
   [UnterseiteCheck setState:ein];
}



#pragma mark Lib
- (NSArray*)readLib
{
   NSMutableArray* tempLibElementArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	BOOL LibOK=NO;
	BOOL istOrdner;
   
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ElementLib"];
   NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   //   NSLog(@"readLib:    LibPfad: %@ LibOK: %d",LibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      //Lib ist noch leer
      
      
   }
   
   //NSLog(@"LibPfad: %@",LibPfad);	
	if (LibOK)
	{
		
		//NSLog(@"readLib: %@",[tempPListDic description]);
		
		NSString* LibName=@"Element.plist";
		LibElementPfad = [NSString string];;
		//NSLog(@"\n\n");
		LibElementPfad=[LibPfad stringByAppendingPathComponent:LibName];
		//NSLog(@"readLib: PListPfad: %@ ",LibElementPfad);
		if (LibElementPfad)		
		{
			
			if ([Filemanager fileExistsAtPath:LibElementPfad])
			{
				NSArray* rawLibElementArray=[NSArray arrayWithContentsOfFile:LibElementPfad];
				int i;
            for(i=0;i<[rawLibElementArray count];i++)
            {
               if ([[rawLibElementArray objectAtIndex:i]objectForKey:@"name"])
               {
                  [tempLibElementArray addObject:[rawLibElementArray objectAtIndex:i]];
               }
            }
            
            //NSLog(@"readLib: tempElementArray: %@",[[LibElementArray valueForKey:@"name"]description]);
            
			}
			
		}
		//	NSLog(@"PListOK: %d",PListOK);
		
	}//LIBOK
   return tempLibElementArray;
}

- (int)SetLibElemente:(NSArray*)LibArray
{
   
   //NSLog(@"Einstellungen Funktion SetLibElemente Description: %@",[LibElemente description]);
   //NSLog(@"Einstellungen Funktion SetLibElemente: %@",LibArray );
   [LibElemente removeAllItems];
   [LibElemente addItemWithTitle:@"Element auswählen"];
   [LibElemente addItemsWithTitles:LibArray];
   return 0;
}

- (IBAction)reportLibPop:(id)sender
{
   //NSLog(@"reportLibPop index: %d",[sender indexOfSelectedItem]);
   if ([sender indexOfSelectedItem])
   {
      int index=[sender indexOfSelectedItem]-1; // Item 0 ist Titel
      //NSLog(@"reportLibPop ElementLibArray aus Pop: %@",[[ElementLibArray objectAtIndex:index]description]);
      
      if ([[ElementLibArray objectAtIndex:index]objectForKey:@"name"])
      {
         LibElementName = [NSString stringWithString:[[ElementLibArray objectAtIndex:index]objectForKey:@"name"]];
      }
      NSLog(@"LibElementName: %@",LibElementName);
      if ([[ElementLibArray objectAtIndex:index]objectForKey:@"elementarray"])// Daten für Element da
      {
         [LibElementArray removeAllObjects];
         [LibElementArray addObjectsFromArray:[[ElementLibArray objectAtIndex:index]objectForKey:@"elementarray"]];
         if ([LibElementArray count])
         {
            [LibStartpunktX setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]];
            [LibStartpunktY setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]];
            [LibEndpunktX setFloatValue:[[[LibElementArray lastObject]objectForKey:@"x"]floatValue]];
            [LibEndpunktY setFloatValue:[[[LibElementArray lastObject]objectForKey:@"y"]floatValue]];
            
         }
         //NSLog(@"reportLibPop LibElementArray LAST: %@",[[LibElementArray lastObject]description]);
      }
      
   }
   
   [libstartx setFloatValue:startx];
   [libstarty setFloatValue:starty];
   
   [self setLibGraphDaten];
   
}

- (IBAction)reportLibElementEinfuegen:(id)sender
{   
   //NSLog(@"reportLibElementEinfuegen name: %@",LibElementName);
   NSMutableDictionary* ElementDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [ElementDic setObject:@"LibElement"  forKey:@"quelle"];
   //NSLog(@"reportLibElementEinfuegen LibElementArray: %@",[LibElementArray description]);
	[ElementDic setObject:LibElementName forKey:@"elementname"];
   //NSLog(@"reportLibElementEinfuegen LibElementArray: %@",[LibElementArray description]);
	[ElementDic setObject:LibElementArray forKey:@"elementarray"];
   
   // Offset x,y einsetzen
   
   NSMutableArray* Koordinatentabelle=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   startx=0;
   starty=0;
   int i=0;
   for (i=1;i<[LibElementArray count];i++) // Erstes Element ist Startpunkt und schon im Array
   {
      float tempx = [[[LibElementArray objectAtIndex:i]objectForKey:@"x"]floatValue] + startx;
      float tempy = [[[LibElementArray objectAtIndex:i]objectForKey:@"y"]floatValue] + starty;
      [Koordinatentabelle addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempx],[NSNumber numberWithFloat:tempy], nil]];
   }
	[ElementDic setObject:Koordinatentabelle forKey:@"koordinatentabelle"];
   
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"LibElementeingabe" object:self userInfo:ElementDic];
   //startx=endx+startx;
   //starty=endy+starty;
   
   [libstartx setFloatValue:startx];
   [libstarty setFloatValue:starty];
   
   [LibGraph clearGraph];
   [LibElemente selectItemAtIndex:0];
}

- (IBAction)reportLibElementLoeschen:(id)sender
{
   int index=[LibElemente indexOfSelectedItem]-1;
   NSLog(@"LibElementLoeschen index: %d Element: %@",index,[[ElementLibArray objectAtIndex:index]objectForKey:@"name"]);
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   
   NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
   [Warnung addButtonWithTitle:@"Entfernen"];
   //[Warnung addButtonWithTitle:@""];
   //[Warnung addButtonWithTitle:@""];
   [Warnung addButtonWithTitle:@"Abbrechen"];
   [Warnung setMessageText:[NSString stringWithFormat:@"Das Element  %@ aus der Lib entfernen?.",[[ElementLibArray objectAtIndex:index]objectForKey:@"name"]]];
   
   NSString* s1=@"";
   NSString* s2=@"";
   NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
   [Warnung setInformativeText:InformationString];
   [Warnung setAlertStyle:NSWarningAlertStyle];
   
   int antwort=[Warnung runModal];
   switch (antwort)
   {
      case NSAlertFirstButtonReturn://
      { 
         NSLog(@"NSAlertFirstButtonReturn");// ersetzen
         NSLog(@"ElementLibArray namen: %@",[[ElementLibArray valueForKey:@"name"]description]); 
         [ElementLibArray removeObjectAtIndex:index];
         [LibGraph clearGraph];
         [LibElemente removeAllItems];
         [LibElemente addItemWithTitle:@"Element auswählen"];
         [LibElemente addItemsWithTitles:[ElementLibArray valueForKey:@"name"]];
         
         [LibElemente selectItemAtIndex:0];
         [NSApp stopModalWithCode:1];
         NSError* error=0;
         NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ElementLib"];
         LibPfad = [LibPfad stringByAppendingPathComponent:@"Element.plist"];
         NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
         NSLog(@"LibElementloeschen LibURL vor: %@",LibURL);
         if ([Filemanager fileExistsAtPath:LibPfad])
         {
            NSInteger clearOK=[Filemanager removeItemAtURL:LibURL error:&error];
            NSLog(@"Elementloeschen clearOK: %d",clearOK);
         }
         int saveOK=[ElementLibArray writeToURL:LibURL atomically:YES];
         NSLog(@"Elementloeschen saveOK: %d",saveOK);
         [LibGraph clearGraph];
         [LibElemente selectItemAtIndex:0];
         
         //[[self window] orderOut:NULL];
         //[self reportElementSichern:NULL];
      }break;
         
      case NSAlertSecondButtonReturn://
      {
         NSLog(@"NSAlertSecondButtonReturn");
         [NSApp stopModalWithCode:1];
      }break;
      case NSAlertThirdButtonReturn://		
      {
         NSLog(@"NSAlertThirdButtonReturn");
         
      }break;
         
   }//switch
   
   
}

- (IBAction)reportLibElementSpiegelnHorizontal:(id)sender
{
   NSLog(@"reportLibElementSpiegelnHorizontal");
   NSMutableArray* tempElementArray = [[[NSMutableArray alloc]initWithArray: LibElementArray]autorelease];
   int i;
   float maxX=0;
   for (i=0;i< [tempElementArray count];i++)
   {
      float tempx=[[[LibElementArray objectAtIndex:i]objectForKey:@"x"]floatValue];
      tempx *= -1;
      [[LibElementArray objectAtIndex:i]setObject:[NSNumber numberWithFloat:tempx]forKey:@"x"];
   }
   [LibStartpunktX setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]];
   [LibEndpunktX setFloatValue:[[[LibElementArray lastObject]objectForKey:@"x"]floatValue]];
   
   [self setLibGraphDaten];
   [LibGraph setNeedsDisplay:YES];
   
   
}

- (IBAction)reportLibElementSpiegelnVertikal:(id)sender
{
   NSLog(@"reportLibElementSpiegelnVertikal");
   NSMutableArray* tempElementArray = [[[NSMutableArray alloc]initWithArray: LibElementArray]autorelease];
   int i;
   for (i=0;i< [tempElementArray count];i++)
   {
      float tempy=[[[LibElementArray objectAtIndex:i]objectForKey:@"y"]floatValue];
      tempy *= -1;
      [[LibElementArray objectAtIndex:i]setObject:[NSNumber numberWithFloat:tempy]forKey:@"y"];
   }
   [LibStartpunktY setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]];
   [LibEndpunktY setFloatValue:[[[LibElementArray lastObject]objectForKey:@"y"]floatValue]];
   
   [self setLibGraphDaten];
   [LibGraph setNeedsDisplay:YES];
   
}

- (IBAction)reportLibElementAnfangZuEnde:(id)sender
{
   // NSLog(@"reportLibElementAnfangZuEnde");
   NSLog(@"startx: %1.1f starty: %1.1f",startx,starty);
   int anz=[LibElementArray count];
   
   // Enddaten fixieren
   float offsetx = [[[LibElementArray objectAtIndex:(anz-1)]objectForKey:@"x"]floatValue];
   float offsety = [[[LibElementArray objectAtIndex:(anz-1)]objectForKey:@"y"]floatValue];
   
   NSMutableArray* tempElementArray = [[[NSMutableArray alloc]initWithArray: LibElementArray]autorelease];
   int i;
   for (i=0;i< [tempElementArray count];i++)
   {
      
      [LibElementArray replaceObjectAtIndex:i  withObject:[tempElementArray objectAtIndex:([tempElementArray count]-i-1)]];
      float tempx=[[[LibElementArray objectAtIndex:i]objectForKey:@"x"]floatValue];
      tempx -= offsetx;
      float tempy=[[[LibElementArray objectAtIndex:i]objectForKey:@"y"]floatValue];
      tempy -= offsety;
      [[LibElementArray objectAtIndex:i]setObject:[NSNumber numberWithFloat:tempx]forKey:@"x"];
      [[LibElementArray objectAtIndex:i]setObject:[NSNumber numberWithFloat:tempy]forKey:@"y"];
      [[LibElementArray objectAtIndex:i]setObject:[NSNumber numberWithInt:i]forKey:@"index"];
      
      
      //NSLog(@"i: %d Data: %@",i,[[LibElementArray objectAtIndex:i]description]);
   }
   
   [LibStartpunktX setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]];
   [LibStartpunktY setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]];
   [LibEndpunktX setFloatValue:[[[LibElementArray lastObject]objectForKey:@"x"]floatValue]];
   [LibEndpunktY setFloatValue:[[[LibElementArray lastObject]objectForKey:@"y"]floatValue]];
   
   [self setLibGraphDaten];
   [LibGraph setNeedsDisplay:YES];
   
}

- (void)doLibTaskMitElement:(int)Elementnummer
{
   if ([[ElementLibArray objectAtIndex:Elementnummer]objectForKey:@"name"])
   {
      LibElementName = [NSString stringWithString:[[ElementLibArray objectAtIndex:Elementnummer]objectForKey:@"name"]];
   }
   NSLog(@"LibElementName: %@",LibElementName);
   if ([[ElementLibArray objectAtIndex:Elementnummer]objectForKey:@"elementarray"])// Daten für Element da
   {
      [LibElementArray removeAllObjects];
      [LibElementArray addObjectsFromArray:[[ElementLibArray objectAtIndex:Elementnummer]objectForKey:@"elementarray"]];
      if ([LibElementArray count])
      {
         [LibStartpunktX setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]];
         [LibStartpunktY setFloatValue:[[[LibElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]];
         [LibEndpunktX setFloatValue:[[[LibElementArray lastObject]objectForKey:@"x"]floatValue]];
         [LibEndpunktY setFloatValue:[[[LibElementArray lastObject]objectForKey:@"y"]floatValue]];
         
      }
      NSLog(@"doLibTaskMitElement LibElementArray: %@",[LibElementArray description]);
      [self reportLibElementEinfuegen:NULL];
   }

}


- (void)setLibGraphDaten
{
   //return;
   NSMutableDictionary* datenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   NSPoint Startpunkt = NSMakePoint([LibStartpunktX floatValue]*zoom, [LibStartpunktY floatValue]*zoom);
   NSPoint Endpunkt = NSMakePoint([LibEndpunktX floatValue]*zoom, [LibEndpunktY floatValue]*zoom);
   [datenDic setObject:NSStringFromPoint(Startpunkt) forKey:@"startpunkt"];
   [datenDic setObject:NSStringFromPoint(Endpunkt) forKey:@"endpunkt"];
   [datenDic setObject:LibElementArray forKey:@"elementarray"];
   [LibGraph setDaten:datenDic];
   [LibGraph setNeedsDisplay:YES];
}

#pragma mark Profil

- (NSArray*)flipProfil:(NSArray*)profilArray
{
   NSMutableArray* flipProfilArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   int i;
   
   for (i=0;i< [profilArray count];i++)
   {
      NSMutableDictionary* tempZeilenDic = [NSMutableDictionary dictionaryWithDictionary:[profilArray objectAtIndex:i]];
      float tempx=[[tempZeilenDic objectForKey:@"x"]floatValue];
      tempx *= -1;
      tempx += 1;
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempx]forKey:@"x"];
      [flipProfilArray addObject:tempZeilenDic];
   }

   return flipProfilArray;
}

- (NSArray*)readProfilLib
{
   NSMutableArray* tempLibElementArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	BOOL LibOK=NO;
	BOOL istOrdner;
   
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	ProfilLibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ProfilLib"];
   [ProfilLibPfad retain];
   //NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:ProfilLibPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"readProfilLib:    LibPfad: %@ LibOK: %d",ProfilLibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      //Lib ist noch leer
      
      
   }
   
   //NSLog(@"LibPfad: %@",LibPfad);	
	if (LibOK)
	{
			NSMutableArray* ProfilnamenArray = (NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:ProfilLibPfad error:NULL];
      [ProfilnamenArray removeObject:@".DS_Store"];
      [ProfilnamenArray removeObject:@" Profile ReadMe.txt"];
		//NSLog(@"readProfilLib ProfilnamenArray: %@",[ProfilnamenArray description]);
      
      return ProfilnamenArray;
      
		
	}//LIBOK
   return tempLibElementArray;
}
- (void)SetLibProfile:(NSArray*)profile
{
   [Profile1 removeAllItems];
   [Profile1 addItemWithTitle:@"Profil auswählen"];
   [Profile2 removeAllItems];
   [Profile2 addItemWithTitle:@"Profil auswählen"];
   int i=0;
   for (i=0; i<[profile count]; i++) 
   {
      [Profile1 addItemWithTitle:[[profile objectAtIndex:i]stringByDeletingPathExtension]];
      [Profile2 addItemWithTitle:[[profile objectAtIndex:i]stringByDeletingPathExtension]];

   }
  // Profilname = [Profilname stringByDeletingPathExtension];
}

- (IBAction)reportProfil1Pop:(id)sender
{
   [FlipHTaste setState:0];
   [FlipVTaste setState:0];
   [ReverseTaste setState:0];
   
   if ([sender indexOfSelectedItem])
   {      
      int index=[sender indexOfSelectedItem]; // Item 0 ist Titel
      [Profile2 selectItemAtIndex:index];    // Profil 2 ist wahrscheinlich gleich
      //NSLog(@"reportProfilPop Profil aus Pop: %@",[Profile1 itemTitleAtIndex:index]);
      Profil1Name=[Profile1 itemTitleAtIndex:index];
      NSString* Profilname = [Profil1Name stringByAppendingPathExtension:@"txt"];
      NSString* Profilpfad = [ProfilLibPfad stringByAppendingPathComponent:Profilname];
      //NSLog(@"reportProfilPop Profilpfad: %@",Profilpfad);
      NSFileManager *Filemanager = [NSFileManager defaultManager];
      int ProfilOK= [Filemanager fileExistsAtPath:Profilpfad];
      if (ProfilOK)
      {
         NSDictionary* ProfilDic = [Utils ProfilDatenAnPfad:Profilpfad];
 
         //NSLog(@"reportProfilPop ProfilDic: %@",[ProfilDic description]);
         //Profil1Array = [ProfilDic objectForKey:@"profilarray"];
         //NSLog(@"SplinekoeffizientenVonArray profilarray: %@",[[ProfilDic objectForKey:@"profilarray"] description]);

         
         if ([ProfilDic objectForKey:@"name"])
         {
            Profil1Name = [NSString stringWithString:[[ElementLibArray objectAtIndex:index]objectForKey:@"name"]];
         }
         //NSLog(@"ProfilName1: %@",Profil1Name);
         if ([ProfilDic objectForKey:@"profilarray"])
         {
            [Profil1Array removeAllObjects];
            [Profil1Array addObjectsFromArray:[ProfilDic objectForKey:@"profilarray"]];
            
            
            if ([Profil1Array count])
            {
               [ProfilStartpunktX setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"x"]floatValue]];
               [ProfilStartpunktY setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"y"]floatValue]];
               [ProfilEndpunktX setFloatValue:[[[Profil1Array lastObject]objectForKey:@"x"]floatValue]];
               [ProfilEndpunktY setFloatValue:[[[Profil1Array lastObject]objectForKey:@"y"]floatValue]];
               
            }
            //NSLog(@"reportProfilPop Profil1Array LAST: %@",[[Profil1Array lastObject]description]);
         }
         [ProfilEinfuegenTaste setEnabled:1]; 
      } // if ProfilOK
      
      
      [self setProfilGraphDaten];
      [ProfilGraph setNeedsDisplay:YES];
   
   }
}

- (IBAction)reportProfil2Pop:(id)sender
{
   [FlipHTaste setState:0];
   [FlipVTaste setState:0];
   [ReverseTaste setState:0];

   if ([sender indexOfSelectedItem])
   {
      int index=[sender indexOfSelectedItem]; // Item 0 ist Titel
      NSLog(@"reportProfil2Pop Profil aus Pop: %@",[Profile2 itemTitleAtIndex:index]);
      Profil2Name=[Profile2 itemTitleAtIndex:index];
      NSString* Profilname = [Profil2Name stringByAppendingPathExtension:@"txt"];
      NSString* Profilpfad = [ProfilLibPfad stringByAppendingPathComponent:Profilname];
      //NSLog(@"reportProfilPop Profilpfad: %@",Profilpfad);
      NSFileManager *Filemanager = [NSFileManager defaultManager];
      int ProfilOK= [Filemanager fileExistsAtPath:Profilpfad];
      if (ProfilOK)
      {
         NSDictionary* ProfilDic = [Utils ProfilDatenAnPfad:Profilpfad];
         //NSLog(@"reportProfil2Pop ProfilDic: %@",[ProfilDic description]);
         //Profil1Array = [ProfilDic objectForKey:@"profilArray"];
      
         
      NSLog(@"Profil2Name: %@",Profil2Name);
      if ([ProfilDic objectForKey:@"profilarray"])
      {
         [Profil2Array removeAllObjects];
         [Profil2Array addObjectsFromArray:[ProfilDic objectForKey:@"profilarray"]];
         
         
         if ([Profil2Array count])
         {
            [ProfilStartpunktX setFloatValue:[[[Profil2Array objectAtIndex:0]objectForKey:@"x"]floatValue]];
            [ProfilStartpunktY setFloatValue:[[[Profil2Array objectAtIndex:0]objectForKey:@"y"]floatValue]];
            [ProfilEndpunktX setFloatValue:[[[Profil2Array lastObject]objectForKey:@"x"]floatValue]];
            [ProfilEndpunktY setFloatValue:[[[Profil2Array lastObject]objectForKey:@"y"]floatValue]];
            
         }
         //NSLog(@"reportProfilPop Profil1Array LAST: %@",[[Profil1Array lastObject]description]);
      }

      [ProfilEinfuegenTaste setEnabled:1]; 
      [self setProfilGraphDaten];
      [ProfilGraph setNeedsDisplay:YES];
      }
   }
}

- (IBAction)reportProfilEinfuegen:(id)sender
{
   //NSLog(@"reportProfilEinfuegen");
   if ([Profil1Array count])
   {
      NSMutableDictionary* ProfilDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [ProfilDic setObject:@"LibProfil"  forKey:@"quelle"];
      //NSLog(@"reportLibElementEinfuegen LibElementArray: %@",[LibElementArray description]);
      [ProfilDic setObject:Profil1Name forKey:@"profilname"];
      [ProfilDic setObject:Profil1Name forKey:@"profil1name"];
      
      //NSLog(@"reportProfilEinfuegen Profil1Array: %@",[Profil1Array description]);
      [ProfilDic setObject:Profil1Array forKey:@"profilarray"];
      [ProfilDic setObject:Profil1Array forKey:@"profil1array"];
      if ([Profil2Array count]) // verschiedene Profile
      {
         [ProfilDic setObject:Profil2Name forKey:@"profil2name"];
         [ProfilDic setObject:Profil2Array forKey:@"profil2array"];
      }
      else // gleiches Profil
      {
         [ProfilDic setObject:Profil1Name forKey:@"profil2name"];
         [ProfilDic setObject:Profil1Array forKey:@"profil2array"];
      }
      
      [ProfilDic setObject:[NSNumber numberWithInt:[OberseiteCheck state]] forKey:@"oberseite"];
      [ProfilDic setObject:[NSNumber numberWithInt:[UnterseiteCheck state]] forKey:@"unterseite"];
      
      [ProfilDic setObject:[NSNumber numberWithInt:[EinlaufCheck state]] forKey:@"einlauf"];
      [ProfilDic setObject:[NSNumber numberWithInt:[AuslaufCheck state]] forKey:@"auslauf"];
      
      [ProfilDic setObject:[NSNumber numberWithFloat:[Einlauflaenge floatValue]] forKey:@"einlauflaenge"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Einlauftiefe floatValue]] forKey:@"einlauftiefe"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Einlaufrand floatValue]] forKey:@"einlaufrand"];

      [ProfilDic setObject:[NSNumber numberWithFloat:[Auslauflaenge floatValue]] forKey:@"auslauflaenge"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Auslauftiefe floatValue]] forKey:@"auslauftiefe"];
      [ProfilDic setObject:[NSNumber numberWithFloat:[Auslaufrand floatValue]] forKey:@"auslaufrand"];

      
      [ProfilDic setObject:[NSNumber numberWithInt:flipH] forKey:@"fliph"];
      [ProfilDic setObject:[NSNumber numberWithInt:flipV] forKey:@"flipv"];
      [ProfilDic setObject:[NSNumber numberWithInt:reverse] forKey:@"reverse"];
      
      [PList setObject:[NSNumber numberWithFloat:[Einlauflaenge floatValue]] forKey:@"einlauflaenge"];
      [PList setObject:[NSNumber numberWithFloat:[Einlauftiefe floatValue]] forKey:@"einlauftiefe"];
      [PList setObject:[NSNumber numberWithFloat:[Einlaufrand floatValue]] forKey:@"einlaufrand"];

      [PList setObject:[NSNumber numberWithFloat:[Auslauflaenge floatValue]] forKey:@"auslauflaenge"];
      [PList setObject:[NSNumber numberWithFloat:[Auslauftiefe floatValue]] forKey:@"auslauftiefe"];
      [PList setObject:[NSNumber numberWithFloat:[Auslaufrand floatValue]] forKey:@"auslaufrand"];
    

      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"LibProfileingabe" object:self userInfo:ProfilDic];
   }
}

- (IBAction)reportProfilLoeschen:(id)sender
{
   
}



- (IBAction)reportProfilSpiegelnHorizontal:(id)sender
{
   if ([Profil1Array count]==0)
   {
      return;
   }

   NSLog(@"reportProfilSpiegelnHorizontal");
   //NSMutableArray* tempElementArray = [[[NSMutableArray alloc]initWithArray: Profil1Array]autorelease];
  
   int i;
   flipH = [sender state];
   NSLog(@"Profil1Array vor flipH: %@",[Profil1Array description]);
   for (i=0;i< [Profil1Array count];i++)
   {
      NSMutableDictionary* tempZeilenDic = [NSMutableDictionary dictionaryWithDictionary:[Profil1Array objectAtIndex:i]];
      float tempx=[[tempZeilenDic objectForKey:@"x"]floatValue];
      tempx *= -1;
      tempx += 1;
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempx]forKey:@"x"];
      [Profil1Array replaceObjectAtIndex:i withObject:tempZeilenDic];
   }
   NSLog(@"Profil1Array nach flipH: %@",[Profil1Array description]);

   
   
   [ProfilStartpunktX setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"x"]floatValue]];
   [ProfilEndpunktX setFloatValue:[[[Profil1Array lastObject]objectForKey:@"x"]floatValue]];
   
   [self setProfilGraphDaten];
   [ProfilGraph setNeedsDisplay:YES];
}

- (IBAction)reportProfilSpiegelnVertikal:(id)sender
{
   if ([Profil1Array count]==0)
   {
      return;
   }
   NSLog(@"reportProfilSpiegelnVertikal");
   int i;
   flipV = [sender state];
   for (i=0;i< [Profil1Array count];i++)
   {
      NSMutableDictionary* tempZeilenDic = [NSMutableDictionary dictionaryWithDictionary:[Profil1Array objectAtIndex:i]];
      float tempy=[[tempZeilenDic objectForKey:@"y"]floatValue];
      tempy *= -1;
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempy]forKey:@"y"];
      [Profil1Array replaceObjectAtIndex:i withObject:tempZeilenDic];
   }
   [ProfilStartpunktY setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"y"]floatValue]];
   [ProfilEndpunktY setFloatValue:[[[Profil1Array lastObject]objectForKey:@"y"]floatValue]];
   
   [self setProfilGraphDaten];
   [ProfilGraph setNeedsDisplay:YES];
   
}

- (IBAction)reportProfilAnfangZuEnde:(id)sender
{
   // NSLog(@"reportProfilAnfangZuEnde");
   NSLog(@"startx: %1.1f starty: %1.1f",startx,starty);
   if ([Profil1Array count]==0)
   {
      return;
   }

   int anz=[Profil1Array count];
   
   // Enddaten fixieren
   float offsetx = [[[Profil1Array objectAtIndex:(anz-1)]objectForKey:@"x"]floatValue];
   float offsety = [[[Profil1Array objectAtIndex:(anz-1)]objectForKey:@"y"]floatValue];
   
   NSMutableArray* tempElementArray = [[[NSMutableArray alloc]initWithArray: Profil1Array]autorelease];
   int i;
   for (i=0;i< [tempElementArray count];i++)
   {
      
      [Profil1Array replaceObjectAtIndex:i  withObject:[tempElementArray objectAtIndex:([tempElementArray count]-i-1)]];
      float tempx=[[[Profil1Array objectAtIndex:i]objectForKey:@"x"]floatValue];
      tempx -= offsetx;
      
      tempx += 1;
      float tempy=[[[Profil1Array objectAtIndex:i]objectForKey:@"y"]floatValue];
      tempy -= offsety;
      NSMutableDictionary* tempZeilenDic = [NSMutableDictionary dictionaryWithDictionary:[Profil1Array objectAtIndex:i]];
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempx]forKey:@"x"];
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempy]forKey:@"y"];
      [tempZeilenDic setObject:[NSNumber numberWithInt:i]forKey:@"index"];
      [Profil1Array replaceObjectAtIndex:i  withObject:tempZeilenDic];
      
      //NSLog(@"i: %d Data: %@",i,[[LibElementArray objectAtIndex:i]description]);
   }
   
   [ProfilStartpunktX setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"x"]floatValue]];
   [ProfilStartpunktY setFloatValue:[[[Profil1Array objectAtIndex:0]objectForKey:@"y"]floatValue]];
   [ProfilEndpunktX setFloatValue:[[[Profil1Array lastObject]objectForKey:@"x"]floatValue]];
   [ProfilEndpunktY setFloatValue:[[[Profil1Array lastObject]objectForKey:@"y"]floatValue]];
   
   [self setProfilGraphDaten];
   [ProfilGraph setNeedsDisplay:YES];
   
}

- (void)setProfilGraphDaten
{
   //NSLog(@"setProfilGraphDaten");
   NSMutableDictionary* datenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [datenDic setObject:Profil1Array forKey:@"elementarray"];
   //NSLog(@"Profil1Array: %d",[Profil1Array count]);
   if ([Profil1Array count] )
   {
     // NSLog(@"Profil1Array Profil 1 count: %d",[Profil1Array count]);
      [datenDic setObject:Profil1Array forKey:@"profil1array"];
   }
   if ([Profil2Array count] )
   {
     // NSLog(@"Profil2Array Profil 2 count: %d",[Profil2Array count]);
      [datenDic setObject:Profil2Array forKey:@"profil2array"];
   }
   [ProfilGraph setDaten:datenDic];
   [ProfilGraph setNeedsDisplay:YES];
   
}

- (void)clearProfilGraphDaten
{
   NSLog(@"clearProfilGraphDaten");
   NSMutableDictionary* datenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   //[datenDic setObject:[NSArray array]];
   //NSLog(@"Profil1Array: %d",[Profil1Array count]);
   if ([Profil1Array count] )
   {
      // NSLog(@"Profil1Array Profil 1 count: %d",[Profil1Array count]);
      [datenDic setObject:[NSArray array] forKey:@"profil1array"];
   }
   if ([Profil2Array count] )
   {
      // NSLog(@"Profil2Array Profil 2 count: %d",[Profil2Array count]);
      [datenDic setObject:[NSArray array] forKey:@"profil2array"];
   }
   [ProfilGraph setDaten:datenDic];
   [ProfilGraph setNeedsDisplay:YES];
   
}




- (void)dealloc
{
   [LibElementName release];
   [LibElementArray release];
   [FigElementArray release];
   [Profil1Name release]; 
   [Profil1Array release];
   [Profil2Array release];
   [ProfilLibPfad release];
   [PList release];
}

#pragma mark Form
- (IBAction)reportForm1Pop:(id)sender
{
   [Form2Pop selectItemAtIndex:[Form1Pop indexOfSelectedItem]];
   return;
   FormName = [sender titleOfSelectedItem];
   float radiusA1 = [SeiteA1 floatValue]/2;
   float radiusB1 = [SeiteB1 floatValue]/2;
   float radiusA2 = [SeiteA2 floatValue]/2;
   float radiusB2 = [SeiteB2 floatValue]/2;
   
   
   switch ([Form1Pop indexOfSelectedItem])
   {
      case 0: // Kreis
      {
         Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA1  mitLage:[LagePop indexOfSelectedItem]]];
         Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA2  mitLage:[LagePop indexOfSelectedItem]]];
         
      }  break;
         
      case 1: // Ellipse
      {
         Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC EllipsenKoordinatenMitRadiusA:radiusA1 mitRadiusB:radiusB1 mitLage:[LagePop indexOfSelectedItem]]];
         Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC EllipsenKoordinatenMitRadiusA:radiusA2 mitRadiusB:radiusB2 mitLage:[LagePop indexOfSelectedItem]]];
         
      }break;
         
      case 2: // Quadrat
      {
         
      }break;
         
      case 3: // Rechteck
      {
         
      }break;
         
   }
   // switch
   
}

- (IBAction)reportForm2Pop:(id)sender
{
   FormName = [sender titleOfSelectedItem];
   float radiusA1 = [SeiteA1 floatValue]/2;
   float radiusB1 = [SeiteB1 floatValue]/2;
   float radiusA2 = [SeiteA2 floatValue]/2;
   float radiusB2 = [SeiteB2 floatValue]/2;
   
   switch ([Form1Pop indexOfSelectedItem])
   {
      case 0: // Kreis
      {
         /*
         Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA1  mitLage:[LagePop indexOfSelectedItem]]];
         Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA2  mitLage:[LagePop indexOfSelectedItem]]];
        */
      }  break;
         
      case 1: // Ellispse
      {
         /*
         Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC EllipsenKoordinatenMitRadiusA:radiusA1 mitRadiusB:radiusB1 mitLage:[LagePop indexOfSelectedItem]]];
         Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC EllipsenKoordinatenMitRadiusA:radiusA2 mitRadiusB:radiusB2 mitLage:[LagePop indexOfSelectedItem]]];
         */
      }break;
         
      case 2: // Quadrat
      {
         
      }break;
         
      case 3: // Rechteck
      {
         
      }break;
         
   }
   // switch
   
}

- (IBAction)reportLagePop:(id)sender
{
   //NSLog(@"reportLagePop");
}

- (IBAction)reportFormEinfuegen:(id)sender
{
   FormName = [Form1Pop titleOfSelectedItem];
   //NSLog(@"reportFormEinfuegen name: %@",FormName);
   
   float radiusA1 = [SeiteA1 floatValue]/2;
   float radiusB1 = [SeiteB1 floatValue]/2;
   float radiusA2 = [SeiteA2 floatValue]/2;
   float radiusB2 = [SeiteB2 floatValue]/2;

   
   switch ([Form1Pop indexOfSelectedItem])
   {
      case 0: // Kreis
      {
         if (radiusA1 >= radiusA2)
         {
            if ([AnzahlPunkte intValue]>2)
            {
         Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA1  mitLage:[LagePop indexOfSelectedItem] mitAnzahlPunkten:[AnzahlPunkte intValue]] ];
            }
            else
            {
               Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA1  mitLage:[LagePop indexOfSelectedItem] mitAnzahlPunkten:-1] ];
               
            }
         int anzahlMasterpunkte = [Form1KoordinatenArray count]-1;
         Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA2  mitLage:[LagePop indexOfSelectedItem]mitAnzahlPunkten: anzahlMasterpunkte]];
         }
         else
         {
            Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA2  mitLage:[LagePop indexOfSelectedItem] mitAnzahlPunkten:-1] ];
            int anzahlMasterpunkte = [Form2KoordinatenArray count]-1;
            Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC KreisKoordinatenMitRadius:radiusA1  mitLage:[LagePop indexOfSelectedItem]mitAnzahlPunkten: anzahlMasterpunkte]];
            
         }
         
      }  break;
         
      case 1: // Ellipse
      {
         Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC EllipsenKoordinatenMitRadiusA:radiusA1 mitRadiusB:radiusB1 mitLage:[LagePop indexOfSelectedItem]mitAnzahlPunkten:-1]];
         int anzahlMasterpunkte = [Form1KoordinatenArray count]-1;
         Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC EllipsenKoordinatenMitRadiusA:radiusA2 mitRadiusB:radiusB2 mitLage:[LagePop indexOfSelectedItem]mitAnzahlPunkten: anzahlMasterpunkte]];
         
      }break;
         
      case 2: // Quadrat
      {
         float quadratwinkel1=0;
         if ([[Winkel1 stringValue] length]==0)
         {
            quadratwinkel1 = [LagePop indexOfSelectedItem]*90;
         }
         else
         {
            quadratwinkel1 = [Winkel1 floatValue];
         }
         
         float quadratwinkel2=0;
         if ([[Winkel1 stringValue] length]==0)
         {
            quadratwinkel2 = [LagePop indexOfSelectedItem]*90;
         }
         else
         {
            quadratwinkel2 = [Winkel2 floatValue];
         }
         
         Form1KoordinatenArray = [NSMutableArray arrayWithArray:[CNC QuadratKoordinatenMitSeite:[SeiteA1 floatValue] mitWinkel:quadratwinkel1]];
         Form2KoordinatenArray = [NSMutableArray arrayWithArray:[CNC QuadratKoordinatenMitSeite:[SeiteA2 floatValue] mitWinkel:quadratwinkel2]];
         
      }break;
         
      case 3: // Rechteck
      {
         
      }break;
         
   }
   // switch

   NSMutableDictionary* ElementDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [ElementDic setObject:@"Form"  forKey:@"quelle"];
   //NSLog(@"reportFormEinfuegen Form1KoordinatenArray count: %d",[Form1KoordinatenArray count]);
   //NSLog(@"reportFormEinfuegen Form2KoordinatenArray count: %d",[Form2KoordinatenArray count]);
   //NSLog(@"reportFormEinfuegen Form1KoordinatenArray: %@",[Form1KoordinatenArray description]);
	[ElementDic setObject:FormName forKey:@"elementname"];
   //NSLog(@"reportFormEinfuegen Form1Array: %@",[Form1KoordinatenArray description]);
	//[ElementDic setObject:LibElementArray forKey:@"elementarray"];
   
   // Offset x,y einsetzen
   
   NSMutableArray* Koordinatentabelle=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   startx=0;
   starty=0;
   int i=0;
   
   if (radiusA1 >= radiusA2)
   {
      for (i=1;i<[Form1KoordinatenArray count];i++) // Erstes Element ist Startpunkt und schon im Array
      {
         float tempax = [[[Form1KoordinatenArray objectAtIndex:i]objectForKey:@"x"]floatValue] + startx;
         float tempay = [[[Form1KoordinatenArray objectAtIndex:i]objectForKey:@"y"]floatValue] + starty;
         float tempbx = [[[Form2KoordinatenArray objectAtIndex:i]objectForKey:@"x"]floatValue] + startx;
         float tempby = [[[Form2KoordinatenArray objectAtIndex:i]objectForKey:@"y"]floatValue] + starty;
         [Koordinatentabelle addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempax],[NSNumber numberWithFloat:tempay],[NSNumber numberWithFloat:tempbx],[NSNumber numberWithFloat:tempby], nil]];
         
      }
   }
   else
   {
      for (i=1;i<[Form2KoordinatenArray count];i++) // Erstes Element ist Startpunkt und schon im Array
      {
         float tempax = [[[Form1KoordinatenArray objectAtIndex:i]objectForKey:@"x"]floatValue] + startx;
         float tempay = [[[Form1KoordinatenArray objectAtIndex:i]objectForKey:@"y"]floatValue] + starty;
         float tempbx = [[[Form2KoordinatenArray objectAtIndex:i]objectForKey:@"x"]floatValue] + startx;
         float tempby = [[[Form2KoordinatenArray objectAtIndex:i]objectForKey:@"y"]floatValue] + starty;
         [Koordinatentabelle addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempax],[NSNumber numberWithFloat:tempay],[NSNumber numberWithFloat:tempbx],[NSNumber numberWithFloat:tempby], nil]];
         
      }
     
   }
   //NSLog(@"reportFormEinfuegen Koordinatentabelle: %@",[Koordinatentabelle description]);

	[ElementDic setObject:Koordinatentabelle forKey:@"koordinatentabelle"];
   
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"Formeingabe" object:self userInfo:ElementDic];
   //startx=endx+startx;
   //starty=endy+starty;
   
   [libstartx setFloatValue:startx];
   [libstarty setFloatValue:starty];
   
   [LibGraph clearGraph];
   [LibElemente selectItemAtIndex:0];
}

#pragma mark Block
- (IBAction)reportBlockEinfuegen:(id)sender
{
   NSLog(@"reportBlockEinfuegen");
   NSMutableDictionary* BlockDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [BlockDic setObject:[NSNumber numberWithInt:[Blockoberkante intValue]] forKey:@"blockoberkante"];
   [BlockDic setObject:[NSNumber numberWithInt:[Auslaufkote intValue]] forKey:@"auslaufkote"];
   [BlockDic setObject:[NSNumber numberWithInt:[Blockbreite intValue]] forKey:@"blockbreite"];
   [BlockDic setObject:[NSNumber numberWithInt:[Blockdicke intValue]] forKey:@"blockdichte"];

   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"Blockeingabe" object:self userInfo:BlockDic];

}

- (IBAction)reportOberkanteStepper:(id)sender
{
   
}
#pragma mark Externe Figur
// Extern
- (NSArray*)readFigur
{
   NSArray* FigurArray = [Utils readFigur];
   NSLog(@"CNC_Eingbe readFigur FigurArray: \n%@",[FigurArray description]);

   return FigurArray;
}

- (IBAction)reportReadFigur:(id)sender
{
   
  // NSArray* FigurArray = [Utils readFigur];
   //NSLog(@"CNC_Eingbe readFigur FigurArray: \n%@",[FigurArray description]);
   FigElementArray= [[NSMutableArray arrayWithArray:[Utils readFigur]]retain]; // retain ist noetig
   NSLog(@"CNC_Eingbe readFigur FigElementArray: \n%@",[FigElementArray description]);
   [self setFigGraphDaten];
   NSLog(@"CNC_Eingbe readFigur A");
   [FigGraph setNeedsDisplay:YES];
   NSLog(@"CNC_Eingbe readFigur B");
   
}

//- (int)SetFigElemente:(NSArray*)LibArray;
//- (IBAction)reportLibPop:(id)sender;

- (IBAction)reportFigElementEinfuegen:(id)sender
{
   //NSLog(@"reportFigElementEinfuegen name: %@",LibElementName);
   NSMutableDictionary* ElementDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [ElementDic setObject:@"FigElement"  forKey:@"quelle"];
	//[ElementDic setObject:FigElementName forKey:@"elementname"];
   NSLog(@"CNC_EingabereportFigElementEinfuegen FigElementArray: %@",[FigElementArray description]);
	[ElementDic setObject:FigElementArray forKey:@"elementarray"];

   NSMutableArray* Koordinatentabelle=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   startx=0;
   starty=0;
   int i=0;
   for (i=1;i<[FigElementArray count];i++) // Erstes Element ist Startpunkt und schon im Array
   {
      float tempx = [[[FigElementArray objectAtIndex:i]objectForKey:@"x"]floatValue] + startx;
      float tempy = [[[FigElementArray objectAtIndex:i]objectForKey:@"y"]floatValue] + starty;
      [Koordinatentabelle addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempx],[NSNumber numberWithFloat:tempy], nil]];
   }
	[ElementDic setObject:Koordinatentabelle forKey:@"koordinatentabelle"];
   //NSLog(@"reportFigElementEinfuegen ElementDic: %@",[ElementDic description]);
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"FigElementeingabe" object:self userInfo:ElementDic];
   [FigGraph clearGraph];

}

- (IBAction)reportFigElementLoeschen:(id)sender
{
   

}

- (IBAction)reportFigElementSpiegelnHorizontal:(id)sender
{
   
}

- (IBAction)reportFigElementSpiegelnVertikal:(id)sender
{
   
}

- (IBAction)reportFigElementAnfangZuEnde:(id)sender
{
   
}

- (void)setFigGraphDaten
{
   NSMutableDictionary* datenDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   
   NSPoint Startpunkt = NSMakePoint([[[FigElementArray objectAtIndex:0]objectForKey:@"x"]floatValue]*zoom, [[[FigElementArray objectAtIndex:0]objectForKey:@"y"]floatValue]*zoom);
   NSPoint Endpunkt = NSMakePoint([[[FigElementArray lastObject]objectForKey:@"x"]floatValue]*zoom, [[[FigElementArray lastObject]objectForKey:@"y"]floatValue]*zoom);
   [datenDic setObject:NSStringFromPoint(Startpunkt) forKey:@"startpunkt"];
   [datenDic setObject:NSStringFromPoint(Endpunkt) forKey:@"endpunkt"];

   [datenDic setObject:FigElementArray forKey:@"elementarray"];
   [FigGraph setDaten:datenDic];
   [FigGraph setNeedsDisplay:YES];
}


- (NSDictionary*)PList
{
   return PList;
}

- (void)setPList:(NSDictionary*)plist
{
   [plist retain];
   [PList release];
   PList = (NSMutableDictionary*)plist;
   
}
/*
 - (IBAction)showWindow:(id)sender
 {
 NSLog(@"showWindow");
 
 [[self window]makeKeyAndOrderFront:NULL];
 }
 */
@end
