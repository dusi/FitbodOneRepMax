import Charts
import SwiftUI

struct OneRepMaxDetailModel {
    struct Defaults {
        static let exercisesLimit = 31
    }
    
    let oneRepMax: OneRepMax
    
    /// An array of exercises. Each exercise represents one rep max on any given day.
    /// The array is limited to 31 elements in order to generate readable chart.
    /// Since there could only be one exercise per day the most granual chart could
    /// show the past 31 days or a month.
    /// Otherwise, for exercises that are more spread out, the chart can show multiple months.
    ///
    /// In order to show larger data sets we could:
    /// 1) Embed the chart in a scroll view
    /// - After a few failed attempts, I gave up on this solution mostly due to the complexities of setting the default offset to show latest data
    /// 2) Provide a control (i.e. segmented control) to switch between longer date periods
    /// - This would most likely require some type of data aggregation for better x-axis distribution
    /// 3) Provide a control (i.e. buttons) to navigate between months (back and forth)
    /// X) And plenty of other solutions
    let exercises: [Exercise]
    
    init(oneRepMax: OneRepMax) {
        self.oneRepMax = oneRepMax
        self.exercises = oneRepMax.exercises.suffix(Defaults.exercisesLimit)
    }
}

extension OneRepMaxDetailModel {
    /// The minimum one rep max value of all exercises
    var minValue: Double {
        guard let minValue = exercises.min(by: { $0.oneRepMax < $1.oneRepMax })?.oneRepMax
        else { return 0 }
        return minValue
    }
    
    /// The maximum one rep max value of all exercises
    var maxValue: Double {
        guard let maxValue = exercises.max(by: { $0.oneRepMax < $1.oneRepMax })?.oneRepMax
        else { return 0 }
        return maxValue
    }
    
    /// The minimum y-axis value (min one rep max value - extra padding)
    var yAxisMinValue: Double {
        let diff = maxValue - minValue
        let div = diff / 4
        let padding = div / 2
        return minValue - padding
    }
    
    /// The maximum y-axis value (max one rep max value + extra padding)
    var yAxisMaxValue: Double {
        let diff = maxValue - minValue
        let div = diff / 4
        let padding = div / 2
        return maxValue + padding
    }
}

struct OneRepMaxDetail: View {
    private var model: OneRepMaxDetailModel
    
    init(oneRepMax: OneRepMax) {
        self.model = OneRepMaxDetailModel(oneRepMax: oneRepMax)
    }
    
    var body: some View {
        VStack {
            OneRepMaxRow(oneRepMax: self.model.oneRepMax)
                .frame(height: 60)
            GeometryReader { geometry in
                Chart {
                    ForEach(self.model.exercises) { exercise in
                        LineMark(
                            x: .value("Date", exercise.date),
                            y: .value("One Rep Max", exercise.oneRepMax)
                        )
                        .symbol(
                            Circle()
                                .strokeBorder(lineWidth: 2)
                        )
                        .symbolSize(50)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.green, .yellow, .red],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                // We want our y-axis to start closer to the min and max values
                .chartYScale(domain: self.model.yAxisMinValue...self.model.yAxisMaxValue)
                .frame(height: geometry.size.height * 0.5)
            }
        }
        .padding()
    }
}

struct OneRepMaxDetail_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxDetail(
            oneRepMax: OneRepMax.mock(
                name: "Deadlift",
                exercises: [
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 1 * 86_400), sets: 5, weight: 200),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 2 * 86_400), sets: 6, weight: 210),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 3 * 86_400), sets: 6, weight: 180),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 4 * 86_400), sets: 8, weight: 230),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 5 * 86_400), sets: 8, weight: 100),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 6 * 86_400), sets: 6, weight: 230),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 6 * 86_400), sets: 6, weight: 230),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 7 * 86_400), sets: 6, weight: 235),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 8 * 86_400), sets: 6, weight: 240),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 9 * 86_400), sets: 6, weight: 245),
                    .mock(name: "Deadlift", date: Date(timeIntervalSinceReferenceDate: 10 * 86_400), sets: 6, weight: 230)
                ]
            )
        )
    }
}
