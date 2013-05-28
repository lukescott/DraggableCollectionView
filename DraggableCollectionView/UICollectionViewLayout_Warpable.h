//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>

@protocol UICollectionViewLayout_Warpable <NSObject>
@required

- (NSIndexPath *)translateIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSIndexPath *warpFromIndexPath;
@property (strong, nonatomic) NSIndexPath *warpToIndexPath;
@property (strong, nonatomic) NSIndexPath *hidenIndexPath;
@end