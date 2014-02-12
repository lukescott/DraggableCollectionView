//
//  FlowLayout.m
//  test
//
//  Created by Luke Scott on 9/21/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import "DraggableCollectionViewFlowLayout.h"
#import "DraggableFlowLayoutInfo.h"
#import "DraggableFlowLayoutSection.h"
#import "DraggableFlowLayoutRow.h"
#import "DraggableFlowLayoutItem.h"

#import "DraggableCollectionViewPlaceholder.h"

@interface DraggableCollectionViewFlowLayout ()
{
    DraggableFlowLayoutInfo *_layoutInfo;
}
@end

@implementation DraggableCollectionViewFlowLayout

- (void)prepareLayout
{
    _layoutInfo = [self generateLayoutInfo];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        _layoutInfo.direction = FlowLayoutDirectionVertical;
        _layoutInfo.dimension = self.collectionView.bounds.size.width;
    } else {
        _layoutInfo.direction = FlowLayoutDirectionHorizontal;
        _layoutInfo.dimension = self.collectionView.bounds.size.height;
    }
    [_layoutInfo computeLayout];
    NSLog(@"compute");
}

- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point
{
    return [self.collectionView indexPathForItemAtPoint:point];
    for (DraggableFlowLayoutSection *section in _layoutInfo.sections) {
        CGRect sectionFrame = section.frame;
        if (! CGRectContainsPoint(sectionFrame, point)) {
            continue;
        }
        for (DraggableFlowLayoutRow *row in section.rows) {
            CGRect rowFrame = CGRectOffset(row.frame, sectionFrame.origin.x, sectionFrame.origin.y);
            if (! CGRectContainsPoint(rowFrame, point)) {
                continue;
            }
            for (DraggableFlowLayoutItem *item in row.items) {
                CGRect itemFrame = CGRectOffset(item.frame, rowFrame.origin.x, rowFrame.origin.y);
                if (! CGRectContainsPoint(itemFrame, point)) {
                    continue;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item.index inSection:section.index];
                return indexPath;
            }
        }
    }
    return nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttrs = [NSMutableArray new];
    for (DraggableFlowLayoutSection *section in _layoutInfo.sections) {
        CGRect sectionFrame = section.frame;
        if (! CGRectIntersectsRect(sectionFrame, rect)) {
            continue;
        }
        DraggableFlowLayoutItem *placeholderItem = section.placeholderItem;
        for (DraggableFlowLayoutRow *row in section.rows) {
            CGRect rowFrame = CGRectOffset(row.frame, sectionFrame.origin.x, sectionFrame.origin.y);
            if (! CGRectIntersectsRect(rowFrame, rect)) {
                continue;
            }
            for (DraggableFlowLayoutItem *item in row.items) {
                CGRect itemFrame = CGRectOffset(item.frame, rowFrame.origin.x, rowFrame.origin.y);
                if (! CGRectIntersectsRect(itemFrame, rect)) {
                    continue;
                }
                if (item == placeholderItem) {
                    continue;
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item.index inSection:section.index];
                UICollectionViewLayoutAttributes *layoutAttr =
                [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                layoutAttr.frame = itemFrame;
                [layoutAttrs addObject:layoutAttr];
            }
        }
    }
    return [layoutAttrs copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DraggableFlowLayoutSection *section = [_layoutInfo.sections objectAtIndex:indexPath.section];
    DraggableFlowLayoutItem *item = [section.items objectAtIndex:indexPath.item];
    CGRect sectionFrame = section.frame;
    CGRect rowFrame = CGRectOffset(item.row.frame, sectionFrame.origin.x, sectionFrame.origin.y);
    CGRect itemFrame = CGRectOffset(item.frame, rowFrame.origin.x, rowFrame.origin.y);
    UICollectionViewLayoutAttributes *layoutAttr =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    layoutAttr.frame = itemFrame;
    return layoutAttr;
}


- (CGSize)collectionViewContentSize
{
    return _layoutInfo.contentSize;
}

- (DraggableFlowLayoutInfo *)generateLayoutInfo
{
    DraggableFlowLayoutInfo *layoutInfo = [DraggableFlowLayoutInfo new];
    UICollectionView *collectionView = self.collectionView;
    id<UICollectionViewDelegateFlowLayout> dataSource = (id<UICollectionViewDelegateFlowLayout>)collectionView.delegate;
    BOOL dynamicItemSize = [dataSource respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
//    BOOL dynamicHeaderSize = [dataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)];
//    BOOL dynamicFooterSize = [dataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)];
    CGSize itemSize = self.itemSize;
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    NSInteger numberOfSections = collectionView.numberOfSections;
    
    for (NSInteger s = 0; s < numberOfSections; ++s) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:s];
        DraggableFlowLayoutSection *section = [DraggableFlowLayoutSection new];
        section.index = s;
        section.minimumInteritemSpacing = minimumInteritemSpacing;
        section.minimumLineSpacing = minimumLineSpacing;
        for (NSInteger i = 0; i < numberOfItems; ++i) {
            if (dynamicItemSize) {
                itemSize = [dataSource collectionView:collectionView
                                               layout:self
                               sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:s]];
            }
            [section addItem:[DraggableFlowLayoutItem itemWithIndex:i size:itemSize]];
        }
        [layoutInfo addSection:section];
    }
    
    for (NSIndexPath *indexPath in self.hiddenItems) {
        DraggableFlowLayoutSection *section = [layoutInfo.sections objectAtIndex:indexPath.section];
        if (section) {
            [section.hiddenItems addIndex:indexPath.item];
        }
    }
    
    DraggableCollectionViewPlaceholder *placeholder = self.placeholder;
    if (placeholder) {
        NSIndexPath *indexPath = placeholder.indexPath;
        DraggableFlowLayoutSection *section = [layoutInfo.sections objectAtIndex:indexPath.section];
        if (section) {
            section.placeholderItem = [DraggableFlowLayoutItem itemWithIndex:indexPath.item size:placeholder.size];
        }
    }
    
    return layoutInfo;
}

@end
