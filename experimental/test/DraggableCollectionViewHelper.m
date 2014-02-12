//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "DraggableCollectionViewHelper.h"
#import "DraggableCollectionViewLayout.h"
#import "DraggableCollectionViewPlaceholder.h"
#import <QuartzCore/QuartzCore.h>

static int kObservingCollectionViewLayoutContext;

#ifndef CGGEOMETRY__SUPPORT_H_
CG_INLINE CGPoint
_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif

typedef NS_ENUM(NSInteger, _ScrollingDirection) {
    _ScrollingDirectionUnknown = 0,
    _ScrollingDirectionUp,
    _ScrollingDirectionDown,
    _ScrollingDirectionLeft,
    _ScrollingDirectionRight
};

@interface DraggableCollectionViewHelper ()
{
    UIView *mockCell;
    NSIndexPath *startingIndexPath;
    NSIndexPath *fromIndexPath;
    NSIndexPath *toIndexPath;
    NSIndexPath *lastIndexPath;
    CGPoint mockCenter;
    CGPoint fingerTranslation;
    CADisplayLink *timer;
    _ScrollingDirection scrollingDirection;
    BOOL canWarp;
    BOOL canScroll;
}
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewLayout<DraggableCollectionViewLayout> *layout;
@end

@implementation DraggableCollectionViewHelper

- (id)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        [_collectionView addObserver:self
                          forKeyPath:@"collectionViewLayout"
                             options:0
                             context:&kObservingCollectionViewLayoutContext];
        _scrollingEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
        _scrollingSpeed = 300.f;
        
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleLongPressGesture:)];
        [_collectionView addGestureRecognizer:_longPressGestureRecognizer];
        
        _panPressGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handlePanGesture:)];
        _panPressGestureRecognizer.delegate = self;

        [_collectionView addGestureRecognizer:_panPressGestureRecognizer];
        
        for (UIGestureRecognizer *gestureRecognizer in _collectionView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
                break;
            }
        }
        
        [self layoutChanged];
    }
    return self;
}

- (void)layoutChanged
{
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    if ([layout conformsToProtocol:@protocol(DraggableCollectionViewLayout)]) {
        self.layout = (UICollectionViewLayout<DraggableCollectionViewLayout>*)layout;
        canScroll = [layout respondsToSelector:@selector(scrollDirection)];
    }
    _longPressGestureRecognizer.enabled = _panPressGestureRecognizer.enabled = self.enabled;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kObservingCollectionViewLayoutContext) {
        [self layoutChanged];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    _longPressGestureRecognizer.enabled = enabled;
    _panPressGestureRecognizer.enabled = enabled;
}

- (UIImage *)imageFromCell:(UICollectionViewCell *)cell {
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0.0f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)invalidatesScrollTimer {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    scrollingDirection = _ScrollingDirectionUnknown;
}

- (void)setupScrollTimerInDirection:(_ScrollingDirection)direction {
    scrollingDirection = direction;
    if (timer == nil) {
        timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
        [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    if([gestureRecognizer isEqual:_longPressGestureRecognizer]) {
//        return self.layout == nil;
//    }
    if([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        return self.layout.placeholder != nil;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isEqual:_longPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:_panPressGestureRecognizer];
    }
    
    if ([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:_longPressGestureRecognizer];
    }
    
    return NO;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        return;
    }
    
    // TODO..
    NSIndexPath *indexPath = [self.layout indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath == nil) {
                return;
            }
            fromIndexPath = indexPath;
            toIndexPath = indexPath;
            lastIndexPath = indexPath;
            
//            if (![(id<UICollectionViewDataSource_Draggable>)self.collectionView.dataSource
//                  collectionView:self.collectionView
//                  canMoveItemAtIndexPath:indexPath]) {
//                return;
//            }
            // Create mock cell to drag around
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            
            cell.highlighted = NO;
            [mockCell removeFromSuperview];
            mockCell = [[UIImageView alloc] initWithFrame:cell.frame];
            ((UIImageView *)mockCell).image = [self imageFromCell:cell];
            mockCenter = mockCell.center;
            [self.collectionView addSubview:mockCell];
            [UIView
             animateWithDuration:0.3
             animations:^{
                 mockCell.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
             }
             completion:nil];
            
            self.layout.hiddenItems = @[indexPath];
            self.layout.placeholder = [DraggableCollectionViewPlaceholder placeholderWithIndexPath:indexPath size:cell.frame.size];
            
            [self.layout invalidateLayout];
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // Tell the data source to move the item
//            [(id<UICollectionViewDataSource_Draggable>)self.collectionView.dataSource collectionView:self.collectionView
//                                                                              moveItemAtIndexPath:self.layoutHelper.fromIndexPath
//                                                                                      toIndexPath:self.layoutHelper.toIndexPath];
//            [self.collectionView moveItemAtIndexPath:self.layoutHelper.fromIndexPath toIndexPath:self.layoutHelper.toIndexPath];

            
            
            [self invalidatesScrollTimer];
            [mockCell removeFromSuperview];
            mockCell = nil;
            fromIndexPath = nil;
            toIndexPath = nil;
        } break;
        default: break;
    }
}

