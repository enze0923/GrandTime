//
//  TimeSpan.swift
//  GrandTimeDemo
//
//  Created by HuStan on 6/23/16.
//  Copyright © 2016 StanHu. All rights reserved.
//

import UIKit
 let TickPerDay = 86400000
 let TickPerHour = 3600000
 let TickPerMinute = 60000
 let TickPerSecond = 1000
func +(left:TimeSpan,right:TimeSpan) -> TimeSpan {
    let tick = left.ticks + right.ticks
    assert(tick < TimeSpan.Max.ticks,"two timespan add can not big than max time span")
    return TimeSpan(ticks: tick)
}

func -(left:TimeSpan,right:TimeSpan) -> TimeSpan {
    let tick = left.ticks - right.ticks
    assert(tick > 0,"two timespan subtruct can not less than 0")
    return TimeSpan(ticks: tick)
}
 public func <(lhs: TimeSpan, rhs: TimeSpan) -> Bool
{
    return lhs.compareTo(rhs) < 0
}
public func <=(lhs: TimeSpan, rhs: TimeSpan) -> Bool
{
    return lhs.compareTo(rhs) <= 0
}

public func >(lhs: TimeSpan, rhs: TimeSpan) -> Bool
{
    return lhs.compareTo(rhs) > 0
}
public func >=(lhs: TimeSpan, rhs: TimeSpan) -> Bool
{
    return lhs.compareTo(rhs) >= 0
}

public func == (lhs: TimeSpan, rhs: TimeSpan) -> Bool
{
    return lhs.compareTo(rhs) == 0
}


