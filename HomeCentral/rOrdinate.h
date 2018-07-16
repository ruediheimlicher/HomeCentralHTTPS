//
//  rOrdinate.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 11.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface rOrdinate : UIView
{
   
}
@property (nonatomic, readwrite)float offsetx;
@property (nonatomic, readwrite)float eckeunteny;

@property (nonatomic, readwrite)float randunten;
@property (nonatomic, readwrite)float diagrammhoehe;
@property (nonatomic, readwrite)float b;
@property (nonatomic, readwrite)int min;
@property (nonatomic, readwrite)int max;
@property (nonatomic, readwrite)int teile;
@property (nonatomic, readwrite)int startwert;
@property (nonatomic, readwrite)int intervall;
@property (nonatomic, readwrite)int red;
@property (nonatomic, readwrite)NSString* einheit;

-(void)OrdinateZeichnenMitDic:(NSDictionary*)derDataDic;

@end
