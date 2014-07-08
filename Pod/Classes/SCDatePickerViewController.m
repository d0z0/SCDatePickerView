//
//  SCDatePickerViewController.m
//  SCDatePicker
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "SCDatePickerViewController.h"
#import "SCDatePickerViewCell.h"
#import "SCDatePickerViewHeader.h"
#import "SCDatePickerViewFlowLayout.h"
#define kSCDatePickerViewCellIdentifier     @"SCDatePickerViewCell"
#define SCDatePickerViewHeaderIdentifier    @"SCDatePickerViewHeader"

@interface SCDatePickerViewController ()

// private properties
@property (nonatomic, strong, readwrite) NSDate *selectedDate;
@property (nonatomic, strong, readwrite) NSDate *selectedEndDate;
@property (nonatomic, strong, readwrite) NSMutableArray *selectedIndexPaths;

@end

static NSUInteger const daysInWeek = 7;

@implementation SCDatePickerViewController

@synthesize calendar;
@synthesize startDate;
@synthesize endDate;

- (id)init
{
    //Force the creation of the view with the pre-defined Flow Layout.
    //Still possible to define a custom Flow Layout, if needed by using initWithCollectionViewLayout:
    self = [super initWithCollectionViewLayout:[[SCDatePickerViewFlowLayout alloc] init]];
    if (self) {
        // Custom initialization
        [self initData];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //Force the creation of the view with the pre-defined Flow Layout.
    //Still possible to define a custom Flow Layout, if needed by using initWithCollectionViewLayout:
    self = [super initWithCollectionViewLayout:[[SCDatePickerViewFlowLayout alloc] init]];
    if (self) {
        // Custom initialization
        [self initData];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    //Force the creation of the view with the pre-defined Flow Layout.
    //Still possible to define a custom Flow Layout, if needed by using initWithCollectionViewLayout:
    self = [super initWithCollectionViewLayout:[[SCDatePickerViewFlowLayout alloc] init]];
    if (self) {
        // Custom initialization
        [self initData];
    }
    
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self initData];
    }
    
    return self;
}

- (void)initData
{
    self.calendar = [NSCalendar currentCalendar];
    
    if(!self.monthHeaderHeight)
        self.monthHeaderHeight = 40.0f;
    
    if(!self.currentMonthOffset)
        self.currentMonthOffset = 0;
    
    if(!self.headerFont)
        self.headerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];

    if(!self.dayOfWeekFont)
        self.dayOfWeekFont = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];

    if(!self.dateFont)
        self.dateFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
//        self.dateFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    
    if(!self.dateColor)
        self.dateColor = [UIColor blackColor];

    if(!self.selectedDateColor)
        self.selectedDateColor = [UIColor blackColor];

    self.dateFormatter.calendar = self.calendar;
    if(!self.dateFormatter)
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"d";
    }
    
    if(!self.monthYearFormatter)
    {
        self.monthYearFormatter = [[NSDateFormatter alloc] init];
        self.monthYearFormatter.calendar = self.calendar;
        self.monthYearFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyyLLLL" options:0 locale:self.calendar.locale];
    }

    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day = 0;
    if(!self.startDate)
        self.startDate = [self.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    offsetComponents.day = -1;
    offsetComponents.year = 1;
    
    if(!self.endDate)
        self.endDate = [self.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    NSLog(@"Drawing calendar from %@ to %@", self.startDate, self.endDate);
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[SCDatePickerViewCell class] forCellWithReuseIdentifier:kSCDatePickerViewCellIdentifier];
    [self.collectionView registerClass:[SCDatePickerViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SCDatePickerViewHeaderIdentifier];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        SCDatePickerViewHeader *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SCDatePickerViewHeaderIdentifier forIndexPath:indexPath];
        
        [headerView.topLineView setFrame:CGRectMake(0.0f, 0.0f, self.collectionView.bounds.size.width, 1.0f)];
        [headerView.bottomLineView setFrame:CGRectMake(0.0f, self.monthHeaderHeight - 1.0f, self.collectionView.bounds.size.width, 1.0f)];

        NSDate *firstDateOfMonth = [self firstDateOfMonthForSection:indexPath.section];

        [headerView.monthYearLabel setFrame:CGRectMake(self.monthHeaderHeight, 0.0f, self.collectionView.bounds.size.width - (self.monthHeaderHeight * 2), self.monthHeaderHeight)];
        headerView.monthYearLabel.text = [self.monthYearFormatter stringFromDate:firstDateOfMonth];

        headerView.monthYearLabel.font = self.headerFont;
        
        headerView.previousMonthBtn.titleLabel.font = self.headerFont;
        headerView.nextMonthBtn.titleLabel.font = self.headerFont;

        NSDateComponents *offset = [[NSDateComponents alloc] init];
        offset.day = -1;
        NSDate *lastDateOfPrevMonth = [self.calendar dateByAddingComponents:offset toDate:firstDateOfMonth options:0];
        offset.day = 0;
        offset.month = 1;
        NSDate *firstDateOfNextMonth = [self.calendar dateByAddingComponents:offset toDate:firstDateOfMonth options:0];

        if([self compareDate:self.startDate withDate:lastDateOfPrevMonth] == NSOrderedDescending)
        {
            [headerView.previousMonthBtn setEnabled:NO];
        }
        else
        {
            [headerView.previousMonthBtn setEnabled:YES];
        }

        if([self compareDate:self.endDate withDate:firstDateOfNextMonth] == NSOrderedAscending)
        {
            [headerView.nextMonthBtn setEnabled:NO];
        }
        else
        {
            [headerView.nextMonthBtn setEnabled:YES];
        }

        if(!self.continousCalendar)
        {
            [headerView.previousMonthBtn setFrame:CGRectMake(0.0f, 0.0f, self.monthHeaderHeight, self.monthHeaderHeight)];
            [headerView.previousMonthBtn addTarget:self action:@selector(previousMonth) forControlEvents:
             UIControlEventTouchUpInside];
            [headerView.previousMonthBtn setHidden:NO];

            [headerView.nextMonthBtn setFrame:CGRectMake(self.collectionView.bounds.size.width - self.monthHeaderHeight, 0.0f, self.monthHeaderHeight, self.monthHeaderHeight)];
            [headerView.nextMonthBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
            [headerView.nextMonthBtn setHidden:NO];
        }
        else
        {
            [headerView.previousMonthBtn setHidden:YES];
            [headerView.previousMonthBtn setHidden:YES];
        }

        NSArray *dow = @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
        [headerView.daysOfWeekView setFrame:CGRectMake(0.0f, self.monthHeaderHeight, self.collectionView.bounds.size.width, 20.0f)];
        CGFloat dayWidth = self.collectionView.bounds.size.width / daysInWeek;
        for(int i = 0; i < 7; i ++)
        {
            UILabel *dayLabel = [[headerView.daysOfWeekView subviews] objectAtIndex:i];
            [dayLabel setFrame:CGRectMake(i * dayWidth, 0.0f, dayWidth, 20.0f)];
            dayLabel.text = [dow objectAtIndex:i];
            dayLabel.font = self.dayOfWeekFont;
        }

        return headerView;
        
    }
    return nil;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320.0f, self.monthHeaderHeight + 20.0f);
}

