//
//  FooService.swift
//  test
//
//  Created by jisoo on 2018. 3. 20..
//  Copyright © 2018년 jisoo. All rights reserved.
//

import Foundation

class FooService {
  private var workItem: DispatchWorkItem?

  /// Complete is executed after a delay.
  ///
  /// Complete is executed after a delay.
  /// When executed, param is passed to complete.
  /// If you call this method, the previous call is automatically canceled.
  ///
  /// - Parameters:
  ///     - param: param to be passed to complete
  ///     - delay: delay of complete execution
  ///     - complete: Closure to be executed after delay
  ///
  public func execute(param: Any, delay: Double, complete: @escaping ((Any) -> Void)) {
    self.cancel()
    workItem = DispatchWorkItem(block: {
      complete(param)
    })
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
  }
  
  /// Cancels the last execute.
  ///
  /// Cancels the last execute.
  /// If there is no last execute, nothing happens.
  ///
  public func cancel() {
    workItem?.cancel()
  }
}
