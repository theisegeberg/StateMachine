
public protocol StateInterface<Output,Context> {
    associatedtype Output
    associatedtype Context
    func enter(
        changeContext:StateChangeContext<Output,Context>
    ) -> Output
    
}
