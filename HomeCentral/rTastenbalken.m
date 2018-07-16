//
//  rTastenbalken.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 31.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rTastenbalken.h"

@implementation rTastenbalken

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (NSDictionary*)StundenDic
{
   NSMutableDictionary* stundendic = [[NSMutableDictionary alloc]initWithCapacity:0];
   
   
   return (NSDictionary*)stundendic;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
