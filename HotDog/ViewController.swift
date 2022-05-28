//  Sabah Naveed
//  ViewController.swift
//  HotDog
//
//  Created by Sabah Naveed on 4/3/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage //image user picks
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("could not convert to ciimage")
            } //converted into ciimage
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreml model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")}
            print(results)
            
            if let firstresult = results.first {
                if firstresult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog ✅"
                    self.navigationController?.navigationBar.backgroundColor = UIColor.green
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
                } else {
                    self.navigationItem.title = "Not Hotdog ❎"
                    self.navigationController?.navigationBar.backgroundColor = UIColor.red
                    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

