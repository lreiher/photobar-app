//
//  HeaderViewController.m
//  PhotoBar
//
//  Created by Lennart Reiher on 28.11.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "HeaderViewController.h"
#import "ViewControllerLayoutAbstract.h"

@interface HeaderViewController ()

@property (nonatomic) NSUserDefaults* sharedDefaults;
@property (nonatomic) NSString* switchMessage;
@property (nonatomic) NSString* heightMessage;
@property (nonatomic) NSString* imgNoMessage;
@end

@implementation HeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lennart.reiher.PhotoBar"];
    
    [self.hSwitch addTarget:(ViewControllerLayoutAbstract*)self.parentViewController action:@selector(switchChangedState:) forControlEvents:UIControlEventValueChanged];
    
    self.switchMessage = NSLocalizedString(@"Always use last photos from camera roll", nil);
    self.heightMessage = NSLocalizedString(@"Choose height of custom PhotoBar", nil);
    self.imgNoMessage = NSLocalizedString(@"Choose number of images of custom PhotoBar", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self setSwitchStates];
}

-(void)setSwitchStates {
    
    NSString* screenName = ((ViewControllerLayoutAbstract*)self.parentViewController).screenName;
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@_usingLastPhotos",((ViewControllerLayoutAbstract*)self.parentViewController).pathComponent]]) {
        [self.hSwitch setOn:true];
    }
    
    if ([screenName isEqualToString:@"Layout 1"] || [screenName isEqualToString:@"Layout 5"] || [screenName isEqualToString:@"Layout 9"]) {
        self.hSwitch.onTintColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
    } else if ([screenName isEqualToString:@"Layout 2"] || [screenName isEqualToString:@"Layout 6"] || [screenName isEqualToString:@"Layout A"]) {
        self.hSwitch.onTintColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    } else if ([screenName isEqualToString:@"Layout 3"] || [screenName isEqualToString:@"Layout 7"] || [screenName isEqualToString:@"Layout B"]) {
        self.hSwitch.onTintColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    } else if ([screenName isEqualToString:@"Layout 4"] || [screenName isEqualToString:@"Layout 8"] || [screenName isEqualToString:@"Layout C"]) {
        self.hSwitch.onTintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
    }
}

-(void)activateHeightMode {
    
    self.hSwitch.hidden = true;
    self.label.text = self.heightMessage;
}

-(void)activateImgNoMode {
    
    self.hSwitch.hidden = true;
    self.label.text = self.imgNoMessage;
}

-(void)activateSwitchMode {
    
    self.hSwitch.hidden = false;
    self.label.text = self.switchMessage;
}

@end
