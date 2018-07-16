//
//  rVariableStore.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 26.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rVariableStore.h"

@implementation rVariableStore
{
   
}
+ (rVariableStore *)sharedInstance
{
   // the instance of this class is stored here
   static rVariableStore *store = nil;
   
   // check to see if an instance already exists
   if (nil == store) {
      store  = [[[self class] alloc] init];
      // initialize variables here
   }
   // return the instance of this class
   return store;
}
- (NSString*)IP
{
   return self.ip;
}
- (void)setIP:(NSString*)ip
{
   self.ip = ip;
   //[IP setString:ip];
}
@end
