//
//  InfoVideo.swift
//  videoMMPlayer
//
//  Created by Owner on 16/1/22.
//

import Foundation
import UIKit

class InfoVideo: UIView, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBOutlet weak var txtVideoTitle: UITextField!
    
    @IBAction func ChooseCover(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .camera
    }
    
    @IBAction func btnAddVideo(_ sender: Any) {
    }
    
}
