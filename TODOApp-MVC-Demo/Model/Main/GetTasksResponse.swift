//
//  AddTaskResponse.swift
//  TODOApp-MVC-Demo
//
//  Created by Ahmed Ezzat on 10/30/20.
//  Copyright © 2020 IDEAEG. All rights reserved.
//

import Foundation

struct GetTasksResponse: Codable {
    let count: Int
    let data: [TaskData]
    
    enum CodingKeys: String, CodingKey {
        case count, data
    }
}
