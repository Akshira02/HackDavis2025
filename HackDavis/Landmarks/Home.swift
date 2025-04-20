import SwiftUI

struct MultiTimelineView: View {
    @State private var timelines: [Timeline] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(timelines) { timeline in
                        VStack(alignment: .leading, spacing: 20) {
                            NavigationLink(destination: TimelineChecklistView(timeline: timeline)) {
                                Text(timeline.name)
                                    .font(.title2)
                                    .bold()
                            }

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

                    // Your Records Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Records")
                            .font(.title2)
                            .bold()

                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Uploaded Documents")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("• I-20.pdf")
                                Text("• Passport Photo.jpg")
                                Text("• SEVIS Receipt.pdf")
                            }
                            Spacer()
                            NavigationLink(destination: RecordsView()) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Your Timelines")
            .onAppear {
                loadTimelinesFromGPT()
            }
        }
    }
    // Replace this with actual GPT integration logic
           //u want the llm model to decide the icon ".document vs office vs fees prepare", and the title like "get ready for interview", and randomized progress. the number of timelines, and name of the Timeline will be decided by how many tasks they say they want to get done in the questionnarire. also the blue header text leads to checklist. the checklist displays info based off the status attribute.
    func loadTimelinesFromGPT() {
        timelines = [
            Timeline(name: "F-1 Visa Application", steps: [
                TimelineStep(type: .document, title: "Form I-20", progress: 0.0, status: .notStarted, note: "Apply to U.S. Schools (9–12 months before start)"),
                TimelineStep(type: .document, title: "DS-160 confirmation page", progress: 0.0, status: .notStarted, note: "4–6 months before start"),
                TimelineStep(type: .fees, title: "SEVIS fee payment receipt (Form I-901)", progress: 0.0, status: .notStarted, note: "3–5 months before start"),
                TimelineStep(type: .office, title: "Visa appointment confirmation", progress: 0.0, status: .inProgress, note: "Schedule Visa Interview (3–4 months before start)"),
                TimelineStep(type: .document, title: "Passport-style photograph", progress: 0.0, status: .inProgress, note: nil),
                TimelineStep(type: .document, title: "Financial documents", progress: 1.0, status: .submitted, note: nil),
                TimelineStep(type: .document, title: "Academic documents", progress: 1.0, status: .submitted, note: nil)
            ])
        ]
    }
}

struct TimelineChecklistView: View {
    let timeline: Timeline

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("F-1 Visa Application")
                    .font(.title2)
                    .bold()

                ForEach(timeline.steps) { step in
                    HStack(alignment: .top) {
                        Image(systemName: step.status == .notStarted ? "square" : "checkmark.square")
                            .foregroundColor(step.status == .notStarted ? .primary : .blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.title)
                                .fontWeight(step.status == .notStarted ? .semibold : .regular)
                                .strikethrough(step.status != .notStarted)
                                .foregroundColor(step.status != .notStarted ? .blue : .primary)

                            if let note = step.note {
                                Text(note)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(timeline.name)
    }
}

struct RecordsView: View {
    var body: some View {
        Text("Records Detail Page")
            .navigationTitle("Your Records")
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
    let status: StepStatus
    let note: String?
}

enum TimelineType: String, Codable, CaseIterable {
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

enum StepStatus: String, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "Documents In Progress"
    case submitted = "Documents Submitted"
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
