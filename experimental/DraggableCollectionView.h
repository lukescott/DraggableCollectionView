//
//  DraggableCollectionView.h
//  test
//
//  Created by Luke Scott on 9/29/13.
//  Copyright (c) 2013 Webconnex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableCollectionView : UICollectionView

@property (nonatomic, assign) BOOL draggable;
@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;
@end
