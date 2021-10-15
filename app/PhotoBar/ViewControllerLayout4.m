//
//  ViewControllerLayout5.m
//  PhotoBar
//
//  Created by Lennart Reiher on 25.09.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayout4.h"

@implementation ViewControllerLayout4

- (IBAction)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    [super buttonTouched:sender forEvent:event];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.screenName = @"Layout 4";
}



-(void)setInitialValues {
    
    self.numberOfImages = 1;
    
    self.pathComponent = @"layout4_image";
    
    self.defaultsKey = @"layout4_needsUpdate";
    
    self.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 3 / 4);
    
    [self setButtonTags];
}



-(void)setButtonTags {
    
    self.button1.tag = 1;
    
    self.editButton1.tag = 1;
    
    self.placeholder1.tag = 1;
}



-(CGSize)getSizeOfReducedImage {
    
    CGSize destinationSize;
    
    destinationSize = CGSizeMake(self.view.frame.size.height * 2, self.view.frame.size.height * 2 * 3 / 4);
    
    return destinationSize;
}



-(void)activateEditMode {
    
    self.placeholder1.superview.hidden = false;
    
    self.button1.hidden = true;
}



-(void)deactivateEditMode {
    
    self.button1.hidden = false;
}



-(void)placeholderForTag:(NSInteger)tag hidden:(BOOL)hidden {
    
    if (tag == 1) {
        self.placeholder1.hidden = hidden;
        self.placeholder1.superview.hidden = hidden;
    }
}

@end
