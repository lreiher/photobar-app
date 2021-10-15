//
//  ViewControllerLayout4.m
//  PhotoBar
//
//  Created by Lennart Reiher on 22.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayout6.h"

@implementation ViewControllerLayout6

- (IBAction)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    [super buttonTouched:sender forEvent:event];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.screenName = @"Layout 6";
}



-(void)setInitialValues {
    
    self.numberOfImages = 3;
    
    self.pathComponent = @"layout6_image";
    
    self.defaultsKey = @"layout6_needsUpdate";
    
    self.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 4 / 3);
    
    [self setButtonTags];
}



-(void)setButtonTags {
    
    self.button1.tag = 1;
    self.button2.tag = 2;
    self.button3.tag = 3;
    
    self.editButton1.tag = 1;
    self.editButton2.tag = 2;
    self.editButton3.tag = 3;
    
    self.placeholder1.tag = 1;
    self.placeholder2.tag = 2;
    self.placeholder3.tag = 3;
}



-(CGSize)getSizeOfReducedImage {
    
    CGSize destinationSize;
    
    destinationSize = CGSizeMake(self.view.frame.size.height * 2 / 3, 2 * self.view.frame.size.height / 3 * 4 / 3);
    
    return destinationSize;
}



-(void)activateEditMode {
    
    self.placeholder1.superview.hidden = false;
    self.placeholder2.superview.hidden = false;
    self.placeholder3.superview.hidden = false;
    
    self.button1.hidden = true;
    self.button2.hidden = true;
    self.button3.hidden = true;
}



-(void)deactivateEditMode {
    
    self.button1.hidden = false;
    self.button2.hidden = false;
    self.button3.hidden = false;
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
    }
}

@end
