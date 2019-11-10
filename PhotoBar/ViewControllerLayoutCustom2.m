//
//  ViewControllerLayoutCustom2.m
//  PhotoBar
//
//  Created by Lennart Reiher on 20.02.15.
//  Copyright (c) 2015 Lennart Reiher. All rights reserved.
//

#import "ViewControllerLayoutCustom2.h"
#import "UIView+AutoLayout.h"
#import "TodayViewControllerLayoutCustom2.h"
#import "HeaderViewController.h"

@interface ViewControllerLayoutCustom2 ()

@property const NSInteger statusBarHeight;
@property const NSInteger navBarHeight;
@property (nonatomic) NSUserDefaults* sharedDefaults;

@end

@implementation ViewControllerLayoutCustom2

-(void)buttonTouched:(id)sender forEvent:(UIEvent *)event {
    
    [super buttonTouched:sender forEvent:event];
}


-(void)loadView {
    
    [super loadView];
    self.pathComponent = @"layoutB_image";
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.screenName = @"Layout B";
}


-(void)setInitialValues {
    
    self.pathComponent = @"layoutB_image";
    
    self.defaultsKey = @"layoutB_needsUpdate";
    
    self.statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.segmentedControl.hidden = YES;
    self.segmentedControl.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self.sharedDefaults setBool:true forKey:@"layoutB_willAutoLayout"];
    [self.sharedDefaults synchronize];
    
}


- (void)viewDidLayoutSubviews {
    if ([self.sharedDefaults boolForKey:@"layoutB_willAutoLayout"]) {
        [self didAutolayout];
    }
    if ([self.sharedDefaults integerForKey:@"layoutB_height"]) {
        self.heightSlider.value = [self.sharedDefaults integerForKey:@"layoutB_height"];
    }
    [self heightChanged:nil];
}


-(void)didAutolayout {
    
    self.heightSlider.minimumValue = self.view.frame.size.width * 1.0 / 4.0;
    self.heightSlider.maximumValue = self.view.frame.size.width;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480) self.heightSlider.maximumValue -= 60;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) self.heightSlider.maximumValue -= 192;
    self.heightSlider.value = self.heightSlider.minimumValue + (self.heightSlider.maximumValue - self.heightSlider.minimumValue) / 2;
    
    self.imageNoSlider.minimumValue = 1;
    self.imageNoSlider.maximumValue = 5;
    
    if ([self.sharedDefaults boolForKey:@"layoutB_isReady"]) {
        
        self.heightSlider.hidden = YES;
        
        self.cropSize = CGSizeMake([self.sharedDefaults floatForKey:@"layoutB_cropSizeW"], [self.sharedDefaults floatForKey:@"layoutB_cropSizeH"]);
        self.numberOfImages = [self.sharedDefaults integerForKey:@"layoutB_count"];
        self.imageNoSlider.value = self.numberOfImages;
        self.heightSlider.value = [self.sharedDefaults integerForKey:@"layoutB_height"];;
        
        [self heightChanged:nil];
        [self imageNoChanged:nil];
        [self confirmedSize:nil];
    } else {
        [(HeaderViewController*)(self.childViewControllers[0]) activateHeightMode];
        [self.sharedDefaults setBool:(self.segmentedControl.selectedSegmentIndex == 0) forKey:@"layoutB_isHorizontal"];
        [self.sharedDefaults synchronize];
    }
    
    [self determinePlaceholderVisibility];
    
    [self.sharedDefaults setBool:false forKey:@"layoutB_willAutoLayout"];
    [self.sharedDefaults synchronize];
}


-(CGSize)getSizeOfReducedImage {
    
    CGSize destinationSize = CGSizeMake(self.cropSize.width * 2, self.cropSize.height * 2);
    
    return destinationSize;
}


