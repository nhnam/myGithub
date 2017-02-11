//
//  CounterReducer.swift
//  myGithub
//
//  Created by ナム Nam Nguyen on 2/11/17.
//  Copyright © 2017 ナム Nam Nguyen. All rights reserved.
//

import Foundation
import ReSwift

struct CounterActionIncrease: Action {}
struct CounterActionDecrease: Action {}

struct CounterReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        var state = state ?? AppState()
        switch action {
        case _ as CounterActionIncrease:
            print("Increase")
            state.counter += 1
        case _ as CounterActionDecrease:
            print("Decrease")
            state.counter -= 1
        default:
            print("Default")
            break
        }
        return state
    }
}
