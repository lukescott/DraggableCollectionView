//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "DraggableCollectionViewFlowLayout.h"
#import "LSCollectionViewLayoutHelper.h"

@interface DraggableCollectionViewFlowLayout ()
{
    LSCollectionViewLayoutHelper *_layoutHelper;
}
@end

@implementation DraggableCollectionViewFlowLayout

- (LSCollectionViewLayoutHelper *)layoutHelper
{
    if(_layoutHelper == nil) {
        _layoutHelper = [[LSCollectionViewLayoutHelper alloc] initWithCollectionViewLayout:self];
    }
    return _layoutHelper;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.layoutHelper modifiedLayoutAttributesForElements:[super layoutAttributesForElementsInRect:rect]];
}

@end
