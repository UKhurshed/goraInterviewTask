//
//  ViewController.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 20.01.2022.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    private let presenter = UserPresenter(userService: UserService())
    private var users = [UserViewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        tableView.delegate = self
        tableView.dataSource = self
        progress.hidesWhenStopped = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        
        presenter.attachView(self)
        presenter.getUsers()
    }

}

extension UserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        cell.accessoryType = .disclosureIndicator   
        return cell
    }

}

extension UserViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint("Index: \(indexPath.row)")
    }
}

extension UserViewController: UserPresenterDelegate{
    
    func presentAlertError( message: String) {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
        
        let alert  = UIAlertController(title: "Error occurred", message: message.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.progress.startAnimating()
        }
    }
    
    func finishLoading() {
        DispatchQueue.main.async {
            self.progress.stopAnimating()
        }
        
    }
    
    func fetchUsers(users: [UserViewData]) {
        self.users = users
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}

