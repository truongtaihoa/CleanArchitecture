//
//  CreateTaskUseCase.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol CreateTaskUseCaseType {
    
    func execute(query: String, title: String) -> Observable<[Task]>
}

enum CreateTaskError: String, Error {
    
    case titleIsEmpty
    case titleIsExist
}

class CreateTaskUseCase: CreateTaskUseCaseType {
    
  
    let repository: TaskRepositoryType
    
    init(repository: TaskRepositoryType) {
        
        self.repository = repository
    }

    func execute(query: String, title: String) -> Observable<[Task]> {
        
        return Observable<String>.just(title)
            .flatMap { [unowned self] title -> Observable<Bool> in
                
                if title.isEmpty {
                    return Observable.error(CreateTaskError.titleIsEmpty)
                }
                
                return self.repository.isExistTask(title: title)
            }
            .flatMap { [unowned self] isExist -> Observable<Task> in
                
                if isExist {
                    return Observable.error(CreateTaskError.titleIsExist)
                }
                
                return self.repository.insertTask(title: title, isDone: false)
            }
            .flatMap { [unowned self] _ -> Observable<[Task]> in
                
                if query.isEmpty {
                    
                    return self.repository.getAllTasks()
                }
                
                return self.repository.getTasks(query: query)
            }
    }
}