- (void)previousMonth
{
    self.currentMonthOffset -= 1;
    [self.collectionView reloadData];
}


- (void)nextMonth
{
    self.currentMonthOffset += 1;
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = self.collectionView.bounds.size.width / daysInWeek;
    return CGSizeMake(itemWidth, itemWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (NSDate *)startDateMonth
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.startDate];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)endDateMonth
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.endDate];
    components.month += 1;
    components.day = 0;
    return [self.calendar dateFromComponents:components];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(!self.continousCalendar)
        return 1;
    else
        return [self.calendar components:NSMonthCalendarUnit fromDate:[self startDateMonth] toDate:[self endDateMonth] options:0].month + 1;
}

- (NSDate *)firstDateOfMonthForSection:(NSInteger)section
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    if(!self.continousCalendar)
        offsetComponents.month = self.currentMonthOffset;
    else
        offsetComponents.month = section;
    return [self.calendar dateByAddingComponents:offsetComponents toDate:[self startDateMonth] options:0];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSRange weeksInMonth = [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:[self firstDateOfMonthForSection:section]];
    return (weeksInMonth.length * daysInWeek);
}

- (NSDate *)firstOfStartDate
{
    NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.startDate];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)dateForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *cellOffset = [[NSDateComponents alloc] init];
    
    if(!self.continousCalendar)
        cellOffset.month = self.currentMonthOffset;
    else
        cellOffset.month = indexPath.section;
    
    NSUInteger weekOffset = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[self firstDateOfMonthForSection:cellOffset.month]];
    cellOffset.day = indexPath.item + ((weekOffset - 1) * -1);
    return [self.calendar dateByAddingComponents:cellOffset toDate:[self firstOfStartDate] options:0];
}

