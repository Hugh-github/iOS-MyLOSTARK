//
//  DefaultSearchRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/21.
//

protocol DefaultRecentSearchRepository {
    func create(_ search: RecentCharacterInfo)
    func delete(_ search: RecentCharacterInfo)
    func deleteAll()
}
