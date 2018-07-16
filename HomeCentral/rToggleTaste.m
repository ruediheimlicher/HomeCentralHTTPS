//
//  rToggleTaste.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 28.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rToggleTaste.h"

@implementation rToggleTaste

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       //NSLog(@"ToggleTaste init");
        // Initialization code
       [self setBackgroundImage:[UIImage imageNamed:@"leeretaste.jpg"] forState:UIControlStateNormal];
       [self setBackgroundImage:[UIImage imageNamed:@"blauetaste.jpg"] forState:UIControlStateSelected];
       [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
       [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    }
    return self;
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
