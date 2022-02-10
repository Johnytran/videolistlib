//
//  InfoVideo.swift
//  videoMMPlayer
//
//  Created by Owner on 16/1/22.
//

import Foundation
import UIKit

class InfoVideo: UIView, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    let pickerController = UIImagePickerController()
    var parentController = UIViewController();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15;
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func getParent(parent: UIViewController){
        self.parentController = parent;
    }
    
    @IBAction func Cancel(_ sender: Any) {
        UIView.transition(with: self, duration: 0.33,
          options: [.curveEaseOut, .transitionFlipFromBottom],
          animations: {
            self.removeFromSuperview();
          },
          completion: nil
        )
    }
    @IBOutlet weak var imgPhotoCover: UIImageView!
    @IBOutlet weak var txtVideoTitle: UITextField!
    
    @IBAction func ChooseCover(_ sender: Any) {
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        parentController.present(self.pickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnAddVideo(_ sender: Any) {
        
        UIView.transition(with: self, duration: 0.33,
          options: [.curveEaseOut, .transitionFlipFromBottom],
          animations: {
            var title: String = self.txtVideoTitle.text ?? ""
            
            self.removeFromSuperview();
          },
          completion: nil
        )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickerController.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            imgPhotoCover.image = image
        }
    }
}
