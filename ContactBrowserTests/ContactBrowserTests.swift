//
//  ContactBrowserTests.swift
//  ContactBrowserTests
//
//  Created by Nolan Lapham on 9/12/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import ContactBrowser

class ContactBrowserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
    // MARK: - ContactViewModel Tests
    
    func testLoadContactsFunctionLoadsTheContactsArray() {
        let contactViewModel = ContactViewModel()
        contactViewModel.loadContacts { err in
            if let _ = err {
                XCTAssert(false)
            } else {
                XCTAssertTrue(contactViewModel.numberOfSections() == 24)
            }
        }
    }
    
    func testLoadFilteredContactsAndResetFilteredContacts() {
        let contactVM = ContactViewModel()
        
        contactVM.loadContacts { _ in }
        
        contactVM.loadFilteredContacts(searchText: "A") {
            XCTAssert(true)
        }

        contactVM.resetFilteredContactArray()
        
        XCTAssertTrue(contactVM.numberOfRowsInSection(section: 0) == 0, "Filter cleared successfully")
    }
    
    func testTitleForHeaderInSection() {
        
        let contactVM = ContactViewModel()
        
        contactVM.loadContacts { _ in }
        
        if let stringD = contactVM.titleForHeaderInSection(section: 3) {
            XCTAssertTrue(stringD == "D", "Wrong string for section")
        } else {
            XCTFail("No title D")
        }

    }
    
    func testNumberOfSectionsFunction() {
        
        let contactVM = ContactViewModel()
        let contactVC = ContactBrowserTableViewController()
        
        contactVM.loadContacts {
            contactVC.tableView.reloadData()
        }
        
        var sections = contactVM.numberOfSections()
        print(sections)
        
        XCTAssertTrue(sections == 24, "sections calculation is wrong")
        
        contactVM.loadFilteredContacts(searchText: "A") {
            XCTAssert(true)
        }
        
        sections = contactVM.numberOfSections()
        
        XCTAssertTrue(sections == 1, "sections calculation is wrong")
        
    }
    
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
