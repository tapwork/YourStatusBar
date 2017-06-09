//
//  YourStatusBarTests.m
//  YourStatusBarTests
//
//  Created by Christian Menschel on 24/03/15.
//  Copyright (c) 2015 Christian Menschel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TWYourStatusBar.h"

@interface YourStatusBarTests : XCTestCase

@end

@implementation YourStatusBarTests

- (void)testStatusBarWindow {
   
    UIWindow *window = [TWYourStatusBar statusBarWindow];
    XCTAssertTrue([window isKindOfClass:[UIWindow class]]);
}

- (void)testCustomText {
    
    [TWYourStatusBar setCustomText:@"My Custom Text"];
    UILabel *label = [[[TWYourStatusBar statusBarWindow] subviews] lastObject];
    
    XCTAssertTrue([label.text isEqualToString:@"My Custom Text"]);
}

- (void)testCustomView {
    
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor redColor];
    [TWYourStatusBar setCustomView:customView];
    UIView *view = [[[TWYourStatusBar statusBarWindow] subviews] lastObject];
    
    XCTAssertTrue([view isEqual:customView]);
}

- (void)testCustomNilView {
    
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor redColor];
    [TWYourStatusBar setCustomView:customView];
    [TWYourStatusBar setCustomView:nil];
    UIView *view = [[[TWYourStatusBar statusBarWindow] subviews] lastObject];
    
    XCTAssertTrue([view isKindOfClass:[UILabel class]]);
}

@end
