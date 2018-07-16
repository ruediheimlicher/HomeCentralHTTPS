//
//  rStromDiagrammView.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 07.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rStromDiagrammView.h"

@implementation rStromDiagrammView

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      // Initialization code
   }
   //self.datadic = [[NSMutableDictionary alloc]initWithCapacity:0];
   return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)DiagrammZeichnenMitDic:(NSDictionary*)derDataDic
{
   //NSLog(@"DiagrammZeichnenMitDic derDataDic: %@",[derDataDic description]);
   
   self.datadic = derDataDic;
   //NSLog(@"DiagrammZeichnenMitDic Dataarray count: %d",[[[[self.datadic objectForKey:@"linearray"]objectAtIndex:0]objectForKey:@"dataarray"]count]);
   //NSLog(@"DiagrammZeichnenMitDic Dataarray : %@",[[[[self.datadic objectForKey:@"linearray"]objectAtIndex:0]objectForKey:@"dataarray"]description]);
   //float anz=(float)[[[[self.datadic objectForKey:@"linearray"]objectAtIndex:0]objectForKey:@"dataarray"]count];
   //float zoom= anz/1440;
   
   //NSLog(@"DiagrammZeichnenMitDic Dataarray count: %.1f zoom: %2.3f",anz,zoom);
   
   //NSLog(@"self.datadic: %@",[self.datadic description]);
   DataDic = derDataDic;
   [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect
{
   // Drawing code
   //NSLog(@"Strom drawRect bounds w: %.1f\t h: %.1f" ,self.bounds.size.width,self.bounds.size.height);
   
   int art = 0;
   if ([DataDic objectForKey:@"art"])
   {
      art = [[DataDic objectForKey:@"art" ]intValue];
   }
   
   self.diagrammbreite = self.bounds.size.width;
   if ([DataDic objectForKey:@"diagrammbreite"])
   {
      self.diagrammbreite = [[DataDic objectForKey:@"diagrammbreite" ] floatValue];
   }
   
   self.diagrammhoehe = self.bounds.size.height; // Diagramm fuellt ganzes Feld
   if ([DataDic objectForKey:@"diagrammhoehe"])
   {
      self.diagrammhoehe = [[DataDic objectForKey:@"diagrammhoehe" ] floatValue];
   }
   
   //NSLog(@"diagrammhoehe: %.2f diagrammbreite: %.2f",self.diagrammhoehe,self.diagrammbreite);
   
   float  eckeunteny =  self.frame.size.height; //Startpunkt fuer Diagrammzeichnen
   
   self.randlinks = kOffsetX;
   if ([DataDic objectForKey:@"randlinks"])
   {
      self.randlinks = [[DataDic objectForKey:@"randlinks"]intValue];
   }
   
   
//   float  eckeuntenx = [[DataDic objectForKey:@"eckeuntenx"]floatValue]; // Koordinate x Ecke des DiagrammView
   //float  eckeunteny = [[DataDic objectForKey:@"eckeunteny"]floatValue]; // Koordinate y
   
   
   //NSLog(@"randlinks: %d",self.randlinks); // Abstand Diagramm zum View
   
   float intervall = kStepX; //Intervall der x-Achse *zoomfaktor
   
   float zoomfaktorx = 1;
   
   if ([DataDic objectForKey:@"zoomfaktorx"])
   {
      zoomfaktorx = [[DataDic objectForKey:@"zoomfaktorx"]floatValue];
   }
   
   
   
   if ([DataDic objectForKey:@"intervallx"])
   {
      intervall = [[DataDic objectForKey:@"intervallx"]floatValue];
   }
   
   intervall *= zoomfaktorx;
   
   int startx=0;
   if ([DataDic objectForKey:@"startx"])
   {
      startx = [[DataDic objectForKey:@"startx"]intValue];
   }
   
   
   //NSLog(@"intervallx: %.2f zoomfaktorx: %.2f intervall: %.2f startx: %d",[[DataDic objectForKey:@"intervallx"]floatValue],[[DataDic objectForKey:@"zoomfaktorx"]floatValue],intervall,startx);

   self.randunten = kGraphBottom; // Abstand Diagramm zum View
   
   if ([DataDic objectForKey:@"randunten"])
   {
      self.randunten = [[DataDic objectForKey:@"randunten"]floatValue];
   }
   
   UIColor* itemColor=[UIColor blackColor];
   UIFont *ordinateFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:9];
   
   NSDictionary* tempAttr=[NSDictionary dictionaryWithObjectsAndKeys:itemColor, NSForegroundColorAttributeName,ordinateFont,NSFontAttributeName,nil];
   
   
   
 
   CGContextRef context = UIGraphicsGetCurrentContext();
   //CGContextTranslateCTM (context,10,0);
   
   CGContextSetLineWidth(context, 0.4);
   CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
   
   //CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
   
   CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
   CGContextSetTextDrawingMode(context, kCGTextFill);

   // Senkrechte Linien
   
   
 // Senkrechte Linien
   
   float linieoben = eckeunteny - self.diagrammhoehe - self.randunten;
   float linieunten = eckeunteny - self.randunten;
   //NSLog(@"eckeunteny: %.2f linieoben: %.2f linieunten: %.2f art: %d",eckeunteny,linieoben,linieunten,art);

   int startstd = startx/60;
   int startmin = startx%60;
   /*
   switch (art)
   {
      case 0:
      {
         
      }break;
      case 1:
      {
         //startstd += 1; // Erste angezeigte Stunde ist die naechste volle Stunde
      }break;
   }
   */
   if (startstd)
   {
      //startstd += 1; // Erste angezeigte Stunde ist die naechste volle Stunde
   
   }
  
   
   //NSLog(@"startstd: %d startmin %d",startstd,startmin);
   
   int anzsenkrecht = self.diagrammbreite/intervall;
   
   for (int i = 0; i <= anzsenkrecht; i++)
   {
      float x = self.randlinks-(startmin * zoomfaktorx) + i * intervall;
      CGContextMoveToPoint(context, x,  linieunten);
      CGContextAddLineToPoint(context, x,linieoben);
      
      NSString* Stundestring = [NSString stringWithFormat:@"%d",i+startstd];      
      
      const char* cName = [Stundestring UTF8String];
      //NSLog(@"linie: %d  x: %.2f cName: %s linieoben: %.2f",i ,x,cName,linieoben);
      
   //   CGContextShowTextAtPoint(context,x-(strlen(cName)*3), linieoben-5,cName,strlen(cName));
      NSMutableAttributedString * wertstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",i+startstd] attributes:tempAttr];
      
      [wertstring drawAtPoint:CGPointMake(x-(strlen(cName)*3),linieoben-12)]; 

   
   }
   CGContextStrokePath(context);
   
   // Waagrechte Linien
   
   float hoehe= (int)(self.bounds.size.height/10)*10;
   if ([DataDic objectForKey:@"diagrammhoehe"])
   {
      hoehe = [[DataDic objectForKey:@"diagrammhoehe"]floatValue];
   }
   
   int startwertx = 0;
   if ([DataDic objectForKey:@"startwertx"])
   {
      startwertx = [[DataDic objectForKey:@"startwertx"]intValue];
   }
   //NSLog(@"startwertx: %d",startwertx);
   
   // waagrechte Linien
   
   float breite = self.bounds.size.width;
   int anzh =8;
   
   for (int i = 0; i <= anzh; i++)
   {
      //if (i%2==0)
      {
      CGContextMoveToPoint(context, self.randlinks, self.bounds.size.height - self.randunten - i * (self.diagrammhoehe/anzh)-0.1);
      CGContextAddLineToPoint(context, breite, self.bounds.size.height - self.randunten - i * (self.diagrammhoehe/anzh));
      }
   }
   CGContextStrokePath(context);
   
   CGContextRef xcontext = UIGraphicsGetCurrentContext();
   
  // CGContextSelectFont(xcontext, "Helvetica", 14, kCGEncodingMacRoman);
  // CGContextSetTextDrawingMode(xcontext, kCGTextFill);
   
   //CGContextTranslateCTM (xcontext,10,0);
   CGContextMoveToPoint(xcontext,kOffsetX,kOffsetY);
   //CGContextAddLineToPoint(xcontext, kOffsetX +10, kOffsetY+20);
   CGContextSetTextMatrix (xcontext, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
      
   //char* x_achse = "0 1 2 3\0";
   //NSLog(@"%s l: %zd",x_achse,strlen(x_achse));
   //CGContextShowTextAtPoint(xcontext,kOffsetX +10,kOffsetY+20,x_achse,strlen(x_achse));
   
   //CGContextStrokePath(xcontext);
   
   //NSLog(@"drawrect self.datadic: %@",[self.datadic description]);
   if ([self.datadic objectForKey:@"linearray"])
   {
      
      NSArray* tempLineArray = [self.datadic objectForKey:@"linearray"];
      //     NSLog(@"tempLineArray da: %@",[[self.datadic objectForKey:@"linearray"] description]);
      if (tempLineArray.count)
      {
         for (int i=0;i< tempLineArray.count;i++)
         {
            //NSLog(@"Linie %d",i);
            
            if ([[tempLineArray objectAtIndex:i]count])
            {
               //NSLog(@"tempLineArray objectAtIndex: %d da: %@",i,[[tempLineArray objectAtIndex:i] description]);
               // contextref anlegen
               CGContextRef templinecontext = UIGraphicsGetCurrentContext();
               //CGContextTranslateCTM (templinecontext,10,0);
               //CGContextSetTextMatrix (templinecontext, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
               
               CGContextSetLineWidth(templinecontext, 0.6);
               NSDictionary* tempLineDic = [tempLineArray objectAtIndex:i];
               if ([tempLineDic objectForKey:@"linecolor"])
               {
                  CGContextSetStrokeColorWithColor(templinecontext, [[UIColor redColor] CGColor]);
                  //CGContextSetStrokeColorWithColor(templinecontext, [[tempLineDic objectForKey:@"linecolor"] CGColor]);
               }
               else
               {
                  CGContextSetStrokeColorWithColor(templinecontext, [[UIColor lightGrayColor] CGColor]);
               }
               NSArray* tempDataArray = [tempLineDic objectForKey:@"dataarray"];
               if ([tempDataArray count]==0)
               {
                  return;
               }
              // NSLog(@"tempDataArray an Index: %d da: %@",i,[[tempDataArray valueForKey:@"x"] description]);
               float startx = self.randlinks+[[[tempDataArray objectAtIndex:0]objectForKey:@"x"]floatValue];
               
               float starty = self.bounds.size.height-self.randunten-[[[tempDataArray objectAtIndex:0]objectForKey:@"y"]floatValue];
               CGContextMoveToPoint(templinecontext,startx,starty);
               //
               //starty = self.bounds.size.height-starty;
               //NSLog(@"SolarDiagrammView drawRect startx: %.1f \t starty: %.1f",startx,starty);
               float x=startx;
               float y=starty;
               
               //CGContextMoveToPoint(templinecontext,startx,starty);
               
               CGContextMoveToPoint(templinecontext,startx,starty);
               //NSLog(@"startx: %.1f \t starty: %.1f",startx,starty);
               starty = self.bounds.size.height-starty;
               CGContextSetLineWidth(templinecontext, 1.6);
               
               for (int index=1;index < [tempDataArray count];index++)
               {
                  
                  x = self.randlinks+[[[tempDataArray objectAtIndex:index]objectForKey:@"x"]floatValue];
                  y = self.bounds.size.height-self.randunten-[[[tempDataArray objectAtIndex:index]objectForKey:@"y"]floatValue];
                  
                  CGContextMoveToPoint(templinecontext,x,linieunten);
                  
                  //NSLog(@"index: %d\t x: %.1f \t y: %.1f",index,x,y);
                  CGContextAddLineToPoint(templinecontext,x,y);
               }// for index
               CGContextStrokePath(templinecontext);
            } //if count
            
         }// for i
      }// if count
   }// if linearray
}


@end
