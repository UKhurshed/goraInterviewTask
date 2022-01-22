//
//  UserPresenter.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 21.01.2022.
//

import Foundation
import UIKit

struct UserViewData{
    let name: String
}

protocol UserPresenterDelegate: AnyObject{
    func startLoading()
    func finishLoading()
    func fetchUsers(users: [UserViewData])
//    func setEmptyUsers()
    func presentAlertError(message: String)
}

//typealias PresenterDelegate = UserPresenterDelegate & UIViewController

class UserPresenter{
    weak var delegate: UserPresenterDelegate?
    let userService: UserService
    
    init(userService: UserService){
        self.userService = userService
    }
    
    func attachView(_ userPresenter: UserPresenterDelegate){
        delegate = userPresenter
    }
    
    func detachView(){
        delegate = nil
    }
    
    public func getUsers(){
        self.delegate?.startLoading()
        userService.getUsers{ [weak self] result in
        self?.delegate?.finishLoading()
            switch result{
            case .success(let users):
                let mappedUsers = users.map{
                    return UserViewData(name: $0.name)
                }
                self?.delegate?.fetchUsers(users: mappedUsers)
            case .failure(let error):
                self?.delegate?.presentAlertError(message: error.localizedDescription )
            }
        }
    }
}
