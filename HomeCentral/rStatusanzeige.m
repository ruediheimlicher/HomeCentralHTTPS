//
//  rStatusanzeige.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 03.Januar.13.
//  Copyright (c) 2013 Ruedi Heimlicher. All rights reserved.
//

#import "rStatusAnzeige.h"

@implementation rStatusanzeige

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAnzeige
{
   

   
}

- (void)drawRect:(CGRect)rect
{
   //NSLog(@"Statusanzeige drawRect");
   UIColor* hintergrund = self.backgroundColor;
   CGContextRef context = UIGraphicsGetCurrentContext();
   //CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
   //CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
   float offset=10;
   float position =0;
   if (self.anzahlelemente ==0)
   {
      return;
   }
   float positionabstand = (self.frame.size.width -2*offset)/self.anzahlelemente;
   //NSLog(@"positionabstand: %.2f elemente: %d",positionabstand,self.anzahlelemente);
   //UIColor *oncolor = (0.0, 0.0, 1.0, 0.8);
   int bitpos=1;
   for (int pos=0;pos<self.anzahlelemente;pos++)
   {
      position = offset+positionabstand*pos;
      //if (pos%4 ==0)
      {
         CGRect posfeld = CGRectMake(position, 4, 40, 12);
         UILabel* std = [[UILabel alloc]initWithFrame:posfeld];
         std.textAlignment =  NSTextAlignmentRight;
         [std setFont:[UIFont fontWithName:@"Helvetica" size:9
                       ]];
         std.text = [self.legendearray objectAtIndex:pos];
         //std.text=[NSString stringWithFormat:@"%d",pos];
         std.textAlignment = NSTextAlignmentCenter;
         std.backgroundColor = hintergrund;
         [self addSubview:std];
         
      }
      position +=40;
      
      switch (self.typ)
      {
         case 0:
         {
            float nenner = 1/255.0;
            
            //NSLog(@"typ 0 stundenwert: %d",stundenwert);
            CGRect tastenfeld = CGRectMake(position, 4.0, 12.1, 12.1);
            
            CGContextAddRect(context, tastenfeld);     //X, Y, Width, Height
            if ((self.code & bitpos)>0)
            {
               float rot = (float)0x00*nenner;
               float gelb = (float)0x69*nenner;
               float blau = (float)0x0D*nenner;

               CGContextSetRGBFillColor(context, rot, gelb, blau, 0.8);
            }
            else
            {
               float rot = (float)0x62*nenner;
               float gelb = (float)0xc8*nenner;
               float blau = (float)0xef*nenner;
               
               CGContextSetRGBFillColor(context, rot, gelb, blau, 0.3);
            }
            CGContextFillPath(context);
            
          }break;
            
       }//switch
      bitpos *=2;
   } // for pos
   
   //position += positionabstand-6;
   //CGRect stundefeld = CGRectMake(position, 16, 12, 12);
   //UILabel* std = [[UILabel alloc]initWithFrame:stundefeld];
   //[std setFont:[UIFont fontWithName:@"Helvetica" size:10]];
   //std.text=[NSString stringWithFormat:@"%d",24];
   //std.textAlignment = NSTextAlignmentCenter;
   //std.backgroundColor = hintergrund;
   
   //[self addSubview:std];
   

}

@end
