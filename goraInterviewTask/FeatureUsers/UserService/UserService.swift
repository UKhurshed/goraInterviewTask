//
//  UserService.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 22.01.2022.
//

import Foundation


/// This Service implement API call
class UserService{
    
    static let shared = UserService()
    
    /// Getting Users
    /// - Parameter callback: Result<[User], Error>
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
