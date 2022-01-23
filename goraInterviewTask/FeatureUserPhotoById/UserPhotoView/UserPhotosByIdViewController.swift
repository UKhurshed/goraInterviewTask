//
//  UserPhotosByIdViewController.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 23.01.2022.
//

import UIKit

/// ViewController of User photo by ID
class UserPhotosByIdViewController: UIViewController {
    
    /// TableView reference
    @IBOutlet weak var photoTableView: UITableView!
    /// Progress indicator reference
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    /// Object of photoPresenter class
    private let photoPresenter = PhotoPresenter()
    /// Request response: List of PhotoViewData
    private var photos = [PhotoViewData]()
    
    /// Initialize field when navigationContoller opened
    var userId: Int = 0
    
    /// Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        photoTableView.dataSource = self
        photoTableView.delegate = self
        progress.hidesWhenStopped = true
        
        photoTableView.allowsSelection = false
        photoTableView.separatorStyle = .none
        
        photoPresenter.attachView(self)
        photoPresenter.fetchPhotos(userId: userId)
    }

}

extension UserPhotosByIdViewController: UITableViewDataSource{
    
    /// Count of data
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section
    /// - Returns: Return count of data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    /// Creating cells
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoTableViewCell
        let photo = photos[indexPath.item]
        cell.titleLabel.text = photo.title
        
        PhotoService.shared.image(imageResult: photo.imageURL){ result in
            switch result{
            case .success(let data):
                guard let img = self.defaultImage(data: data) else{
                    cell.photoView.image = UIImage(named: "not_found")!
                    return
                }
                DispatchQueue.main.async {
                    cell.photoView.image = img
                }
            case .failure(let error):
                self.presentAlertError(message: error.localizedDescription)
            }
        }
        
        return cell
    }
    
    /// Checking data and return UIImage
    /// - Parameter data: data
    /// - Returns: UIImage
    func defaultImage(data: Data?) -> UIImage?{
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage(named: "not_found")
    }
}

//Implementation all methods from Photo Presenter protocol
extension UserPhotosByIdViewController: UITableViewDelegate{
    
    /// Height for cell row
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}

extension UserPhotosByIdViewController: PhotoPresenterDelegate{
    /// Progress Bar starts
    func startLoading() {
        DispatchQueue.main.async {
            self.progress.startAnimating()
        }
    }
    
    /// Progress Bar finished
    func finishLoading() {
        DispatchQueue.main.async {
            self.progress.stopAnimating()
        }
    }
    
    /// Alert show message when catching error
    /// - Parameter message: error description
    func presentAlertError(message: String) {
        DispatchQueue.main.async {
            self.photoTableView.isHidden = false
        
        let alert  = UIAlertController(title: "Photo error occurred", message: message.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    /// Fetch photos and reload tableView
    /// - Parameter photo: [PhotoViewData]
    func fetchPhotos(photo: [PhotoViewData]) {
        self.photos = photo
        DispatchQueue.main.async {
            self.photoTableView.isHidden = false
            self.photoTableView.reloadData()
        }
    }
    
    
}


