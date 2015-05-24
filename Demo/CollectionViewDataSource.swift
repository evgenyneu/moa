import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
  
    return 100
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AppConstants.collectionViewCellId,
      forIndexPath: indexPath) as? CollectionViewCell
      
    cell?.prepareForDisplay()
      
    return cell ?? UICollectionViewCell()
  }
}