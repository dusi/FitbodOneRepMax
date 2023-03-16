import SwiftUI

struct OneRepMaxHeader: View {
    private let exercise: Exercise
    private let foregroundColor: Color
    private let dateFormatter: DateFormatter
    
    init(
        dateFormatter: DateFormatter,
        exercise: Exercise,
        foregroundColor: Color
    ) {
        self.dateFormatter = dateFormatter
        self.exercise = exercise
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        HStack {
            Text(self.dateFormatter.string(from: self.exercise.date))
                .font(.title2)
                .foregroundColor(self.foregroundColor)
            Spacer()
            Text(String(format: "%.1f", self.exercise.oneRepMax))
                .font(.title)
                .foregroundColor(self.foregroundColor)
        }
    }
}

struct OneRepMaxHeader_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxHeader(dateFormatter: DateFormatter.default, exercise: .mock, foregroundColor: .blue)
    }
}
