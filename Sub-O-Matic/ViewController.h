//
//  ViewController.h
//  Sub-O-Matic
//
//  Created by Cristiano Tenuta on 5/20/15.
//  Copyright (c) 2015 Cubique Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OSHashAlgorithm.h"
#import "OROpenSubtitleDownloader.h"


@interface ViewController : NSViewController<OROpenSubtitleDownloaderDelegate,NSTableViewDataSource,NSTableViewDelegate,NSComboBoxDataSource,NSComboBoxDelegate>



@property (assign) VideoHash hash;
@property (retain, nonatomic) NSArray *subtitles;
@property (retain, nonatomic) NSMutableArray *sortedSubtitles;

@property (retain, nonatomic)  NSString *moviePath;
@property (retain, nonatomic)  NSString *movieFileName;
@property (retain, nonatomic) IBOutlet NSTableView *tableView;
@property (retain, nonatomic) IBOutlet NSTextField *movieFilePath;

@property (retain, nonatomic) IBOutlet NSTextField *status;
@property (retain, nonatomic) IBOutlet NSButton *importMovie;

@property (retain, nonatomic) NSTimer *checkStatusTimer;



@end

