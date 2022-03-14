//
//  PlayerCell.swift
//  MMPlayerView
//
//  Created by Millman YANG on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

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
    // 1
    var isInEditingMode: Bool = false {
        didSet {
            checkmarkLabel.isHidden = !isInEditingMode
        }
    }

    // 2
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                checkmarkLabel.text = isSelected ? "✓" : ""
            }
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.isHidden = false
        data = nil
    }
    @IBAction func DeleteVideo(_ sender: Any) {
        
    }
}
