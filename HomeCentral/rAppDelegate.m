//
//  rAppDelegate.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 28.November.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rAppDelegate.h"

@implementation rAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
   [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0], NSFontAttributeName, nil]];

   NSLog(@"didFinishLaunchingWithOptions: %@",[launchOptions description]);
   /*
    // Override point for customization after application launch.
   NSString* DataSuffix=@"ip.txt";
   //NSLog(@"StromDataVonHeute  DownloadPfad: %@ DataSuffix: %@",ServerPfad,DataSuffix);
   NSString* ServerPfad =@"https://www.ruediheimlicher.ch/Data";
   NSURL *URL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:DataSuffix]];
   NSLog(@"didFinishLaunchingWithOptions IP URL: %@",URL);
   NSStringEncoding *  enc=0;
   NSError* WebFehler=NULL;
  //
   return YES; 
   NSMutableURLRequest* IPrequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:0 timeoutInterval:10];
   NSURLResponse* response=nil;
   // http://hayageek.com/ios-nsurlsession-example
   NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
   
   NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];

   [IPrequest setHTTPMethod:@"GET"];
   
   NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:IPrequest];

   //   [dataTask resume];
    */
   return YES;
   
   
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
   NSLog(@"applicationWillResignActive: ");
   
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   NSLog(@"applicationDidEnterBackground: ");
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"EnterBackground" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]forKey:@"status"]];
   

   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.


}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   NSLog(@"applicationWillEnterForeground: ");
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   NSLog(@"applicationDidBecomeActive: ");
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   //NSArray* Kontroller = [self rootViewController];
   NSString* DataSuffix=@"ip.txt";
   //NSLog(@"StromDataVonHeute  DownloadPfad: %@ DataSuffix: %@",ServerPfad,DataSuffix);
   NSString* ServerPfad =@"https://www.ruediheimlicher.ch/Data";
   NSURL *URL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:DataSuffix]];
   NSLog(@"didFinishLaunchingWithOptions IP URL: %@",URL);
   NSStringEncoding *  enc=0;
   NSError* WebFehler=NULL;
   //
   //return YES; 
   NSMutableURLRequest* IPrequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:0 timeoutInterval:10];
   NSURLResponse* response=nil;
   // http://hayageek.com/ios-nsurlsession-example
   NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
   
   NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
   
   [IPrequest setHTTPMethod:@"GET"];
   
   NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:IPrequest];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
   NSLog(@"applicationWillTerminate: ");
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"Beenden" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]forKey:@"status"]];

   // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// **************************************
#pragma mark NSURLSession Delegate Methods

// NSURLSessionDataDelegate - get continuous status of your request
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
   NSLog(@" didReceiveResponse");
   receivedData=nil; receivedData=[[NSMutableData alloc] init];
   //[receivedData setLength:0];
   
   completionHandler(NSURLSessionResponseAllow);
}
//NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
   //receivedAnswerString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
   //NSLog(@"AppDelegate didReceiveData: receivedAnswerString: %@",receivedAnswerString);
   //NSString * HTML_Inhalt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
   NSString * IPString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
   NSLog(@"AppDelegate didReceiveData: IPString: %@",IPString);
   NSLog(@"IP: %@",IPString);
   if (IPString)
   {
      
      NSArray* IPArray = [IPString componentsSeparatedByString:@"\r\n"];
      NSLog(@"IPArray: %@",[IPArray description]);
      NSLog(@"didFinishLaunchingWithOptions vor nc");
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      //set   [nc postNotificationName:@"IP" object:self userInfo:[NSDictionary dictionaryWithObject:IPString forKey:@"ip"]];
      [[rVariableStore sharedInstance] setIP:IPString];
   }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task 
didCompleteWithError:(NSError *)error {
   if (error) {
      NSLog(@"AppDelegate didCompleteWithError mit error: %@",error);
      // do the same like connection:didFailWithError:
   }
   else {
      NSLog(@"AppDelegate didCompleteWithError OK");
      // do the same like connectionDidFinishLoading:
   }
}

@end
