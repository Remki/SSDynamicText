//
//  SSDynamicTextFieldTests.m
//  SSDynamicTextExample
//
//  Created by Remigiusz Herba on 31/08/15.
//  Copyright (c) 2015 Splinesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <SSDynamicTextField.h>
#import <OCMock/OCMock.h>
#import "SSDynamicsView.h"
#import "SSAttributedStringValidator.h"

static NSString * const kTestFontName = @"Avenir-Roman";
static CGFloat    const kTestFontSize = 14.f;
static CGFloat    const kTestFontSizeDifferenceForSizeEELarge = 2.f;

@interface SSDynamicTextFieldTests : XCTestCase

@property (nonatomic, strong) SSDynamicTextField *dynamicTextField;
@property (nonatomic, strong) id applicationMock;
@property (nonatomic, strong) SSDynamicTextField *dynamicTextFieldFromXib;

@end

@implementation SSDynamicTextFieldTests

- (void)setUp {
    [super setUp];
    self.applicationMock = OCMPartialMock([UIApplication sharedApplication]);
    self.dynamicTextField = [SSDynamicTextField textFieldWithFont:kTestFontName baseSize:kTestFontSize];

    SSDynamicsView *view = [[NSBundle mainBundle] loadNibNamed:@"SSDynamicsView" owner:nil options:nil].firstObject;
    self.dynamicTextFieldFromXib = view.textField;
}

- (void)tearDown {
    [self.applicationMock stopMocking];
    [super tearDown];
}

- (void)mockEELargeCategory {
    OCMStub([self.applicationMock preferredContentSizeCategory]).andReturn(UIContentSizeCategoryExtraExtraLarge);
}

- (void)testDefaultSettings {
    //Assert
    XCTAssertEqualObjects(self.dynamicTextField.font.fontName, kTestFontName);
    XCTAssertEqualObjects(self.dynamicTextFieldFromXib.font.fontName, kTestFontName);
    XCTAssertEqual(self.dynamicTextField.font.pointSize, kTestFontSize);
    XCTAssertEqual(self.dynamicTextFieldFromXib.font.pointSize, kTestFontSize);
}

- (void)testContentSizeChange {
    //Arrange
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertEqual(self.dynamicTextField.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
    XCTAssertEqual(self.dynamicTextFieldFromXib.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
}

- (void)testFontChangeAndThenContentSizeChange {
    //Arrange
    CGFloat newFontSize = 7.0f;
    UIFont *newFont = [UIFont systemFontOfSize:newFontSize];
    [self mockEELargeCategory];

    //Act
    self.dynamicTextField.font = newFont;
    self.dynamicTextFieldFromXib.font = newFont;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertEqualObjects(self.dynamicTextField.font.fontName, newFont.fontName);
    XCTAssertEqualObjects(self.dynamicTextFieldFromXib.font.fontName, newFont.fontName);
    XCTAssertEqual(self.dynamicTextField.font.pointSize, newFontSize + kTestFontSizeDifferenceForSizeEELarge);
    XCTAssertEqual(self.dynamicTextFieldFromXib.font.pointSize, newFontSize + kTestFontSizeDifferenceForSizeEELarge);
}

- (void)testAttributedStringContentSizeChange {
    //Arrange
    NSAttributedString *attributedString = [SSAttributedStringValidator testAttributedString];
    self.dynamicTextField.dynamicAttributedText = attributedString;
    self.dynamicTextFieldFromXib.dynamicAttributedText = attributedString;
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicTextField.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicTextFieldFromXib.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);

    XCTAssertEqualObjects(attributedString, self.dynamicTextField.dynamicAttributedText);
    XCTAssertEqualObjects(attributedString, self.dynamicTextFieldFromXib.dynamicAttributedText);
}

@end
