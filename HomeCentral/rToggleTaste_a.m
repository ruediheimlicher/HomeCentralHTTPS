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
       NSLog(@"toggletaste init");
        // Initialization code
       [self setBackgroundImage:[UIImage imageNamed:@"leeretaste.jpg"] forState:UIControlStateNormal];
       [self setBackgroundImage:[UIImage imageNamed:@"blauetaste.jpg"] forState:UIControlStateSelected];
       [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
       [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
   [super touchesBegan:touches withEvent:event];
   self.highlighted = self.selected = !self.selected;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
   [super touchesMoved:touches withEvent:event];
   self.highlighted = self.selected;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   [super touchesEnded:touches withEvent:event];
   self.highlighted = self.selected;
}

- (void)setSelected:(BOOL)selected{
   [super setSelected:selected];
   self.highlighted = selected;
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
