//
//  GetAllTasksUseCase.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol GetAllTasksUseCaseType {
    
    func execute() -> Observable<[Task]>
}

class GetAllTasksUseCase: GetAllTasksUseCaseType {
    
    let repository: TaskRepositoryType
    
    init(repository: TaskRepositoryType) {
        
        self.repository = repository
    }
    
    func execute() -> Observable<[Task]> {
        
        return  self.repository.getAllTasks()
    }
}
