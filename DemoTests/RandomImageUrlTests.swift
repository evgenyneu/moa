import UIKit
import XCTest
import Demo

class RandomImageUrlTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  // MARK: - random image name
  
  func testRandomUnseenImageName() {
    let saved = RandomImageUrl.imageNames
    
    RandomImageUrl.imageNames = ["test_image.jpg"]
  
    let randomImageUrl = RandomImageUrl()
    let result = randomImageUrl.randomUnseenImageName
    
    XCTAssertEqual("test_image.jpg", result)
    
    RandomImageUrl.imageNames = saved
  }
  
  // MARK: - remember image name

  func testRememberImageName() {
    let randomImageUrl = RandomImageUrl()
    randomImageUrl.rememberImageName("test url")
    XCTAssertEqual(1, randomImageUrl.seenImageNames.count)
    XCTAssertEqual("test url", randomImageUrl.seenImageNames[0])
  }
  
  func testRememberUrl_dontAddDuplicate() {
    let randomImageUrl = RandomImageUrl()
    randomImageUrl.rememberImageName("file name")
    randomImageUrl.rememberImageName("file name")
    XCTAssertEqual(1, randomImageUrl.seenImageNames.count)
  }
  
  func testRememberUrl_keepLimitedNumberOfImagesInMemoty() {
    let randomImageUrl = RandomImageUrl()
    
    for i in 1...9 {
      randomImageUrl.rememberImageName("file name \(i)")
    }

    XCTAssertEqual(8, randomImageUrl.seenImageNames.count)
    XCTAssertEqual("file name 2", randomImageUrl.seenImageNames[0])
  }
  
  // MARK: - unseen image names
  
  func testUnseenImageNames() {
    let randomImageUrl = RandomImageUrl()
    let result = randomImageUrl.unseenImageNames()
    XCTAssertEqual(12, result.count)
  }
  
  func testUnseenImageNames_withSeenImages() {
    let randomImageUrl = RandomImageUrl()
    randomImageUrl.seenImageNames.append("AcanthochoerusGroteiSmit.jpg")
    let result = randomImageUrl.unseenImageNames()
    XCTAssertEqual(11, result.count)
  }
  
  func testUnseenImageNames_resetSeenImagesWhenAllSeen() {
    let randomImageUrl = RandomImageUrl()
    randomImageUrl.seenImageNames = RandomImageUrl.imageNames
    let result = randomImageUrl.unseenImageNames()
    XCTAssertEqual(0, randomImageUrl.seenImageNames.count)
    XCTAssertEqual(12, result.count)
  }
}