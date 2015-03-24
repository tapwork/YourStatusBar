//
//  TWCustomStatusBar.h
//  YourStatusBar
//
//  Created by Christian Menschel on 24/03/15.
//  Copyright (c) 2015 Christian Menschel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWCustomStatusBar : NSObject

+ (void)setCustomText:(NSString*)text;
+ (UIWindow*)statusBarWindow;
+ (void)setCustomView:(UIView*)customView;

@end
