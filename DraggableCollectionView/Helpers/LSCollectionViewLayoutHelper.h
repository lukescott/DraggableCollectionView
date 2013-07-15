//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>
#import "UICollectionViewLayout_Warpable.h"

@interface LSCollectionViewLayoutHelper : NSObject

- (id)initWithCollectionViewLayout:(UICollectionViewLayout<UICollectionViewLayout_Warpable>*)collectionViewLayout;

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements;

@property (nonatomic, weak, readonly) UICollectionViewLayout<UICollectionViewLayout_Warpable> *collectionViewLayout;
@property (strong, nonatomic) NSIndexPath *fromIndexPath;
@property (strong, nonatomic) NSIndexPath *toIndexPath;
@property (strong, nonatomic) NSIndexPath *hideIndexPath;
@end
