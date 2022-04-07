import UIKit
import CoreData

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
    @IBOutlet weak var innerView: UIView!
    var sourceData = [DataObj]()
    var coreSource: [NSManagedObject] = []
    var collectionView: UICollectionView!
    var parent: ViewController!
    
    var indexPath: IndexPath = []
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.isHidden = false
        data = nil
        
    }
    
    
    @IBOutlet weak var testView: UIView!
    
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
    
    
    
}
