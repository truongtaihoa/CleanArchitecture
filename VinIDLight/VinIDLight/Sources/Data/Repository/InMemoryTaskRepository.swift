//
//  TaskRepository.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

class InMemoryTaskRepository {
    
    var tasks: [Task] = []
}

extension InMemoryTaskRepository: TaskRepositoryType {
    
    func getAllTasks() -> Observable<[Task]> {
        
        return Observable.just(tasks)
    }
    
    func getTasks(query: String) -> Observable<[Task]> {
        
        return Observable.just(tasks.filter { $0.title.lowercased().contains(query.lowercased()) })
    }
    
    func insertTask(title: String, isDone: Bool) -> Observable<Task> {
        
        let id = UUID().uuidString
        let task = Task(id: id, title: title, isDone: isDone)
        tasks.append(task)
        
        return Observable.just(task)
    }
    
    func isExistTask(title: String) -> Observable<Bool> {
        
        let isExist = tasks.filter { $0.title.lowercased() == title.lowercased() }.count > 0
        
        return Observable.just(isExist)
    }
    
    func deleteTask(_ task: Task) -> Observable<Bool> {
        
        tasks.removeAll { $0.id == task.id }
        
        return Observable.just(true)
    }
    
    func deleteAllTasks() -> Observable<Bool> {
        
        tasks.removeAll()
        
        return Observable.just(true)
    }
    
    func updateTask(_ task: Task) -> Observable<Task> {
        
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            
            tasks[index] = task
        }

        return Observable.just(task)
    }
}
