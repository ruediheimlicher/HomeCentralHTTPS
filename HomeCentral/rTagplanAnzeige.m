//
//  rhalbstundetagplananzeige.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 29.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rTagplanAnzeige.h"
#import <QuartzCore/QuartzCore.h>

@implementation rTagplanAnzeige

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   if ([self.datenarray count]==0)
   {
      return;
   }
    // Drawing code
   // Felder fuer die Stunden aufbauen
   float stundenabstand = 12;
   
   UIColor* hintergrund = self.backgroundColor;
   CGContextRef context = UIGraphicsGetCurrentContext();
   //CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
   //CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
   float offset=1;
   float position =0;
   //UIColor *oncolor = (0.0, 0.0, 1.0, 0.8);
   for (int stunde=0;stunde<24;stunde++)
   {
      position = offset+stundenabstand*stunde;
      if (stunde%4 ==0)
      {
      CGRect stundefeld = CGRectMake(position, 16, 12, 12);
      UILabel* std = [[UILabel alloc]initWithFrame:stundefeld];
      [std setFont:[UIFont fontWithName:@"Helvetica" size:10]];
      std.text=[NSString stringWithFormat:@"%d",stunde];
      std.textAlignment = NSTextAlignmentCenter;
      std.backgroundColor = hintergrund;
      [self addSubview:std];
      
      }
      position +=6;
      int stundenwert = [[self.datenarray objectAtIndex:stunde]intValue];
      switch (self.typ)
      {
         case 0:
         {
            
            //NSLog(@"typ 0 stundenwert: %d",stundenwert);
            CGRect tastenfeld = CGRectMake(position, 8.0, 3.8, 8.0);
            
            CGContextAddRect(context, tastenfeld);     //X, Y, Width, Height
            if ((stundenwert & 0x02)>0)
            {
               CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.8);
            }
            else
            {
               CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 0.5);
            }
            CGContextFillPath(context);
            
            
            tastenfeld.origin.x += 5;
            CGContextAddRect(context, tastenfeld);     //X, Y, Width, Height
            
            if ((stundenwert & 0x01)>0)
            {
               CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.8);
            }
            else
            {
               CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 0.5);
            }
            
            CGContextFillPath(context);
         }break;
            
         case 1: // ganze Stunden
         {
            //NSLog(@"typ 1 stundenwert: %d",stundenwert);
            CGRect tastenfeld = CGRectMake(position, 8.0, 7.6, 8.0);
            
            CGContextAddRect(context, tastenfeld);     //X, Y, Width, Height
            if ((stundenwert )>0)
            {
               CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.8);
            }
            else
            {
               CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 0.5);
            }
            CGContextFillPath(context);

         }break;
      }//switch
      
   } // for stunde
   
   position += stundenabstand-6;
   CGRect stundefeld = CGRectMake(position, 16, 12, 12);
   UILabel* std = [[UILabel alloc]initWithFrame:stundefeld];
   [std setFont:[UIFont fontWithName:@"Helvetica" size:10]];
   std.text=[NSString stringWithFormat:@"%d",24];
   std.textAlignment = NSTextAlignmentCenter;
   std.backgroundColor = hintergrund;
   
   [self addSubview:std];

}


@end
