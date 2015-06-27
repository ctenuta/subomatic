//
//  PreferencesWindowsController.m
//  Sub-O-Matic
//
//  Created by Cristiano Tenuta on 5/21/15.
//  Copyright (c) 2015 Cubique Solutions. All rights reserved.
//

#import "PreferencesWindowsController.h"
#import "PreferencesViewController.h"

@interface PreferencesWindowsController ()

@end

@implementation PreferencesWindowsController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [_toolbar setSelectedItemIdentifier:@"General"];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


-(IBAction)loadLanguages:(id)sender
{
    PreferencesViewController *controller = (PreferencesViewController*)self.window.contentViewController;
    [controller.tab selectTabViewItemAtIndex:1];

}

-(IBAction)loadGeneral:(id)sender
{
    PreferencesViewController *controller = (PreferencesViewController*)self.window.contentViewController;
    [controller.tab selectTabViewItemAtIndex:0];
    
}




@end
