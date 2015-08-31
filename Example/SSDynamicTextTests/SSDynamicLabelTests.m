//
//  SSDynamicLabelTests.m
//  SSDynamicTextExample
//
//  Created by Remigiusz Herba on 31/08/15.
//  Copyright (c) 2015 Splinesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <SSDynamicLabel.h>
#import <OCMock/OCMock.h>
#import "SSDynamicsView.h"
#import "SSAttributedStringValidator.h"

static NSString * const kTestFontName = @"Avenir-Roman";
static CGFloat    const kTestFontSize = 14.f;
static CGFloat    const kTestFontSizeDifferenceForSizeEELarge = 2.f;

@interface SSDynamicLabelTests : XCTestCase

@property (nonatomic, strong) SSDynamicLabel *dynamicLabel;
@property (nonatomic, strong) id applicationMock;
@property (nonatomic, strong) SSDynamicLabel *dynamicLabelFromXib;

@end

@implementation SSDynamicLabelTests

- (void)setUp {
    [super setUp];
    self.applicationMock = OCMPartialMock([UIApplication sharedApplication]);
    self.dynamicLabel = [SSDynamicLabel labelWithFont:kTestFontName baseSize:kTestFontSize];

    SSDynamicsView *view = [[NSBundle mainBundle] loadNibNamed:@"SSDynamicsView" owner:nil options:nil].firstObject;
    self.dynamicLabelFromXib = view.label;
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
    XCTAssertEqualObjects(self.dynamicLabel.font.fontName, kTestFontName);
    XCTAssertEqualObjects(self.dynamicLabelFromXib.font.fontName, kTestFontName);
    XCTAssertEqual(self.dynamicLabel.font.pointSize, kTestFontSize);
    XCTAssertEqual(self.dynamicLabelFromXib.font.pointSize, kTestFontSize);
}

- (void)testContentSizeChange {
    //Arrange
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertEqual(self.dynamicLabel.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
    XCTAssertEqual(self.dynamicLabelFromXib.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
}

- (void)testFontChangeAndThenContentSizeChange {
    //Arrange
    CGFloat newFontSize = 7.0f;
    UIFont *newFont = [UIFont systemFontOfSize:newFontSize];
    [self mockEELargeCategory];

    //Act
    self.dynamicLabel.font = newFont;
    self.dynamicLabelFromXib.font = newFont;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertEqualObjects(self.dynamicLabel.font.fontName, newFont.fontName);
    XCTAssertEqualObjects(self.dynamicLabelFromXib.font.fontName, newFont.fontName);
    XCTAssertEqual(self.dynamicLabel.font.pointSize, newFontSize + kTestFontSizeDifferenceForSizeEELarge);
    XCTAssertEqual(self.dynamicLabelFromXib.font.pointSize, newFontSize + kTestFontSizeDifferenceForSizeEELarge);
}

- (void)testAttributedStringContentSizeChange {
    //Arrange
    NSAttributedString *attributedString = [SSAttributedStringValidator testAttributedString];
    self.dynamicLabel.attributedText = attributedString;
    self.dynamicLabelFromXib.attributedText = attributedString;
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicLabel.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicLabelFromXib.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);
}

@end
