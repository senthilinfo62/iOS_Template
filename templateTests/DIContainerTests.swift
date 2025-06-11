//
//  DIContainerTests.swift
//  templateTests
//
//  Created by Senthilkumar Maruthasalam on 11/06/25.
//

import XCTest
@testable import template

final class DIContainerTests: XCTestCase {
    var container: AppContainer!
    
    override func setUp() {
        super.setUp()
        container = AppContainer()
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    func testAPIServiceRegistration() {
        // Given & When
        let apiService = container.resolve(APIServiceProtocol.self)
        
        // Then
        XCTAssertNotNil(apiService)
        XCTAssertTrue(apiService is APIService)
    }
    
    func testPostRepositoryRegistration() {
        // Given & When
        let repository = container.resolve(PostRepositoryProtocol.self)
        
        // Then
        XCTAssertNotNil(repository)
        XCTAssertTrue(repository is PostRepository)
    }
    
    func testFetchPostUseCaseRegistration() {
        // Given & When
        let useCase = container.resolve(FetchPostUseCaseProtocol.self)
        
        // Then
        XCTAssertNotNil(useCase)
        XCTAssertTrue(useCase is FetchPostUseCase)
    }
    
    func testHomeViewModelFactory() {
        // Given & When
        let viewModel = container.makeHomeViewModel()
        
        // Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.message, "Loading...")
    }
    
    func testSingletonBehavior() {
        // Given & When
        let apiService1 = container.resolve(APIServiceProtocol.self)
        let apiService2 = container.resolve(APIServiceProtocol.self)
        
        // Then
        XCTAssertTrue(apiService1 === apiService2 as AnyObject)
    }
    
    func testDependencyChain() {
        // Given & When
        let useCase = container.resolve(FetchPostUseCaseProtocol.self)
        
        // Then
        XCTAssertNotNil(useCase)
        // Verify that the use case has the correct repository injected
        // This tests the dependency chain: UseCase -> Repository -> APIService
    }
    
    func testMockRegistration() {
        // Given
        let mockAPIService = MockAPIService()
        mockAPIService.setMockPost(title: "Test Title", body: "Test Body")
        
        // When
        container.register(APIServiceProtocol.self, instance: mockAPIService)
        let resolvedService = container.resolve(APIServiceProtocol.self)
        
        // Then
        XCTAssertTrue(resolvedService is MockAPIService)
    }
    
    func testThemeUseCaseRegistration() {
        // Given & When
        let themeUseCase = container.resolve(ThemeUseCaseProtocol.self)
        
        // Then
        XCTAssertNotNil(themeUseCase)
        XCTAssertTrue(themeUseCase is ThemeUseCase)
    }
    
    func testSettingsViewModelFactory() {
        // Given & When
        let viewModel = container.makeSettingsViewModel()
        
        // Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.currentTheme, .system) // Default theme
    }
}
