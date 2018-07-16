//
//  rAbszisse.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 11.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rAbszisse : UIView
{
   
}


@property (nonatomic, readwrite)float eckeuntenx;
@property (nonatomic, readwrite)float eckeunteny;
@property (nonatomic, readwrite)float h;
@property (nonatomic, readwrite)float b;
@property (nonatomic, readwrite)int min;
@property (nonatomic, readwrite)int max;
@property (nonatomic, readwrite)int teile;
@property (nonatomic, readwrite)int startwert;
@property (nonatomic, readwrite)int intervall;

-(void)AbszisseZeichnenMitDic:(NSDictionary*)derDataDic;
@end
