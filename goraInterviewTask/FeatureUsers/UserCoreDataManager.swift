//
//  UserCoreDataManager.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 02.02.2022.
//

import Foundation
import CoreData

class UserCoreDataManager{
    
    static let shared = UserCoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                debugPrint("Error in loadPersistentStores: \(error)")
            }
        })
        return container
    }()
    
    lazy var viewContext = persistentContainer.viewContext
    
    
    func saveContext(){
        do{
            try viewContext.save()
        }catch {
            debugPrint("Error from saveContext: \(error)")
        }
    }
    
    func createUser(userNames: [UserViewData]){
//        guard let entity = NSEntityDescription.entity(forEntityName: "UserModel", in: viewContext) else { return }
        for userName in userNames{
            let newUser = UserEntity(context: viewContext)
            newUser.name = userName.name
        }
        saveContext()
    }
    
    func fetchUserDB(completed: @escaping (Result<[UserEntity], Error>) -> Void){
        let fetchUserRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        var userEntity = [UserEntity]()
        do {
            if let fetchResult = try viewContext.fetch(fetchUserRequest) as? [UserEntity]{
                for data in fetchResult{
                    userEntity.append(data)
                }
                completed(.success(userEntity))
            }
            
        }catch{
            print(error)
            completed(.failure(error))
        }
    }
    
    
}
