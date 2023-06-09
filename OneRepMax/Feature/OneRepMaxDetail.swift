import Charts
import SwiftUI

/// The model that is responsible for providing data to the view and handling user interactions with the chart
class OneRepMaxDetailModel: ObservableObject {
    /// Pre-defined values
    struct Defaults {
        struct Device {
            static let exercisesPhoneLimit = 31
            static let exercisesPadLimit = 93
        }
        
        struct Style {
            static let lineMarkForegroundColors: [Color] = [.green, .yellow, .red]
            static let selectionColor = Color.blue
        }
    }
    
    /// The on rep max
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
    
    /// Selected exercise based on user's interaction with the chart
    @Published var selectedExercise: Exercise?
    
    init(oneRepMax: OneRepMax, userInterfaceIdiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom) {
        self.oneRepMax = oneRepMax
        self.exercises = oneRepMax.exercises.suffix(
            userInterfaceIdiom == .pad ? Defaults.Device.exercisesPadLimit : Defaults.Device.exercisesPhoneLimit
        )
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
    
    /// The personal best exercise
    var personalBestExercise: Exercise {
        oneRepMax.personalBestExercise
    }
    
    /// The most recent or selected exercise
    var mostRecentOrSelectedExercise: Exercise {
        if let selectedExercise {
            return selectedExercise
        } else {
            return oneRepMax.lastExercise
        }
    }
    
    /// Date formatter used to display date values
    var dateFormatter: DateFormatter {
        DateFormatter.default
    }
    
    /// A flag indicating that an exercise has been selected by user
    var showsMostRecentExercise: Bool {
        selectedExercise == nil
    }
    
    /// The foreground color used in the header
    var footerForegroundColor: Color {
        selectedExercise != nil ? Defaults.Style.selectionColor : .primary
    }
    
    /// The user gesture to interact with the chart
    func chartGestureDidChange(with date: Date) {
        let selectedDate = self.exercises
            .sorted(by: {
                abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
            })
            .first?
            .date
        
        self.selectedExercise = self.exercises.first(where: { $0.date == selectedDate })
    }
    
    /// The user gesture to end interacting with the chart
    func chartGestureDidEnd() {
        self.selectedExercise = nil
    }
}

/// The view that displays one rep max detail
struct OneRepMaxDetail: View {
    /// The model that provides most of the business logic
    @ObservedObject var model: OneRepMaxDetailModel
    
    init(oneRepMax: OneRepMax) {
        self.model = OneRepMaxDetailModel(oneRepMax: oneRepMax, userInterfaceIdiom: UIDevice.current.userInterfaceIdiom)
    }
    
    var body: some View {
        GeometryReader { outerGeometry in
            VStack {
                // Header showing personal best one rep max
                OneRepMaxHeader(
                    dateFormatter: self.model.dateFormatter,
                    exercise: self.model.personalBestExercise
                )
                
                // The chart with historical one rep maxes
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
                                colors: OneRepMaxDetailModel.Defaults.Style.lineMarkForegroundColors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    // Show a ruler when user interacts with the chart
                    if let selectedExercise = self.model.selectedExercise {
                        RuleMark(
                            x: .value("Selected date", selectedExercise.date)
                        )
                        .foregroundStyle(OneRepMaxDetailModel.Defaults.Style.selectionColor)
                        
                        PointMark(
                            x: .value("Selected date", selectedExercise.date),
                            y: .value("Selected exercise", selectedExercise)
                        )
                        .symbolSize(150)
                        .foregroundStyle(OneRepMaxDetailModel.Defaults.Style.selectionColor)
                    }
                }
                // We want our y-axis to start closer to the min and max values (not from zero)
                .chartYScale(domain: self.model.yAxisMinValue...self.model.yAxisMaxValue)
                // Allow interactions with the chart
                .chartOverlay { proxy in
                    GeometryReader { innerGeometry in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        guard let date = date(for: value.location, geometry: innerGeometry, chart: proxy)
                                        else { return }
                                        self.model.chartGestureDidChange(with: date)
                                    }
                                    .onEnded { _ in
                                        self.model.chartGestureDidEnd()
                                    }
                            )
                            .onTapGesture { value in
                                guard let date = date(for: value, geometry: innerGeometry, chart: proxy)
                                else { return }
                                self.model.chartGestureDidChange(with: date)
                            }
                    }
                }
                .frame(height: outerGeometry.size.height * 0.5)
                
                // Footer showing most recent or selected one rep max
                OneRepMaxFooter(
                    dateFormatter: self.model.dateFormatter,
                    exercise: self.model.mostRecentOrSelectedExercise,
                    foregroundColor: self.model.footerForegroundColor,
                    showsMostRecentExercise: self.model.showsMostRecentExercise
                )
            }
            .padding()
            .navigationTitle(self.model.oneRepMax.name)
        }
    }
    
    private func date(for location: CGPoint, geometry: GeometryProxy, chart: ChartProxy) -> Date? {
        let xPosition = location.x - geometry[chart.plotAreaFrame].origin.x
        return chart.value(atX: xPosition)
    }
}

extension Exercise: Plottable {
    init?(primitivePlottable: Double) {
        self.init(date: Date(), name: "", reps: 0, sets: 0, weight: 0)
    }
    
    var primitivePlottable: Double {
        self.oneRepMax
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
