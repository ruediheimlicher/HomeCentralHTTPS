//
//  rVariableStore.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 26.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

// From http://www.picksourcecode.com/ps/ct/161183.php

#import <Foundation/Foundation.h>

@interface rVariableStore : NSObject
{
   
}
@property (nonatomic, readwrite) NSString* ip;
+ (rVariableStore *)sharedInstance;
- (NSString*)IP;
- (void)setIP:(NSString*)ip;
@end
