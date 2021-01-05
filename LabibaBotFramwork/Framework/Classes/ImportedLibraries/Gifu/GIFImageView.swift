import UIKit
/// Example class that conforms to `GIFAnimatable`. Uses default values for the animator frame buffer count and resize behavior. You can either use it directly in your code or use it as a blueprint for your own subclass.
class GIFImageView: UIImageView, GIFAnimatable {
    

  /// A lazy animator.
//  lazy var animator: Animator? = {
//    return Animator(withDelegate: self)
//  }()
    lazy var animator: Animator? = {
        return animator2
    }()
    var animator2:Animator?
    
       override init(frame: CGRect) {
           super.init(frame: frame)
           animator2 = Animator(withDelegate: self)
       }
       required init?(coder: NSCoder) {
           super.init(coder: coder)
         //  fatalError("init(coder:) has not been implemented")
           animator2 = Animator(withDelegate: self)
       }

  /// Layer delegate method called periodically by the layer. **Should not** be called manually.
  ///
  /// - parameter layer: The delegated layer.
  override func display(_ layer: CALayer) {
    updateImageIfNeeded()
  }
}


class im : UIView, GIFAnimatable {
    var animator: Animator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animator = Animator(withDelegate: self)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
      //  fatalError("init(coder:) has not been implemented")
        animator = Animator(withDelegate: self)
    }
    
}
