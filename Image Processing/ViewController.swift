//
//  ViewController.swift
//  Image Processing
//
//  Created by Syed  Rafay on 26/09/2018.
//  Copyright © 2018 Syed  Rafay. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
     var imagePicker = UIImagePickerController()
    var widthcoordinatesOfLabel:CGFloat?
    var heightcoordinatesOfLabel:CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: self.imageView.bounds.width/2 - 25, y: self.imageView.bounds.height/2 - 25, width: 50, height: 50))
        label.backgroundColor = UIColor.clear
//        label.layer.borderColor = .black
        label.layer.borderWidth = 2
        self.view.addSubview(label)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.wasDragged(_:)))
        label.addGestureRecognizer(gesture)
        label.isUserInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func wasDragged(_ gesture: UIPanGestureRecognizer){
        
        var translation = gesture.translation(in: self.imageView)
        let label = gesture.view!
        translation.x = max(translation.x, imageView.frame.minX - label.frame.minX)
        translation.x = min(translation.x, imageView.frame.maxX - label.frame.maxX)
        
        translation.y = max(translation.y, imageView.frame.minY - label.frame.minY)
        translation.y = min(translation.y, imageView.frame.maxY - label.frame.maxY)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
        
        widthcoordinatesOfLabel = label.frame.width
        heightcoordinatesOfLabel = label.frame.height
        
    }

    @IBOutlet weak var getColour: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func getColourPressed(_ sender: Any) {
    
        if imageView.image != nil {
            
            print("\(self.findColors(imageView.image!))")
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Please select an Image", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func addAphotoPressed(_ sender: Any) {
       
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: { () -> Void in
//
//        })
//
//        imageView.image = image
//    }
//
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func findColors(_ image: UIImage) -> [UIColor] {
        let pixelsWide = Int(widthcoordinatesOfLabel!)
        let pixelsHigh = Int(heightcoordinatesOfLabel!)
        
        guard let pixelData = image.cgImage?.dataProvider?.data else { return [] }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var imageColors: [UIColor] = []
        for x in 0..<pixelsWide {
            for y in 0..<pixelsHigh {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((pixelsWide * Int(point.y)) + Int(point.x)) * 4
                let color = UIColor(red: CGFloat(data[pixelInfo]) / 255.0,
                                    green: CGFloat(data[pixelInfo + 1]) / 255.0,
                                    blue: CGFloat(data[pixelInfo + 2]) / 255.0,
                                    alpha: CGFloat(data[pixelInfo + 3]) / 255.0)
                imageColors.append(color)
            }
        }
        return [imageColors[0]]
    }
    
}

