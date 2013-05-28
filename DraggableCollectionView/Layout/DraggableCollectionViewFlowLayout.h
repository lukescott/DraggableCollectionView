//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import <UIKit/UIKit.h>
#import "UICollectionViewLayout_Warpable.h"

@interface DraggableCollectionViewFlowLayout : UICollectionViewFlowLayout <UICollectionViewLayout_Warpable>

- (NSIndexPath *)translateIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSIndexPath *warpFromIndexPath;
@property (strong, nonatomic) NSIndexPath *warpToIndexPath;
@property (strong, nonatomic) NSIndexPath *hidenIndexPath;
@end
