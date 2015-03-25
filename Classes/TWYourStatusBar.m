//
//  YourStatusBar
//
//  Created by Christian Menschel on 24/03/15.
//  Copyright (c) 2015 Christian Menschel. All rights reserved.
//

#import "TWYourStatusBar.h"

static UIWindow *kStatusBarWindow = nil;
static UIView *kCustomView = nil;
static UILabel *kTextLabel = nil;

@implementation TWYourStatusBar

+ (void)initialize
{
    if (self == [TWYourStatusBar class]) {
        [self retrieveStatusBarWindow];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:11];
        CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
        label.frame = CGRectMake(0, 0, size.width, size.height);
        [kStatusBarWindow addSubview:label];
        kTextLabel = label;
    }
}

+ (void)setCustomView:(UIView *)customView
{
    if (!kStatusBarWindow) {
        [self retrieveStatusBarWindow];
    }
    if (![kCustomView isEqual:customView]) {
        if (customView) {
            [kTextLabel removeFromSuperview];
            [kStatusBarWindow addSubview:customView];
        } else {
            [kStatusBarWindow addSubview:kTextLabel];
            [kCustomView removeFromSuperview];
        }
        kCustomView = customView;
    }
}

+ (void)setCustomText:(NSString*)text;
{
    if (!kStatusBarWindow) {
        [self retrieveStatusBarWindow];
    }
    kTextLabel.text = text;
}

+ (UIWindow*)statusBarWindow
{
    return kStatusBarWindow;
}

#pragma mark - internal class methods

+ (void)retrieveStatusBarWindow
{
    NSString *statusBarString = [NSString stringWithFormat:@"_statusBarWindow"];
    UIWindow *window = [[UIApplication sharedApplication] valueForKey:statusBarString];
    if ([window respondsToSelector:@selector(subviews)]) {
        [[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    kStatusBarWindow = window;
}

@end