//
//  DogsEndpoints.swift
//  DogBreed
//
//  Created by Claudia Danciu on 19/08/2021.
//

import Foundation
import UIKit

class DogsEndpoints {
    enum Endpoint {
        case imageDogs
        case imageBreed(String)
        case listBreed
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .imageDogs:
                return "https://dog.ceo/api/breeds/image/random"
            case .imageBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listBreed:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func imageDogsRequired(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let imageResponse = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let handledImage = UIImage(data: data)
            completionHandler(handledImage, nil)
        })
        imageResponse.resume()
    }
    
    class func imageDogRequired(breed: String, completionHandler: @escaping (DogsImages?, Error?) -> Void) {
        let imageDogRequired = DogsEndpoints.Endpoint.imageBreed(breed).url
        let imageResponse = URLSession.shared.dataTask(with: imageDogRequired) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogsImages.self, from: data)
            print(imageData)
            completionHandler(imageData, nil)
        }
        imageResponse.resume()
    }
    
    class func listBreedRequired(completionHandler: @escaping ([String], Error?) -> Void) {
        let listResponse = URLSession.shared.dataTask(with: Endpoint.listBreed.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let listBreedRequired = try! decoder.decode(DogsImageList.self, from: data)
            let dogListBreeds = listBreedRequired.message.keys.map({$0})
            completionHandler(dogListBreeds, nil)
            
        }
        listResponse.resume()
    }
    
}
