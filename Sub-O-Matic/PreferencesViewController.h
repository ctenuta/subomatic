//
//  PreferencesViewController.h
//  Sub-O-Matic
//
//  Created by Cristiano Tenuta on 5/21/15.
//  Copyright (c) 2015 Cubique Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesViewController : NSViewController<NSComboBoxDataSource,NSComboBoxDelegate>

@property (retain, nonatomic) IBOutlet NSTabView *tab;
@property (strong, nonatomic) IBOutlet NSComboBox *languageCombo;

@property (retain, nonatomic)  NSArray *languageNames;
@property (retain, nonatomic)  NSArray *languageCodes;
@property (retain, nonatomic)  NSMutableArray *filteredLanguages;

@property (retain, nonatomic) IBOutlet NSButton *matchMovieFileName;
@property (retain, nonatomic) IBOutlet NSButton *overwriteExistingSubtitle;

@end
