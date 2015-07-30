//
//  KJDropdownAlert.h
//  KJDropdownAlert
//
//  Created by Richard Kim on 8/26/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//  Created by Kurt Jensen on 7/29/15.
//  Copyright (c) 2015 Kurt Jensen. All rights reserved.
//

/*
 
 Copyright (c) 2014 Choong-Won Richard Kim <cwrichardkim@gmail.com>
 Copyright (c) 2015 Kurt Jensen

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <UIKit/UIKit.h>
@class KJDropdownAlert;
extern NSString *const KJDropdownAlertDismissAllNotification;

@protocol KJDropdownAlertDelegate <NSObject>
-(void)didDismissDropdownAlert:(KJDropdownAlert*)alert;
-(void)willShowDropdownAlert:(KJDropdownAlert*)alert;
@end

@interface KJDropdownAlert : UIButton

+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds delegate:(id<KJDropdownAlertDelegate>)delegate titleFont:(UIFont *)titleFont subTitleFont:(UIFont *)subTitleFont numberOfAlertsShowing:(NSInteger)numberShowing;

+(void)dismissAllAlert;

@property BOOL isShowing;
@property id<KJDropdownAlertDelegate> delegate;


@end
