//
//  SSDynamicTextField.m
//  SSDynamicText
//
//  Created by Jonathan Hersh on 10/6/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDynamicText.h"
#import "NSAttributedString+SSTextSize.h"

@interface SSDynamicTextField ()

@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) CGFloat baseSize;
@property (nonatomic, copy) NSAttributedString *baseAttributedText;

- (void) setup;

@end

@implementation SSDynamicTextField

- (void)setFont:(UIFont *)font {
    [super setFont:font];

    self.fontName = self.font.fontName;
    self.baseSize = self.font.pointSize;
    self.defaultFontDescriptor = (self.font.fontDescriptor ?:
                                  [UIFontDescriptor fontDescriptorWithName:self.fontName
                                                                      size:self.baseSize]);
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.baseAttributedText = attributedText;

    [self changeAttributedStringFontWithDelta:[UIApplication sharedApplication].preferredFontSizeDelta];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setup];
}

+ (instancetype)textFieldWithFont:(NSString *)fontName baseSize:(CGFloat)size {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:fontName size:size];
    
    return [self textFieldWithFontDescriptor:fontDescriptor];
}

+ (instancetype)textFieldWithFontDescriptor:(UIFontDescriptor *)descriptor {
    SSDynamicTextField *textField = [self new];
    textField.defaultFontDescriptor = descriptor;
    
    return textField;
}

- (void)dealloc {
    [self ss_stopObservingTextSizeChanges];
}

- (void)changeFontWithDelta:(NSInteger)newDelta {
    CGFloat preferredSize = [self.defaultFontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute] floatValue];
    preferredSize += newDelta;

    [super setFont:[UIFont fontWithDescriptor:self.defaultFontDescriptor
                                         size:preferredSize]];
}

- (void)changeAttributedStringFontWithDelta:(NSInteger)newDelta {
    [super setAttributedText:[self.baseAttributedText ss_attributedStringWithAdjustedFontSizeWithDelta:newDelta]];
}

- (void)setup {
    __weak typeof (self) weakSelf = self;
    
    SSTextSizeChangedBlock changeHandler = ^(NSInteger newDelta) {

        [weakSelf changeFontWithDelta:newDelta];
        if (weakSelf.baseAttributedText.length > 0) {
            [weakSelf changeAttributedStringFontWithDelta:newDelta];
        }
    };
    
    [self ss_startObservingTextSizeChangesWithBlock:changeHandler];
}

@end
