import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates how to take small features and compose them into bigger ones using reducer builders and the `Scope` reducer, as well as the `scope` operator on stores.

  It reuses the domain of the counter screen and embeds it, twice, in a larger domain.
  """

// MARK: - Feature domain

struct TwoCounters: Reducer {
  struct State: Equatable {
    var counter1 = Counter.State()
    var counter2 = Counter.State()
  }

  @CasePathable
  enum Action: Equatable {
    case counter1(Counter.Action)
    case counter2(Counter.Action)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.counter1, action: \.counter1) {
      Counter()
    }
    Scope(state: \.counter2, action: \.counter2) {
      Counter()
    }
  }
}

// MARK: - Feature view

struct TwoCountersView: View {
  @State var store = Store(initialState: TwoCounters.State()) {
    TwoCounters()
  }

  var body: some View {
    Form {
      Section {
        AboutView(readMe: readMe)
      }

      HStack {
        Text("Counter 1")
        Spacer()
        CounterView(store: self.store.scope(state: \.counter1, action: { .counter1($0) }))
      }

      HStack {
        Text("Counter 2")
        Spacer()
        CounterView(store: self.store.scope(state: \.counter2, action: { .counter2($0) }))
      }
    }
    .buttonStyle(.borderless)
    .navigationTitle("Two counters demo")
  }
}

// MARK: - SwiftUI previews

struct TwoCountersView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TwoCountersView(
        store: Store(initialState: TwoCounters.State()) {
          TwoCounters()
        }
      )
    }
  }
}
