//
//  SearchTaskUseCase.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/17/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchTaskUseCaseType {
    
    func execute(query: String) -> Observable<[Task]>
}

class SearchTaskUseCase: SearchTaskUseCaseType {
    
    let repository: TaskRepositoryType
    
    init(repository: TaskRepositoryType) {
        
        self.repository = repository
    }
    
    func execute(query: String) -> Observable<[Task]> {
        
        return Observable<String>.just(query)
            .flatMap { [unowned self] query -> Observable<[Task]> in
                
                if query.isEmpty {
                    
                    return self.repository.getAllTasks()
                }
                
                return self.repository.getTasks(query: query)
            }
    }
}
