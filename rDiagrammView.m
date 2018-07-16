//
//  rDiagrammView.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 06.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rDiagrammView.h"

@implementation rDiagrammView

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
   //NSLog(@"derDataDic: %@",[derDataDic description]);
   self.datadic = derDataDic;
   //NSLog(@"self.datadic: %@",[self.datadic description]);
   DataDic = derDataDic;
   [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
   NSLog(@"drawRect bounds w: %.1f\t h: %.1f" ,self.bounds.size.width,self.bounds.size.height);
 CGContextRef context = UIGraphicsGetCurrentContext();
 //CGContextTranslateCTM (context,10,0);

   CGContextSetLineWidth(context, 0.6);
   CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
   // How many lines?
   int howMany = (kDefaultGraphWidth - kOffsetX) / kStepX;
   // Here the lines go
   for (int i = 0; i < howMany; i++)
   {
      CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
      CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
   }
   int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
   for (int i = 0; i <= howManyHorizontal; i++)
   {
      CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
      CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
   }

   CGContextStrokePath(context);
   /*
    void CGContextShowText (
    CGContextRef c,
    const char *string,
    size_t length
    */
   
   CGContextRef xcontext = UIGraphicsGetCurrentContext();
   //CGContextSelectFont(xcontext, "Helvetica", 14, kCGEncodingMacRoman);
   CGContextSetTextDrawingMode(xcontext, kCGTextFill);

   
   //CGContextTranslateCTM (xcontext,10,0);
   CGContextMoveToPoint(xcontext,kOffsetX,kOffsetY);
   //CGContextAddLineToPoint(xcontext, kOffsetX +10, kOffsetY+20);
   CGContextSetTextMatrix (xcontext, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
   
  
//   char* x_achse = "0 1 2 3\0";
   //NSLog(@"%s l: %zd",x_achse,strlen(x_achse));
   //CGContextShowTextAtPoint(xcontext,kOffsetX +10,kOffsetY+20,x_achse,strlen(x_achse));
   CGContextStrokePath(xcontext);
    
   //NSLog(@"drawrect self.datadic: %@",[self.datadic description]);
   if ([self.datadic objectForKey:@"linearray"])
   {
      
      //CGContextRef linecontext = UIGraphicsGetCurrentContext();
      
      //CGContextTranslateCTM (context,10,10);

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
               //NSLog(@"tempDataArray an Index: %d da: %@",i,[tempDataArray  description]);
               float startx = [[[tempDataArray objectAtIndex:0]objectForKey:@"x"]floatValue];
               float starty = self.bounds.size.height-[[[tempDataArray objectAtIndex:0]objectForKey:@"y"]floatValue];

               CGContextMoveToPoint(templinecontext,startx,starty);
               NSLog(@"x: %.1f \t y: %.1f",startx,starty);
               starty = self.bounds.size.height-starty;
               for (int index=1;index < [tempDataArray count];index++)
               {
                  float x = [[[tempDataArray objectAtIndex:index]objectForKey:@"x"]floatValue];
                  float y = self.bounds.size.height-[[[tempDataArray objectAtIndex:index]objectForKey:@"y"]floatValue];
                 
                  NSLog(@"x: %.1f \t y: %.1f",x,y);
                  CGContextAddLineToPoint(templinecontext,x,y);
                  
               }// for index
               CGContextStrokePath(templinecontext);
            } //if count
            
         }// for i
      }// if count
   }// if linearray
}


@end
