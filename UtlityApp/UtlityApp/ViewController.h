//
//  ViewController.h
//  UtlityApp
//
//  Created by Narendra Verma on 4/15/16.
//  Copyright © 2016 Punchh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSTextViewDelegate>
@property (weak) IBOutlet NSTextField *txtClassName;

@property (strong, nonatomic) NSMutableArray * marrProperties;
@property (weak) IBOutlet NSTextField *lblinvalidJson;
@property (unsafe_unretained) IBOutlet NSTextView *txtView;

- (IBAction)btnClearTapped:(id)sender;
- (IBAction)btnJsonTapped:(id)sender;
@end

