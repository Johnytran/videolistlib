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
            if((data) != nil){
                if FileManager.default.fileExists(atPath: (data?.image)!) {
                    let url = NSURL(string: (data?.image)!)
                    let data = NSData(contentsOf: url! as URL)
                    self.imgView.image = UIImage(data: data! as Data)
                }
                
                self.labTitle.text = data?.title
            }
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.isHidden = false
        data = nil
    }
}
