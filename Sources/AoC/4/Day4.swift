import Files
import Foundation
class Day4: Day {
    var challenges: [Challenge] = [Challenge1(), Challenge2()]
    required init() { }
}

private class Challenge1: Challenge {
    func run(input: String) {
        //split into lines
        let lines = input.split(separator: "\n").map({ String($0) })
        //map over the lines and then sort them
        let sortedEntries = lines.map({ Entry(line: $0) }).sorted()
        //Take all of the sleeps and sort them by minutes slept so as to find the sleepiest guard
        let sleeps = sortedEntries.sleeps.sorted { a, b in
            return a.sleepMinutes > b.sleepMinutes
        }
        //the first sleep is the one with the most sleep minutes
        guard let maxSleep = sleeps.first else {
            print("There are no sleeps?")
            return
        }
        //get just the guard who sleeps the most's sleeps
        let maxGuardSleeps = sleeps.filter({ $0.theGuard.id == maxSleep.theGuard.id })
        
        //build up a representation of the minutes slept
        var minutes = [Int: Int]()
        let minutesSleptAfterMidnight = maxGuardSleeps.compactMap({ $0.minutesSleptAfterMidnight })
        
        for sleep in minutesSleptAfterMidnight {
            for index in sleep {
                minutes[index] = (minutes[index] ?? 0) + 1
            }
        }
        
        //find the minute most slept on
        var maxTime = 0
        var maxMinutesSlept = 0
        for index in minutes.keys {
            if let minutesSlept = minutes[index] {
                if minutesSlept > maxMinutesSlept {
                    maxMinutesSlept = minutesSlept
                    maxTime = index
                }
            }
        }
        print("Max Guard: \(maxSleep.theGuard.id)")
        print("Most Asleep On: \(maxTime)")
        print("Multiplied Together: \(maxSleep.theGuard.id * maxTime)")
    }
}

//843055

private class Challenge2: Challenge1 {
    
    override func run(input: String) {
        //split into lines
        let lines = input.split(separator: "\n").map({ String($0) })
        //map over the lines and then sort them
        let sortedEntries = lines.map({ Entry(line: $0) }).sorted()
        //convert to sleeps
        let sleeps = sortedEntries.sleeps
        //find all of my guards
        let guards = Set<Guard>(sleeps.map({ $0.theGuard }))
        
        //set up data structure to hold guards to specific minutes slept
        var guardToMinutesSlept = [Guard: [Int:Int]]()
        for theGuard in guards {
            let guardSleeps = sleeps.filter({ $0.theGuard.id == theGuard.id })
            var minutes = [Int: Int]()
            //for each sleep mark down the exact minutes they slept
            for sleep in guardSleeps {
                guard let minutesSleptAfterMidnight = sleep.minutesSleptAfterMidnight else {
                    print("guard \(theGuard) didnt sleep?")
                    continue
                }
                for index in minutesSleptAfterMidnight {
                    minutes[index] = (minutes[index] ?? 0) + 1
                }
            }
            guardToMinutesSlept[theGuard] = minutes
        }
        
        var maxSleepGuard: Guard?
        var maxSleepMinute = 0
        var maxSleepCount = 0
        for (theGuard, minutes) in guardToMinutesSlept {
            for (minute, count) in minutes where count > maxSleepCount {
                maxSleepGuard = theGuard
                maxSleepMinute = minute
                maxSleepCount = count
            }
        }
        print("Most Asleep Guard: \(maxSleepGuard?.id ?? 0)")
        print("Most Asleep On: \(maxSleepMinute)")
        print("Multiplied together: \((maxSleepGuard?.id ?? 0) * maxSleepMinute)")
    }
}

fileprivate var calendar: Calendar = {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(abbreviation: "GMT+0:00")!
    return calendar
}()

fileprivate var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")!
    return dateFormatter
}()

class Sleep {
    let start: Date
    let end: Date
    let theGuard: Guard
    
    init(start: Date, end: Date, theGuard: Guard) {
        self.start = start
        self.end = end
        self.theGuard = theGuard
    }
    
    var sleepMinutes: Int {
        return calendar.dateComponents([.minute], from: self.start, to: self.end).minute ?? 0
    }
    
    var minutesSleptAfterMidnight: Range<Int>? {
        let sleepDate = calendar.dateComponents([.hour, .minute], from: self.start)
        guard let startHour = sleepDate.hour, let startMinute = sleepDate.minute else {
            print("No Hour?")
            return nil
        }
        let minuteAsleep = startHour != 11 ? startMinute : 0
        guard let wakeMinutes = calendar.dateComponents([.minute], from: self.end).minute else {
            print("No Minute?")
            return nil
        }
        return minuteAsleep..<wakeMinutes
    }
}

class Entry: Comparable {
    let date: Date
    let event: Event
    
    init(date: Date, event: Event) {
        self.date = date
        self.event = event
    }
    
    convenience init(line: String) {
        //force unwrapping since I know the input
        let tokens = line.split(separator: " ")
        var dateString = String(tokens[0]) + " " + String(tokens[1])
        dateString.removeFirst()
        dateString.removeLast()
        let date = dateFormatter.date(from: dateString)!
        let token2 = tokens[2]
        let event: Event
        if token2 == "Guard" {
            var idString = tokens[3]
            idString.removeFirst()
            let id = Int(idString)!
            event = .beginsShift(Guard(id: id))
        } else if token2 == "falls" {
            event = .fallsAsleep
        } else {
            event = .wakesUp
        }
        self.init(date: date, event: event)
    }
    
    //we are assuming each entry will have a unique date
    static func < (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.date == rhs.date
    }
}

extension Array where Element: Entry {
    var prettyDescription: String {
        var returnString = ""
        for entry in self {
            var string: String
            switch entry.event {
            case .beginsShift(let theGuard):
                string = "Guard #\(theGuard.id) begins shift"
            case .fallsAsleep:
                string = "falls asleep"
            case .wakesUp:
                string = "wakes up"
            }
            returnString += "[\(dateFormatter.string(from: entry.date))] \(string)\n"
        }
        return returnString
    }
    
    var sleeps: [Sleep] {
        var sleeps = [Sleep]()
        var currentGuard: Guard?
        var startSleepTime: Date?
        for entry in self {
            switch entry.event {
            case .beginsShift(let theGuard):
                currentGuard = theGuard
            case .fallsAsleep:
                startSleepTime = entry.date
            case .wakesUp:
                guard let startSleepTime = startSleepTime, let currentGuard = currentGuard else {
                    continue
                }
                sleeps.append(Sleep(start: startSleepTime, end: entry.date, theGuard: currentGuard))
            }
        }
        return sleeps
    }
}

enum Event {
    case beginsShift(Guard)
    case fallsAsleep
    case wakesUp
}

struct Guard: Hashable {
    let id: Int
}
