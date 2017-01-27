//
//  myGithubTests.swift
//  myGithubTests
//
//  Created by ナム Nam Nguyen on 1/27/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import Quick
import Nimble
import IGListKit

class ApiSpec:QuickSpec {
    override func spec() {
        describe("Api Management") {
            it("should has ApiProvider when app get started") {
                expect(ApiProvider).toNot(beNil())
            }
            it("should return first 30 repos with username \"nhnam\"") {
                waitUntil(timeout: 5.0, action: { (done) in
                    ApiProvider.request(Api.userRepositories("nhnam")) { (result) in
                        switch result {
                        case let .success(response):
                            do {
                                let json =  try response.mapJSON() as? Array<Any>
                                expect(json?.count).to(equal(30))
                            } catch {
                                
                            }
                            break
                        case .failure(_):
                            break
                        }
                        done()
                    }
                })
            }
        }
        describe("Repositories ViewController") {
            let sut = ViewController()
            
            it("should has collectionView") {
                let _ = sut.view
                expect(sut.collectionView).toNot(beNil())
            }
            it("should has adapter") {
                let _ = sut.view
                expect(sut.adapter).toNot(beNil())
            }
            it("should has adapter with datasource is set") {
                let _ = sut.view
                expect(sut.adapter.dataSource).toNot(beNil())
            }
            
        }
        describe("RepositoriesLoader") {
            let loader = RepositoriesLoader()
            
            it("should has list repositories") {
                expect(loader.repositories).toNot(beNil())
            }
        }
    }
}
