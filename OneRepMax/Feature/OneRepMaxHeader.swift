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
                Text(self.exercise.date, formatter: self.dateFormatter)
                    .font(.subheadline)
            }
            Spacer()
            Text("\(self.exercise.oneRepMax, specifier: "%.1f")")
                .font(.title)
        }
    }
}

struct OneRepMaxHeader_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxHeader(dateFormatter: DateFormatter.default, exercise: .mock)
    }
}
