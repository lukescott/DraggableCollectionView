//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import <UIKit/UIKit.h>

@interface DraggableCollectionViewHelper : NSObject <UIGestureRecognizerDelegate>

- (id)initWithCollectionView:(UICollectionView *)collectionView;

@property (nonatomic, readonly) UIGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, readonly) UIGestureRecognizer *panPressGestureRecognizer;
@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;
@property (nonatomic, assign) BOOL enabled;
@end
