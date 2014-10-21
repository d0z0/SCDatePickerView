//
//  SCDatePickerView.m
//  SCDatePickerViewDemo
//
//  Created by Schubert Cardozo on 18/07/14.
//  Copyright (c) 2014 Schubert. All rights reserved.
//

#import "SCDatePickerView.h"

#define kSCDatePickerViewCellIdentifier     @"SCDatePickerViewCell"
#define SCDatePickerViewHeaderIdentifier    @"SCDatePickerViewHeader"

@interface SCDatePickerView ()
{
    NSCalendar *calendar;
    CGFloat defaultMonthHeaderHeight;
    UICollectionView *calendarCollectionView;
}

@end

@implementation SCDatePickerView

- (id)initWithFrame:(CGRect)frame style:(SCDatePickerVieWStyle)style
{
    self = [super initWithFrame:frame];
    if(self) {
        self.style = style;
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
        
    }
    return self;
}

- (BOOL)isContinousCalendar {
    return (self.style == SCDatePickerViewStyleContinous || self.style == SCDatePickerViewStyleContinousWithRangeSelection);
}

- (BOOL)isRangeSelection {
    return (self.style == SCDatePickerViewStyleContinousWithRangeSelection);
}

- (void)setupDefaults
{
    calendar = [NSCalendar currentCalendar];
    
    defaultMonthHeaderHeight = 40.0f;
    
    if(!self.currentMonthOffset)
        self.currentMonthOffset = 0;
    
    if(!self.headerFont)
        self.headerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    
    if(!self.dayOfWeekFont)
        self.dayOfWeekFont = [UIFont fontWithName:@"HelveticaNeue" size:10.0f];
    
    if(!self.dateFont)
        self.dateFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    
    if(!self.selectedDateFont)
        self.selectedDateFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f];

    self.dateFormatter.calendar = calendar;
    if(!self.dateFormatter)
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"d";
    }
    
    if(!self.monthYearFormatter)
    {
        self.monthYearFormatter = [[NSDateFormatter alloc] init];
        self.monthYearFormatter.calendar = calendar;
        self.monthYearFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyyLLLL" options:0 locale:calendar.locale];
    }
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day = 0;
    
    if(!self.startDate)
        self.startDate = [calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    
    offsetComponents.day = -1;
    offsetComponents.year = 1;
    
    if(!self.endDate)
        self.endDate = [calendar dateByAddingComponents:offsetComponents toDate:self.startDate options:0];
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    if([self date:selectedDate isBetween:self.startDate and:self.endDate])
    {
        _selectedDate = [calendar dateFromComponents:[calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:selectedDate]];
    }
    if(_selectedDate) {
        if([self isContinousCalendar]) {
            [calendarCollectionView scrollToItemAtIndexPath:[self indexPathForDate:_selectedDate] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        }
        else
        {
            // FIX ME -- move to offset
        }
    }
}

- (void)setSelectedEndDate:(NSDate *)selectedEndDate
{
    if([self date:selectedEndDate isBetween:self.startDate and:self.endDate])
    {
        _selectedEndDate = [calendar dateFromComponents:[calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:selectedEndDate]];
    }
}

- (void)setup
{
    [self setupDefaults];
    
    SCDatePickerViewFlowLayout *flowLayout = [[SCDatePickerViewFlowLayout alloc] init];
    
    CGRect componentFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    calendarCollectionView = [[UICollectionView alloc] initWithFrame:componentFrame collectionViewLayout:flowLayout];
    
    [calendarCollectionView registerClass:[SCDatePickerViewCell class] forCellWithReuseIdentifier:kSCDatePickerViewCellIdentifier];
    [calendarCollectionView registerClass:[SCDatePickerViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SCDatePickerViewHeaderIdentifier];
    
    calendarCollectionView.delegate = self;
    calendarCollectionView.dataSource = self;
    calendarCollectionView.showsHorizontalScrollIndicator = NO;
    calendarCollectionView.showsVerticalScrollIndicator = YES;
    calendarCollectionView.backgroundColor = [UIColor whiteColor];
    
    calendarCollectionView.bounces = YES;
    calendarCollectionView.allowsMultipleSelection = YES; //[self isRangeSelection]; //cont
    
    [self addSubview:calendarCollectionView];
}

- (void)layoutSubviews {
    [calendarCollectionView setFrame:self.bounds];
    // FIXME -- this method is getting called twice, need to check why
    if(self.style != SCDatePickerViewStylePaginated)
        [calendarCollectionView scrollToItemAtIndexPath:[self indexPathForDate:self.selectedDate] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader) {
        SCDatePickerViewHeader *headerView = [calendarCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SCDatePickerViewHeaderIdentifier forIndexPath:indexPath];
        
        [headerView.topLineView setFrame:CGRectMake(0.0f, 0.0f, calendarCollectionView.bounds.size.width, 1.0f)];
        [headerView.bottomLineView setFrame:CGRectMake(0.0f, defaultMonthHeaderHeight - 1.0f, calendarCollectionView.bounds.size.width, 1.0f)];
        
        NSDate *firstDateOfMonth = [self firstDateOfMonthForSection:indexPath.section];
        
        [headerView.monthYearLabel setFrame:CGRectMake(defaultMonthHeaderHeight, 0.0f, calendarCollectionView.bounds.size.width - (defaultMonthHeaderHeight * 2), defaultMonthHeaderHeight)];
        headerView.monthYearLabel.text = [self.monthYearFormatter stringFromDate:firstDateOfMonth];
        
        headerView.monthYearLabel.font = self.headerFont;
        
        headerView.previousMonthBtn.titleLabel.font = self.headerFont;
        headerView.nextMonthBtn.titleLabel.font = self.headerFont;
        
        
        // previous month button
        if([self.delegate respondsToSelector:@selector(previousMonthImageForDatePickerView:)])
        {
            [headerView.previousMonthImage setImage:[self.delegate previousMonthImageForDatePickerView:self]];
            [headerView.previousMonthImage setContentMode:UIViewContentModeCenter];
            [headerView.previousMonthBtn setTitle:@"" forState:UIControlStateNormal];
        }
        else
        {
            [headerView.previousMonthImage setImage:nil];
            [headerView.previousMonthBtn setTitle:@"<" forState:UIControlStateNormal];
        }
        
        // next month button
        if([self.delegate respondsToSelector:@selector(nextMonthImageForDatePickerView:)])
        {
            [headerView.nextMonthImage setImage:[self.delegate nextMonthImageForDatePickerView:self]];
            [headerView.nextMonthImage setContentMode:UIViewContentModeCenter];
            [headerView.nextMonthBtn setTitle:@"" forState:UIControlStateNormal];
        }
        else
        {
            [headerView.nextMonthImage setImage:nil];
            [headerView.nextMonthBtn setTitle:@">" forState:UIControlStateNormal];
        }
        
        
        NSDateComponents *offset = [[NSDateComponents alloc] init];
        offset.day = -1;
        NSDate *lastDateOfPrevMonth = [calendar dateByAddingComponents:offset toDate:firstDateOfMonth options:0];
        offset.day = 0;
        offset.month = 1;
        NSDate *firstDateOfNextMonth = [calendar dateByAddingComponents:offset toDate:firstDateOfMonth options:0];
        
        if([self compareDate:self.startDate withDate:lastDateOfPrevMonth] == NSOrderedDescending)
        {
            [headerView.previousMonthBtn setEnabled:NO];
            [headerView.previousMonthImage setAlpha:0.25f];
        }
        else
        {
            [headerView.previousMonthBtn setEnabled:YES];
            [headerView.previousMonthImage setAlpha:1.0f];
            
        }
        
        if([self compareDate:self.endDate withDate:firstDateOfNextMonth] == NSOrderedAscending)
        {
            [headerView.nextMonthBtn setEnabled:NO];
            [headerView.nextMonthImage setAlpha:0.25f];
        }
        else
        {
            [headerView.nextMonthBtn setEnabled:YES];
            [headerView.nextMonthImage setAlpha:1.0f];
            
        }
        
        if(![self isContinousCalendar])
        {
            [headerView.previousMonthImage setFrame:CGRectMake(5.0f, 5.0f, defaultMonthHeaderHeight - 10.0f, defaultMonthHeaderHeight - 10.0f)];
            [headerView.previousMonthBtn setFrame:headerView.previousMonthImage.frame];
            [headerView.previousMonthBtn addTarget:self action:@selector(previousMonth) forControlEvents:
             UIControlEventTouchUpInside];
            [headerView.previousMonthBtn setHidden:NO];
            [headerView.previousMonthImage setHidden:NO];

            
            [headerView.nextMonthImage setFrame:CGRectMake(calendarCollectionView.bounds.size.width - defaultMonthHeaderHeight + 5.0f, 5.0f, defaultMonthHeaderHeight - 10.0f, defaultMonthHeaderHeight - 10.0f)];
            [headerView.nextMonthBtn setFrame:headerView.nextMonthImage.frame];
            [headerView.nextMonthBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
            [headerView.nextMonthBtn setHidden:NO];
            [headerView.nextMonthImage setHidden:NO];
        }
        else
        {
            [headerView.previousMonthBtn setHidden:YES];
            [headerView.nextMonthBtn setHidden:YES];
            [headerView.previousMonthImage setHidden:YES];
            [headerView.nextMonthImage setHidden:YES];

        }
        
        NSArray *dow = @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
        int dayWidth = floorf(calendarCollectionView.bounds.size.width / 7);
        int inset = fmod(calendarCollectionView.bounds.size.width, 7);
        [headerView.daysOfWeekView setFrame:CGRectMake(inset/2.0f, defaultMonthHeaderHeight, calendarCollectionView.bounds.size.width - inset, 20.0f)];
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
    if([self.delegate respondsToSelector:@selector(heightForMonthHeaderInDatePickerView:)])
        defaultMonthHeaderHeight = [self.delegate heightForMonthHeaderInDatePickerView:self];
    
    return CGSizeMake(calendarCollectionView.bounds.size.width, defaultMonthHeaderHeight + 20.0f);
}

- (void)previousMonth
{
    self.currentMonthOffset -= 1;
    [calendarCollectionView reloadData];
}

- (void)nextMonth
{
    self.currentMonthOffset += 1;
    [calendarCollectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int itemWidth = floorf(calendarCollectionView.bounds.size.width / 7.0f);
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
    int rem = fmod(calendarCollectionView.bounds.size.width, 7);
    return UIEdgeInsetsMake(0.0f, rem/2.0f, 0.0f, rem/2.0f);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(![self isContinousCalendar])
        return 1;
    else
        return [calendar components:NSMonthCalendarUnit fromDate:[self startDateMonth] toDate:[self endDateMonth] options:0].month + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSRange weeksInMonth = [calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:[self firstDateOfMonthForSection:section]];
    return (weeksInMonth.length * 7);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self isRangeSelection])
    {
        _selectedDate = [self dateForItemAtIndexPath:indexPath];
        [calendarCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        if([self.delegate respondsToSelector:@selector(datePickerView:didSelectDate:)])
        {
            [self.delegate datePickerView:self didSelectDate:[self dateForItemAtIndexPath:indexPath]];
        }
    }
    else if([self isRangeSelection])
    {
        _selectedEndDate = [self dateForItemAtIndexPath:indexPath];
        [self selectDateRangeFrom:self.selectedDate to:self.selectedEndDate];
        if([self.delegate respondsToSelector:@selector(datePickerView:didSelectDateRangeFrom:to:)])
        {
            [self.delegate datePickerView:self didSelectDateRangeFrom:self.selectedDate to:self.selectedEndDate];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self isRangeSelection])
        [self reset];
    [calendarCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:calendarCollectionView didSelectItemAtIndexPath:indexPath];
    return NO;
}

- (void)reset
{
    _selectedDate = nil;
    _selectedEndDate = nil;
    [calendarCollectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(((SCDatePickerViewCell *)[calendarCollectionView cellForItemAtIndexPath:indexPath]).cellDateType != SCDatePickerViewCellDateTypeValid)
    {
        [calendarCollectionView reloadData];
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCDatePickerViewCellDateType cellDateType = ((SCDatePickerViewCell *)[calendarCollectionView cellForItemAtIndexPath:indexPath]).cellDateType;
    // selection beyond month bounds
    if(![self isContinousCalendar] && cellDateType == SCDatePickerViewCellDateTypeInvalid)
    {
        return NO;
    }
    else if([self isContinousCalendar] && cellDateType != SCDatePickerViewCellDateTypeValid)
    {
        return NO;
    }

    if(![self isRangeSelection] && [[calendarCollectionView indexPathsForSelectedItems] count] > 0) {
        [self reset];
    }
    
    if([self isRangeSelection] && [[self dateForItemAtIndexPath:indexPath] compare:self.selectedDate] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCDatePickerViewCell *cell = [calendarCollectionView dequeueReusableCellWithReuseIdentifier:kSCDatePickerViewCellIdentifier forIndexPath:indexPath];
    NSDate *cellDate = [self dateForItemAtIndexPath:indexPath];
    
    // Fetch components
    NSDateComponents *cellDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:cellDate];
    NSDateComponents *startDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.startDate];
    NSDateComponents *endDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.endDate];
    
    if([self.delegate respondsToSelector:@selector(datePickerView:selectedBackgroundViewForDate:withFrame:)])
    {
        cell.selectedBackgroundView = [self.delegate datePickerView:self selectedBackgroundViewForDate:cellDate withFrame:cell.contentView.frame];
    }
    else
    {
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = selectedBackgroundView;
    }
    
    NSDateComponents *firstOfMonthComponents = [calendar components:NSMonthCalendarUnit fromDate:[self firstDateOfMonthForSection:indexPath.section]];

    if(cellDateComponents.month != firstOfMonthComponents.month) {
        // invalidate cells which do not belong to current month
        cell.cellDateType = SCDatePickerViewCellDateTypeDisabled;
    }
    else if(cellDateComponents.month == startDateComponents.month && cellDateComponents.year == startDateComponents.year && cellDateComponents.day < startDateComponents.day) {
        // disable cells before startDate
        cell.cellDateType = SCDatePickerViewCellDateTypeInvalid;
    }
    else if(cellDateComponents.month == endDateComponents.month && cellDateComponents.year == endDateComponents.year && cellDateComponents.day > endDateComponents.day) {
        // disable cells after endDate
        cell.cellDateType = SCDatePickerViewCellDateTypeInvalid;
    }
    else {
        // everything else is valid
        cell.cellDateType = SCDatePickerViewCellDateTypeValid;
    }
    
    // cell selection
    if(self.selectedDate != nil && cell.cellDateType == SCDatePickerViewCellDateTypeValid) {
        NSDateComponents *selectedDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.selectedDate];
        
        if((self.selectedDate != nil && cellDateComponents.day == selectedDateComponents.day && cellDateComponents.month == selectedDateComponents.month && cellDateComponents.year == selectedDateComponents.year) || (self.selectedDate != nil && self.selectedEndDate != nil && [self isContinousCalendar] && [self date:cellDate isBetween:self.selectedDate and:self.selectedEndDate]))
        {
            [calendarCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [cell setSelected:YES];
        }
    }

    // set appearance
    if(cell.cellDateType == SCDatePickerViewCellDateTypeValid)
    {
        cell.tag = cellDateComponents.day;
        if(cell.selected)
        {
            cell.dateLabel.font = self.selectedDateFont;
            if([self.delegate respondsToSelector:@selector(datePickerView:selectedDateColorForDate:)])
            {
                cell.dateLabel.textColor = [self.delegate datePickerView:self selectedDateColorForDate:cellDate];

            }
            else
            {
                cell.dateLabel.textColor = [UIColor blackColor];
            }
        }
        else
        {
            cell.dateLabel.font = self.dateFont;
            if([self.delegate respondsToSelector:@selector(datePickerView:enabledDateColorForDate:)])
                cell.dateLabel.textColor = [self.delegate datePickerView:self enabledDateColorForDate:cellDate];
            else
                cell.dateLabel.textColor = [UIColor darkGrayColor];
        }
    }
    else if(cell.cellDateType == SCDatePickerViewCellDateTypeDisabled)
    {
        cell.dateLabel.font = self.dateFont;
        if([self.delegate respondsToSelector:@selector(datePickerView:disabledDateColorForDate:)])
            cell.dateLabel.textColor = [self.delegate datePickerView:self disabledDateColorForDate:cellDate];
        else
            cell.dateLabel.textColor = [UIColor grayColor];
    }
    else if(cell.cellDateType == SCDatePickerViewCellDateTypeInvalid)
    {
        cell.dateLabel.font = self.dateFont;
        if([self.delegate respondsToSelector:@selector(datePickerView:invalidDateColorForDate:)])
        {
            cell.dateLabel.textColor = [self.delegate datePickerView:self invalidDateColorForDate:cellDate];
        }
        else
        {
            cell.dateLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
    // out of month dates are not shown for continous calendar
    if([self isContinousCalendar])
        cell.dateLabel.text = cell.cellDateType == SCDatePickerViewCellDateTypeDisabled ? @"" : [self.dateFormatter stringFromDate:cellDate];
    else
        cell.dateLabel.text = [self.dateFormatter stringFromDate:cellDate];

    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

/*
 CALENDAR FUNCTIONS
 */


- (NSDate *)startDateMonth
{
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.startDate];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)endDateMonth
{
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.endDate];
    components.month += 1;
    components.day = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)firstDateOfMonthForSection:(NSInteger)section
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    if(![self isContinousCalendar])
        offsetComponents.month = self.currentMonthOffset;
    else
        offsetComponents.month = section;
    return [calendar dateByAddingComponents:offsetComponents toDate:[self startDateMonth] options:0];
}

- (NSDate *)firstOfStartDate
{
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.startDate];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *cellOffset = [[NSDateComponents alloc] init];
    
    if(![self isContinousCalendar])
        cellOffset.month = self.currentMonthOffset;
    else
        cellOffset.month = indexPath.section;
    
    NSUInteger weekOffset = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[self firstDateOfMonthForSection:cellOffset.month]];
    cellOffset.day = indexPath.item + (-(weekOffset - 1));
    return [calendar dateByAddingComponents:cellOffset toDate:[self firstOfStartDate] options:0];
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date
{
    NSInteger section = [calendar components:NSMonthCalendarUnit fromDate:[self startDateMonth] toDate:date options:0].month;
    return [self indexPathForDate:date inSection:section];
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date inSection:(NSUInteger)section
{
    NSDate *firstDateInSection = [self dateForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:firstDateInSection toDate:date options:0];
    return [NSIndexPath indexPathForItem:difference.day inSection:section];
}

- (NSArray *)indexPathsBetween:(NSIndexPath *)fromIndexPath and:(NSIndexPath *)toIndexPath
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    // in the same section for continous calendar
    if([fromIndexPath section] == [toIndexPath section])
    {
        NSUInteger s = [fromIndexPath section];
        for(NSUInteger i = [fromIndexPath row]; i <= [toIndexPath row] ; i ++)
        {
            if(![self isContinousCalendar])
                s = 0;
            if(s < [calendarCollectionView numberOfSections])
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:s]];
        }
    }
    // accross sections for continous calendar
    else
    {
        for(NSUInteger s = [fromIndexPath section]; s <= [toIndexPath section]; s ++)
        {
            if(s >= [calendarCollectionView numberOfSections])
                break;
            
            NSUInteger rmin;
            NSUInteger rmax;
            if(s == [fromIndexPath section])
            {
                rmin = [fromIndexPath row];
                rmax = [calendarCollectionView numberOfItemsInSection:s];
            }
            else if(s == [toIndexPath section])
            {
                rmin = 0;
                rmax = [toIndexPath row];
            }
            else
            {
                rmin = 0;
                rmax = [calendarCollectionView numberOfItemsInSection:s];
            }
            for(NSUInteger i = rmin; i <= rmax ; i ++)
            {
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:s]];
            }
        }
    }
    return indexPaths;
}