- (NSArray *)indexPathsBetween:(NSIndexPath *)fromIndexPath and:(NSIndexPath *)toIndexPath
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    if([fromIndexPath section] == [toIndexPath section])
    {
        NSUInteger s = [fromIndexPath section];
        for(NSUInteger i = [fromIndexPath row]; i <= [toIndexPath row] ; i ++)
        {
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:s]];
        }
    }
    else
    {
        for(NSUInteger s = [fromIndexPath section]; s <= [toIndexPath section]; s ++)
        {
            NSUInteger rmin;
            NSUInteger rmax;
            if(s == [fromIndexPath section])
            {
                rmin = [fromIndexPath row];
                rmax = [self.collectionView numberOfItemsInSection:s];
            }
            else if(s == [toIndexPath section])
            {
                rmin = 0;
                rmax = [toIndexPath row];
            }
            else
            {
                rmin = 0;
                rmax = [self.collectionView numberOfItemsInSection:s];
            }
            for(NSUInteger i = rmin; i <= rmax ; i ++)
            {
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:s]];
            }
        }
    }
    return indexPaths;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.collectionView indexPathsForSelectedItems] count] == 1)
    {
        self.selectedDate = [self dateForItemAtIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(SCDatePickerViewController:didSelectDate:)])
        {
            [self.delegate SCDatePickerViewController:self didSelectDate:self.selectedDate];
        }
    }
    else if([[self.collectionView indexPathsForSelectedItems] count] == 2)
    {
        self.selectedEndDate = [self dateForItemAtIndexPath:indexPath];

        NSArray *sortedIndexPathsForSelectedItems = [[self.collectionView indexPathsForSelectedItems] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        for(NSIndexPath *i in [self indexPathsBetween:[sortedIndexPathsForSelectedItems objectAtIndex:0] and:[sortedIndexPathsForSelectedItems objectAtIndex:1]])
        {
            if([self.collectionView cellForItemAtIndexPath:i] == nil) // not sure what to do.. may be check if date for cells month belongs to section
            {
                NSDateComponents *firstOfMonthComponents = [self.calendar components:NSMonthCalendarUnit fromDate:[self firstDateOfMonthForSection:i.section]];
                NSDateComponents *dateComponents = [self.calendar components:NSMonthCalendarUnit fromDate:[self dateForItemAtIndexPath:i]];
                if([firstOfMonthComponents month] == [dateComponents month])
                    [self.collectionView selectItemAtIndexPath:i animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
            else if([self.collectionView cellForItemAtIndexPath:i].tag != 0)
                [self.collectionView selectItemAtIndexPath:i animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        if ([self.delegate respondsToSelector:@selector(SCDatePickerViewController:didSelectDateRangeFrom:to:)])
        {
            [self.delegate SCDatePickerViewController:self didSelectDateRangeFrom:self.selectedDate to:self.selectedEndDate];
        }
        
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.collectionView cellForItemAtIndexPath:indexPath].tag == 0)
    {
        [self.collectionView reloadData];
        return NO;
    }
    
    if([[self.collectionView indexPathsForSelectedItems] count] == 0)
    {
        if(self.rangeSelection == YES)
        {
            self.collectionView.allowsMultipleSelection = YES;
        }
        return YES;
    }
    else if([[self.collectionView indexPathsForSelectedItems] count] == 1 && self.rangeSelection == YES)
    {
        return YES;
    }
    else
    {
        if(self.rangeSelection == YES)
        {
            [self.collectionView reloadData];
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCDatePickerViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kSCDatePickerViewCellIdentifier forIndexPath:indexPath];
    NSDate *cellDate = [self dateForItemAtIndexPath:indexPath];

    NSDateComponents *cellDateComponents = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:cellDate];
    cell.dateLabel.text = [self.dateFormatter stringFromDate:cellDate];
    cell.dateLabel.font = self.dateFont;
    
    if(cell.selected)
        cell.dateLabel.textColor = self.selectedDateColor;
    else
        cell.dateLabel.textColor = self.dateColor;

    if ([self.delegate respondsToSelector:@selector(SCDatePickerViewController:selectedBackgroundViewForDate:)])
    {
        cell.selectedBackgroundView = [self.delegate SCDatePickerViewController:self selectedBackgroundViewForDate:cellDate];
    }
    else
    {
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        //selectedBackgroundView.layer.cornerRadius = cell.contentView.frame.size.width/2;
//        selectedBackgroundView.layer.borderColor = [UIColor grayColor].CGColor;
//        selectedBackgroundView.layer.borderWidth = 1.0f;
        cell.selectedBackgroundView = selectedBackgroundView;
    }

    NSDateComponents *firstOfMonthComponents = [self.calendar components:NSMonthCalendarUnit fromDate:[self firstDateOfMonthForSection:indexPath.section]];

    if(cellDateComponents.month == firstOfMonthComponents.month && ([self compareDate:cellDate withDate:self.startDate] != NSOrderedAscending && [self compareDate:cellDate withDate:self.endDate] != NSOrderedDescending))
    {
        // enabled cells
        cell.tag = cellDateComponents.day;
        cell.dateLabel.textColor = [UIColor blackColor];
        
        // today view (only for enabled cells obviously)
        if([self compareDate:cellDate withDate:[NSDate date]] == NSOrderedSame)
        {
            if ([self.delegate respondsToSelector:@selector(SCDatePickerViewController:todayBackgroundViewForDate:)])
            {
                cell.todayBackgroundView = [self.delegate SCDatePickerViewController:self todayBackgroundViewForDate:cellDate];
            }
            cell.todayBackgroundView.hidden = NO;
        }
        else
        {
            cell.todayBackgroundView.hidden = YES;
        }
        

    }
    else
    {
        // disabled cells
        cell.tag = 0;
        cell.dateLabel.textColor = [UIColor lightGrayColor];
    }
    
    
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

- (int)compareDate:(NSDate *)firstDate withDate:(NSDate *)secondDate
{
    NSDateComponents *firstComponents = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:firstDate];
    NSDateComponents *secondComponents = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:secondDate];
    
    return [[self.calendar dateFromComponents:firstComponents] compare:[self.calendar dateFromComponents:secondComponents]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //[self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
