//
//  ViewController.swift
//  imageFrame
//
//  Created by Md. Faysal Ahmed on 11/12/22.
//

import UIKit
import PhotosUI

class EditingPageVC: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedImage = UIImage(named: "landscape")
    var frameImage = UIImage(named: "empty")
    
    var prev: IndexPath = [0, 0]
    
    let frame = [UIImage(named: "0"),
                 UIImage(named: "1"),
                 UIImage(named: "2"),
                 UIImage(named: "3"),
                 UIImage(named: "4"),
                 UIImage(named: "5"),
                 UIImage(named: "6")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.image = selectedImage!
        setupCollectionView()
    }
    
    
    
    func setupCollectionView() {
        let nib = UINib(nibName: "FrameCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    // MARK: -
    @IBAction func doneAction(_ sender: Any) {
        var bottomImage = selectedImage
        var topImage = frameImage

        var size = CGSize(width: 300, height: 300)
        
        
        UIGraphicsBeginImageContext(size)   // Writing image has started

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage!.draw(in: areaSize)

        topImage!.draw(in: areaSize, blendMode: .normal, alpha: 0.8)

        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()         // Writing image has ended
        
        
        let storyboard = UIStoryboard(name: "NewImageVC", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewImageVC") as! NewImageVC
        
        vc.newImg = newImage
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageFrame(_ imageFrame: UIImage) {
        let image = selectedImage!
        selectedImage = image
        let aspectRatio = image.size.height / image.size.width
        
        let aspectRatioConstraint = NSLayoutConstraint(item: userImageView,attribute: .height, relatedBy: .equal, toItem: userImageView, attribute: .width, multiplier: aspectRatio, constant: 0)
        
        userImageView.image = image
        userImageView.addConstraint(aspectRatioConstraint)
        
        frameImageView.image = imageFrame
    }


}


extension EditingPageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return frame.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FrameCollectionViewCell
        cell.img.image = frame[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            frameImage = UIImage(named: "empty")
            imageFrame(frameImage!)
        }
        else {
            frameImage = frame[indexPath.row]
            imageFrame(frameImage!)
        }
        
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 5

        } else { return }
        
        if let cell = collectionView.cellForItem(at: prev) {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
            prev = indexPath

        } else { return }
        
    }
    
    
    
}



extension EditingPageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90.0, height: 90.0)
    }
    
    
}


extension EditingPageVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: .none)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) {object, error in
                if let image = object as? UIImage {
                    self.selectedImage = image
                }
                
            }
        }
    }
    

}
