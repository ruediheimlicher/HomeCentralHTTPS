//
//  rStatusanzeige.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 03.Januar.13.
//  Copyright (c) 2013 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rStatusanzeige : UIView
{
   
}
@property (nonatomic, readwrite) int typ;
@property (nonatomic, readwrite) int anzahlelemente;
@property (nonatomic, readwrite) int code;
@property (nonatomic, readwrite) NSArray* legendearray;
@end
