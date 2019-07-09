//
//  Date.swift
//  Uplift
//
//  Created by Adam Cobb on 1/3/17.
//  Copyright © 2017 Adam Cobb. All rights reserved.
//

import Foundation

public typealias Milliseconds = Int64

public extension Date{
    var timeInMillis:Milliseconds{
        return Milliseconds(timeIntervalSince1970 * 1000)
    }
    
    init(milliseconds: Milliseconds) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    enum TimeMeasurement:Int{
        case seconds = 1
        case minutes = 2
        case hours = 3
        case days = 4
        case weeks = 5
        case years = 6
        
        func unitString(shorthand:Bool)->String{
            switch self{
            case .seconds:
                return shorthand ? "sec" : "second"
            case .minutes:
                return shorthand ? "min" : "minute"
            case .hours:
                return shorthand ? "hr" : "hour"
            case .days:
                return shorthand ? "day" : "day"
            case .weeks:
                return shorthand ? "wk" : "week"
            case .years:
                return shorthand ? "yr" : "year"
            }
        }
        
        static public func > (left: TimeMeasurement, right: TimeMeasurement) -> Bool {
            return left.rawValue > right.rawValue
        }
        
        static public func < (left: TimeMeasurement, right: TimeMeasurement) -> Bool {
            return left.rawValue < right.rawValue
        }
    }
    
    func agoString(timeIncrements:[TimeMeasurement] = [.seconds, .minutes, .hours, .days, .weeks, .years], useShorthand:Bool = false)->String{
        
        // largest increment first (years before seconds)
        let timeIncrements = timeIncrements.sorted{ a, b in
            return a > b
        }
        
        var measurementMap:[TimeMeasurement:Int] = [:]
        
        measurementMap[.seconds] = Int(Date().timeIntervalSince(self))
        measurementMap[.minutes] = measurementMap[.seconds]! / 60
        measurementMap[.hours] = measurementMap[.minutes]! / 60
        measurementMap[.days] = measurementMap[.hours]! / 24
        measurementMap[.weeks] = measurementMap[.days]! / 7
        measurementMap[.years] = Int(Double(measurementMap[.days]!) / 365.2422)
        
        for increment in timeIncrements{
            if let value = measurementMap[increment], value > 0{
                return "\(value) \(increment.unitString(shorthand: useShorthand))\(value == 1 ? "" : "s") ago"
            }
        }
        
        return "Now"
    }
}

public extension TimeInterval{
    var milliseconds:Milliseconds{
        return Milliseconds(self * 1000)
    }
}
