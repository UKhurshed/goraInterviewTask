//
//  UserPresenter.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 21.01.2022.
//

import Foundation
import UIKit

protocol UserPresenterDelegate: AnyObject{
    func fetchUsers(users: [User])
    func presentAlert(title: String, message: String)
}

typealias PresenterDelegate = UserPresenterDelegate & UIViewController

class UserPresenter{
    weak var delegate: PresenterDelegate?
    
    public func getUsers(){
        guard let url  = URL(string: "https://jsonplaceholder.typicode.com/users") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else{
                debugPrint("Error from data or error=\(String(describing: error))")
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self?.delegate?.fetchUsers(users: users)
                
            }catch let error{
                debugPrint("Couldn't parse JSON:\(error)")
                return
            }
        }
        task.resume()
    }
    
    public func setViewDelegate(delegate: PresenterDelegate){
        self.delegate = delegate
    }
}
