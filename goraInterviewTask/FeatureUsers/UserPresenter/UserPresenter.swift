//
//  UserPresenter.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 21.01.2022.
//

import Foundation
import UIKit

/// The structure that is needed to display specific fields from response
struct UserViewData{
    let name: String
}

/// The main protocol of the presenter
protocol UserPresenterDelegate: AnyObject{
    func startLoading()
    func finishLoading()
    func fetchUsers(users: [UserViewData])
    func presentAlertError(message: String)
}

/// Implements fetching User 
class UserPresenter{
    weak var delegate: UserPresenterDelegate?
    
    /// Initialize protocol
    /// - Parameter userPresenter: The protocol of UserPresenter
    func attachView(_ userPresenter: UserPresenterDelegate){
        delegate = userPresenter
    }
    
    
    /// Detach View and nil protocol
    func detachView(){
        delegate = nil
    }
    
    /// The function call methods from protocol to fetch Users from API and show to UI
    public func getUsers(){
        self.delegate?.startLoading()
        UserCoreDataManager.shared.fetchUserDB(completed: { [weak self] entityResult in
            self?.delegate?.finishLoading()
            switch entityResult{
            case .success(let userEntity):
                if userEntity.count > 0 {
                    debugPrint("fetched from DB")
                    let mappedUsers = userEntity.map{
                        return UserViewData(name: $0.name ?? "current name")
                    }
                    self?.delegate?.fetchUsers(users: mappedUsers)
                }else{
                    debugPrint("fetched from API")
                    self?.fetchUsersFromAPI()
                }
            case .failure(let error):
                self?.delegate?.presentAlertError(message: error.localizedDescription)
            }
        })

    }

    private func fetchUsersFromAPI(){
            UserService.shared.getUsers{ [weak self] result in
            self?.delegate?.finishLoading()
                switch result{
                case .success(let users):
                    let mappedUsers = users.map{
                        return UserViewData(name: $0.name)
                    }
                    UserCoreDataManager.shared.createUser(userNames: mappedUsers)
                    self?.delegate?.fetchUsers(users: mappedUsers)
                case .failure(let error):
                    self?.delegate?.presentAlertError(message: error.localizedDescription )
                }
            }
        }
}
