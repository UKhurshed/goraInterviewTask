//
//  UserCoreDataManager.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 02.02.2022.
//

import Foundation
import CoreData

class UserCoreDataManager{
    
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
}
