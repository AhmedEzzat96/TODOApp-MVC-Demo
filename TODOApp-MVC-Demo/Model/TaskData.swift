//
//  TaskData.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 10/30/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct TaskData: Codable {
    let completed: Bool
    let id: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case completed, description
        case id = "_id"
    }
}
