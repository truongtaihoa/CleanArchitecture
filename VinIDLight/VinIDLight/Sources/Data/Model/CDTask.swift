//
//  CDTask.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import CoreData

final class CDTask: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var isDone: Bool
}

extension CDTask: DomainConvertibleType {
    
    func asDomain() -> Task {
        
        return Task(id: id, title: title, isDone: isDone)
    }
}
