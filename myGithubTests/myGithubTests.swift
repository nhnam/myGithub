//
//  myGithubTests.swift
//  myGithubTests
//
//  Created by ナム Nam Nguyen on 1/27/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import UIKit
import Quick
import Nimble
import SwiftyJSON
import RandomKit
import Chameleon

class ApiSpec: QuickSpec {
    override func spec() {
        describe("ApiProvider") {
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
            it("should has sample data for userProfile") {
                let data = Api.userProfile("any_user").sampleData
                let dataStringtify = JSON(data: data)
                expect(dataStringtify["login"]).to(equal("any_user"))
            }
            it("should has sample data for userRepository") {
                let data = Api.userRepositories("any_user").sampleData
                let dataStringtify = JSON(data: data)
                expect(dataStringtify["name"]).to(equal("Nam's Repos"))
            }
        }
        describe("Repositories ViewController") {
            let sut = ViewController()

            it("should has title Nam's Github") {
                let _ = sut.view
                expect(sut.title).to(equal("Nam's Github"))
            }
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
            it("should has empty view if there's no data") {
                let _ = sut.view
                waitUntil(timeout: 1.0, action: { (done) in
                    sut.adapter.reloadData(completion: { (_) in
                        done()
                    })
                })
                expect(sut.collectionView.subviews.first).to(beAnInstanceOf( EmptyView.self))
            }
            it("should has navigationcontroller when app started") {
                let bundle = Bundle(for: ApiSpec.self)
                let storyboard = UIStoryboard.init(name: "Main", bundle: bundle)
                let rootViewController = storyboard.instantiateInitialViewController()
                expect(rootViewController).to(beAnInstanceOf(UINavigationController.self))
            }
            it("should has navigation bar color is flatSand") {
                let bundle = Bundle(for: ApiSpec.self)
                let storyboard = UIStoryboard.init(name: "Main", bundle: bundle)
                let rootViewController = storyboard.instantiateInitialViewController() as? UINavigationController
                let barColor = rootViewController?.navigationBar.barTintColor
                expect(barColor?.hexValue()).to(equal("#ECEFF1"))
            }
        }
        describe("FastViewController") {
            let sut = FastViewController()
            it("should be an instance of UIViewController") {
                expect(sut).to(beAKindOf(UIViewController.self))
            }
            it("should has view is loaded") {
                expect(sut.view).toNot(beNil())
            }
            it("should has view with white background") {
                expect(sut.view.backgroundColor).to(equal(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            }
            it("shouldn't has a default title") {
                expect(sut.title).to(beNil())
            }
        }
        describe("RepositoriesLoader") {
            let loader = RepositoriesLoader()
            it("should has list repositories") {
                expect(loader.repositories).toNot(beNil())
            }
            it("should has data after loadRepos") {
                waitUntil(timeout: 5.0, action: { (done) in
                    loader.loadRepos(username:"nhnam") { _ in
                        expect(loader.repositories.count).to(equal(30))
                        done()
                    }
                })
            }
            it("should has data as a list of Repository after app started") {
                waitUntil(timeout: 5.0, action: { (done) in
                    loader.loadRepos(username:"nhnam") { _ in
                        done()
                    }
                })
                let arrRepos = loader.repositories.filter({ (element: Repository) -> Bool in
                    return(element is Repository)
                })
                expect(arrRepos.count).to(equal(loader.repositories.count))
            }
            it("should has data as a list of Repository with name, url") {
                waitUntil(timeout: 5.0, action: { (done) in
                    loader.loadRepos(username:"nhnam") { _ in
                        done()
                    }
                })
                let arrRepos = loader.repositories.filter({ (element: Repository) -> Bool in
                    return(element.name != nil && element.url != nil)
                })
                expect(arrRepos.count).to(equal(loader.repositories.count))
            }
            it("should should return success false with invalid username") {
                var _success = true
                waitUntil(timeout: 5.0, action: { (done) in
                    loader.loadRepos(username:"nhnamxxx") { success in
                        _success = success
                        done()
                    }
                })
                expect(_success).to(beFalse())
            }
        }
        describe("Repository") {
            let reposJson = loadSampleUserRepositories()
            it("should has 30 items") {
                expect(reposJson.count).to(equal(30))
            }
            it("should has first Repository") {
                let first = reposJson[0]
                let repo = Repository(name: first["name"].string!,
                                      url: first["html_url"].string!,
                                      language: first["language"].string,
                                      stars: first["stargazers_count"].int!)
                expect(repo).toNot(beNil())
            }
            it("should has first Repository with name myGithub") {
                let first = reposJson[0]
                let repo = Repository(name: first["name"].string!,
                                      url: first["html_url"].string!,
                                      language: first["language"].string,
                                      stars: first["stargazers_count"].int!)
                expect(repo.name).to(equal("myGithub"))
            }
            it("should be equal if 2 repo has the same name") {
                let repoA = Repository(name: "Repo_ABC",
                                       url: "http://github.com",
                                      language: "Swift",
                                      stars: 2)
                let repoB = Repository(name: "Repo_ABC",
                                       url: "http://github.com",
                                       language: "Swift",
                                       stars: 2)
                expect(repoA.isEqual(toDiffableObject: repoB)).to(beTrue())
            }
            it("shouldnotbe equal if 1 of 2 is not a repo") {
                let repoA = Repository(name: "Repo_ABC",
                                       url: "http://github.com",
                                       language: "Swift",
                                       stars: 2)
                let repoB = "I am not a Repo"
                expect(repoA.isEqual(repoB)).to(beFalse())
            }
        }
    }
}
