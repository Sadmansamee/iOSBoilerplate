//
//  LoginVMTests.swift
//  iOSBoilerplateTests
//
//  Created by sadman samee on 9/19/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import Foundation
@testable import iOSBoilerplate
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
import Moya

class LoginVMTests: QuickSpec{
    override func spec() {
        describe("LoginVM"){
            
            var stubbingProvider: MoyaProvider<AuthService>
        
            beforeEach {
                stubbingProvider = MoyaProvider<AuthService>(stubClosure: MoyaProvider.immediatelyStub)
            }
            
            context("when initialized") {
                
                stubbingProvider.request(.login("", ""), completion: { result in
                    
                })
            }
        }
    }
}
