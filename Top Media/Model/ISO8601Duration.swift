//
//  ISO8601Duration.swift
//  ISO8601Duration
//
//  Created by Matthew Reddin on 13/08/2021.
//

import Foundation

// Decodes ISO8601 durations to strings. https://en.wikipedia.org/wiki/ISO_8601#Durations
struct ISO8601Duration {
    
    func convertToSeconds(isoString: String) -> Int {
        let rangeOfTime = isoString.firstIndex(of: "T")
        var seconds = 0
        if rangeOfTime != isoString.index(after: isoString.startIndex) {
            seconds += convertPeriodString(str: String(isoString[isoString.index(after: isoString.startIndex)..<(rangeOfTime ?? isoString.endIndex)]))
        }
        if let rangeOfTime = rangeOfTime {
            seconds += convertTimeString(str: String(isoString[isoString.index(after: rangeOfTime)...]))
        }
        return seconds
    }
    
    private func convertPeriodString(str: String) -> Int {
        guard !str.isEmpty else { return 0 }
        var starting = str.startIndex
        var seconds = 0
        for indx in str.indices {
            if str[indx].isLetter {
                let num = Int(str[starting..<indx])!
                starting = str.index(after: indx)
                switch str[indx] {
                case "Y":
                    seconds += 365 * 24 * 60 * 60 * num
                case "M":
                    seconds += 30 * 24 * 60 * 60 * num
                case "W":
                    seconds += 7 * 24 * 60 * 60 * num
                case "D":
                    seconds += 24 * 60 * 60 * num
                default:
                    break
                }
            }
        }
        return seconds
    }
    
    private func convertTimeString(str: String) -> Int {
        guard !str.isEmpty else { return 0 }
        var starting = str.startIndex
        var seconds = 0
        for indx in str.indices {
            if str[indx].isLetter {
                let num = Int(str[starting..<indx])!
                starting = str.index(after: indx)
                switch str[indx] {
                case "H":
                    seconds += 60 * 60 * num
                case "M":
                    seconds += 60 * num
                case "S":
                    seconds += num
                default:
                    break
                }
            }
        }
        return seconds
    }
}
