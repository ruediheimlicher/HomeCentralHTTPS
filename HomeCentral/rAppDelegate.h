//
//  rAppDelegate.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 28.November.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "HomeCentral-Swift.h"
#import "rVariableStore.h"

@interface rAppDelegate : UIResponder <UIApplicationDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLConnectionDelegate>
{
   IBOutlet id TabBar;
   NSData*receivedData;
}
@property (strong, nonatomic) UIWindow *window;

@end
