import SwiftUI

/// A simple header view to display one rep max info
struct OneRepMaxHeader: View {
    private let exercise: Exercise
    private let dateFormatter: DateFormatter
    
    init(
        dateFormatter: DateFormatter,
        exercise: Exercise
    ) {
        self.dateFormatter = dateFormatter
        self.exercise = exercise
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Personal best")
                    .font(.title2)
                Text(self.dateFormatter.string(from: self.exercise.date))
                    .font(.subheadline)
            }
            Spacer()
            Text(String(format: "%.1f", self.exercise.oneRepMax))
                .font(.title)
        }
    }
}

struct OneRepMaxHeader_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxHeader(dateFormatter: DateFormatter.default, exercise: .mock)
    }
}
