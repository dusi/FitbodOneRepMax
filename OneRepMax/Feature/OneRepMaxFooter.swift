import SwiftUI

/// A simple footer view to display one rep max info
struct OneRepMaxFooter: View {
    private let exercise: Exercise
    private let foregroundColor: Color
    private let dateFormatter: DateFormatter
    private let showsMostRecentExercise: Bool
    
    init(
        dateFormatter: DateFormatter,
        exercise: Exercise,
        foregroundColor: Color,
        showsMostRecentExercise: Bool
    ) {
        self.dateFormatter = dateFormatter
        self.exercise = exercise
        self.foregroundColor = foregroundColor
        self.showsMostRecentExercise = showsMostRecentExercise
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(showsMostRecentExercise ? "Most recent": "On Date")
                    .font(.title2)
                Text(self.exercise.date, formatter: self.dateFormatter)
                    .font(.subheadline)
            }
            .foregroundColor(self.foregroundColor)
            Spacer()
            Text(String(format: "%.1f", self.exercise.oneRepMax))
                .font(.title)
                .foregroundColor(self.foregroundColor)
        }
    }
}

struct OneRepMaxFooter_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxFooter(dateFormatter: DateFormatter.default, exercise: .mock, foregroundColor: .blue, showsMostRecentExercise: false)
    }
}
