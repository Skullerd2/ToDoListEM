//
//  TaskModel.swift
//  ToDoListEM
//
//  Created by Vadim on 20.11.2024.
//

import Foundation

struct TaskModel{
    let todos: [ToDoS]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ToDoS{
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