- (void)moveItemToPoint:(CGPoint)point
{
    NSIndexPath *indexPath = [self.layout indexPathForItemAtPoint:point];
    if (indexPath == nil) {
        return;
    }
    if (indexPath.item >= lastIndexPath.item) {
        indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
    }
    if ([indexPath isEqual:lastIndexPath]) {
        return;
    }
    lastIndexPath = indexPath;
    
    //    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:toIndexPath:)] == YES
    //        && [(id<UICollectionViewDataSource_Draggable>)self.collectionView.dataSource
    //            collectionView:self.collectionView
    //            canMoveItemAtIndexPath:self.layoutHelper.fromIndexPath
    //            toIndexPath:indexPath] == NO) {
    //        return;
    //    }
    
    toIndexPath = indexPath;


    [self.collectionView performBatchUpdates:^{
        self.layout.placeholder.indexPath = indexPath;
    } completion:nil];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateChanged) {
        // Move mock to match finger
        fingerTranslation = [sender translationInView:self.collectionView];
        mockCell.center = _CGPointAdd(mockCenter, fingerTranslation);
        
        // Scroll when necessary
        if (canScroll) {
            UICollectionViewFlowLayout *scrollLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
            if([scrollLayout scrollDirection] == UICollectionViewScrollDirectionVertical) {
                if (mockCell.center.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingEdgeInsets.top)) {
                    [self setupScrollTimerInDirection:_ScrollingDirectionUp];
                }
                else {
                    if (mockCell.center.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingEdgeInsets.bottom)) {
                        [self setupScrollTimerInDirection:_ScrollingDirectionDown];
                    }
                    else {
                        [self invalidatesScrollTimer];
                    }
                }
            }
            else {
                if (mockCell.center.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingEdgeInsets.left)) {
                    [self setupScrollTimerInDirection:_ScrollingDirectionLeft];
                } else {
                    if (mockCell.center.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingEdgeInsets.right)) {
                        [self setupScrollTimerInDirection:_ScrollingDirectionRight];
                    } else {
                        [self invalidatesScrollTimer];
                    }
                }
            }
        }
        
        // Avoid warping a second time while scrolling
        if (scrollingDirection > _ScrollingDirectionUnknown) {
            return;
        }
        
        // Warp item to finger location
        [self moveItemToPoint:[sender locationInView:self.collectionView]];
    }
}

- (void)handleScroll:(NSTimer *)timer {
    if (scrollingDirection == _ScrollingDirectionUnknown) {
        return;
    }
    
    CGSize frameSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat distance = self.scrollingSpeed / 60.f;
    CGPoint translation = CGPointZero;
    
    switch(scrollingDirection) {
        case _ScrollingDirectionUp: {
            distance = -distance;
            if ((contentOffset.y + distance) <= 0.f) {
                distance = -contentOffset.y;
            }
            translation = CGPointMake(0.f, distance);
        } break;
        case _ScrollingDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height;
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            translation = CGPointMake(0.f, distance);
        } break;
        case _ScrollingDirectionLeft: {
            distance = -distance;
            if ((contentOffset.x + distance) <= 0.f) {
                distance = -contentOffset.x;
            }
            translation = CGPointMake(distance, 0.f);
        } break;
        case _ScrollingDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width;
            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }
            translation = CGPointMake(distance, 0.f);
        } break;
        default: break;
    }
    
    mockCenter  = _CGPointAdd(mockCenter, translation);
    mockCell.center = _CGPointAdd(mockCenter, fingerTranslation);
    self.collectionView.contentOffset = _CGPointAdd(contentOffset, translation);
    
    [self moveItemToPoint:mockCell.center];
}

@end
