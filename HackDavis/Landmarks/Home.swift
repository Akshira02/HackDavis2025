import SwiftUI

struct MultiTimelineView: View {
    @State private var timelines: [Timeline] = [
        Timeline(name: "Visa Application>", steps: [
            TimelineStep(type: .document, title: "Submit Docs", progress: 1.0),
            TimelineStep(type: .office, title: "Visit Office", progress: 0.6),
            TimelineStep(type: .fees, title: "Pay Fees", progress: 0.2),
            TimelineStep(type: .prepare, title: "Prep Interview", progress: 0.0)
        ]),
        Timeline(name: "Work Permit>", steps: [
            TimelineStep(type: .document, title: "Docs Upload", progress: 1.0),
            TimelineStep(type: .fees, title: "Payment", progress: 0.8),
            TimelineStep(type: .prepare, title: "Prep Docs", progress: 0.5)
        ])
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(timelines) { timeline in
                        VStack(alignment: .leading, spacing: 20) {
                            Text(timeline.name)
                                .font(.title2)
                                .bold()

                            ScrollView(.horizontal, showsIndicators: false) {
                                ZStack(alignment: .center) {
                                    GeometryReader { geometry in
                                        Path { path in
                                            let y = geometry.size.height / 2
                                            let stepCount = timeline.steps.count
                                            let spacing: CGFloat = 90
                                            let totalWidth = CGFloat(stepCount - 1) * spacing
                                            path.move(to: CGPoint(x: 0, y: y))
                                            path.addLine(to: CGPoint(x: totalWidth, y: y))
                                        }
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)

                                        Path { path in
                                            let y = geometry.size.height / 2
                                            let stepCount = timeline.steps.count
                                            let spacing: CGFloat = 90
                                            let totalWidth = CGFloat(stepCount - 1) * spacing
                                            let progressWidth = totalWidth * timeline.overallProgress
                                            path.move(to: CGPoint(x: 0, y: y))
                                            path.addLine(to: CGPoint(x: progressWidth, y: y))
                                        }
                                        .stroke(Color.blue, lineWidth: 4)
                                    }
                                    .frame(height: 60)

                                    HStack(spacing: 90) {
                                        ForEach(timeline.steps) { step in
                                            NavigationLink(destination: TimelineStepDetail(step: step)) {
                                                VStack(spacing: 10) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color(.systemBackground))
                                                            .frame(width: 60, height: 60)
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                                                            )
                                                        Circle()
                                                            .trim(from: 0.0, to: CGFloat(step.progress))
                                                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                                            .rotationEffect(.degrees(-90))
                                                            .frame(width: 60, height: 60)
                                                        Image(systemName: step.type.iconName)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                            .opacity(0.8)
                                                    }
                                                    Text(step.title)
                                                        .font(.caption)
                                                        .multilineTextAlignment(.center)
                                                        .frame(width: 70)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.vertical, 10)
                                .frame(height: 100)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Your Timelines")
        }
    }
}

struct Timeline: Identifiable {
    let id = UUID()
    let name: String
    var steps: [TimelineStep]

    var overallProgress: Double {
        steps.map { $0.progress }.reduce(0, +) / Double(steps.count)
    }
}

struct TimelineStep: Identifiable {
    let id = UUID()
    let type: TimelineType
    let title: String
    let progress: Double
}


//edit this later for the docs formed
enum TimelineType {
    case document, office, fees, prepare
    var iconName: String {
        switch self {
        case .document: return "doc.text"
        case .office: return "building.2"
        case .fees: return "creditcard"
        case .prepare: return "brain.head.profile"
        }
    }
}

struct TimelineStepDetail: View {
    let step: TimelineStep

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: step.type.iconName)
                .resizable()
                .frame(width: 60, height: 60)
                .padding()
                .background(Circle().fill(Color(.systemTeal)))

            Text(step.title)
                .font(.title2)
                .bold()

            Text("Progress: \(Int(step.progress * 100))% completed.")
                .padding()
        }
        .navigationTitle(step.title)
    }
}

#Preview {
    MultiTimelineView()
}
