//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "LSCollectionViewLayoutHelper.h"

@interface LSCollectionViewLayoutHelper ()
{
    NSMutableDictionary *_cellMap;
}
@end

@implementation LSCollectionViewLayoutHelper

- (id)initWithCollectionViewLayout:(UICollectionViewLayout<UICollectionViewLayout_Warpable>*)collectionViewLayout
{
    self = [super init];
    if (self) {
        _collectionViewLayout = collectionViewLayout;
        _cellMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements
{
    NSIndexPath *fromIndexPath = self.warpFromIndexPath;
    NSIndexPath *toIndexPath = self.warpToIndexPath;
    NSIndexPath *hideIndexPath = self.hiddenIndexPath;
    
    [_cellMap removeAllObjects];
    
    if (toIndexPath == nil) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
            if ([layoutAttributes.indexPath isEqual:hideIndexPath]) {
                layoutAttributes.hidden = YES;
            }
        }
    }
    // Item moved to different place in same section
    else if(fromIndexPath.section == toIndexPath.section) {
        for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
            if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
                continue;
            }
            NSIndexPath *indexPath = layoutAttributes.indexPath;
            // Leave other sections alone
            if (indexPath.section != fromIndexPath.section) {
                continue;
            }
            // Item's new location
            if([indexPath isEqual:toIndexPath]) {
                layoutAttributes.indexPath = fromIndexPath;
            }
            // Item moved back
            else if(indexPath.item <= fromIndexPath.item && indexPath.item > toIndexPath.item) {
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
            // Item item moved forward
            else if(indexPath.item >= fromIndexPath.item && indexPath.item < toIndexPath.item) {
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }            
            if([indexPath isEqual:layoutAttributes.indexPath] == NO) {
                [_cellMap setObject:indexPath forKey:layoutAttributes.indexPath];
            }
            if ([indexPath isEqual:hideIndexPath]) {
                layoutAttributes.hidden = YES;
            }
        }
    }
    // Item moved to different section
    else {
        NSInteger sourceSectionCount = [self.collectionViewLayout.collectionView numberOfItemsInSection:fromIndexPath.section];
        NSInteger targetSectionCount = [self.collectionViewLayout.collectionView numberOfItemsInSection:toIndexPath.section];
        NSIndexPath *indexPathToRemove = [NSIndexPath indexPathForItem:sourceSectionCount - 1 inSection:fromIndexPath.section];
        NSIndexPath *indexPathToInsert = [NSIndexPath indexPathForItem:targetSectionCount inSection:toIndexPath.section];
        UICollectionViewLayoutAttributes *insertLayoutAttributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPathToInsert];
        
        for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
            if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
                continue;
            }
            // Remove item in source section and insert item in target section
            if([layoutAttributes.indexPath isEqual:indexPathToRemove]) {
                layoutAttributes.indexPath = indexPathToInsert;
                layoutAttributes.center = insertLayoutAttributes.center;
            }
            NSIndexPath *indexPath = layoutAttributes.indexPath;
            // Item's new location
            if([indexPath isEqual:toIndexPath]) {
                layoutAttributes.indexPath = fromIndexPath;
            }
            // Change indexes in source section
            else if(indexPath.section == fromIndexPath.section && indexPath.item >= fromIndexPath.item) {
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
            // Change indexes in destination section
            else if(indexPath.section == toIndexPath.section && indexPath.item >= toIndexPath.item) {
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
            if([indexPath isEqual:layoutAttributes.indexPath] == NO) {
                [_cellMap setObject:indexPath forKey:layoutAttributes.indexPath];
            }
            if ([indexPath isEqual:hideIndexPath]) {
                layoutAttributes.hidden = YES;
            }
        }
    }
    return elements;
}

- (NSIndexPath *)translateIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *lookupIndexPath = [_cellMap objectForKey:indexPath];
    if(lookupIndexPath) {
        return lookupIndexPath;
    }
    return indexPath;
}

@end
