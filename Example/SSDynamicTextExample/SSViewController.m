//
//  SSViewController.m
//  SSLabelExample
//
//  Created by Jonathan Hersh on 10/4/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSViewController.h"
#import <SSDynamicText.h>

static NSString * const kLabelText = @"This label, text field, and text view all support custom fonts and respond to changes in preferred text size.\n\nSwitch to Settings.app, change your preferred text size, then switch back here.";

@interface SSViewController ()

@property (nonatomic, strong) SSDynamicLabel *label;
@property (nonatomic, strong) SSDynamicButton *button;
@property (nonatomic, strong) SSDynamicTextField *textField;
@property (nonatomic, strong) SSDynamicTextView *textView;
@property (nonatomic, assign) BOOL isAttributedTextEnabled;

@end

@implementation SSViewController

- (void)changeTexts:(UIButton *)sender {
    if (self.isAttributedTextEnabled) {
        [self setUpNormalTexts];
    } else {
        [self setUpAttributedTexts];
    }
    self.isAttributedTextEnabled = !self.isAttributedTextEnabled;
}

- (void)setUpNormalTexts {
    _label.attributedText = nil;
    _textField.attributedText = nil;
    _textView.attributedText = nil;
    [_button setAttributedTitle:nil forState:UIControlStateNormal];

    _label.text = kLabelText;
    _textView.text = @"Text View";
    [_button setTitle:@"Change to attributed" forState:UIControlStateNormal];
}

- (void)setLabelAttributedTextWithFirstAttributes:(NSDictionary *)attributes secondAttributes:(NSDictionary *)secondAttributes {
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:kLabelText
                                                                                  attributes:attributes];
    [labelText addAttributes:secondAttributes range:[kLabelText rangeOfString:@"change your preferred text size"]];

    _label.attributedText = labelText;
}

- (void)setTextFieldAttributedTextWithFirstAttributes:(NSDictionary *)attributes secondAttributes:(NSDictionary *)secondAttributes {
    NSString *textFieldString = @"TextField support";
    NSMutableAttributedString *textFieldText = [[NSMutableAttributedString alloc] initWithString:textFieldString
                                                                                      attributes:attributes];
    [textFieldText addAttributes:secondAttributes range:[textFieldString rangeOfString:@"TextField"]];
    _textField.attributedText = textFieldText;
}

- (void)setTextViewAttributedTextWithFirstAttributes:(NSDictionary *)attributes secondAttributes:(NSDictionary *)secondAttributes {
    NSString *textViewString = @"I hope this also works for TextView";
    NSMutableAttributedString *textViewText = [[NSMutableAttributedString alloc] initWithString:textViewString
                                                                                     attributes:attributes];
    [textViewText addAttributes:secondAttributes range:[textViewString rangeOfString:@"works for TextView"]];
    _textView.attributedText = textViewText;
}

- (void)setButtonAttributedTextWithFirstAttributes:(NSDictionary *)attributes secondAttributes:(NSDictionary *)secondAttributes {
    NSString *buttonString = @"Change to normal";
    NSMutableAttributedString *buttonText = [[NSMutableAttributedString alloc] initWithString:buttonString
                                                                                   attributes:attributes];
    [buttonText addAttributes:secondAttributes range:[buttonString rangeOfString:@"normal"]];
    [_button setAttributedTitle:buttonText forState:UIControlStateNormal];
}

- (void)setUpAttributedTexts {
    _label.text = nil;
    _textField.text = nil;
    _textView.text = nil;

    NSDictionary *attributes =
    @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16.0f]};

    NSDictionary *secondAttributes =
    @{NSForegroundColorAttributeName: [UIColor blueColor], NSFontAttributeName: [UIFont fontWithName:@"Courier" size:25.0f]};

    [self setLabelAttributedTextWithFirstAttributes:attributes secondAttributes:secondAttributes];
    [self setTextFieldAttributedTextWithFirstAttributes:attributes secondAttributes:secondAttributes];
    [self setTextViewAttributedTextWithFirstAttributes:attributes secondAttributes:secondAttributes];
    [self setButtonAttributedTextWithFirstAttributes:attributes secondAttributes:secondAttributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _label = [SSDynamicLabel labelWithFont:@"Courier" baseSize:16.0f];
    _label.textColor = [UIColor darkGrayColor];
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentCenter;
    [_label setFrame:(CGRect){
        {10, 25},
        {CGRectGetWidth(self.view.frame) - 20, 220}
    }];
    
    [self.view addSubview:_label];

    _button = [SSDynamicButton buttonWithFont:@"Courier" baseSize:16.0f];
    [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor lightGrayColor];
    [_button setFrame:(CGRect){
        {10, CGRectGetMaxY(_label.frame) + 10},
        {CGRectGetWidth(self.view.frame) - 20, 44}
    }];
    [_button addTarget:self action:@selector(changeTexts:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_button];

    _textField = [SSDynamicTextField textFieldWithFont:@"Courier"
                                              baseSize:15.0f];
    _textField.textColor = [UIColor darkGrayColor];
    _textField.backgroundColor = [UIColor lightGrayColor];
    _textField.placeholder = @"Text Field";
    [_textField setFrame:(CGRect){
        {10, CGRectGetMaxY(_button.frame) + 10},
        {CGRectGetWidth(self.view.frame) - 20, 32}
    }];
    
    [self.view addSubview:_textField];
    
    _textView = [SSDynamicTextView textViewWithFont:@"Courier"
                                           baseSize:15.0f];
    _textView.textColor = [UIColor redColor];
    _textView.backgroundColor = [UIColor lightGrayColor];
    [_textView setFrame:(CGRect){
        {10, CGRectGetMaxY(_textField.frame) + 10},
        {CGRectGetWidth(self.view.frame) - 20, 100}
    }];
    
    [self.view addSubview:_textView];

    [self setUpNormalTexts];
}

@end
