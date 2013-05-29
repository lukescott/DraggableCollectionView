//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import <UIKit/UIKit.h>
#import "UICollectionViewLayout_Warpable.h"
#import "LSCollectionViewLayoutHelper.h"

@interface DraggableCollectionViewFlowLayout : UICollectionViewFlowLayout <UICollectionViewLayout_Warpable>

@property (readonly, nonatomic) LSCollectionViewLayoutHelper *layoutHelper;
@end
