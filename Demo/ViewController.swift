import UIKit
import moa

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  let collectionViewDataSource = CollectionViewDataSource()
  let flowLayout = UICollectionViewFlowLayout()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Log to console
    Moa.logger = MoaConsoleLogger
    
    // Maximum number of simultaneous image downloads. Default: 10.
    Moa.settings.maximumSimultaneousDownloads = 5
    
    // Timeout for image requests in seconds. This will cause a timeout if a resource is not able to be retrieved within a given timeout. Default timeout: 30 seconds.
    Moa.settings.requestTimeoutSeconds = 10
    
    collectionView.dataSource = collectionViewDataSource
    setupCollectionViewLayout()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent; }
  
  private func setupCollectionViewLayout() {
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.minimumLineSpacing = 0
    changeItemSize(UIScreen.main.bounds.width)
    collectionView.setCollectionViewLayout(flowLayout, animated: false)
  }
  
  private func changeItemSize(_ screenWidth: CGFloat) {
    let itemsInRow = Int(screenWidth / 150)
    let itemSideSize = screenWidth / CGFloat(itemsInRow)
    flowLayout.itemSize = CGSize(width: itemSideSize, height: itemSideSize)
  }
  
  override func viewWillTransition(to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator) {
  
    super.viewWillTransition(to: size, with: coordinator)
      
    changeItemSize(size.width)
  }
  
  @IBAction func onJosephSmitTapped(_ sender: AnyObject) {
    if let url = URL(string: "http://en.wikipedia.org/wiki/Joseph_Smit") {
      UIApplication.shared.openURL(url)
    }
  }
}
