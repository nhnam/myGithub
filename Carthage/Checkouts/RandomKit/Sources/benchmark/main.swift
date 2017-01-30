//
//  main.swift
//  RandomKit Benchmark
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2016 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import RandomKit

func contains(_ arg: String) -> Bool {
    let arg = arg.lowercased()
    return CommandLine.arguments.contains { $0.lowercased() == arg }
}

func argument(after arg: String) -> String? {
    let arg = arg.lowercased()
    if let index = CommandLine.arguments.indices.first(where: { CommandLine.arguments[$0].lowercased() == arg }) {
        return CommandLine.arguments[safe: index + 1]
    } else {
        return nil
    }
}

func int(after arg: String) -> Int? {
    return argument(after: arg).flatMap { Int($0) }
}

func hasArgs() -> Bool {
    let args = CommandLine.arguments
    return args.count > 1 && args.suffix(from: 1).contains(where: { $0.lowercased() != "--no-color" })
}

let styleOutput = !contains("--no-color")

if !hasArgs() || contains("--help") || contains("-h") {
    printHelpAndExit()
}

let benchmarkAll           = contains("--all") || contains("-a")
let benchmarkAllGenerators = benchmarkAll || contains("--all-generators")
let benchmarkAllIntegers   = benchmarkAll || contains("--all-integers")
let benchmarkAllProtocols  = benchmarkAll || contains("--all-protocols")

let benchmarkRandom                  = benchmarkAllProtocols || contains("Random")
let benchmarkRandomToValue           = benchmarkAllProtocols || contains("RandomToValue")
let benchmarkRandomThroughValue      = benchmarkAllProtocols || contains("RandomThroughValue")
let benchmarkRandomWithinRange       = benchmarkAllProtocols || contains("RandomWithinRange")
let benchmarkRandomWithinClosedRange = benchmarkAllProtocols || contains("RandomWithinClosedRange")

let benchmarkRandomArray            = contains("--array")
let benchmarkRandomArrayCount       = int(after: "--array")
let benchmarkSafeRandomArray        = benchmarkRandomArray         || contains("--array-safe")
let benchmarkSafeRandomArrayCount   = int(after: "--array-safe")   ?? benchmarkRandomArrayCount ?? 100
let benchmarkUnsafeRandomArray      = benchmarkRandomArray         || contains("--array-unsafe")
let benchmarkUnsafeRandomArrayCount = int(after: "--array-unsafe") ?? benchmarkRandomArrayCount ?? 100

let count = int(after: "--count") ?? int(after: "-c") ?? 10_000_000

func arc4RandomIsAvailable() -> Bool {
    let available = RandomGenerator.arc4RandomIsAvailable
    if !available {
        print(style("The arc4random generator is unavailable", with: [.bold, .red]))
    }
    return available
}

var generators: [RandomGenerator] = []
if benchmarkAllGenerators {
    if arc4RandomIsAvailable() {
        generators = [
            .xoroshiro(threadSafe: false),
            .xoroshiro(threadSafe: true),
            .mersenneTwister(threadSafe: false),
            .mersenneTwister(threadSafe: true),
            .arc4Random,
            .device(.random),
            .device(.urandom)
        ]
    } else {
        generators = [
            .xoroshiro(threadSafe: false),
            .xoroshiro(threadSafe: true),
            .mersenneTwister(threadSafe: false),
            .mersenneTwister(threadSafe: true),
            .device(.random),
            .device(.urandom)
        ]
        print(style("The arc4random generator is unavailable", with: [.bold, .red]))
    }
} else {
    let benchmarkWithXoroshiro = contains("--xoroshiro")
    if benchmarkWithXoroshiro || contains("--xoroshiro-unsafe") {
        generators.append(.xoroshiro(threadSafe: false))
    }
    if benchmarkWithXoroshiro || contains("--xoroshiro-safe") {
        generators.append(.xoroshiro(threadSafe: true))
    }
    let benchmarkWithMersenneTwister = contains("--mersenne-twister")
    if benchmarkWithMersenneTwister || contains("--mersenne-twister-unsafe") {
        generators.append(.mersenneTwister(threadSafe: false))
    }
    if benchmarkWithMersenneTwister || contains("--mersenne-twister-safe") {
        generators.append(.mersenneTwister(threadSafe: true))
    }

    if contains("--arc4random") {
        if arc4RandomIsAvailable() {
            generators.append(.arc4Random)
        } else {
            print(style("The arc4random generator is unavailable", with: [.bold, .red]))
        }
    }

    let benchmarkWithDev = contains("--dev")
    if benchmarkWithDev || contains("--dev-random") {
        generators.append(.device(.random))
    }
    if benchmarkWithDev || contains("--dev-urandom") {
        generators.append(.device(.urandom))
    }

    if generators.isEmpty {
        generators = [
            .xoroshiro(threadSafe: false),
            .xoroshiro(threadSafe: true)
        ]
        if arc4RandomIsAvailable() {
            generators.append(.arc4Random)
        }
    }
}

