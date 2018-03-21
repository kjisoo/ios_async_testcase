//
//  RxFooServiceTests.swift
//  testTests
//
//  Created by jisoo on 2018. 3. 21..
//  Copyright © 2018년 jisoo. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
@testable import test

class RxFooServiceTests: XCTestCase {
  
  var fooService: RxFooService!
  
  override func setUp() {
    super.setUp()
    fooService = RxFooService()
  }

  func testPassParam() {
    let text = "Test param string"
    
    let firstParam = try! fooService.execute(param: text, delay: 1.0).toBlocking().first()
    
    XCTAssertEqual((firstParam as! String), text)
  }
  
  func testExecuteBlock() {
    let subscribeExpectation = XCTestExpectation(description: "subscribe expectation")
    _ = fooService.execute(param: "_", delay: 1.0).subscribe(onNext: { (_) in
      subscribeExpectation.fulfill()
    })
    wait(for: [subscribeExpectation], timeout: 2)
  }
  
  func testExecuteBlockUsingRxTest() {
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(String.self)
    
    scheduler.scheduleAt(100) {
      _ = self.fooService.execute(param: "first", delay: 0.1, scheduler: scheduler)
        .map { $0 as! String }
        .subscribe(observer)
    }
    scheduler.start()
    let expectedEvents = [
      next(101, "first")
    ]
    
    XCTAssertEqual(observer.events, expectedEvents)
  }
  
  func testCancelExecuteBlock() {
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(String.self)
    
    scheduler.scheduleAt(100) {
      _ = self.fooService.execute(param: "first", delay: 10, scheduler: scheduler)
        .map { $0 as! String }
        .subscribe(observer)
    }
    scheduler.scheduleAt(105) {
      self.fooService.cancel()
    }
    scheduler.start()
    let expectedEvents: [Recorded<Event<String>>] = [
      completed(105)
    ]
    
    XCTAssertEqual(observer.events, expectedEvents)
  }
  
  func testDoubleExecuteBlock() {
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(String.self)
    
    scheduler.scheduleAt(100) {
      _ = self.fooService.execute(param: "first", delay: 10, scheduler: scheduler)
        .map { $0 as! String }
        .subscribe(observer)
    }
    scheduler.scheduleAt(105) {
      _ = self.fooService.execute(param: "second", delay: 10, scheduler: scheduler)
        .map { $0 as! String }
        .subscribe(observer)
    }
    scheduler.start()
    let expectedEvents: [Recorded<Event<String>>] = [
      completed(105),
      next(115, "second")
    ]
    
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
