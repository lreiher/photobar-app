//
//  ViewControllerLayout3.m
//  PhotoBar
//
//  Created by Lennart Reiher on 21.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayout5.h"

@implementation ViewControllerLayout5

- (IBAction)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    [super buttonTouched:sender forEvent:event];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.screenName = @"Layout 5";
}



-(void)setInitialValues {
    
    self.numberOfImages = 2;
    
    self.pathComponent = @"layout5_image";
    
    self.defaultsKey = @"layout5_needsUpdate";
    
    self.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    
    [self setButtonTags];
}



-(void)setButtonTags {
    
    self.button1.tag = 1;
    self.button2.tag = 2;
    
    self.editButton1.tag = 1;
    self.editButton2.tag = 2;
    
    self.placeholder1.tag = 1;
    self.placeholder2.tag = 2;
}



-(CGSize)getSizeOfReducedImage {
    
    CGSize destinationSize;
    
    destinationSize = CGSizeMake(self.view.frame.size.height, self.view.frame.size.height);
    
    return destinationSize;
}



-(void)activateEditMode {
    
    self.placeholder1.superview.hidden = false;
    self.placeholder2.superview.hidden = false;
    
    self.button1.hidden = true;
    self.button2.hidden = true;
}



-(void)deactivateEditMode {
    
    self.button1.hidden = false;
    self.button2.hidden = false;
}



-(void)placeholderForTag:(NSInteger)tag hidden:(BOOL)hidden {
    
    if (tag == 1) {
        self.placeholder1.hidden = hidden;
        self.placeholder1.superview.hidden = hidden;
    } else if (tag == 2) {
        self.placeholder2.hidden = hidden;
        self.placeholder2.superview.hidden = hidden;
    }
}

@end
