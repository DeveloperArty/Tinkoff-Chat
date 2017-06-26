//
//  PixabayImageProvider.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 14.05.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit

class PixabayImageProvider {
    
    let urlString = "https://pixabay.com/api/?key=5364482-bde7a9746d5d9fe549c72899b&editors_choice=true&image_type=photo"

    func getPicUrls() -> [URL]? {
        self.performRequest() { data in
            let urls = self.parseResponce(data: data) 
        }
        return nil
    }
    
    func performRequest(parseHandler: @escaping (Data?) -> Void ) {
        if let url = URL.init(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, responce: URLResponse?, error: Error?) in
                guard error == nil else { return }
                parseHandler(data)
            }
            print("resuming Task")
            task.resume()
        }
    }
    
    func parseResponce(data: Data?) -> [URL] {
        var imageUrls = [URL]()
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data,
                                                               options: []) as? [String: Any] {
                    if let totalHits = json["totalHits"] as? Int,
                    let hits = json["hits"] as? [Any] {
                        
                        for i in 0...19 {
                            if let imageDescription = hits[i] as? [String: Any] {
                                if let urlString = imageDescription["pageURL"] as? String {
                                    if let url = URL.init(string: urlString) {
                                        imageUrls.append(url)
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        print(imageUrls.count)
        return imageUrls
    }
}
