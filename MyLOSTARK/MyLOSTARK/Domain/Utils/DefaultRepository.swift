//
//  DefaultRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/15.
//

protocol DefualtRepository {
    associatedtype T
    
    func fetch() async -> [T]
}
