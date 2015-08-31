//
//  SSDynamicTextView.m
//  SSDynamicText
//
//  Created by Jonathan Hersh on 10/6/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDynamicText.h"
#import "NSAttributedString+SSTextSize.h"

@interface SSDynamicTextView ()

@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) CGFloat baseSize;
@property (nonatomic, copy) NSAttributedString *baseAttributedText;
@property (nonatomic, assign) BOOL preventFromChangingAttributedFont;

- (void) setup;

@end

@implementation SSDynamicTextView

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setupBaseFontBasedOnCurrentFont];
}

/*
 TextView in setText calls setAttributedText. 
 It was causing bug, where font size was reduced/incremented two times, preventFromChangingAttributedFont is fix for this issue.
 */
- (void)setText:(NSString *)text {
    self.preventFromChangingAttributedFont = YES;
    [super setText:text];
    self.preventFromChangingAttributedFont = NO;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.baseAttributedText = attributedText;
    NSInteger preferredFontSizeDelta = self.preventFromChangingAttributedFont ? 0 : [UIApplication sharedApplication].preferredFontSizeDelta;
    [self changeAttributedStringFontWithDelta:preferredFontSizeDelta];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setupBaseFontBasedOnCurrentFont];
    [self setup];
}

+ (instancetype)textViewWithFont:(NSString *)fontName baseSize:(CGFloat)size {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:fontName size:size];
    
    return [self textViewWithFontDescriptor:fontDescriptor];
}

+ (instancetype)textViewWithFontDescriptor:(UIFontDescriptor *)descriptor {
    SSDynamicTextView *textView = [self new];
    textView.defaultFontDescriptor = descriptor;
    
    return textView;
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

- (void)setupBaseFontBasedOnCurrentFont {
    if (self.font) {
        self.fontName = self.font.fontName;
        self.baseSize = self.font.pointSize;
    }

    self.fontName = (self.fontName ?: [self ss_defaultFontName]);
    self.baseSize = (self.baseSize ?: [self ss_defaultBaseSize]);

    self.defaultFontDescriptor = (self.font.fontDescriptor ?:
                                  [UIFontDescriptor fontDescriptorWithName:self.fontName
                                                                      size:self.baseSize]);
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
