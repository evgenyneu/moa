import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  let collectionViewDataSource = CollectionViewDataSource()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = collectionViewDataSource
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
}

