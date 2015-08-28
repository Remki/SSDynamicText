//
//  SSDynamicButtonTests.m
//  SSDynamicTextExample
//
//  Created by Remigiusz Herba on 31/08/15.
//  Copyright (c) 2015 Splinesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <SSDynamicButton.h>
#import <OCMock/OCMock.h>
#import "SSDynamicsView.h"
#import "SSAttributedStringValidator.h"

static NSString * const kTestFontName = @"Avenir-Roman";
static CGFloat    const kTestFontSize = 14.f;
static CGFloat    const kTestFontSizeDifferenceForSizeEELarge = 2.f;

@interface SSDynamicButtonTests : XCTestCase

@property (nonatomic, strong) SSDynamicButton *dynamicButton;
@property (nonatomic, strong) id applicationMock;
@property (nonatomic, strong) SSDynamicButton *dynamicButtonFromXib;

@end

@implementation SSDynamicButtonTests

- (void)setUp {
    [super setUp];
    self.applicationMock = OCMPartialMock([UIApplication sharedApplication]);
    self.dynamicButton = [SSDynamicButton buttonWithFont:kTestFontName baseSize:kTestFontSize];

    SSDynamicsView *view = [[NSBundle mainBundle] loadNibNamed:@"SSDynamicsView" owner:nil options:nil].firstObject;
    self.dynamicButtonFromXib = view.button;
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
    XCTAssertEqualObjects(self.dynamicButton.titleLabel.font.fontName, kTestFontName);
    XCTAssertEqualObjects(self.dynamicButtonFromXib.titleLabel.font.fontName, kTestFontName);
    XCTAssertEqual(self.dynamicButton.titleLabel.font.pointSize, kTestFontSize);
    XCTAssertEqual(self.dynamicButtonFromXib.titleLabel.font.pointSize, kTestFontSize);
}

- (void)testContentSizeChange {
    //Arrange
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertEqual(self.dynamicButton.titleLabel.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
    XCTAssertEqual(self.dynamicButtonFromXib.titleLabel.font.pointSize, kTestFontSize + kTestFontSizeDifferenceForSizeEELarge);
}

- (void)testAttributedStringContentSizeChange {
    //Arrange
    NSAttributedString *attributedString = [SSAttributedStringValidator testAttributedString];
    [self.dynamicButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self.dynamicButtonFromXib setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self mockEELargeCategory];

    //Act
    [[NSNotificationCenter defaultCenter] postNotificationName:UIContentSizeCategoryDidChangeNotification object:nil];

    //Assert
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicButton.titleLabel.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);
    XCTAssertTrue([SSAttributedStringValidator isValidTestAttributedString:self.dynamicButtonFromXib.titleLabel.attributedText
                                                            changedByDelta:kTestFontSizeDifferenceForSizeEELarge]);
}

@end
