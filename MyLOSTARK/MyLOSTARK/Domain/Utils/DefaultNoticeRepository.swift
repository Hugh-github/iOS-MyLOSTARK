//
//  DefaultNoticeRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/20.
//

protocol DefaultNoticeRepository {
    func fetch(_ type: NoticeType) async throws -> [Notice]
}
