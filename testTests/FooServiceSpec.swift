//
//  FooServiceSpec.swift
//  testTests
//
//  Created by jisoo on 2018. 3. 20..
//  Copyright © 2018년 jisoo. All rights reserved.
//

import Quick
import Nimble
@testable import test

class FooServiceSpec: QuickSpec {
  override func spec() {
    describe("FooService") {
      var fooService: FooService!
      beforeEach {
        fooService = FooService()
      }

      context("Pass parameters") {
        it("Compares parameters equally using waitUntil.") {
          let text = "Test param string"
          waitUntil(timeout: 2) { done in
            fooService.execute(param: text, delay: 1, complete: { (param) in
              expect((param as! String)).to(equal(text))
              done()
            })
          }
        }
        
        it("Compares parameters equally using toEventually.") {
          let text = "Test param string"
          var inBlockText: String = ""
          fooService.execute(param: text, delay: 1, complete: { (param) in
            inBlockText = param as! String
            
          })
          expect(inBlockText).toEventually(equal(text), timeout: 2)
        }
      }
      
      describe("About complete block") {
        it("Execute complete block") {
          waitUntil(timeout: 2) { done in
            fooService.execute(param: "", delay: 1, complete: { (param) in
              done()
            })
          }
        }

        context("Cancel execute complete block") {
          it("When call cancel method") {
            fooService.execute(param: "", delay: 1, complete: { (param) in
              fail()
            })
            fooService.cancel()
          }
          
          it("When call execute again") {
            waitUntil(timeout: 2) { done in
              fooService.execute(param: "", delay: 0.5, complete: { (param) in
                fail()
              })
              fooService.execute(param: "", delay: 1, complete: { (param) in
                done()
              })
            }
          }
        }
      }
    }
  }
}
