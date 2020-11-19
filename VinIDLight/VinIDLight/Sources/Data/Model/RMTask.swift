//
//  RMTask.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RealmSwift

final class RMTask: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension RMTask: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case isDone = "is_done"
    }
}

extension RMTask: DomainConvertibleType {
    
    func asDomain() -> Task {
        return Task(id: id, title: title, isDone: isDone)
    }
}