public class TimeSpan: NSObject,Comparable {
    
    
    static let Max = TimeSpan(days: 100000, hours: 23, minutes: 59, seconds: 59, milliseconds: 999)
    static let Zero = TimeSpan(days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
    var _day = 0
    var _hour = 0
    var _minute = 0
    var _second = 0
    var _millisecond = 0
    var _ticks = 0
    override init() {
        super.init()
    }
    
    convenience init(ticks:Int) {
        self.init()
        _ticks = ticks
        setTimes()
    }
    
    convenience init(hours:Int,minutes:Int,seconds:Int) {
        self.init()
        assert(hours > 0, "hours must > 0")
        assert(minutes > 0 && minutes < 60, "minus must > 0 and < 60")
        assert(seconds > 0 && seconds < 60, "seconds must > 0 and < 60")
        _hour = hours
        _minute = minutes
        _second = seconds
        _ticks = hours * TickPerHour + _minute * TickPerMinute + _second * TickPerSecond
    }
    
    convenience init(days:Int,hours:Int,minutes:Int,seconds:Int) {
        assert(hours > 0 && hours < 24, "hours must > 0 and < 24")
        self.init(hours:hours,minutes: minutes,seconds: seconds)
        _day = days
        _ticks = _ticks + _day * TickPerDay

    }
    
    convenience init(days:Int,hours:Int,minutes:Int,seconds:Int,milliseconds:Int) {
        assert(milliseconds > 0 && milliseconds < 999, "milliseconds must > 0 and < 999")
        self.init(days:days,hours:hours,minutes: minutes,seconds: seconds)
        _millisecond = milliseconds
        _ticks = _ticks + milliseconds
    }
    
    public var days:Int{
        get{
            return _day
        }
        set{
            assert(newValue > 0, "days must > 0")
            _ticks = _ticks - _day * TickPerDay
            _day = newValue
            _ticks = _ticks + _day * TickPerDay
        }
    }
    
    public var hours:Int{
        get{
            return _hour
        }
        set{
            assert(newValue > 0 && newValue < 24, "hours must > 0 and < 24")
            _ticks = _ticks - _hour * TickPerHour
            _hour = newValue
            _ticks = _ticks + _hour * TickPerHour
        }
    }
    
    public var minutes:Int{
        get{
            return _minute
        }
        set{
            assert(newValue > 0 && newValue < 60, "minutes must > 0 and < 60")
            _ticks = _ticks - _minute * TickPerMinute
            _minute = newValue
            _ticks = _ticks + _minute * TickPerMinute
        }
    }
    
    public var seconds:Int{
        get{
            return _second
        }
        set{
            assert(newValue > 0 && newValue < 60, "seconds must > 0 and < 60")
            _ticks = _ticks - _second * TickPerSecond
            _second = newValue
            _ticks = _ticks + _minute * TickPerMinute

        }
    }
    
    public var milliseconds:Int{
        get{
            return _millisecond
        }
        set{
            assert(newValue > 0 && newValue < 999, "milliseconds must > 0 and < 999")
            _ticks = _ticks - _millisecond
            _millisecond = newValue
            _ticks = _ticks - _millisecond
        }
    }
    
    public var ticks:Int{
        get{
            return _ticks
        }
        set{
            _ticks = newValue
            setTimes()
        }
    }
    
    public var totalDays:Double{
        return Double(_ticks) / Double(TickPerDay)
    }
    
    public var totalHours:Double{
        return Double(_ticks) / Double(TickPerHour)
    }
    
    public var totalMinutes:Double{
        return Double(_ticks) / Double(TickPerMinute)
    }
    
    public var totalSeconds:Double{
        return Double(_ticks) / Double(TickPerSecond)
    }
    
    public static func compare(t1:TimeSpan,t2:TimeSpan)->Int{
        if t1.ticks > t2.ticks {
            return 1
        }
        else if t1.ticks < t2.ticks{
            return -1
        }
        return 0
    }
    
    public static func equl(t1:TimeSpan,t2:TimeSpan)->Bool{
       return t1.ticks == t2.ticks
    }

    public static func fromDays(days:Double)->TimeSpan{
        assert(days > 0, "days must > 0")
        return TimeSpan(ticks: Int(days * Double(TickPerDay)))
    }
    
    public static func fromHours(hours:Double)->TimeSpan{
        assert(hours > 0, "hours must > 0") //这里就不需要<24了
        return TimeSpan(ticks: Int(hours * Double(TickPerHour)))
    }
    
    public static func fromMinuts(minutes:Double)->TimeSpan{
        assert(minutes > 0, "minutes must > 0")//这里就不需要<60了
        return TimeSpan(ticks: Int(minutes * Double(TickPerMinute)))
    }
    
    public static func fromSeconds(seconds:Double)->TimeSpan{
        assert(seconds > 0, "minutes must > 0")//这里就不需要<60了
        return TimeSpan(ticks: Int(seconds * Double(TickPerSecond)))
    }
    public static func fromTicks(ticks:Int)->TimeSpan{
        assert(ticks > 0, "minutes must > 0")//这里就不需要<60了
        return TimeSpan(ticks: ticks)
    }
    
    //默认格式： day hors:minutes:seconds:milliseconds
    //这个地方不太好处理
    //这里可能要用正则，字符單解析一直是个大难题，这就是为什么编译器这么难写
    //C#里面有-的TimeSpan 我觉得没有必要
    public static func parse(time:String)->TimeSpan?{
        return nil //时间不够，暂时不做
    }
    
    //借NSDateFormatter这个来用一用
    public static func parse(time:String,format:NSDateFormatter)->NSTimer?{
        return nil //时间不够，暂时不做
    }
    
    public func add(time:TimeSpan)->TimeSpan{
        let tick = time.ticks + self.ticks
        assert(ticks > TimeSpan.Max.ticks,"the added value must < max")
        return TimeSpan(ticks: tick)
    }
    
    
    func compareTo(time:TimeSpan) -> Int {
        return TimeSpan.compare(self, t2: time)
    }
    
//    public override var hash: Int{
//        return
//    }
    
//    public override func isEqual(object: AnyObject?) -> Bool {
//        if let time = object as TimeSpan{
//            return time == self
//        }
//        return false
//    }
    

    func subtract(time:TimeSpan) -> TimeSpan {
        let tick = self.ticks - time.ticks
        assert(ticks > 0,"tick must > 0")
        return TimeSpan(ticks: tick)
    }
    

    public  override var description: String{
        get{
            let hour = String(format: "%02x", hours)
            let minute = String(format: "%02x", minutes)
            let second = String(format: "%02x", seconds)
            let millisecond = String(format: "%02x", milliseconds)
            
            if days > 0{
                return "\(days) \(hour):\(minute):\(second):\(millisecond)"
            }
            else {
                return "\(hour):\(minute):\(second):\(millisecond)"
            }
        }
    }
    
  
  
    
    private func setTimes(){
        if _ticks > 0 {
            _day = _ticks / TickPerDay
            _hour = (_ticks - _day * TickPerDay) / TickPerHour
            _minute = (_ticks - _day * TickPerDay - _hour * TickPerHour) / TickPerMinute
            _second = (_ticks - _day * TickPerDay - _hour * TickPerHour - _minute * TickPerMinute)  / TickPerSecond
            _millisecond = _ticks - _day * TickPerDay - _hour * TickPerHour - _minute * TickPerMinute - _second * TickPerSecond
        }
    }
}
