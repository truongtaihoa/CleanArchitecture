//
//  RealmTaskRepository.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class RMTaskRepository {
    
    var tasks: [Task] = []
    
    func workerRealm() -> Realm {
        
        do {
            
            return try Realm()
        } catch {
            
            fatalError(String(describing: error))
        }
    }
}

extension RMTaskRepository: TaskRepositoryType {
    
    func getAllTasks() -> Observable<[Task]> {
        
        let results = Array(workerRealm().objects(RMTask.self))
        let tasks = results.map { $0.asDomain() }
        return Observable.just(tasks)
    }
    
    func getTasks(query: String) -> Observable<[Task]> {
        
        let results = Array(workerRealm().objects(RMTask.self))
        let tasks = results.map { $0.asDomain() }.filter { $0.title.lowercased().contains(query.lowercased()) }
        return Observable.just(tasks)
    }
    
    func insertTask(title: String, isDone: Bool) -> Observable<Task> {
        
        let task = RMTask()
        task.id = UUID().uuidString
        task.title = title
        task.isDone = isDone
        
        try! workerRealm().write {
            workerRealm().add(task)
        }
        
        return Observable.just(task.asDomain())
    }
    
    func isExistTask(title: String) -> Observable<Bool> {
        
        let isExist = workerRealm().objects(RMTask.self).filter { $0.title.lowercased() == title.lowercased() }.count > 0
        return Observable.just(isExist)
    }
    
    func deleteTask(_ task: Task) -> Observable<Bool> {
        
        if let object = workerRealm().objects(RMTask.self).filter({ $0.id == task.id }).first {
            try! workerRealm().write {
                workerRealm().delete(object)
            }
            
            return Observable.just(true)
        }
        
        return Observable.just(false)
    }
    
    func deleteAllTasks() -> Observable<Bool> {
        
        let results = workerRealm().objects(RMTask.self)
        try! workerRealm().write {
            workerRealm().delete(results)
        }
        
        return Observable.just(true)
    }
    
    func updateTask(_ task: Task) -> Observable<Task> {
        
        let object = RMTask()
        object.id = task.id
        object.title = task.title
        object.isDone = task.isDone
        
        try! workerRealm().write {
            workerRealm().add(object, update: .modified)
        }
        
        return Observable.just(task)
    }
}