-(void)activateEditMode {
    
    NSInteger limit = self.imgContainer.subviews.count;
    for (int i = 1; i < limit; i++) {
        
        UIView* placeholder = self.imgContainer.subviews[i];
        
        [placeholder.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        NSFileManager* fm = [NSFileManager defaultManager];
        NSURL* dataURL = [self.storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%d_1",self.pathComponent, i]];
        
        if ([fm fileExistsAtPath:[dataURL path]]) {
            UIView* overlay = [[UIView alloc] initWithFrame:placeholder.frame];
            overlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            [self.imgContainer addSubview:overlay];
            
            UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [overlay addSubview:moreButton];
            [moreButton autoCenterInSuperview];
            [moreButton setTitle:@"•••" forState:UIControlStateNormal];
            moreButton.titleLabel.font = [UIFont fontWithName:moreButton.titleLabel.font.fontName size:20.0];
            moreButton.tintColor = [UIColor blackColor];
            moreButton.tag = i;
            [moreButton addTarget:self action:@selector(buttonTouched:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}



-(void)deactivateEditMode {
    
    for (int i = self.numberOfImages+1.0; i < self.imgContainer.subviews.count;) {
        [self.imgContainer.subviews[i] removeFromSuperview];
    }
    [self createButtons];
}



-(void)placeholderForTag:(NSInteger)tag hidden:(BOOL)hidden {
    
    if ([self.imgContainer.subviews count] > self.numberOfImages) {
        [self.imgContainer.subviews[tag] setHidden:hidden];
    } else {
        [self.imgContainer.subviews[tag-1] setHidden:hidden];
    }
}


//++++++++++++++++++++++++ custom +++++++++++++++++++++++++++


-(void)resetLayout {
    
    [self.sharedDefaults setBool:false forKey:@"layoutB_isReady"];
    [self.sharedDefaults setBool:false forKey:[NSString stringWithFormat:@"%@_usingLastPhotos",self.pathComponent]];
    [self.sharedDefaults synchronize];
    [self removeAllPhotos:self.numberOfImages];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmedSize:(id)sender {
    
    if (self.imageNoSlider.hidden && sender != nil) {    //confirmed size
        
        [self.sharedDefaults setInteger:self.heightSlider.value forKey:@"layoutB_height"];
        [self.sharedDefaults synchronize];
        
        self.heightSlider.hidden = YES;
        self.imageNoSlider.hidden = NO;
        self.segmentedControl.hidden = NO;
        
        [self imageNoChanged:nil];
        
        [(HeaderViewController*)(self.childViewControllers[0]) activateImgNoMode];
        
    } else {                            //confirmed imgNo
        
        self.imageNoSlider.hidden = YES;
        self.segmentedControl.hidden = YES;
        self.confirmButton.hidden = YES;
        
        self.numberOfImages = self.imageNoSlider.value;
        
        [self setAdditionalValues];
        [self createButtons];
        [self createWidget];
        [(HeaderViewController*)(self.childViewControllers[0]) activateSwitchMode];
    }
}


-(void)createButtons {
    
    int i = 0, j = 1;
    if (self.imgContainer.subviews.count > self.numberOfImages) {
        i = 1;
        j = 0;
    }
    for (; i < self.imgContainer.subviews.count; i++) {
        UIButton* addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [self.imgContainer.subviews[i] addSubview:addButton];
        [addButton autoCenterInSuperview];
        addButton.tintColor = [UIColor blackColor];
        addButton.tag = (i+j);
        [self.imgContainer.subviews[i] setTag:(i+j)];
        [addButton addTarget:self action:@selector(buttonTouched:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}



-(void)requestReload {
    
    [self.sharedDefaults setBool:true forKey:self.defaultsKey];
    [self.sharedDefaults synchronize];
    [self.imgContainer setNeedsDisplay];
    
    [self.imgContainer.subviews[0] removeFromSuperview];
    [self createWidget];
}




-(void)setAdditionalValues {
    
    CGFloat height = self.heightSlider.value;
    CGFloat imgRatio;
    if ([self.sharedDefaults boolForKey:@"layoutB_isHorizontal"]) {
        imgRatio = (self.view.frame.size.width / (float)self.numberOfImages / height);
    } else {
        imgRatio = (self.view.frame.size.width * (float)self.numberOfImages / height);
    }
    [self.sharedDefaults setFloat:imgRatio forKey:@"layoutB_ratio"];
    [self.sharedDefaults synchronize];
    
    if ([self.sharedDefaults boolForKey:@"layoutB_isHorizontal"]) {
        
        if (self.view.frame.size.width / self.view.frame.size.height >= imgRatio) {
            self.cropSize = CGSizeMake(self.view.frame.size.height * imgRatio, self.view.frame.size.height);
        } else {
            self.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width / imgRatio);
        }
    } else {
        self.cropSize = CGSizeMake(self.view.frame.size.width, height / self.numberOfImages);
    }
    
    [self.sharedDefaults setInteger:self.numberOfImages forKey:@"layoutB_count"];
    [self.sharedDefaults setFloat:self.cropSize.width forKey:@"layoutB_cropSizeW"];
    [self.sharedDefaults setFloat:self.cropSize.height forKey:@"layoutB_cropSizeH"];
    
    [self.sharedDefaults setBool:true forKey:@"layoutB_isReady"];
    [self.sharedDefaults synchronize];
    
}

-(void)createWidget {
    
    TodayViewControllerLayoutCustom2* widget = [[TodayViewControllerLayoutCustom2 alloc] init];
    [self.imgContainer insertSubview:widget.view atIndex:0];
}





- (IBAction)heightChanged:(id)sender {
    
    
    NSInteger newHeight = self.heightSlider.value;
    
    CGRect frame = self.imgContainer.frame;
    
    frame.origin.y = (self.view.frame.size.height - self.navBarHeight - self.statusBarHeight) / 2 + self.navBarHeight + self.statusBarHeight - newHeight / 2;
    frame.size.height = newHeight;
    self.imgContainer.frame = frame;
    
    CGRect topFrame = self.prevContainer.frame;
    topFrame.origin.y = self.navBarHeight + self.statusBarHeight;
    topFrame.size.height = (self.view.frame.size.height - self.navBarHeight - self.statusBarHeight - frame.size.height) / 2;
    self.prevContainer.frame = topFrame;
    
    CGRect bottomFrame = self.prevBContainer.frame;
    bottomFrame.size.height = (self.view.frame.size.height - self.navBarHeight - self.statusBarHeight - frame.size.height) / 2;
    bottomFrame.origin.y = self.view.frame.size.height - bottomFrame.size.height;
    self.prevBContainer.frame = bottomFrame;
}

- (IBAction)imageNoChanged:(id)sender {
    
    [self.imgContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    NSInteger imgNo = roundf(self.imageNoSlider.value);
    
    CGRect frame = self.imgContainer.frame;
    
    for (int i = 0; i < imgNo; i++) {
        UIView* placeholder;
        if ([self.sharedDefaults boolForKey:@"layoutB_isHorizontal"]) {
            placeholder = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/imgNo*i, 0, frame.size.width/imgNo, frame.size.height)];
        } else {
            placeholder = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height/imgNo*i, frame.size.width, frame.size.height/imgNo)];
        }
        placeholder.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.35*(i%2)];
        [self.imgContainer addSubview:placeholder];
    }
}

- (IBAction)imageNoTouchUp:(id)sender {
    
    self.imageNoSlider.value = roundf(self.imageNoSlider.value);
}

- (IBAction)segmentTriggered:(id)sender {
    
    [self.sharedDefaults setBool:(self.segmentedControl.selectedSegmentIndex == 0) forKey:@"layoutB_isHorizontal"];
    [self.sharedDefaults synchronize];
    
    if (![self.sharedDefaults boolForKey:@"layoutB_isHorizontal"]) {
        self.imageNoSlider.minimumValue = 2;
        self.imageNoSlider.maximumValue = ((NSInteger)(self.heightSlider.value / 60.0) > 2) ? (NSInteger)(self.heightSlider.value / 60.0) : 2;
    } else {
        self.imageNoSlider.minimumValue = 1;
        self.imageNoSlider.maximumValue = (NSInteger)(self.view.frame.size.width / 60.0);
    }
    
    [self imageNoChanged:nil];
}

-(NSString*)getPathComponent {
    
    return self.pathComponent;
}

@end
