//
//  APIServiceTest.swift
//  APIServiceTest
//
//  Created by dhoney96 on 2023/07/18.
//

import XCTest

final class APIServiceTest: XCTestCase {
    var networkManager: NetworkManager? = nil
    var apiService: LOSTARKAPIService? = nil

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.networkManager = NetworkManager(urlSession: MockURLSession(statusCode: 200))
        self.apiService = LOSTARKAPIService(networkManager: self.networkManager!)
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        self.networkManager = nil
        self.apiService = nil
    }
    
    func test_success_get_EventList() async throws {
        // given
        let expectation = XCTestExpectation(description: "APIServiceExpectation")
        let result = [
            EventDTO(
                title: "소울이터 사전등록",
                thumbnail: "https://cdn-lostark.game.onstove.com/uploadfiles/banner/5765b4f7954a4d6f9a32ba13772b8852.jpg",
                link: "https://lostark.game.onstove.com/Promotion/Reservation/230705",
                startDate: "2023-07-05T06:00:00",
                endDate: "2023-07-19T06:00:00"
            ),
            EventDTO(
                title: "2023 썸머 POINT 빙고",
                thumbnail: "https://cdn-lostark.game.onstove.com/uploadfiles/banner/d8cc023db09e427e9ebd708076c09fbb.jpg",
                link: "https://lostark.game.onstove.com/Promotion/Bingo/230628",
                startDate: "2023-06-28T06:00:00",
                endDate: "2023-07-26T06:00:00"
            )
        ]
        
        // when
        let response = try await apiService!.getEventList()
        expectation.fulfill()

        print(response)
        // then
        XCTAssertEqual(result, response)
    }
    
    func test_failure_get_EventList_By_ClientError() async {
        // given
        let expectation = XCTestExpectation(description: "APIServiceExpectation")
        let clientError = NetworkError.clientError
        
        // when
        self.networkManager = NetworkManager(urlSession: MockURLSession(statusCode: 403))
        self.apiService = LOSTARKAPIService(networkManager: self.networkManager!)
        
        do {
            let response = try await apiService!.getEventList()
            expectation.fulfill()
        } catch (let error) {
            XCTAssertEqual(clientError, error as! NetworkError)
        }
    }
}
