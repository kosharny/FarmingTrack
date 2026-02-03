import SwiftUI

struct TaskExecutionViewFT: View {
    let task: TaskModelFT
    @EnvironmentObject var viewModel: MainViewModelFT
    @Environment(\.dismiss) var dismiss
    
    @State private var currentStepIndex = 0
    @State private var isFinished = false
    @State private var isPulsing = false
    @State private var showBurst = false
    @State private var burstScale: CGFloat = 0.2
    @State private var burstOpacity: Double = 0
    @State private var idlePulse = false
    @State private var idleRotation = 0.0



    
    var currentStep: TaskStepFT {
        task.steps[currentStepIndex]
    }
    
    var progress: Double {
        Double(currentStepIndex + 1) / Double(task.steps.count)
    }
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Step \(currentStepIndex + 1) of \(task.steps.count)")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                
                // Progress Bar
                ProgressView(value: progress)
                    .tint(Color.FT.farmGreen)
                    .background(Color.white.opacity(0.2))
                    .padding(.horizontal)
                
                Spacer()
                
                // Step Content
                VStack(spacing: 30) {
                    Text(currentStep.title)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .id("title-\(currentStepIndex)")
                    
                    Text(currentStep.description)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    ZStack {
                        // Idle Core
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.FT.primaryYellow,
                                        Color.FT.primaryYellow.opacity(0.6),
                                        Color.FT.primaryYellow.opacity(0.2)
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 160, height: 160)
                            .scaleEffect(idlePulse ? 1.05 : 0.95)
                            .rotationEffect(.degrees(idleRotation))
                            .blur(radius: 2)
                            .opacity(showBurst ? 0 : 1)

                        // Thin rotating ring
                        Circle()
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        .clear,
                                        Color.FT.primaryYellow,
                                        .clear
                                    ],
                                    center: .center
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(idleRotation))
                            .opacity(0.6)

                        // Action Burst (поверх)
                        if showBurst {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.FT.primaryYellow,
                                            Color.FT.primaryYellow.opacity(0.4),
                                            .clear
                                        ],
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 160
                                    )
                                )
                                .scaleEffect(burstScale)
                                .opacity(burstOpacity)
                                .frame(width: 320, height: 320)
                                .blur(radius: 10)
                        }
                    }
                    .allowsHitTesting(false)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            idlePulse = true
                        }

                        withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                            idleRotation = 360
                        }
                    }


                    
                    // Tip / Extra Detail
                    VStack(spacing: 8) {
                        
                        Text("Focus on quality over speed. Ensure each step is done correctly for maximum reward points.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(.easeInOut, value: currentStepIndex)
                
                Spacer()
                
                // Controls
                VStack(spacing: 16) {
                    if currentStepIndex < task.steps.count - 1 {
                        PrimaryButtonFT(title: "Next Step", icon: "arrow.right", action: {
                            withAnimation {
                                currentStepIndex += 1
                            }
                        })
                    } else {
                        PrimaryButtonFT(title: "Finish Task", icon: "checkmark.seal.fill", color: Color.FT.primaryYellow, action: {
                            finishTask()
                        })
                    }
                }
                .padding(.bottom, 50)
                .padding(.horizontal)
            }
        }
    }

    
    private func finishTask() {
        viewModel.completeTask(task)
        dismiss()
    }
}
