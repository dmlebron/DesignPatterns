//
//  DetailPresenterTests.swift
//  DesignPatternsTests
//
//  Created by david martinez on 3/5/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import XCTest
@testable import DesignPatterns

class DetailPresenterTests: XCTestCase {
    var presenter: DetailPresenter!
    var mockInteractor: MockDetailInteractor!
    var mockView: MockDetailView!
    var mockRouter: MockDetailRouter!
    
    override func setUp() {
        mockInteractor = MockDetailInteractor()
        mockView = MockDetailView()
        mockRouter = MockDetailRouter()
        presenter = DetailPresenter(interactor: mockInteractor, router: mockRouter)
        presenter.set(view: mockView)
    }
    
    func test_ViewDidLoad_Calls_FetchLoad() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.didCallFetchJob)
    }
    
    func test_WebsiteUrlButtonTapped_Calls_OpenUrl() {
        let mockUrl = URL(string: "www.google.com")
        presenter.websiteUrlButtonTapped(url: mockUrl)
        
        XCTAssertTrue(mockRouter.didCallOpenUrl == mockUrl)
    }
    
    func test_ReadMoreButtonTapped_Calls_NavigateTo() {
        let mockContext = UINavigationController()
        let mockAttrString = NSAttributedString(string: "Hello")
        presenter.readMoreButtonTapped(context: mockContext, attributedDescription: mockAttrString)
        
        XCTAssertTrue(mockRouter.didCallNavigateToJobDescription?.attrString == mockAttrString)
        XCTAssertTrue(mockRouter.didCallNavigateToJobDescription?.context == mockContext)
    }
    
    func test_ChangedJob_Calls_ChangedViewData_AllFields() {
        let mockJob = MockJob.allFields
        presenter.changed(job: mockJob)
        
        XCTAssertTrue(mockView.didCallChangedViewData?.name == mockJob.companyName)
        XCTAssertTrue(mockView.didCallChangedViewData?.location == mockJob.location)
        XCTAssertTrue(mockView.didCallChangedViewData?.urlString == mockJob.companyUrlString)
        XCTAssertTrue(mockView.didCallChangedViewData?.isWebsiteButtonEnabled == true)
    }
    
    func test_ChangedJob_Calls_ChangedViewData_OnlyTitleLocaationAndName() {
        let mockJob = MockJob.onlyTitleLocationAndName
        presenter.changed(job: mockJob)
        
        XCTAssertTrue(mockView.didCallChangedViewData?.name == mockJob.companyName)
        XCTAssertTrue(mockView.didCallChangedViewData?.location == mockJob.location)
        XCTAssertTrue(mockView.didCallChangedViewData?.urlString == DetailPresenter.Constants.noUrlString)
        XCTAssertTrue(mockView.didCallChangedViewData?.isWebsiteButtonEnabled == false)
        XCTAssertTrue(mockView.didCallChangedViewData?.description == DetailPresenter.Constants.noDescriptionAttributedString)
    }
    
    func test_LoadedCompanyLogo_Calls_SetCompanyLogo() {
        let mockImage = UIImage(named: "location")
        presenter.loaded(companyLogo: mockImage)
        
        XCTAssertTrue(mockView.didCallSetCompanyLogo == mockImage)
    }
}

// MARK: - Mock DetailInteractor
class MockDetailInteractor: DetailInteractorInput {
    func set(presenter: DetailInteractorOutput) {}
    
    var didCallFetchJob = false
    func fetchJob() {
        didCallFetchJob = true
    }
}

// MARK: - Mock DetailView
class MockDetailView: DetailViewInput {
    var didCallChangedViewData: DetailViewController.ViewData?
    func changed(viewData: DetailViewController.ViewData) {
        didCallChangedViewData = viewData
    }
    
    var didCallSetCompanyLogo: UIImage?
    func set(companyLogo: UIImage?) {
        didCallSetCompanyLogo = companyLogo
    }
}

// MARK: - Mock DetailRouter
class MockDetailRouter: DetailRouterInput {
    static func present(job: Job, userLocation: Location?, builder: DetailModuleBuilder, context: UINavigationController) {}
    
    var didCallOpenUrl: URL?
    func openUrl(_ url: URL?) {
        didCallOpenUrl = url
    }
    
    var didCallNavigateToJobDescription: (context: UINavigationController?, attrString: NSAttributedString)?
    func navigateToJobDescriptionViewController(context: UINavigationController?, attributedDescription: NSAttributedString) {
        didCallNavigateToJobDescription = (context: context, attrString: attributedDescription)
    }
}
