//
//  ViewController.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 20.01.2022.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let presenter = UserPresenter()
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        
        presenter.setViewDelegate(delegate: self)
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
    func fetchUsers(users: [User]) {
        self.users = users
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func presentAlert(title: String, message: String) {
        
    }
    
    
}

