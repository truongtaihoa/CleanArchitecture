//
//  AppComponent.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation
import RIBs

class AppComponent: Component<EmptyDependency>, TaskListDependency {
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
