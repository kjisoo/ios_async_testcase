//
//  RxFooService.swift
//  test
//
//  Created by jisoo on 2018. 3. 21..
//  Copyright © 2018년 jisoo. All rights reserved.
//

import Foundation
import RxSwift

class RxFooService {
  private let cancelSubject = PublishSubject<Void>()
  
  /// After the delay, the param is emitted via the observer.
  ///
  /// After the delay, the param is emitted via the observer.
  /// If you call this method, the previous observer is automatically disposed.
  ///
  /// - Parameters:
  ///     - param: param to be passed to observer
  ///     - delay: delay for emitted
  /// - Returns: Observer to receive param after delay
  ///
  public func execute(param: Any, delay: Double) -> Observable<Any> {
    self.cancel()
    return Observable<Any>
      .create({ (observer) -> Disposable in
        observer.onNext(param)
        return Disposables.create()
      })
      .delay(delay, scheduler: MainScheduler.instance)
      .takeUntil(self.cancelSubject)
  }
  
  /// Cancels the last execute.
  ///
  /// Cancels the last execute.
  /// If there is no last execute, nothing happens.
  ///
  public func cancel() {
    self.cancelSubject.onNext(Void())
  }
}
