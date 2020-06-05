//
//  Data.swift
//  Lifetool
//
//  Created by 范艺晨 on 2020/3/28.
//  Copyright © 2020 SUESiOSClub. All rights reserved.
//

import Foundation
import SwiftUI


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func load<T: Decodable>(_ data: Data) -> T? {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Couldn't parse data as \(T.self):\n\(error)")
        return nil
    }
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(verbatim: name))
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

func post(url:URL,parameters:[String:String?],completionHandler:@escaping (DataResponse?,Error?)->Void){
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    if let httpBody = try? JSONEncoder().encode(parameters){
        request.httpBody = httpBody
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        guard let data = data,
            let response = response as? HTTPURLResponse,
            error == nil else {                        // check for fundamental networking error
                print("error", error ?? "Unknown error")
                let decodedData = DataResponse(execOKOrNotFlag: "0")
                completionHandler(decodedData, error)
                return
        }

        guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
            print("statusCode should be 2xx, but is \(response.statusCode)")
            print("response = \(response)")
            let decodedData = DataResponse(execOKOrNotFlag: "0")
            completionHandler(decodedData, error)
            return
        }
        
        if let decodedData:DataResponse = load(data) {
            completionHandler(decodedData, nil)
        } else {
            let decodedData = DataResponse(execOKOrNotFlag: "0")
            completionHandler(decodedData, nil)
        }
    }
    task.resume()
}

