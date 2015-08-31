//
//  SSTextViewTests.m
//  SSDynamicTextExample
//
//  Created by Remigiusz Herba on 31/08/15.
//  Copyright (c) 2015 Splinesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <SSDynamicTextView.h>
#import <OCMock/OCMock.h>
#import "SSDynamicsView.h"
#import "SSAttributedStringValidator.h"

static NSString * const kTestFontName = @"Avenir-Roman";
static CGFloat    const kTestFontSize = 14.f;
static CGFloat    const kTestFontSizeDifferenceForSizeEELarge = 2.f;

@interface SSTextViewTests : XCTestCase

@property (nonatomic, strong) SSDynamicTextView *dynamicTextView;
@property (nonatomic, strong) id applicationMock;
@property (nonatomic, strong) SSDynamicTextView *dynamicTextViewFromXib;

@end

@implementation SSTextViewTests

- (void)setUp {
    [super setUp];
    self.applicationMock = OCMPartialMock([UIApplication sharedApplication]);
    self.dynamicTextView = [SSDynamicTextView textViewWithFont:kTestFontName baseSize:kTestFontSize];

    SSDynamicsView *view = [[NSBundle mainBundle] loadNibNamed:@"SSDynamicsView" owner:nil options:nil].firstObject;
    self.dynamicTextViewFromXib = view.textView;
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
    XCTAssertEqualObjects(self.dynamicTextView.font.fontName, kTestFontName);
    XCTAssertEqualObjects(self.dynamicTextViewFromXib.font.fontName, kTestFontName);
    XCTAssertEqual(self.dynamicTextView.font.pointSize, kTestFontSize);
    XCTAssertEqual(self.dynamicTextViewFromXib.font.pointSize, kTestFontSize);
}

- (void)testContentSizeChange {
    //Arrange
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertEqual(self.dynamicTextView.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
    XCTAssertEqual(self.dynamicTextViewFromXib.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
}

- (void)testFontChangeAndThenContentSizeChange {
    //Arrange
    CGFloat newFontSize = 7.0f;
    UIFont *newFont = [UIFont systemFontOfSize:newFontSize];
    [self mockEELargeCategory];

    //Act
    self.dynamicTextView.font = newFont;
    self.dynamicTextViewFromXib.font = newFont;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertEqualObjects(self.dynamicTextView.font.fontName, newFont.fontName);
    XCTAssertEqualObjects(self.dynamicTextViewFromXib.font.fontName, newFont.fontName);
    XCTAssertEqual(self.dynamicTextView.font.pointSize, newFontSize + kTestFontSizeDifferenceForSizeEELarge);
    XCTAssertEqual(self.dynamicTextViewFromXib.font.pointSize, newFontSize + kTestFontSizeDifferenceForSizeEELarge);
}

- (void)testAttributedStringContentSizeChange {
    //Arrange
    NSAttributedString *attributedString = [SSAttributedStringValidator testAttributedString];
    self.dynamicTextView.attributedText = attributedString;
    self.dynamicTextViewFromXib.attributedText = attributedString;
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicTextView.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicTextViewFromXib.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);
}

@end
