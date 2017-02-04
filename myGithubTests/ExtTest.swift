//
//  ExtTest.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 2/4/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import Quick

class Tests: QuickSpec {
    
    override func spec() {
        
        describe("String Interpolation") {
            
            it("should omit the optional text") {
                let optionalString: String? = "string1"
                XCTAssertEqual("\(optionalString)", optionalString!)
            }
            
            it("should omit the nil text") {
                let optionalString: String? = nil
                XCTAssertEqual("\(optionalString)", "")
            }
            
            it("should work for nested optional") {
                let nestedOptionalString: String?? = "string2"
                XCTAssertEqual("\(nestedOptionalString)", nestedOptionalString!!)
            }
            
            it("should work for the example") {
                let n: Int? = 1
                let t: String? = nil
                let s: String? = "string1"
                let o: String?? = "string2"
                XCTAssertEqual("\(n) \(t) \(s) \(o)", "1  string1 string2")
            }
        }
    }
}
