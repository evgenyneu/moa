import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
  
    return 1000
  }
  
  func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.collectionViewCellId,
      for: indexPath) as? CollectionViewCell
      
    cell?.prepareForDisplay()
      
    return cell ?? UICollectionViewCell()
  }
}
