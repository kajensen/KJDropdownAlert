//
//  KJDropdownController.m
//  KJDropdownController
//
//  Created by Kurt Jensen on 7/29/15.
//  Copyright (c) 2015 Kurt Jensen. All rights reserved.
//

#import "KJDropdownController.h"
#import "KJDropdownAlert.h"

@interface KJDropdownController () <KJDropdownAlertDelegate>

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *subTitleFont;
@property (nonatomic, strong) UIColor *textColorError;
@property (nonatomic, strong) UIColor *viewColorError;
@property (nonatomic, strong) UIColor *textColorInfo;
@property (nonatomic, strong) UIColor *viewColorInfo;
@property (nonatomic, strong) UIColor *textColorSuccess;
@property (nonatomic, strong) UIColor *viewColorSuccess;
@property (nonatomic, strong) UIColor *textColorOther;
@property (nonatomic, strong) UIColor *viewColorOther;
@property NSInteger seconds;

@property (nonatomic, strong) NSMutableArray *visibleAlerts;

@end

@implementation KJDropdownController

+ (instancetype)controller {
    static KJDropdownController *sharedStateVar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStateVar = [[self alloc] init];
    });
    return sharedStateVar;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //defaults
        self.titleFont = [UIFont systemFontOfSize:20.0f];
        self.subTitleFont = [UIFont systemFontOfSize:12.0f];
        self.textColorError = [UIColor redColor];
        self.viewColorError = [UIColor colorWithWhite:0 alpha:0.5f];
        self.textColorInfo = [UIColor blueColor];
        self.viewColorInfo = [UIColor colorWithWhite:0 alpha:0.5f];
        self.textColorSuccess = [UIColor greenColor];
        self.viewColorSuccess = [UIColor colorWithWhite:0 alpha:0.5f];
        self.textColorOther = [UIColor orangeColor];
        self.viewColorOther = [UIColor colorWithWhite:0 alpha:0.5f];
        self.seconds = 3;
    }
    return self;
}

- (NSMutableArray *)visibleAlerts {
    if (!_visibleAlerts) {
        _visibleAlerts = [NSMutableArray arrayWithObjects:[NSNull null],
                          [NSNull null],[NSNull null],[NSNull null],
                          [NSNull null],[NSNull null],[NSNull null],
                          [NSNull null],[NSNull null],[NSNull null], nil];
    }
    return _visibleAlerts;
}

- (void)setDefaultTimeInSeconds:(NSInteger)seconds {
    self.seconds = seconds;
}

- (void)setDefaultTitleFont:(UIFont *)titleFont subTitleFont:(UIFont *)subTitleFont {
    self.titleFont = titleFont;
    self.subTitleFont = subTitleFont;
}

- (void)setDefaultAlert:(KJDropdownAlertType)alertType fontColor:(UIColor *)fontColor viewColor:(UIColor *)viewColor {
    switch (alertType) {
        case KJDropdownAlertTypeError:
            self.textColorError = fontColor;
            self.viewColorError = viewColor;
            break;
        case KJDropdownAlertTypeInfo:
            self.textColorInfo = fontColor;
            self.viewColorInfo = viewColor;
            break;
        case KJDropdownAlertTypeSuccess:
            self.textColorSuccess = fontColor;
            self.viewColorSuccess = viewColor;
            break;
        case KJDropdownAlertTypeOther:
            self.textColorOther = fontColor;
            self.viewColorOther = viewColor;
            break;
        default:
            break;
    }
}

- (void)showAlert:(KJDropdownAlertType)alertType withTitle:(NSString *)title andSubTitle:(NSString *)subTitle {
    switch (alertType) {
        case KJDropdownAlertTypeError:
            [KJDropdownAlert title:title message:subTitle backgroundColor:self.viewColorError textColor:self.textColorError time:self.seconds delegate:self titleFont:self.titleFont subTitleFont:self.subTitleFont numberOfAlertsShowing:[self firstOpenSpot]];
            break;
        case KJDropdownAlertTypeInfo:
            [KJDropdownAlert title:title message:subTitle backgroundColor:self.viewColorInfo textColor:self.textColorInfo time:self.seconds delegate:self titleFont:self.titleFont subTitleFont:self.subTitleFont numberOfAlertsShowing:[self firstOpenSpot]];
            break;
        case KJDropdownAlertTypeSuccess:
            [KJDropdownAlert title:title message:subTitle backgroundColor:self.viewColorSuccess textColor:self.textColorSuccess time:self.seconds delegate:self titleFont:self.titleFont subTitleFont:self.subTitleFont numberOfAlertsShowing:[self firstOpenSpot]];
            break;
        case KJDropdownAlertTypeOther:
            [KJDropdownAlert title:title message:subTitle backgroundColor:self.viewColorOther textColor:self.textColorOther time:self.seconds delegate:self titleFont:self.titleFont subTitleFont:self.subTitleFont numberOfAlertsShowing:[self firstOpenSpot]];
            break;
        default:
            break;
    }
}

- (NSInteger)firstOpenSpot {
    for (id obj in self.visibleAlerts) {
        if ([obj isKindOfClass:[NSNull class]]) {
            return [self.visibleAlerts indexOfObject:obj];
        }
    }
    return 0;
}

- (void)willShowDropdownAlert:(KJDropdownAlert *)alert {
    if (![self.visibleAlerts containsObject:alert]) {
        [self.visibleAlerts replaceObjectAtIndex:[self firstOpenSpot] withObject:alert];
    }
}

- (void)didDismissDropdownAlert:(KJDropdownAlert *)alert {
    if ([self.visibleAlerts containsObject:alert]) {
        [self.visibleAlerts replaceObjectAtIndex:[self.visibleAlerts indexOfObject:alert] withObject:[NSNull null]];
    }
}

@end
