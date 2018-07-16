//
//  rAbszisse.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 11.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rAbszisse.h"

@implementation rAbszisse

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)AbszisseZeichnenMitDic:(NSDictionary*)derDataDic;
{
  // NSLog(@"AbszisseZeichnenMitDic %@",[derDataDic description]);
   if ([derDataDic objectForKey:@"offsetx"])
   {
      self.eckeuntenx = [[derDataDic objectForKey:@"offsetx"]floatValue];
   }
   else
   {
      self.eckeuntenx = 2;
   }
   if ([derDataDic objectForKey:@"eckeunteny"])
   {
      
      self.eckeunteny = [[derDataDic objectForKey:@"eckeunteny"]floatValue];
      //NSLog(@"eckeunteny: %.1f",self.eckeunteny);
      
   }
   else
   {
      self.eckeunteny = self.frame.size.height;
   }
   if ([derDataDic objectForKey:@"diagrammhoehe"])
   {
      self.h = [[derDataDic objectForKey:@"diagrammhoehe"]floatValue];
   }
   else
   {
      self.h = 20;
   }
   
   if ([derDataDic objectForKey:@"b"])
   {
      self.b = [[derDataDic objectForKey:@"b"]floatValue];
   }
   else
   {
      self.b = 200;
   }
   
   if ([derDataDic objectForKey:@"teile"])
   {
      self.teile = [[derDataDic objectForKey:@"teile"]floatValue];
   }
   else
   {
      self.teile = 10;
   }
   
   if ([derDataDic objectForKey:@"intervall"])
   {
      self.intervall = [[derDataDic objectForKey:@"intervall"]floatValue];
   }
   else
   {
      self.intervall = 10;
   }

}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
   
   
   UIColor* itemColor=[UIColor blackColor];
   UIFont *ordinateFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:9];
   
//   NSDictionary* tempAttr=[NSDictionary dictionaryWithObjectsAndKeys:itemColor, NSForegroundColorAttributeName,ordinateFont,NSFontAttributeName,nil];
   
  // int wert = 10;
   
 //  NSMutableAttributedString * wertstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",wert] attributes:tempAttr];
   
  // [wertstring drawAtPoint:CGPointMake(x,y)]; 

   /*
// NSLog(@"Abszisse drawRect h: %.1f\t eckeuntenx: %.1f eckeunteny: %.1f" ,self.h,self.eckeuntenx,self.eckeunteny);
 //NSLog(@"Ordinate drawRect teile: %d",self.teile);
 CGContextRef context = UIGraphicsGetCurrentContext();
 //CGContextTranslateCTM (context,8,0);
// CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
 CGContextSetTextDrawingMode(context, kCGTextFill);
 //CGContextTranslateCTM (xcontext,10,0);
 CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
 
 CGContextSetLineWidth(context, 0.4);
 CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);

 */  

//   float startx = self.eckeuntenx;
//   float starty = self.eckeunteny;
   //NSLog(@"Abszisse startx: %.1f starty: %.1f",startx,starty);


}


@end
