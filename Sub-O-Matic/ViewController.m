//
//  ViewController.m
//  Sub-O-Matic
//
//  Created by Cristiano Tenuta on 5/20/15.
//  Copyright (c) 2015 Cubique Solutions. All rights reserved.
//

#import "ViewController.h"
#import "OSHashAlgorithm.h"

OROpenSubtitleDownloader *downloader;


@implementation ViewController

@synthesize hash;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    downloader = [[OROpenSubtitleDownloader alloc] initWithUserAgent:@"Sub-O-Matic"];
    downloader.languageString = [defaults stringForKey:@"SelectedLanguage"];
    downloader.delegate = self;

    NSLog(@"Hash: %@", [OSHashAlgorithm stringForHash:hash.fileHash]);
    

    [self.tableView setDoubleAction:@selector(doubleClick:)];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.view.window];
    
    
    _checkStatusTimer =  [NSTimer scheduledTimerWithTimeInterval:.5
                                                        target:self
                                                      selector:@selector(checkStatus)
                                                      userInfo:nil
                                                       repeats:YES];
    
}

- (IBAction)doubleClick:(id)sender {

    NSInteger rowNumber = [self.tableView clickedRow];
    OpenSubtitleSearchResult *downloadSubtitle = [_sortedSubtitles objectAtIndex:rowNumber];
    
    [self downloadSubtitleWithSubtitleId:downloadSubtitle.subtitleID];
    

}


-(IBAction)donate:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:
    [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=cristiano%40tenuta%2ecom%2ebr&lc=BR&item_name=Cristiano%20Tenuta&item_number=Sub%2dO%2dMatic&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"]];   
}


- (IBAction)openMovieDialog:(id)sender {
    
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"mp4", @"avi", @"mkv", nil];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:FALSE];
    
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
        if ([files count] > 0)
        {
            NSURL *fileURL = [files objectAtIndex:0];
                        
            _moviePath = [[fileURL path] stringByDeletingLastPathComponent];
            _movieFileName = [[[fileURL path] lastPathComponent] stringByDeletingPathExtension];
            _movieFilePath.stringValue = [fileURL path];
            
            _movieFilePath.enabled = NO;
            _importMovie.enabled = NO;
            
            hash = [OSHashAlgorithm hashForPath:[fileURL path]];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            downloader.languageString = [defaults stringForKey:@"SelectedLanguage"];
      
            [downloader searchForSubtitlesWithHash:[OSHashAlgorithm stringForHash:hash.fileHash] andFilesize:[NSNumber numberWithUnsignedLong:hash.fileSize]:^(NSArray *subtitles) {
                
                _movieFilePath.enabled = YES;
                _importMovie.enabled = YES;

                 _subtitles = subtitles;
                
                _sortedSubtitles = [[NSMutableArray alloc] initWithArray:_subtitles];
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subDownloadsCnt" ascending:FALSE];
                [_sortedSubtitles sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
          
                [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
            }];
        }   
    }
}

- (NSURL*)applicationDirectory {
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager*fm = [NSFileManager defaultManager];
    NSURL*    dirPath = nil;
    
    // Find the application support directory in the home directory.
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        // Append the bundle ID to the URL for the
        // Application Support directory
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        // If the directory does not exist, this method creates it.
        // This method is only available in OS X v10.7 and iOS 5.0 or later.
        NSError*    theError = nil;
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                           attributes:nil error:&theError])
        {
            // Handle the error.
            return nil;
        }
    }
    
    return dirPath;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_sortedSubtitles count];
}


-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    OpenSubtitleSearchResult *subtitle =  [_sortedSubtitles objectAtIndex:row];
    
    NSString *columnId =[tableColumn identifier];
    NSString *value = [subtitle valueForKey: columnId];
  
    NSTableCellView *result = [tableView makeViewWithIdentifier:columnId owner:self];
    
    
    if ([columnId isEqualToString:@"subtitleDownloadAddress"])
    {
        NSButton *downloadButton = (NSButton *)[result viewWithTag:0];
        
        downloadButton.alternateTitle = subtitle.subtitleID;
        [downloadButton setTarget:self];
        [downloadButton setAction:@selector(download:)];
    }
    else
        result.textField.stringValue = value;
    
    // Return the result
    return result;

}

