//
//  ViewController.swift
//  photoEditor
//
//  Created by 羅承志 on 2021/8/17.
//

import UIKit
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var scaleX: Int = 1
    let aDegree = Float.pi/180
    var angle: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定照片比例為1:1
        backgroundView.bounds.size = CGSize(width: 350, height: 350)
    }
    
    //選取照片
    @IBAction func selectPhoto(_ sender: Any) {
        let alertController = UIAlertController(title: "選擇照片來源", message: "", preferredStyle: .actionSheet)
        let imagePickerController = UIImagePickerController()
        let albumAction = UIAlertAction(title: "從相簿選", style: .default) { (UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { (UIAlertAction) in imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(albumAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //儲存照片
    @IBAction func savePhoto(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: backgroundView.bounds.size)
        let imageRenderer = renderer.image { (UIGraphicsImageRendererContext) in backgroundView.drawHierarchy(in: backgroundView.bounds, afterScreenUpdates: true)
        }
        let shareActivityViewController = UIActivityViewController(activityItems: [imageRenderer], applicationActivities: nil)
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    @IBAction func selectRatio(_ sender: UISegmentedControl) {
        let length: Int = 350
        var width: Int
        var height: Int
        switch sender.selectedSegmentIndex {
        case 0: //1:1
            width = length
            height = length
        case 1: //16:9
            width = length
            height = Int(Double(length) / 16 * 9)
        case 2: //10:8
            width = length
            height = Int(Double(length) / 10 * 8)
        case 3: //7:5
            width = length
            height = Int(Double(length) / 7 * 5)
        case 4: //4:3
            width = length
            height = Int(Double(length) / 4 * 3)
        default:
            width = length
            height = length
        }
        backgroundView.bounds.size = CGSize(width: width, height: height)
    }
    
    @IBAction func flipPhoto(_ sender: Any) {
        scaleX *= -1
        photoImageView.transform = CGAffineTransform(scaleX: CGFloat(scaleX), y: 1)
    }
    
    @IBAction func SpinPhoto(_ sender: Any) {
        angle += 90
        angle = angle % 360 == 0 ? 0 : angle
        photoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(aDegree * Float(angle)))
    }
    
    @IBAction func scalePhoto(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: false)
        photoImageView.transform = CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value))
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    //完成挑選照片並展示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
