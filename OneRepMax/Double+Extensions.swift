import Foundation

extension Double {
    func round(toNearest: Double) -> Double {
        return Darwin.round(self / toNearest) * toNearest
    }
}
