//
//  ViewController.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 20.01.2022.
//

import UIKit

/// ViewController of User
class UserViewController: UIViewController {
    
    /// TableView reference
    @IBOutlet weak var tableView: UITableView!
    /// Progress indicator reference
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    /// Object of userPresenter class
    private let presenter = UserPresenter()
    /// Request response: List of UserViewData
    private var users = [UserViewData]()
    
    /// Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        tableView.delegate = self
        tableView.dataSource = self
        progress.hidesWhenStopped = true
        
        presenter.attachView(self)
        presenter.getUsers()
    }

}

extension UserViewController: UITableViewDataSource{
    /// Count of data
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section
    /// - Returns: Return count of data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    /// Creating cells
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        cell.accessoryType = .disclosureIndicator   
        return cell
    }

}

extension UserViewController: UITableViewDelegate{
    /// When User touch element from tableView and open another Screen
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoById") as? UserPhotosByIdViewController{
            viewController.userId = indexPath.row + 1
            if let navigator = navigationController{
                navigator.pushViewController(viewController, animated: true)
            }
        }
        debugPrint("Index: \(indexPath.row)")
    }
}

// Implementation all methods from User Presenter protocol
extension UserViewController: UserPresenterDelegate{
    
    /// Alert show message when catching error
    /// - Parameter message: error description
    func presentAlertError( message: String) {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
        
        let alert  = UIAlertController(title: "Error occurred", message: message.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
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
    
    /// Fetch users and reload tableView
    /// - Parameter users: userViewData
    func fetchUsers(users: [UserViewData]) {
        self.users = users
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}

