//
//  PhotoService.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 23.01.2022.
//

import Foundation

/// This PhotoService implement API fetching photo by userID and cached images
class PhotoService{
    
    /// NSCache
    private var images = NSCache<NSString, NSData>()
    
    static let shared = PhotoService()
    
    /// Get photos by userID
    /// - Parameters:
    ///   - userId: userID - Int
    ///   - completed: Result<[Photo], Error>
    func getPhotos(userId: Int, _ completed: @escaping (Result<[Photo], Error>) -> Void){
        guard let url  = URL(string: "https://jsonplaceholder.typicode.com/photos") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){ data, respose, error in
                if let error = error {
                    completed(.failure(error))
                }else if let data = data {
                do {
                    let photos = try JSONDecoder().decode([Photo].self, from: data)
                    let filteredById = photos.filter{ photo in
                        return photo.albumID == userId
                    }
                    debugPrint(filteredById.count)
                    completed(.success(filteredById))
                    
                }catch let error{
                    debugPrint("Couldn't parse JSON:\(error)")
                    completed(.failure(error))
                    return
                }
                }
            }
            task.resume()
    }
    
    /// Public func for caching image
    /// - Parameters:
    ///   - imageResult: imageUrl
    ///   - completion: completion Result<Data, Error>
    func image(imageResult: String, completion: @escaping (Result<Data?, Error>) -> Void){
        let url = URL(string: imageResult)!
        cacheImage(imageURL: url, completion: completion)
    }
    
    /// If image cached return image from cache, otherwise save to cache and return image
    /// - Parameters:
    ///   - imageURL: imageUrl
    ///   - completion: completion Result<Data, Error>
    private func cacheImage(imageURL: URL, completion: @escaping(Result<Data?, Error>) -> Void){
        if let imageData = images.object(forKey: imageURL.absoluteString as NSString){
            debugPrint("Using cached images")
            completion(.success(imageData as Data))
            return
        }
        
        let task = URLSession.shared.downloadTask(with: imageURL){ localUrl, response, error in
            if let error = error{
                debugPrint("Error in downloadTask: \(error)")
                completion(.failure(error))
            }
            
            guard let localUrl = localUrl else {
                completion(.failure(localUrl?.absoluteString as! Error))
                return
            }
            do {
                let data = try Data(contentsOf: localUrl)
                self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(.success(data))
            }catch let error{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
