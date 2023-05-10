//
//  ViewController.swift
//  HotDog or Not!
//
//  Created by Mesut Gedik on 10.05.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // user's original unedited image selected by user
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                
                fatalError("Could not convert to UIImage into CIImage")
            }
            // detect fonksiyonunu çağırarak ciimage i aktarıyoruz
            detectImage(image:ciImage )
        }
        
       
        
        imagePicker.dismiss(animated: true,completion: nil)
            
    }
    
    func detectImage (image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                
                fatalError("Model failed to process Image.")
            }
            
            if let firstResult = results.first{
                print(firstResult)
                if firstResult.identifier.contains("hotdog") {
                    
                    print("i found The hotdog")
                    self.navigationController?.navigationBar.topItem!.title = "HotDog!"
                }else {
                    
                    print("i didnt find the hot dog")
                    self.navigationController?.navigationBar.topItem!.title = "Not Hotdog!"
                }
            }
            
//            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true,completion: nil)
        
    }
    
   
    
}

