//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "DraggableCircleLayout.h"
#import "LSCollectionViewLayoutHelper.h"

@interface DraggableCircleLayout ()
{
    LSCollectionViewLayoutHelper *_layoutHelper;
}
@end

@implementation DraggableCircleLayout

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
