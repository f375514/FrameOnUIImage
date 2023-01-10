//
//  ViewController.swift
//  imageFrame
//
//  Created by Md. Faysal Ahmed on 11/12/22.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
    @IBAction func addButtonAction(_ sender: Any) {
        var phPickerConfig = PHPickerConfiguration()
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    


}


extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: .none)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) {object, error in
                if let image = object as? UIImage {
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "EditingPage", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "EditingPage") as! EditingPageVC
                        
                        vc.selectedImage = image
                        vc.modalPresentationStyle = .fullScreen
                        
                        self.present(vc, animated: true, completion: nil)

                    }
                                        
                }
                
            }
        }
    }
    

}
