//
//  ViewControllerLayout7.m
//  PhotoBar
//
//  Created by Lennart Reiher on 28.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayout3.h"

@implementation ViewControllerLayout3

- (IBAction)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    [super buttonTouched:sender forEvent:event];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.screenName = @"Layout 3";
}



-(void)setInitialValues {
    
    self.numberOfImages = 8;
    
    self.pathComponent = @"layout3_image";
    
    self.defaultsKey = @"layout3_needsUpdate";
    
    self.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    
    [self setButtonTags];
}



-(void)setButtonTags {
    
    self.button1.tag = 1;
    self.button2.tag = 2;
    self.button3.tag = 3;
    self.button4.tag = 4;
    self.button5.tag = 5;
    self.button6.tag = 6;
    self.button7.tag = 7;
    self.button8.tag = 8;
    
    self.editButton1.tag = 1;
    self.editButton2.tag = 2;
    self.editButton3.tag = 3;
    self.editButton4.tag = 4;
    self.editButton5.tag = 5;
    self.editButton6.tag = 6;
    self.editButton7.tag = 7;
    self.editButton8.tag = 8;
    
    self.placeholder1.tag = 1;
    self.placeholder2.tag = 2;
    self.placeholder3.tag = 3;
    self.placeholder4.tag = 4;
    self.placeholder5.tag = 5;
    self.placeholder6.tag = 6;
    self.placeholder7.tag = 7;
    self.placeholder8.tag = 8;
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
    self.placeholder5.superview.hidden = false;
    self.placeholder6.superview.hidden = false;
    self.placeholder7.superview.hidden = false;
    self.placeholder8.superview.hidden = false;
    
    self.button1.hidden = true;
    self.button2.hidden = true;
    self.button3.hidden = true;
    self.button4.hidden = true;
    self.button5.hidden = true;
    self.button6.hidden = true;
    self.button7.hidden = true;
    self.button8.hidden = true;
}



-(void)deactivateEditMode {
    
    self.button1.hidden = false;
    self.button2.hidden = false;
    self.button3.hidden = false;
    self.button4.hidden = false;
    self.button5.hidden = false;
    self.button6.hidden = false;
    self.button7.hidden = false;
    self.button8.hidden = false;
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
    } else if (tag == 5) {
        self.placeholder5.hidden = hidden;
        self.placeholder5.superview.hidden = hidden;
    } else if (tag == 6) {
        self.placeholder6.hidden = hidden;
        self.placeholder6.superview.hidden = hidden;
    } else if (tag == 7) {
        self.placeholder7.hidden = hidden;
        self.placeholder7.superview.hidden = hidden;
    } else if (tag == 8) {
        self.placeholder8.hidden = hidden;
        self.placeholder8.superview.hidden = hidden;
    }
}

@end
