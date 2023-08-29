
import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public extension StateInterface {
    func binding<T>(changeContext: StateChangeContext<Output, Context>, kp:WritableKeyPath<Self,T>) -> Binding<T> {
        Binding<T>(get: {
            self[keyPath: kp]
        }, set: { newValue in
            var copy = self
            copy[keyPath: kp] = newValue
            changeContext.enter(state: copy)
        })
    }
}
