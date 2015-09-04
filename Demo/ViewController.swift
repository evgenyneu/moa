import UIKit
import moa

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  let collectionViewDataSource = CollectionViewDataSource()
  let flowLayout = UICollectionViewFlowLayout()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Moa.logger = MoaConsoleLogger
    collectionView.dataSource = collectionViewDataSource
    setupCollectionViewLayout()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  private func setupCollectionViewLayout() {
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.minimumLineSpacing = 0
    changeItemSize(UIScreen.mainScreen().bounds.width)
    collectionView.setCollectionViewLayout(flowLayout, animated: false)
  }
  
  private func changeItemSize(screenWidth: CGFloat) {
    let itemsInRow = Int(screenWidth / 150)
    let itemSideSize = screenWidth / CGFloat(itemsInRow)
    flowLayout.itemSize = CGSize(width: itemSideSize, height: itemSideSize)
  }
  
  override func viewWillTransitionToSize(size: CGSize,
    withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
  
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
      
    changeItemSize(size.width)
  }
  
  @IBAction func onJosephSmitTapped(sender: AnyObject) {
    NSURL(string: "http://en.wikipedia.org/wiki/Joseph_Smit").map { url in
      UIApplication.sharedApplication().openURL(url)
    }
  }
}

