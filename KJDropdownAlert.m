//
//  KJDropdownAlert.m
//  KJDropdownAlert
//
//  Created by Richard Kim on 8/26/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//  Created by Kurt Jensen on 7/29/15.
//  Copyright (c) 2015 Kurt Jensen. All rights reserved.
//

#import "KJDropdownAlert.h"

NSString *const KJDropdownAlertDismissAllNotification = @"KJDropdownAlertDismissAllNotification";

static int HEIGHT = 90; //height of the alert view
static float ANIMATION_TIME = .3; //time it takes for the animation to complete in seconds
static int X_BUFFER = 10; //buffer distance on each side for the text
static int Y_BUFFER = 10; //buffer distance on top/bottom for the text
static int STATUS_BAR_HEIGHT = 20;

@implementation KJDropdownAlert{
    UILabel *titleLabel;
    UILabel *messageLabel;
}

- (id)initWithFrame:(CGRect)frame titleFont:(UIFont *)titleFont subTitleFont:(UIFont *)subTitleFont
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //%%% title setup (the bolded text at the top of the view)
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(X_BUFFER, STATUS_BAR_HEIGHT, frame.size.width-2*X_BUFFER, 30)];
        [titleLabel setFont:titleFont];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //%%% message setup (the regular text below the title)
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(X_BUFFER, STATUS_BAR_HEIGHT +Y_BUFFER*2.3, frame.size.width-2*X_BUFFER, 40)];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.font = subTitleFont;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.numberOfLines = 2; // 2 lines ; 0 - dynamic number of lines
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
        
        [self addTarget:self action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissAlertView)
                                                     name:KJDropdownAlertDismissAllNotification
                                                   object:nil];
        self.isShowing = NO;

    }
    return self;
}

- (void)dismissAlertView {
    [self hideView:self];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KJDropdownAlertDismissAllNotification
                                                  object:nil];
}

//%%% button method (what happens when you touch the drop down view)
-(void)viewWasTapped:(UIButton *)alertView
{
    [self hideView:alertView];
}

-(void)hideView:(UIButton *)alertView
{
    if (alertView) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            CGRect frame = alertView.frame;
            frame.origin.y = -HEIGHT;
            alertView.frame = frame;
        }];
        [self performSelector:@selector(removeView:) withObject:alertView afterDelay:ANIMATION_TIME];
    }
}

-(void)removeView:(KJDropdownAlert *)alertView
{
    if (alertView){
        [alertView removeFromSuperview];
        self.isShowing = NO;
        if (self.delegate){
            [self.delegate didDismissDropdownAlert:alertView];
        }
    }
}

#pragma mark IGNORE THESE

//%%% these are necessary methods that call each other depending on which method you call. Generally shouldn't edit these unless you know what you're doing

+(KJDropdownAlert*)alertViewWithDelegate:(id<KJDropdownAlertDelegate>)delegate numberOfAlertsShowing:(NSInteger)numberShowing titleFont:(UIFont *)titleFont subTitleFont:(UIFont *)subTitleFont
{
    KJDropdownAlert *alert = [[self alloc]initWithFrame:CGRectMake(0, (HEIGHT*numberShowing)-HEIGHT, [[UIScreen mainScreen]bounds].size.width, HEIGHT) titleFont:titleFont subTitleFont:subTitleFont];
    alert.delegate = delegate;
    return alert;
}

/* reserved */
+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds delegate:(id<KJDropdownAlertDelegate>)delegate titleFont:(UIFont *)titleFont subTitleFont:(UIFont *)subTitleFont numberOfAlertsShowing:(NSInteger)numberShowing
{
    [[self alertViewWithDelegate:delegate numberOfAlertsShowing:numberShowing titleFont:titleFont subTitleFont:subTitleFont] title:title message:message backgroundColor:backgroundColor textColor:textColor time:seconds numberShowing:numberShowing];
}

+(void)dismissAllAlert{
    [[NSNotificationCenter defaultCenter] postNotificationName:KJDropdownAlertDismissAllNotification object:nil];
}

-(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds numberShowing:(NSInteger)numberShowing
{
    NSInteger time = seconds;
    titleLabel.text = title;
    
    if (message && message.length > 0) {
        messageLabel.text = message;
        if ([self messageTextIsOneLine]) {
            CGRect frame = titleLabel.frame;
            frame.origin.y = STATUS_BAR_HEIGHT+5;
            titleLabel.frame = frame;
        }
    } else {
        CGRect frame = titleLabel.frame;
        frame.size.height = HEIGHT-2*Y_BUFFER-STATUS_BAR_HEIGHT;
        frame.origin.y = Y_BUFFER+STATUS_BAR_HEIGHT;
        titleLabel.frame = frame;
    }
    
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
    if (textColor) {
        titleLabel.textColor = textColor;
        messageLabel.textColor = textColor;
    }
    
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal && !window.hidden) {
                [window addSubview:self];
                break;
            }
    }
    
    self.isShowing = YES;
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        CGRect frame = self.frame;
        frame.origin.y = HEIGHT*numberShowing;
        self.frame = frame;
    }];
    if (self.delegate) {
        [self.delegate willShowDropdownAlert:self];
    }
    [self performSelector:@selector(viewWasTapped:) withObject:self afterDelay:time+ANIMATION_TIME];
}




-(BOOL)messageTextIsOneLine
{
    CGSize size = [messageLabel.text sizeWithAttributes:
                   @{NSFontAttributeName:
                         messageLabel.font}];
    if (size.width > messageLabel.frame.size.width) {
        return NO;
    }
    
    return YES;
}

@end
