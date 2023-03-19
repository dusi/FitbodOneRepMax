import SwiftUI

/// Simple row to display one rep maxes
struct OneRepMaxRow: View {
    private let oneRepMax: OneRepMax
    
    init(oneRepMax: OneRepMax) {
        self.oneRepMax = oneRepMax
    }
    
    var body: some View {
        HStack {
            Text(oneRepMax.name)
                .font(.title2)
            Spacer()
            Text("\(self.oneRepMax.lastExercise.oneRepMax, specifier: "%.1f")")
                .font(.title)
            Text("lbs")
        }
    }
}

struct OneRepMaxRow_Previews: PreviewProvider {
    static var previews: some View {
        OneRepMaxRow(oneRepMax: .mock)
    }
}
