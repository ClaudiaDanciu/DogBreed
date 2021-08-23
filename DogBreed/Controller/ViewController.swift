//
//  DogsEndpoints.swift
//  DogBreed
//
//  Created by Claudia Danciu on 19/08/2021.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var headerView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    var dogListBreeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.dataSource = self
        pickerView.delegate = self
        self.pickerView.layer.cornerRadius = 20;
        self.imageView.layer.cornerRadius  = 20
        
        // accessibility
        
        self.headerView.accessibilityLabel = title
        self.headerView.adjustsFontForContentSizeCategory
            = true
        self.imageView.accessibilityLabel = imageView.description
        self.pickerView.accessibilityLabel = pickerView.description
        
        DogsEndpoints.listBreedRequired(completionHandler: handleBreedsListResponse(dogListBreeds:error:))
    }
    
    func handleBreedsListResponse(dogListBreeds: [String], error: Error?) {
        self.dogListBreeds = dogListBreeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func handleRandomImageResponse(imageData: DogsImages?, error: Error?) {
        guard let imageURL = URL(string: imageData?.message ?? "") else {
            return
        }
        DogsEndpoints.imageDogsRequired(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
        
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dogListBreeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dogListBreeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogsEndpoints.imageDogRequired(breed: dogListBreeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
    
}