-(void)download:(NSButton *)sender {
    [self downloadSubtitleWithSubtitleId:sender.alternateTitle];
}


-(void)downloadSubtitleWithSubtitleId:(NSString *)subtitleId {
    NSString *fileName;
    NSError *err;
    NSURL *fileURL;
    
    for (OpenSubtitleSearchResult *subtitle in _sortedSubtitles)
    {
        if ([subtitle.subtitleID isEqualToString:subtitleId])
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            BOOL mathMovieFileName = [defaults boolForKey:@"MatchMovieFileName"];
            BOOL overwriteExistingSubtitle = [defaults boolForKey:@"OverwriteExistingSubtitle"];
            
            if (mathMovieFileName)
            {
                fileName = [_movieFileName stringByAppendingPathExtension:subtitle.subFormat];
                [downloader downloadSubtitlesForResult:subtitle toPath:[NSString stringWithFormat:@"%@/%@", _moviePath,fileName] :^{
                }];
            }
            else
            {
                if (overwriteExistingSubtitle)
                {
                    [downloader downloadSubtitlesForResult:subtitle toPath:[NSString stringWithFormat:@"%@/%@", _moviePath,subtitle.subtitleFileName] :^{}];
                }
                else
                {
                    
                    fileName = [NSString stringWithFormat:@"%@/%@", _moviePath,subtitle.subtitleFileName];
                    fileURL = [NSURL fileURLWithPath:fileName isDirectory:NO];
                    
                    
                    if ([fileURL checkResourceIsReachableAndReturnError:&err] == NO)
                        [downloader downloadSubtitlesForResult:subtitle toPath:[NSString stringWithFormat:@"%@/%@", _moviePath,subtitle.subtitleFileName] :^{}];
                    else
                    {
                        
                        BOOL fileExist = YES;
                        int count = 0;
                        
                        while (fileExist)
                        {
                            count++;
                            fileName = [subtitle.subtitleFileName stringByDeletingPathExtension];
                            fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@"-%d",count]];
                            fileName = [fileName stringByAppendingPathExtension:subtitle.subFormat];
                            fileName = [NSString stringWithFormat:@"%@/%@", _moviePath,fileName];
                            fileURL = [NSURL fileURLWithPath:fileName isDirectory:NO];
                            fileExist = [fileURL checkResourceIsReachableAndReturnError:&err];
                        }
                        
                        [downloader downloadSubtitlesForResult:subtitle toPath:[NSString stringWithFormat:@"%@", fileName] :^{}];
                        
                    }
                    
                }
                
            }
            
        }
    }
}


-(void)openSubtitlerDidLogIn:(OROpenSubtitleDownloader *)downloader {
    _movieFilePath.enabled = YES;
    _importMovie.enabled = YES;    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


- (void)windowWillClose:(NSNotification *)notification {
    NSWindow *win = [notification object];
    
    if ([win.identifier isEqualToString:@"MainWindow"])
        [NSApp terminate:self];
}

-(void)checkStatus {
    switch (downloader.state) {
        case OROpenSubtitleStateLoggingIn:
            [_status setStringValue:@"Status: Logging In..."];
            break;
        case OROpenSubtitleStateLoggedIn:
            [_status setStringValue:@"Status: Logged In"];
            break;
        case OROpenSubtitleStateSearching:
            [_status setStringValue:@"Status: Searching..."];
            break;
        case OROpenSubtitleStateFetched:
            [_status setStringValue:@"Status: Fetched"];
            break;
        case OROpenSubtitleStateDownloading:
            [_status setStringValue:@"Status: Downloading..."];
            break;
        case OROpenSubtitleStateDownloaded:
            [_status setStringValue:@"Status: Downloaded"];
            break;
        default:
             [_status setStringValue:@"Status: Offline"];
            break;
    }
}
@end
