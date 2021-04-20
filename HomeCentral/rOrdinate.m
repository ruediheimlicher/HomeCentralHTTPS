//
//  rOrdinate.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 11.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//


#import "rOrdinate.h"

@implementation rOrdinate

char* itoa(int val, int base)
{
	
	static char buf[32] = {0};
	
	int i = 30;
	
	for(; val && i ; --i, val /= base)
      
		buf[i] = "0123456789abcdef"[val % base];
	
	return &buf[i+1];
	
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       NSLog(@"ordinate init");
        // Initialization code
    }
    return self;
}


-(void)OrdinateZeichnenMitDic:(NSDictionary*)derDataDic;
{
   //NSLog(@"OrdinateZeichnenMitDic: %@",[derDataDic description]);
   if ([derDataDic objectForKey:@"offsetx"])
   {
      self.offsetx = [[derDataDic objectForKey:@"offsetx"]floatValue];
   }
   else
   {
      self.offsetx = 2;
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
      self.diagrammhoehe = [[derDataDic objectForKey:@"diagrammhoehe"]floatValue];
   }
   else
   {
      self.diagrammhoehe = 200;
   }

   if ([derDataDic objectForKey:@"b"])
   {
      self.b = [[derDataDic objectForKey:@"b"]floatValue];
   }
   else
   {
      self.b = 20;
   }

   if ([derDataDic objectForKey:@"teile"])
   {
      self.teile = [[derDataDic objectForKey:@"teile"]floatValue];
   }
   else
   {
      self.teile = 10;
   }

   if ([derDataDic objectForKey:@"intervally"])
   {
      self.intervall = [[derDataDic objectForKey:@"intervally"]floatValue];
   }
   else
   {
      self.intervall = 10;
   }

   
   
   if ([derDataDic objectForKey:@"randunten"])
   {
      self.randunten = [[derDataDic objectForKey:@"randunten"]floatValue];
   }
   else
   {
      self.randunten = 10;
   }

   if ([derDataDic objectForKey:@"red"]) // Reduktion der anzahl angegebener Ordinaten. 0: alle 1: nur gerade
   {
      self.red = [[derDataDic objectForKey:@"red"]floatValue];
   }
   else
   {
      self.red = 0;
   }

   if ([derDataDic objectForKey:@"einheit"])
   {
      self.einheit = [derDataDic objectForKey:@"einheit"];
   }
   else
   {
      self.einheit = @"";
   }
   //NSLog(@"einheit: *%@*",self.einheit);

}

- (void)drawRect:(CGRect)rect
{
   /*
   self.offsetx=2;
   self.eckeunteny=2;
   self.teile=12;
   self.intervall = 10;
   //self.h=self.frame.size.height-self.eckeunteny - 2;
   self.b=self.frame.size.width - 2;
    */
   
    // Drawing code
   //NSLog(@"Ordinate drawRect bounds w: %.1f\t h: %.1f" ,self.bounds.size.width,self.bounds.size.height);
    //NSLog(@"Ordinate drawRect diagrammhoehe: %.1f\t offsetx: %.1f" ,self.diagrammhoehe,self.offsetx);
   //NSLog(@"Ordinate drawRect teile: %d",self.teile);
   
   UIColor* itemColor=[UIColor blackColor];
   UIFont *ordinateFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:9];
   NSDictionary* tempAttr=[NSDictionary dictionaryWithObjectsAndKeys:itemColor, NSForegroundColorAttributeName,ordinateFont,NSFontAttributeName,nil];

   
   CGContextRef context = UIGraphicsGetCurrentContext();
   //CGContextTranslateCTM (context,8,0);
   /*
   CGFontRef schrift =  CGFontCreateWithFontName((CFStringRef)@"Helvetica");
   // https://stackoverflow.com/questions/467404/how-to-create-a-font-with-cgfontcreatewithfontname
   CGContextSetFont(context,schrift);
   CGContextSetFontSize(context,10);
   
   CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
   CGContextSetTextDrawingMode(context, kCGTextFill);
   //CGContextTranslateCTM (xcontext,10,0);
   CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));

   CGContextSetLineWidth(context, 0.4);
   CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
   //NSLog(@"drawRect eckeunteny: %.1f",self.eckeunteny);
*/
  
   
   float startx = self.offsetx;
   float starty = self.eckeunteny+2-self.randunten;
   //NSLog(@"Ordinate startx: %.1f starty: %.1f",startx,starty);
      
   CGContextMoveToPoint(context, startx,starty);
   float y = 0;
   float x = 0;
//   NSNumber *celcius = @21;
//   NSNumber *pi = @3.14159265359;
    for (int i=0;i<self.teile+1;i++)
   {
      int wert = self.startwert+i*self.intervall;
      //const char* cLegende = [[[NSNumber numberWithInt:wert]stringValue]UTF8String];
   //   const char* cLegende = malloc(6);
      //NSLog(@"Ordinate i: %d wert: %d",i,wert);
   //   cLegende = [[[NSNumber numberWithInt:wert ]stringValue] UTF8String];
      x = self.offsetx;
      
      if (wert<10)
      {
         x += 10;
         
      }
      else if (wert<100)
      {
         x += 5;
      }
      

      NSMutableAttributedString * wertstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",wert] attributes:tempAttr];
      
      CGContextBeginPath(context);
      //char* c = itoa(wert,10);
      //char* cLegende=
      switch (self.red)
      {
         case 0:
         {
            y = starty - 8 - i*(self.diagrammhoehe/(self.teile));
            /*
            CGMutablePathRef path = CGPathCreateMutable();
            //CTFramesetterRef ctFramesetting = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)wertstring);
            CTFramesetterRef rahmensetting = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)wertstring);
            CTFrameRef rahmen = CTFramesetterCreateFrame(rahmensetting, CFRangeMake(0, wertstring.length), path, NULL);
            // https://stackoverflow.com/questions/25249860/ios-draw-a-text-at-a-point-in-a-rectangle
             */
           [wertstring drawAtPoint:CGPointMake(x,y)]; 
            
           // CGContextShowTextAtPoint(context,x ,y,cLegende,strlen(cLegende));
         
         }break;
         case 1: // nur gerade
         {
            if (i%2==0)
            {
               y = starty - 8 - i*(self.diagrammhoehe/(self.teile));
               [wertstring drawAtPoint:CGPointMake(x,y)]; 
               //CGContextShowTextAtPoint(context,x ,y,cLegende,strlen(cLegende));
            }
         }break;
      } // switch
      
      
      //NSLog(@"i: %d cLegende: %s x: %.2f y: %.2f",i ,cLegende,x,y);
      
      
      CGContextStrokePath(context);
   
    
   }
   if ([self.einheit length])
   {
      CGContextBeginPath(context);
 //     const char* cEinheit = malloc(4);
 //     cEinheit = [self.einheit UTF8String];
      //NSLog(@"cEinheit: %s",cEinheit);
      NSMutableAttributedString* einheitstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.einheit] attributes:tempAttr];
      
      [einheitstring drawAtPoint:CGPointMake(self.offsetx+5,y-15)]; 
//      CGContextShowTextAtPoint(context,self.offsetx+5 ,y-15,cEinheit,strlen(cEinheit));
      CGContextStrokePath(context);
      
   }

   
   
}


@end
