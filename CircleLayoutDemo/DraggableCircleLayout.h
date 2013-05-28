//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "CircleLayout.h"
#import "UICollectionViewLayout_Warpable.h"

@interface DraggableCircleLayout : CircleLayout <UICollectionViewLayout_Warpable>

- (NSIndexPath *)translateIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSIndexPath *warpFromIndexPath;
@property (strong, nonatomic) NSIndexPath *warpToIndexPath;
@property (strong, nonatomic) NSIndexPath *hidenIndexPath;
@end
