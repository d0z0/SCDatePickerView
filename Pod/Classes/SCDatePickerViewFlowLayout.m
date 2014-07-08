//
//  SCDatePickerViewFlowLayout.m
//  SCDatePickerDemo
//
//  Created by Schubert Cardozo on 19/06/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "SCDatePickerViewFlowLayout.h"

@implementation SCDatePickerViewFlowLayout

- (id)init
{
    self = [super init];
    if(self)
    {

    }
    return self;
}

- (void)prepareLayout
{
    
}

// -- REF -- http://stackoverflow.com/questions/17229350/cell-spacing-in-uicollectionview
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 0;
        NSInteger originX = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(originX + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width)
        {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = originX + maximumSpacing;
            frame.size.width = round(self.collectionViewContentSize.width/7);
            currentLayoutAttributes.frame = frame;
        }
        
        // prevents the 1px line spacing -- quick fix.. overlaps cells a bit
        // TODO -- get a proper fix for this
        CGRect frame = currentLayoutAttributes.frame;
        frame.size.height +=1;
        currentLayoutAttributes.frame = frame;
        
    }
    return answer;
}

// -- REF -- http://stackoverflow.com/questions/17229350/cell-spacing-in-uicollectionview
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
