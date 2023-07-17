//
//  JSONManager.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/17.
//

import Foundation

class JSONManager {
    static let shared = JSONManager()
    
    private init() { }
    
    var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
    func decodeListData<T: Decodable>(_ data: Data) throws -> [T] {
        let modelDTO = try self.decoder.decode([T].self, from: data)
        return modelDTO
    }
    
    func decodeSingleData<T: Decodable>(_ data: Data) throws -> T {
        let modelDTO = try self.decoder.decode(T.self, from: data)
        return modelDTO
    }
}
