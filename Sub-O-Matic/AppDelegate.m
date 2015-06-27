//
//  AppDelegate.m
//  Sub-O-Matic
//
//  Created by Cristiano Tenuta on 5/20/15.
//  Copyright (c) 2015 Cubique Solutions. All rights reserved.
//

#import "AppDelegate.h"




@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"SelectedLanguage"] == nil)
    {
        [defaults setObject:@"eng" forKey:@"SelectedLanguage"];
    }
    
    if ([defaults objectForKey:@"MatchMovieFileName"] == nil)
    {
        [defaults setBool:YES forKey:@"MatchMovieFileName"];
    }
    
    if ([defaults objectForKey:@"OverwriteExistingSubtitle"] == nil)
    {
        [defaults setBool:YES forKey:@"OverwriteExistingSubtitle"];
    }
    
    [defaults synchronize];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
