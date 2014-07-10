//
//  SCDatePickerAppDelegate.m
//  SCDatePickerView
//
//  Created by Schubert Cardozo on 07/04/2014.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import "SCDatePickerAppDelegate.h"
#import "SCDatePickerViewController.h"

@implementation SCDatePickerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    
    SCDatePickerViewController *datePickerVC = [[SCDatePickerViewController alloc] init];
    datePickerVC.delegate = self;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:datePickerVC];

    // -- Date range which the selection must be restricted to
    datePickerVC.startDate = [NSDate date];
    datePickerVC.endDate = [NSDate dateWithTimeInterval:((24 * 60 * 60) * 152) sinceDate:[NSDate date]];
    
    // -- Pre selected dates
    datePickerVC.selectedDate = [NSDate date];
    
    // -- Continous calendar (show all months, scrolling vertically)
    // datePickerVC.continousCalendar = NO;
    
    // -- Current month offset from startDate (only applies if continousCalendar is NO)
    // datePickerVC.currentMonthOffset = 0;

    // -- Allows a range of dates to be selected (only works accross months if continousCalendar is YES)
    // datePickerVC.rangeSelection = YES;

    // -- Appearance customization
    // datePickerVC.monthHeaderHeight = 40.0f;
    // datePickerVC.headerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    // datePickerVC.dayOfWeekFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    // datePickerVC.dateFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    // datePickerVC.dateColor = [UIColor blackColor];

    [self.window setRootViewController:navigation];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIImage *)SCDatePickerViewController:(SCDatePickerViewController *)controller previousMonthImageForMonth:(int)monthOffset
{
    return [UIImage imageNamed:@"glyph-left-arrow.png"];
}

- (UIImage *)SCDatePickerViewController:(SCDatePickerViewController *)controller nextMonthImageForMonth:(int)monthOffset
{
    return [UIImage imageNamed:@"glyph-right-arrow.png"];
}

- (void)SCDatePickerViewController:(SCDatePickerViewController *)controller didSelectDate:(NSDate *)date
{
    NSLog(@"Date selected: %@", date);
}

- (void)SCDatePickerViewController:(SCDatePickerViewController *)controller didSelectDateRangeFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSLog(@"Date range selected: %@ - %@", fromDate, toDate);
}

- (UIView *)SCDatePickerViewController:(SCDatePickerViewController *)controller todayBackgroundViewForDate:(NSDate *)date
{
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
