import SwiftUI

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
            Text(String(format: "%.0f", oneRepMax.latestOneRepMax))
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