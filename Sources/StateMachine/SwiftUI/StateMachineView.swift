
import SwiftUI


@available(macOS 10.15, *)
@available(iOS 13.0, *)
private class StateMachineController<Output,Context>:ObservableObject {
    @Published public var viewState:Output
    private let stateMachine:StateMachine<Output,Context>
    private var task:Task<Void,Never>? = nil
    
    internal init(state:any StateInterface<Output,Context>, context:Context) {
        let machine = StateMachine(state: state, context: context)
        self.stateMachine = machine
        self.viewState = machine.output
        self.task = Task {
            @MainActor in
            for await newViewState in machine.outputStream {
                self.viewState = newViewState
            }
        }
    }
}


@available(macOS 10.15, *)
@available(iOS 13.0, *)
public struct StateMachineView<Output,Context,Content:View>:View {
    @ObservedObject private var controller:StateMachineController<Output,Context>
    private let content:(Output) -> Content
    
    public init(initialState:any StateInterface<Output,Context>, context:Context, @ViewBuilder content:@escaping (Output) -> Content) {
        self.controller = StateMachineController(state: initialState, context: context)
        self.content = content
    }
    
    public init(initialState:any StateInterface<Output,Context>, @ViewBuilder content:@escaping (Output) -> Content) where Context == Void {
        self.controller = StateMachineController(state: initialState, context: ())
        self.content = content
    }
    
    public var body: some View {
        content(controller.viewState)
    }
}


