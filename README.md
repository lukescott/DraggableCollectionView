DraggableCollectionView
=====================================

Extension for the `UICollectionView` and `UICollectionViewLayout` that allows a user to move items with drag and drop.

## Getting Started

- Include UICollectionView+Draggable catagory (and related files).
- Include QuartzCoreFramework.
- Set `draggable` to true on collection view.
- Set `collectionViewLayout` to a layout that implements the `UICollectionViewLayout_Warpable` protocol (will fallback if layout does not). For the default Flow layout (grid) use `DraggableCollectionViewFlowLayout` - you can set this in Interface Builder.
- Implement the `UICollectionViewDataSource_Draggable` extended protocol.

## How it Works

It works just like `UITableView`. The extended protocol contains similarly named methods related to drag and drop found in the `UITableViewDataSource` protocol. The `moveItemAtIndexPath:toIndexPath` method is only called once - when the user lifts their finger. This is acomplished by "warping" the cells by modifying the output from the `layoutAttributesForElementsInRect` method. This allows you to physically move the cells around without touching the data source.

## Custom Layouts

This extension can work with most custom layouts - just implement the `UICollectionViewLayout_Warpable` protocol. An easy way to do this is subclass your layout and feed the output from `layoutAttributesForElementsInRect` through `LSCollectionViewLayoutHelper`. For an example how to do this see `DraggableCollectionViewFlowLayout` - you can pretty much copy and paste from there. `DraggableCollectionViewFlowLayout` is included for Apple's default `UICollectionViewFlowLayout` (see FlowLayoutDemo). There is also CircleLayoutDemo for Apple's CircleLayout example from WWDC 2012.

## License

DraggableCollectionView is available under the [MIT license](LICENSE).