- (void)selectDateRangeBetweenSelection
{
    NSArray *sortedIndexPathsForSelectedItems = [[calendarCollectionView indexPathsForSelectedItems] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
    for(NSIndexPath *i in [self indexPathsBetween:[sortedIndexPathsForSelectedItems objectAtIndex:0] and:[sortedIndexPathsForSelectedItems objectAtIndex:1]])
    {
        if(((SCDatePickerViewCell *)[calendarCollectionView cellForItemAtIndexPath:i]).cellDateType == SCDatePickerViewCellDateTypeValid)
        {
            [calendarCollectionView selectItemAtIndexPath:i animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [indexPathsToReload addObject:i];
        }
        
    }
    [calendarCollectionView reloadItemsAtIndexPaths:indexPathsToReload];
}

- (void)selectDateRangeFrom:(NSDate *)date1 to:(NSDate *)date2
{
    NSIndexPath *index1 = [self indexPathForDate:date1];
    NSIndexPath *index2 = [self indexPathForDate:date2];
    
    NSArray *sortedIndexPathsForSelectedItems = [@[index1, index2] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
    for(NSIndexPath *i in [self indexPathsBetween:[sortedIndexPathsForSelectedItems objectAtIndex:0] and:[sortedIndexPathsForSelectedItems objectAtIndex:1]])
    {
        if(((SCDatePickerViewCell *)[calendarCollectionView cellForItemAtIndexPath:i]).cellDateType == SCDatePickerViewCellDateTypeValid)
        {
            [calendarCollectionView selectItemAtIndexPath:i animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [indexPathsToReload addObject:i];
        }
        
    }
    [calendarCollectionView reloadItemsAtIndexPaths:indexPathsToReload];
}


- (BOOL)date:(NSDate *)date isBetween:(NSDate *)firstDate and:(NSDate *)secondDate
{
    return (date && [self compareDate:date withDate:firstDate] != NSOrderedAscending && [self compareDate:date withDate:secondDate] != NSOrderedDescending);
}

- (int)compareDate:(NSDate *)firstDate withDate:(NSDate *)secondDate
{
    NSDateComponents *firstComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:firstDate];
    NSDateComponents *secondComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:secondDate];
    
    return [[calendar dateFromComponents:firstComponents] compare:[calendar dateFromComponents:secondComponents]];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
