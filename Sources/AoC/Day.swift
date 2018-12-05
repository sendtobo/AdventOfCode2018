import Foundation

protocol Day {
    init()
    var challenges: [Challenge] { get }
}

struct Days {
    static func convertStringtoDay(_ day: Int) -> Day? {
        let clazz: AnyClass? = NSClassFromString("AoC.Day\(day)")
        guard let theClass = clazz.self as? Day.Type else {
            return nil
        }
        return theClass.init()
    }
}
