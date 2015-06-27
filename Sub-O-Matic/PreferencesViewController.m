//
//  PreferencesViewController.m
//  Sub-O-Matic
//
//  Created by Cristiano Tenuta on 5/21/15.
//  Copyright (c) 2015 Cubique Solutions. All rights reserved.
//

#import "PreferencesViewController.h"

NSUserDefaults *defaults;

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    

    
    _languageCodes = [[NSArray alloc] initWithObjects:@"alb",@"ara",@"baq",@"pob",@"bul",@"cat",@"chi",@"hrv",@"cze",@"dan",@"dut",@"eng",@"est",@"fin",@"fre",@"glg",@"geo",@"ger",@"ell",@"heb",@"hun",@"ice",@"ind",@"ita",@"jpn",@"kor",@"mac",@"may",@"nor",@"oci",@"per",@"pol",@"por",@"rum",@"rus",@"scc",@"sin",@"slo",@"slv",@"spa",@"swe",@"tgl",@"tha",@"tur",@"ukr",@"vie",nil];
    
    _languageNames = [[NSArray alloc] initWithObjects:@"Albanian",@"Arabic",@"Basque",@"Brazilian",@"Bulgarian",@"Catalan",@"Chinese",@"Croatian"
                      ,@"Czech",@"Danish",@"Dutch",@"English",@"Estonian",@"Finnish",@"French",@"Galician",@"Georgian",@"German",@"Greek",@"Hebrew",@"Hungarian",@"Icelandic",@"Indonesian",@"Italian",@"Japanese",@"Korean",@"Macedonian",@"Malay",@"Norwegian",@"Occitan",@"Persian",@"Polish",@"Portuguese",@"Romanian",@"Russian",@"Serbian",@"Sinhalese",@"Slovak",@"Slovenian",@"Spanish",@"Swedish",@"Tagalog",@"Thai",@"Turkish",@"Ukrainian",@"Vietnamese",nil];
    

    defaults =  [NSUserDefaults standardUserDefaults];
    
    
   if ([defaults boolForKey:@"MatchMovieFileName"])
   {
       [_matchMovieFileName setState:1];
        [_overwriteExistingSubtitle setEnabled:NO];
   }
   else
   {
       [_matchMovieFileName setState:0];
        [_overwriteExistingSubtitle setEnabled:YES];
   }
    
    if ([defaults boolForKey:@"OverwriteExistingSubtitle"])
        [_overwriteExistingSubtitle setState:1];
    else
        [_overwriteExistingSubtitle setState:0];
    

    [self.languageCombo reloadData];
//    self.languageCombo.usesDataSource = YES;
//    self.languageCombo.dataSource = self;
//    self.languageCombo.delegate = self;


}



- (void) viewDidAppear
{
    
    NSString *selectedLanguage = [defaults stringForKey:@"SelectedLanguage"];
    
    NSUInteger index = [_languageCodes indexOfObject:selectedLanguage];
    
    [self.languageCombo selectItemAtIndex:index];
   // [_languageCombo setObjectValue:[self comboBox:_languageCombo
     //                   objectValueForItemAtIndex:[_languageCombo indexOfSelectedItem]]];
}
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [_languageNames count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return [_languageNames objectAtIndex:index];
}


- (NSString *)comboBox:(NSComboBox *)comboBox completedString:(NSString
                                                               *)partialString {

        int idx; // loop counter
        for (idx = 0; idx < [_languageNames count]; idx++) {
            NSString *testItem = [_languageNames objectAtIndex:idx];
            if ([[testItem commonPrefixWithString:partialString
                                          options:NSCaseInsensitiveSearch] length] == [partialString length]) {
                return testItem;
            }
        }
    
    return @"";
}

//-(NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string {
//    
//    
//    
//    
//    NSArray  *currentList = [NSArray arrayWithArray:_languageNames];
//    
//    NSEnumerator *theEnum = [currentList objectEnumerator];
//    id eachString;
//    NSInteger maxLength = 0;
//    NSString *bestMatch = @"";
//    while (nil != (eachString = [theEnum nextObject]) )
//    {
//        NSString *commonPrefix = [eachString
//                                  commonPrefixWithString:string options:NSCaseInsensitiveSearch];
//        if (commonPrefix.length >= string.length &&
//            commonPrefix.length > maxLength)
//        {
//            maxLength = commonPrefix.length;
//            bestMatch = eachString;
//            
//            break;
//        }
//    }
//    
//    [self resultsInComboForString:string];
//    
//    
//    
//    return bestMatch;br
//}

//-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector{
//    
//    NSComboBox *comboBox = (NSComboBox *) control;
//    
//    if (comboBox == _languageCombo && (commandSelector == @selector(insertNewline:) ||
//                                       commandSelector == @selector(insertBacktab:) ||
//                                       commandSelector == @selector(insertTab:))){
//        if ([self resultsInComboForString:comboBox.stringValue].count == 0 ||
//            _filteredLanguages.count == _languageNames.count) {
//            comboBox.stringValue = _languageNames[0];
//        }
//        
//    }
//    
//    return NO;
//}

-(IBAction)matchMovieFileNameClick:(id)sender
{
    NSButton *button = sender;
    if ([button state] == NSOnState)
    {
        [defaults setBool:YES forKey:@"MatchMovieFileName"];
        [_overwriteExistingSubtitle setEnabled:NO];
    }
    else
    {
       [defaults setBool:NO forKey:@"MatchMovieFileName"];
        [_overwriteExistingSubtitle setEnabled:YES];
    }
    
    [defaults synchronize];

}

-(IBAction)overwriteExistigSubtitleClick:(id)sender
{
    NSButton *button = sender;
    if ([button state] == NSOnState)
        [defaults setBool:YES forKey:@"OverwriteExistingSubtitle"];
    else
        [defaults setBool:NO forKey:@"OverwriteExistingSubtitle"];
    
    [defaults synchronize];
}

-(void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    
    NSUInteger index = [_languageCombo indexOfSelectedItem];
    
    [defaults setObject:[_languageCodes objectAtIndex:index] forKey:@"SelectedLanguage"];
    
    [defaults synchronize];
}
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string{
    
    
    return [_languageNames indexOfObject:string];
}

//
//-(void)comboBoxWillPopUp:(NSNotification *)notification{
//    [self resultsInComboForString:((NSComboBox *)[notification object]).stringValue];
//}
//
//-(NSArray *)resultsInComboForString:(NSString *)string{
//    [_filteredLanguages removeAllObjects];
//    
//    if (string.length == 0 || [string isEqualToString:@""] || [string isEqualToString:@" "]) {
//        [_filteredLanguages addObjectsFromArray:_languageNames];
//    }
//    else{
//        for (int i = 0; i < _languageNames.count; i++) {
//            
//            NSRange searchName  = [_languageNames[i] rangeOfString:string options:NSCaseInsensitiveSearch];
//            if (searchName.location != NSNotFound) { [_filteredLanguages addObject:_languageNames[i]]; }
//            
//        }
//    }
//    
//    
//    [_languageCombo reloadData];
//    
//    return _filteredLanguages;
//}


@end
