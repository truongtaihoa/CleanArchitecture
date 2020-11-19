//
//  DomainConvertibleType.swift
//  VinIDLight
//
//  Created by Truong Huu Hoa on 11/18/20.
//  Copyright © 2020 VinID. All rights reserved.
//

import Foundation

protocol DomainConvertibleType {
    
    associatedtype DomainType
    
    func asDomain() -> DomainType
}
