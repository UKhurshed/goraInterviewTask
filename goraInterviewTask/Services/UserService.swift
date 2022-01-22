//
//  UserService.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 22.01.2022.
//

import Foundation


class UserService{
    func getUsers(_ callback: @escaping (Result<[User], Error>) -> Void){
        guard let url  = URL(string: "https://jsonplaceholder.typicode.com/users") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                callback(.failure(error))
            }else if let data = data {
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                callback(.success(users))
                
            }catch let error{
                debugPrint("Couldn't parse JSON:\(error)")
                callback(.failure(error))
                return
            }
            }
        }
        task.resume()
    }
}

/*
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
 */
