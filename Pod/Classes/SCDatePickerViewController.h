//
//  SCDatePickerViewController.h
//  SCDatePicker
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@protocol SCDatePickerViewDelegate;

@interface SCDatePickerViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong, readonly) NSDate *selectedDate;
@property (nonatomic, strong, readonly) NSDate *selectedEndDate;
@property (nonatomic, strong, readonly) NSMutableArray *selectedIndexPaths;

@property (nonatomic, weak) id<SCDatePickerViewDelegate> delegate;

// customization properties
@property (nonatomic, assign) float monthHeaderHeight;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) int currentMonthOffset;
@property (nonatomic, assign) BOOL continousCalendar;
@property (nonatomic, strong) UIFont *headerFont;
@property (nonatomic, strong) UIFont *dayOfWeekFont;
@property (nonatomic, strong) UIFont *dateFont;
@property (nonatomic, strong) UIColor *dateColor;
@property (nonatomic, strong) UIColor *selectedDateColor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *monthYearFormatter;
@property (nonatomic, assign) BOOL rangeSelection;


@end

@protocol SCDatePickerViewDelegate <NSObject>

@optional
- (void)SCDatePickerViewController:(SCDatePickerViewController *)controller didSelectDate:(NSDate *)date;
- (void)SCDatePickerViewController:(SCDatePickerViewController *)controller didSelectDateRangeFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (UIView *)SCDatePickerViewController:(SCDatePickerViewController *)controller selectedBackgroundViewForDate:(NSDate *)date;
- (UIView *)SCDatePickerViewController:(SCDatePickerViewController *)controller todayBackgroundViewForDate:(NSDate *)date;

@end