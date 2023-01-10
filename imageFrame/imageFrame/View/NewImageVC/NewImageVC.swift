//
//  NewImageVC.swift
//  imageFrame
//
//  Created by Md. Faysal Ahmed on 12/12/22.
//

import Foundation
import UIKit


class NewImageVC: UIViewController {
    
    @IBOutlet weak var newImage: UIImageView!
    
    var newImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newImage.image = newImg
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func downloadAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(newImg!, self, #selector(saveCompleted), nil)
        
    }
    
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(ac, animated: true)
        }
        else {
            let ac = UIAlertController(title: "Save finished!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true)
        }
    }
    
    
}
