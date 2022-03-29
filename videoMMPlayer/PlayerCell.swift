import UIKit
import CoreData
@IBDesignable

class PlayerCell: UICollectionViewCell {
    
    var data:DataObj? {
        didSet {
            if(data != nil){
                self.labTitle.text = data?.title
                let url = NSURL(string: (data?.image)!)
                let data = NSData(contentsOf: url! as URL)
                self.imgView.image = UIImage(data: data! as Data)
            }
            
            
        }
    }
    var sourceData = [DataObj]()
    var coreSource: [NSManagedObject] = []
    var collectionView: UICollectionView!
    var parent: ViewController!
    
    var indexPath: IndexPath = []
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.isHidden = false
        data = nil
        
    }
    
    @IBAction func DeleteVideo(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        print(coreSource[indexPath.item])
        let itemToDelete = coreSource[indexPath.item]
        
        sourceData.remove(at: indexPath.item)
        context.delete(itemToDelete)
        collectionView!.deleteItems(at: [indexPath])
        appDelegate.saveContext()
        self.parent.dataSource = sourceData;
        collectionView.reloadData()
    }
    
    
    @IBInspectable open var firstColor: UIColor = UIColor.white
      {
      didSet
      {
        if gradientLayer != nil
        {
          self.updateColors()
        }
      }
    }
    
    /// Second color of gradient i.e. it appears in bottom when angleº set to 0.0.
    @IBInspectable open var secondColor: UIColor = UIColor.white
      {
      didSet
      {
        if gradientLayer != nil
        {
          self.updateColors()
        }
      }
    }
    
    /// Angleº will describe the tilt of gradient.
    @IBInspectable open var angleº: Float = 45.0
      {
      didSet
      {
        // handle negative angles
        if angleº < 0.0 {
          angleº = 360.0 + angleº
        }
        
        // offset of 45 is needed to make logic work
        angleº = angleº + 45
        
        let multiplier = Int(angleº / 360)
        if (multiplier > 0)
        {
          angleº = angleº - Float(360 * multiplier)
        }
        
        if gradientLayer != nil
        {
          self.updatePoints()
        }
      }
    }
    
    /// Color ratio will describe the proportion of colors. It's value ranges from 0.0 to 1.0 default is 0.5.
    @IBInspectable open var colorRatio: Float = 0.5
      {
      didSet
      {
        assert(colorRatio >= 0 || colorRatio <= 1, "Color Ratio: Valid range is from 0.0 to 1.0")
        if gradientLayer != nil
        {
          self.updateLocation()
        }
      }
    }
    
    /// Fade intensity will describe the disperse of colors. It's value ranges from 0.0 to 1.0 default is 0.0.
    @IBInspectable open var fadeIntensity: Float = 0.0
      {
      didSet
      {
        assert(colorRatio >= 0 || colorRatio <= 1, "Fade Intensity: Valid range is from 0.0 to 1.0")
        if gradientLayer != nil
        {
          self.updateLocation()
        }
      }
    }
    
    /// Is blur allow to add visual effect on gradient view. Can't be change during run-time.
    @IBInspectable open var isBlur: Bool = false
      {
      didSet
      {
        if gradientLayer != nil
        {
          self.checkBlurStatusAndUpdateOpacity()
        }
      }
    }
    /// Blur opacity will describe the transparency of blur. It's value ranges from 0.0 to 1.0 default is 0.0. It is suggested to set EZYGradientView background color as clear color for better results.
    @IBInspectable open var blurOpacity: Float = 0.0
      {
      didSet
      {
        assert(blurOpacity >= 0 || blurOpacity <= 1, "Blur Opacity: Valid range is from 0.0 to 1.0")
        if gradientLayer != nil
        {
          self.checkBlurStatusAndUpdateOpacity()
        }
      }
    }
    
      fileprivate var blurView: UIVisualEffectView?
    open var blurLayer: CALayer?
    open var gradientLayer: CAGradientLayer?
    
    //MARK:- Designated Initializer
    
    override init(frame: CGRect)
    {
      super.init(frame: frame)
      self.backgroundColor = UIColor.clear
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
      super.init(coder: aDecoder)
      self.backgroundColor = UIColor.clear
    }
    
    //MARK:- Draw Rect with steps
    
    override open func draw(_ rect: CGRect)
    {
      if gradientLayer == nil
      {
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = self.bounds
        layer.insertSublayer(gradientLayer!, at: 0)
      }
      self.updateColors()
      self.updatePoints()
      self.updateLocation()
      self.checkBlurStatusAndUpdateOpacity()
    }
    /**
     Step 1
     */
    fileprivate func updateColors()
    {
      gradientLayer!.colors = [firstColor.cgColor, secondColor.cgColor]
    }
    /**
     Step 2
     */
    fileprivate func updatePoints()
    {
      let points = startEndPoints()
      gradientLayer!.startPoint = points.0
      gradientLayer!.endPoint = points.1
    }
    /**
     Step 3
     */
    fileprivate func updateLocation()
    {
      let colorLoc = locations()
      gradientLayer!.locations = [NSNumber(value: colorLoc.0), NSNumber(value: colorLoc.1)]
    }
    /**
     Step 4
     */
    fileprivate func checkBlurStatusAndUpdateOpacity()
    {
      if isBlur
      {
        if blurView == nil
        {
          let blurEffect = UIBlurEffect(style: .light)
          blurView = UIVisualEffectView(effect: blurEffect)
          blurView?.frame = self.bounds
          blurLayer = blurView?.layer
        }
        gradientLayer!.colors = [blurColor(firstColor), blurColor(secondColor)]
        self.layer.insertSublayer(blurLayer!, below: gradientLayer)
      }
      else
      {
        blurLayer?.removeFromSuperlayer()
        blurLayer = nil
        blurView = nil
      }
    }
    
    //MARK:- Helpers
    
    fileprivate func blurColor(_ color: UIColor) -> CGColor
    {
      return color.withAlphaComponent(CGFloat(0.9 - (blurOpacity / 2))).cgColor
    }
    
    fileprivate func startEndPoints() -> (CGPoint, CGPoint)
    {
      var rotCalX: Float = 0.0
      var rotCalY: Float = 0.0
      
      // to convert from 0...360 range to 0...4
      let rotate = angleº / 90
      
      // 1...4 can be understood to denote the four quadrants
      if rotate <= 1
      {
        rotCalY = rotate
      }
      else if rotate <= 2
      {
        rotCalY = 1
        rotCalX = rotate - 1
      }
      else if rotate <= 3
      {
        rotCalX = 1
        rotCalY = 1 - (rotate - 2)
      }
      else if rotate <= 4
      {
        rotCalX = 1 - (rotate - 3)
      }
      
      let start = CGPoint(x: 1 - CGFloat(rotCalY), y: 0 + CGFloat(rotCalX))
      let end = CGPoint(x: 0 + CGFloat(rotCalY), y: 1 - CGFloat(rotCalX))
      
      return (start, end)
    }
    
    fileprivate func locations() -> (Float, Float)
    {
      let divider = fadeIntensity / self.divider()
      return(colorRatio - divider, colorRatio + divider)
    }
    
    fileprivate func divider() -> Float
    {
      if colorRatio == 0.1
      {
        return 10
      }
      if colorRatio < 0.5
      {
        let value = 0.5 - colorRatio + 0.5
        return 1 / (1 - value)
      }
      return 1 / (1 - colorRatio)
    }
}
