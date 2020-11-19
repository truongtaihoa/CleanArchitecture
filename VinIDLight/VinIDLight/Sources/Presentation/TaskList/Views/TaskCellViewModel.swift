//
//  TaskCellViewModel.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

struct TaskCellViewModel {
    
    let title: String
    let iconImage: UIImage?
    
    let task: Task
    
    init(task: Task) {
        
        title = task.title
        iconImage = UIImage(named: (task.isDone ? "checkbox_checked" : "checkbox_unchecked"))
        
        self.task = task
    }
}

extension TaskCellViewModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        return lhs.title == rhs.title && lhs.iconImage == rhs.iconImage
    }
}

extension TaskCellViewModel: IdentifiableType {
    var identity: String {
        return task.id
    }
}
