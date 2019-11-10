//
//  BottomButtonViewControllerCustom.m
//  PhotoBar
//
//  Created by Lennart Reiher on 17.02.15.
//  Copyright (c) 2015 Lennart Reiher. All rights reserved.
//

#import "BottomButtonViewControllerCustom.h"
#import "ViewControllerLayoutCustom.h"
#import "ViewControllerLayoutCustom2.h"
#import "ViewControllerLayoutCustom3.h"

@interface BottomButtonViewControllerCustom ()

@property (nonatomic) NSUserDefaults* sharedDefaults;
@property (nonatomic) NSString* pathComponent;

@end

@implementation BottomButtonViewControllerCustom

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lennart.reiher.PhotoBar"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.pathComponent = [[(ViewControllerLayoutCustom*)(self.parentViewController) getPathComponent] stringByReplacingOccurrencesOfString:@"_image" withString:@""];
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@_isReady",self.pathComponent]]) {
        self.button.hidden = NO;
    } else {
        self.button.hidden = YES;
    }
    
    if ([self.pathComponent hasSuffix:@"A"]) {
        self.label.text = NSLocalizedString(@"Pull down Notification Center, tap Edit and then select PhotoBar A from the list.", nil);
    } else if ([self.pathComponent hasSuffix:@"B"]) {
        self.label.text = NSLocalizedString(@"Pull down Notification Center, tap Edit and then select PhotoBar B from the list.", nil);
    } else {
        self.label.text = NSLocalizedString(@"Pull down Notification Center, tap Edit and then select PhotoBar C from the list.", nil);
    }
}

-(void)userDefaultsDidChange {
    
    if ([self.sharedDefaults boolForKey:[NSString stringWithFormat:@"%@_isReady",self.pathComponent]]) {
        self.button.hidden = NO;
    } else {
        self.button.hidden = YES;
    }
}

- (IBAction)buttonTouched:(id)sender {
    
    if ([self.pathComponent hasSuffix:@"A"]) {
        [(ViewControllerLayoutCustom*)(self.parentViewController) resetLayout];
    } else if ([self.pathComponent hasSuffix:@"B"]) {
        [(ViewControllerLayoutCustom2*)(self.parentViewController) resetLayout];
    } else {
        [(ViewControllerLayoutCustom3*)(self.parentViewController) resetLayout];
    }
}


@end
