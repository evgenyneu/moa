/**

Used for simulation of image download. It can be useful in unit tests if you want to check which images where requested. One can supply UIImage objects for specific request URLs.

*/
public struct MoaSimulator {
  
  /// Contains a shared instance of the simulator.
  static var instance: MoaSimulator?
  
  public static func start() {
    instance = MoaSimulator()
  }
  
  public static func stop() {
    instance = nil
  }
}