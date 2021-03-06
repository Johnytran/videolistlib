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
    var parentController = ViewController()
    var pickedImage: String = ""
    var parentVideo: String = ""
    var collectionView: UICollectionView!
    
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
    func getParent(parent: ViewController){
        self.parentController = parent;
    }
    func getVideoURL(video: String){
        self.parentVideo = video;
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
    
    @IBOutlet weak var alertMessage: UILabel!
    
    
    @IBAction func ChooseCover(_ sender: Any) {
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        parentController.present(self.pickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnAddVideo(_ sender: Any) {
        alertMessage.text = ""
        let title: String = self.txtVideoTitle.text ?? ""
        if(title.isEmpty || pickedImage.isEmpty ){
            alertMessage.text = "Please fill video title and photo cover."
            return
        }
        UIView.transition(with: self, duration: 0.33,
          options: [.curveEaseOut, .transitionFlipFromBottom],
          animations: {
            
            let tmpData = DataObj(image: self.pickedImage,
                                   play_Url: self.parentVideo,
                                    title: title)
            //print(tmpData)
            if(self.parentController.saveLocal(data: tmpData)){
                self.removeFromSuperview();
                self.parentController.getLocalData();
                self.collectionView.reloadData();
            }
          },
          completion: nil
        )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickerController.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            imgPhotoCover.image = image
        
            let tmpStr = String()

            let fileName = tmpStr.uniqueFilename()+".jpg"
            //print(fileName)

            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if let data = image.jpegData(compressionQuality:  1.0){
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    pickedImage = fileName
                    print("image saved")
                } catch {
                    print("error saving image:", error)
                }
            }
            
        }
    }
}