if benchmarkRandom {
    benchmarkRandom(for: Int.self)
    if benchmarkAllIntegers {
        benchmarkRandom(for: Int64.self)
        benchmarkRandom(for: Int32.self)
        benchmarkRandom(for: Int16.self)
        benchmarkRandom(for: Int8.self)
    }
    benchmarkRandom(for: UInt.self)
    if benchmarkAllIntegers {
        benchmarkRandom(for: UInt64.self)
        benchmarkRandom(for: UInt32.self)
        benchmarkRandom(for: UInt16.self)
        benchmarkRandom(for: UInt8.self)
    }
}

if benchmarkRandomToValue {
    benchmarkRandomToValue(with: Int.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomToValue(with: Int64.maxAdjusted)
        benchmarkRandomToValue(with: Int32.maxAdjusted)
        benchmarkRandomToValue(with: Int16.maxAdjusted)
        benchmarkRandomToValue(with: Int8.maxAdjusted)
    }
    benchmarkRandomToValue(with: UInt.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomToValue(with: UInt64.maxAdjusted)
        benchmarkRandomToValue(with: UInt32.maxAdjusted)
        benchmarkRandomToValue(with: UInt16.maxAdjusted)
        benchmarkRandomToValue(with: UInt8.maxAdjusted)
    }
}

if benchmarkRandomThroughValue {
    benchmarkRandomThroughValue(with: Int.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomThroughValue(with: Int64.maxAdjusted)
        benchmarkRandomThroughValue(with: Int32.maxAdjusted)
        benchmarkRandomThroughValue(with: Int16.maxAdjusted)
        benchmarkRandomThroughValue(with: Int8.maxAdjusted)
    }
    benchmarkRandomThroughValue(with: UInt.maxAdjusted)
    if benchmarkAllIntegers {
        benchmarkRandomThroughValue(with: UInt64.maxAdjusted)
        benchmarkRandomThroughValue(with: UInt32.maxAdjusted)
        benchmarkRandomThroughValue(with: UInt16.maxAdjusted)
        benchmarkRandomThroughValue(with: UInt8.maxAdjusted)
    }
}

if benchmarkRandomWithinRange {
    benchmarkRandomWithinRange(with: Int.minMaxRange)
    if benchmarkAllIntegers {
        benchmarkRandomWithinRange(with: Int64.minMaxRange)
        benchmarkRandomWithinRange(with: Int32.minMaxRange)
        benchmarkRandomWithinRange(with: Int16.minMaxRange)
        benchmarkRandomWithinRange(with: Int8.minMaxRange)
    }
    benchmarkRandomWithinRange(with: UInt.minMaxRange)
    if benchmarkAllIntegers {
        benchmarkRandomWithinRange(with: UInt64.minMaxRange)
        benchmarkRandomWithinRange(with: UInt32.minMaxRange)
        benchmarkRandomWithinRange(with: UInt16.minMaxRange)
        benchmarkRandomWithinRange(with: UInt8.minMaxRange)
    }
}

if benchmarkRandomWithinClosedRange {
    benchmarkRandomWithinClosedRange(with: Int.minMaxClosedRange)
    if benchmarkAllIntegers {
        benchmarkRandomWithinClosedRange(with: Int64.minMaxClosedRange)
        benchmarkRandomWithinClosedRange(with: Int32.minMaxClosedRange)
        benchmarkRandomWithinClosedRange(with: Int16.minMaxClosedRange)
        benchmarkRandomWithinClosedRange(with: Int8.minMaxClosedRange)
    }
    benchmarkRandomWithinClosedRange(with: UInt.minMaxClosedRange)
    if benchmarkAllIntegers {
        benchmarkRandomWithinClosedRange(with: UInt64.minMaxClosedRange)
        benchmarkRandomWithinClosedRange(with: UInt32.minMaxClosedRange)
        benchmarkRandomWithinClosedRange(with: UInt16.minMaxClosedRange)
        benchmarkRandomWithinClosedRange(with: UInt8.minMaxClosedRange)
    }
}

if benchmarkSafeRandomArray {
    benchmarkSafeRandomArray(for: Int.self, randomCount: benchmarkSafeRandomArrayCount)
}

if benchmarkUnsafeRandomArray {
    benchmarkUnsafeRandomArray(for: Int.self, randomCount: benchmarkUnsafeRandomArrayCount)
}
