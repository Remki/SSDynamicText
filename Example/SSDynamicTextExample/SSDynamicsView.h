//
//  SSDynamicsView.h
//  SSDynamicTextExample
//
//  Created by Remigiusz Herba on 31/08/15.
//  Copyright (c) 2015 Splinesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSDynamicText.h>

@interface SSDynamicsView : UIView

@property (weak, nonatomic) IBOutlet SSDynamicLabel *label;
@property (weak, nonatomic) IBOutlet SSDynamicTextField *textField;
@property (weak, nonatomic) IBOutlet SSDynamicTextView *textView;
@property (weak, nonatomic) IBOutlet SSDynamicButton *button;

@end
