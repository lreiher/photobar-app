//
//  ViewControllerLayout1.m
//  PhotoBar
//
//  Created by Lennart Reiher on 19.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayout2.h"

@implementation ViewControllerLayout2

- (IBAction)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    [super buttonTouched:sender forEvent:event];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.screenName = @"Layout 2";
}



-(void)setInitialValues {
    
    self.numberOfImages = 4;
    
    self.pathComponent = @"layout2_image";
    
    self.defaultsKey = @"layout2_needsUpdate";
    
    self.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    
    [self setButtonTags];
}



-(void)setButtonTags {
    
    self.button1.tag = 1;
    self.button2.tag = 2;
    self.button3.tag = 3;
    self.button4.tag = 4;
    
    self.editButton1.tag = 1;
    self.editButton2.tag = 2;
    self.editButton3.tag = 3;
    self.editButton4.tag = 4;
    
    self.placeholder1.tag = 1;
    self.placeholder2.tag = 2;
    self.placeholder3.tag = 3;
    self.placeholder4.tag = 4;
}



-(CGSize)getSizeOfReducedImage {
    
    CGSize destinationSize = CGSizeMake(self.view.frame.size.height / 2, self.view.frame.size.height / 2);
    
    return destinationSize;
}



-(void)activateEditMode {
    
    self.placeholder1.superview.hidden = false;
    self.placeholder2.superview.hidden = false;
    self.placeholder3.superview.hidden = false;
    self.placeholder4.superview.hidden = false;
    
    self.button1.hidden = true;
    self.button2.hidden = true;
    self.button3.hidden = true;
    self.button4.hidden = true;
}



-(void)deactivateEditMode {
    
    self.button1.hidden = false;
    self.button2.hidden = false;
    self.button3.hidden = false;
    self.button4.hidden = false;
}



-(void)placeholderForTag:(NSInteger)tag hidden:(BOOL)hidden {
    
    if (tag == 1) {
        self.placeholder1.hidden = hidden;
        self.placeholder1.superview.hidden = hidden;
    } else if (tag == 2) {
        self.placeholder2.hidden = hidden;
        self.placeholder2.superview.hidden = hidden;
    } else if (tag == 3) {
        self.placeholder3.hidden = hidden;
        self.placeholder3.superview.hidden = hidden;
    } else if (tag == 4) {
        self.placeholder4.hidden = hidden;
        self.placeholder4.superview.hidden = hidden;
    }
}

@end
