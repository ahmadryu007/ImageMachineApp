//
//  DetailMachineDataViewController.swift
//  Image Machine
//
//  Created by User on 28/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit

class DetailMachineDataViewController: UIViewController, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var selectedMachineData: MachineDataStruct!
    private var textLabel: UITextView!
    private var collectionImage: UICollectionView!
    public var listImage: [UIImage] = [UIImage]()
    private let cellid = "cellCollectionImage"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        view.backgroundColor = UIColor.clear
        
        let detailMachine = UIView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: 300))
        detailMachine.layer.cornerRadius = 10
        detailMachine.layer.masksToBounds = true
        detailMachine.backgroundColor = UIColor.white
        
        textLabel = UITextView(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: 30))
        textLabel.isEditable = false
        textLabel.text = "Machine ID \t\t : \(selectedMachineData.machineId!)"
        detailMachine.addSubview(textLabel)
        
        textLabel = UITextView(frame: CGRect(x: 0, y: 35, width: view.frame.width, height: 30))
        textLabel.isEditable = false
        textLabel.text = "Machine Name \t : \(selectedMachineData.machineName!)"
        detailMachine.addSubview(textLabel)
        
        textLabel = UITextView(frame: CGRect(x: 0, y: 65, width: view.frame.width, height: 30))
        textLabel.isEditable = false
        textLabel.text = "Machine Type \t\t : \(selectedMachineData.machineType!)"
        detailMachine.addSubview(textLabel)
        
        textLabel = UITextView(frame: CGRect(x: 0, y: 95, width: view.frame.width, height: 30))
        textLabel.isEditable = false
        textLabel.text = "Machine Number \t : \(selectedMachineData.machineNumber!)"
        detailMachine.addSubview(textLabel)
        
        textLabel = UITextView(frame: CGRect(x: 0, y: 125, width: view.frame.width, height: 30))
        textLabel.isEditable = false
        textLabel.text = "Last Maintenance \t : 2018-11-28"
        detailMachine.addSubview(textLabel)
        
        let buttonImage = UIButton(frame: CGRect(x: 10, y: 165, width: detailMachine.frame.width - 15, height: 40))
        buttonImage.layer.cornerRadius = 5
        buttonImage.layer.masksToBounds = true
        buttonImage.setTitle("Machine Image", for: .normal)
        buttonImage.backgroundColor = .blue
        buttonImage.addTarget(self, action: #selector(machineImagePick(sender:)), for: .touchUpInside)
        detailMachine.addSubview(buttonImage)
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionImage = UICollectionView(frame: CGRect(x: 0, y: 310, width: view.frame.width, height: view.frame.height - 210), collectionViewLayout: collectionLayout)
        collectionImage.alwaysBounceVertical = true
        collectionImage.dataSource = self
        collectionImage.delegate = self
        collectionImage.register(ImageCollectionCell.self, forCellWithReuseIdentifier: cellid)
        collectionImage.backgroundColor = .white
        
        
        let defaults = UserDefaults.standard
        let storedImage = defaults.imageForKey(key: selectedMachineData.machineNumber!.stringValue)
        
        if (storedImage != nil){
            listImage.append(storedImage!)
        }
        
        view.addSubview(detailMachine)
        view.addSubview(collectionImage)
    }
    
    @objc func machineImagePick(sender: UIButton){
        
        if (listImage.count < 10){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            
            let alert = UIAlertController(title: "Warning", message: "You just can select max 10 image", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.listImage.append(image)
            self.collectionImage.reloadData()
            
            let defaults = UserDefaults.standard
            defaults.setImage(image: image, forKey: self.selectedMachineData.machineNumber!.stringValue)
            defaults.synchronize()
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listImage.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? ImageCollectionCell
        if (cell == nil){
            cell = ImageCollectionCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        
        cell?.setupView(imageData: self.listImage[indexPath.row])
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Detail Image", message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
            let index = indexPath.row
            self.listImage.remove(at: index )
            alert.dismiss(animated: true, completion: nil)
            self.collectionImage.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.addImage(image: self.listImage[indexPath.row])
        
        self.present(alert, animated: true, completion: nil)
        
    }

}

class ImageCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setupView(imageData: UIImage){
        
        let imageView = UIImageView(frame: contentView.frame)
        imageView.image = imageData
        
        contentView.addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension UIAlertController {
    
    func addImage(image: UIImage){
        
        let maxSize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        
        var ratio: CGFloat!
        
        if (imgSize.width > imgSize.height){
            ratio = maxSize.width / imgSize.width
        } else {
            ratio = maxSize.height / imgSize.height
        }
        
        let scaledSize = CGSize(width: imgSize.width * ratio, height: imgSize.height * ratio)
        let resizedImage = image.resizeImage(targetSize: scaledSize)
        
        let action = UIAlertAction(title: "", style: .default, handler: nil)
        action.isEnabled = false
        action.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(action)
        
    }
    
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension UserDefaults {
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
}
