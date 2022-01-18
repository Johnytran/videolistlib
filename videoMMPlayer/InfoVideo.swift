//
//  InfoVideo.swift
//  videoMMPlayer
//
//  Created by Owner on 16/1/22.
//

import Foundation
import UIKit

class InfoVideo: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var txtVideoTitle: UITextField!
    
    @IBOutlet weak var imgviewPhotoCover: UIImageView!
    @IBAction func btnAddVideo(_ sender: Any) {
    }
    
}
