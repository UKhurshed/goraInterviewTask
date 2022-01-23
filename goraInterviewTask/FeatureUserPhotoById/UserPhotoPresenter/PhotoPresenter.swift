//
//  PhotoPresenter.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 23.01.2022.
//

import Foundation
import UIKit

/// The structure that is needed to display specific fields from response
struct PhotoViewData{
    let title: String
    let imageURL: String
}

/// The protocol of the presenter for user photo by ID
protocol PhotoPresenterDelegate: AnyObject{
    func startLoading()
    func finishLoading()
    func presentAlertError(message: String)
    func fetchPhotos(photo: [PhotoViewData])
}

/// Implements fetching PhotoPresenter
class PhotoPresenter{
    weak var photoDelegate: PhotoPresenterDelegate?
    
    /// Initialize protocol
    /// - Parameter photoPresenter: PhotoPresenterDelegate
    func attachView(_ photoPresenter: PhotoPresenterDelegate){
        photoDelegate = photoPresenter
    }
    
    /// Detach View and nil protocol
    func detachView(){
        photoDelegate = nil
    }
    
    /// The function call methods from protocol to fetch Photos by ID from API and show to UI
    /// - Parameter userId: user ID
    public func fetchPhotos(userId: Int){
        self.photoDelegate?.startLoading()
        PhotoService.shared.getPhotos(userId: userId){ [weak self] result in
            self?.photoDelegate?.finishLoading()
            switch result {
            case .success(let photos):
                let mappedPhoto = photos.map{
                    return PhotoViewData(title: $0.title, imageURL: $0.url)
                }
                self?.photoDelegate?.fetchPhotos(photo: mappedPhoto)
            case .failure(let error):
                self?.photoDelegate?.presentAlertError(message: error.localizedDescription)
            
            }
        }
    }
    
}
