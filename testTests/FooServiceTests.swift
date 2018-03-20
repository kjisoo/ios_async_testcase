//
//  FooServiceTests.swift
//  testTests
//
//  Created by jisoo on 2018. 3. 20..
//  Copyright © 2018년 jisoo. All rights reserved.
//

import XCTest
@testable import test

class FooServiceTests: XCTestCase {
  
  var fooService: FooService!
  
  override func setUp() {
    super.setUp()
    self.fooService = FooService()
  }
  
  func testPassParam() {
    let executeExpectation = XCTestExpectation(description: "in block")
    let text = "Test param string"
    fooService.execute(param: text, delay: 1) { (param) in
      executeExpectation.fulfill()
      XCTAssert(text == (param as! String))
    }
    wait(for: [executeExpectation], timeout: 2)
  }
  
  func testExecuteBlock() {
    let executeExpectation = XCTestExpectation(description: "in block")
    fooService.execute(param: "param", delay: 1) { (_) in
      executeExpectation.fulfill()
    }
    wait(for: [executeExpectation], timeout: 2)
  }
  
  func testExecuteBlockOtherWay() {
    let executeExpectation = self.expectation(description: "in block")
    fooService.execute(param: "param", delay: 1) { (_) in
      executeExpectation.fulfill()
    }
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testCancelExecuteBlock() {
    let executeExpectation = XCTestExpectation(description: "in block")
    executeExpectation.isInverted = true
    fooService.execute(param: "param", delay: 1) { (_) in
      executeExpectation.fulfill()
    }
    fooService.cancel()
    wait(for: [executeExpectation], timeout: 2)
  }
  
  func testDoubleExecuteBlock() {
    let executeExpectation = XCTestExpectation(description: "in block")
    let notExecuteExpectation = XCTestExpectation(description: "never execute")
    notExecuteExpectation.isInverted = true
    fooService.execute(param: "param", delay: 1) { (_) in
      notExecuteExpectation.fulfill()
      XCTFail()
    }
    fooService.execute(param: "param", delay: 1) { (_) in
      executeExpectation.fulfill()
    }
    wait(for: [executeExpectation, notExecuteExpectation], timeout: 2)
  }
}
