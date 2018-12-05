import Files
import Foundation

func main() {
    let dayNumber: Int
    var challengeNumber: Int
    if CommandLine.arguments.count >= 3 {
        dayNumber = Int(CommandLine.arguments[1])!
        challengeNumber = Int(CommandLine.arguments[2])!
    } else {
        (dayNumber, challengeNumber) = configFromPlist()
    }
    challengeNumber -= 1
    let inputFile: File
    do {
        inputFile = try File(path: "Day\(dayNumber)input")
    } catch {
        print("No Input for day \(dayNumber) found")
        return
    }
    let inputText = try! inputFile.readAsString()

    guard let day = Days.convertStringtoDay(dayNumber) else {
        print("No Day found for day \(dayNumber)")
        return
    }
    let challenge = day.challenges[challengeNumber]
    print("Running day \(dayNumber) challenge \(challengeNumber + 1)")
    challenge.run(input: inputText)
}

func configFromPlist() -> (day: Int, challenge: Int) {
    let path = Bundle.main.path(forResource: "Config", ofType: "plist")!
    let arr = NSDictionary.init(contentsOfFile: path)!
    return (Int(arr["day"] as! String)!,Int(arr["challenge"] as! String)!)
}

main()
