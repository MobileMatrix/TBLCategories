
let secondsInAMinute = Double(60)
let secondsInAnHour = 60 * secondsInAMinute
let secondsInADay = 24 * secondsInAnHour
let secondsInAWeek = 7 * secondsInADay

let minutesInAnHour = Double(60)
let minutesInADay = 24 * minutesInAnHour

extension NSDate {

    func timeAgo() -> String {
        return timeAgoWithSeconds(false)
    }

    func timeAgoWithSeconds() -> String {
        return timeAgoWithSeconds(true)
    }

    // TODO: add version with format specifier
    func timeAgoWithSeconds(withSeconds: Bool) -> String {
        let now = NSDate()
        let deltaSeconds: NSTimeInterval = now.timeIntervalSinceDate(self)
        if (deltaSeconds <= 0) {
            return (withSeconds ? "1s" : "1m") // special case for clock wonkiness
        } else if (deltaSeconds < 60) {
            if (withSeconds) {
                return "\(deltaSeconds)s"
            } else {
                return "0m"
            }
        } else if (deltaSeconds < (60 * 60)) {
            let minutes = Int(floor(deltaSeconds/secondsInAMinute))
            return "\(minutes)m"
        } else if (deltaSeconds < (24 * 60 * 60)) {
            let hours = Int(floor(deltaSeconds/secondsInAnHour))
            return "\(hours)h"
        } else if (deltaSeconds < (7 * 24 * 60 * 60)) {
            let days = Int(floor(deltaSeconds/secondsInADay))
            return "\(days)d"
        } else {
            let weeks = Int(floor(deltaSeconds/secondsInAWeek))
            return "\(weeks)w"
        }
    }

    func isAfter(otherDate: NSDate) -> Bool {
        return compare(otherDate) == .OrderedDescending
    }

    func isBefore(otherDate: NSDate) -> Bool {
        return compare(otherDate) == .OrderedAscending
    }

    func isBefore(#daysAgo: Double) -> Bool {
        return isBefore(minutesAgo: (daysAgo * minutesInADay))
    }

    func isAfter(#daysAgo: Double) -> Bool {
        return isAfter(minutesAgo: (daysAgo * minutesInADay))
    }

    func isBefore(#hoursAgo: Double) -> Bool {
        return isBefore(minutesAgo: (hoursAgo * minutesInAnHour))
    }

    func isAfter(#hoursAgo: Double) -> Bool {
        return isAfter(minutesAgo: (hoursAgo * minutesInAnHour))
    }

    func isBefore(#minutesAgo: Double) -> Bool {
        return timeIntervalSinceNow < inThePast(minutesAgo * secondsInAMinute)
    }

    func isAfter(#minutesAgo: Double) -> Bool {
        return timeIntervalSinceNow > inThePast(minutesAgo * secondsInAMinute)
    }

    private func inThePast(seconds: Double) -> NSTimeInterval {
        return -seconds
    }

    func isToday() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let nowComponents = calendar.components((NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay), fromDate: NSDate())
        let selfComponents = calendar.components((NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay), fromDate:self)

        if let definitelyToday = calendar.dateFromComponents(nowComponents),
            possiblyToday = calendar.dateFromComponents(selfComponents) {
                return definitelyToday.isEqualToDate(possiblyToday)
        }

        // TODO return an enum with true/false/unknown instead?
        return false
    }

    func isTomorrow() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let nowComponents = calendar.components((NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay), fromDate: NSDate())
        let selfComponents = calendar.components((NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay), fromDate:self)

        if let definitelyToday = calendar.dateFromComponents(nowComponents),
            possiblyTomorrow = calendar.dateFromComponents(selfComponents) {
                return possiblyTomorrow.timeIntervalSinceDate(definitelyToday) == (60 * 60 * 24)
        }

        // TODO return an enum with true/false/unknown instead?
        return false
    }
}