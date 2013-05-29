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
    NSIndexPath *hideIndexPath = self.hidenIndexPath;
    
    [_cellMap removeAllObjects];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
        if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        if (toIndexPath != nil) {
            // TODO: Support multiple sections
            if(indexPath.section != fromIndexPath.section) {
                continue;
            }
            
            if(indexPath.item == toIndexPath.item) {
                layoutAttributes.indexPath = fromIndexPath;
            }
            else if (fromIndexPath.item > toIndexPath.item) {
                // Item is being moved before its current position
                if(indexPath.item <= fromIndexPath.item && indexPath.item > toIndexPath.item) {
                    layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
                }
            }
            else {
                // Item is being moved after its current position
                if(indexPath.item >= fromIndexPath.item && indexPath.item < toIndexPath.item) {
                    layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
                }
            }
            if([indexPath isEqual:layoutAttributes.indexPath] == NO) {
                [_cellMap setObject:indexPath forKey:layoutAttributes.indexPath];
            }
        }
        if ([indexPath isEqual:hideIndexPath]) {
            layoutAttributes.hidden = YES;
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
