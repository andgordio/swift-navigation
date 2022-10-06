#if compiler(>=5.5)
  extension View {
    /// Presents an alert from a binding to optional alert state.
    ///
    /// SwiftUI's `alert` view modifiers are driven by two disconnected pieces of state: an
    /// `isPresented` binding to a boolean that determines if the alert should be presented, and
    /// optional alert `data` that is used to customize its actions and message.
    ///
    /// Modeling the domain in this way unfortunately introduces a couple invalid runtime states:
    ///
    ///   * `isPresented` can be `true`, but `data` can be `nil`.
    ///   * `isPresented` can be `false`, but `data` can be non-`nil`.
    ///
    /// On top of that, SwiftUI's `alert` modifiers take static titles, which means the title cannot
    /// be dynamically computed from the alert data.
    ///
    /// This overload addresses these shortcomings with a streamlined API. First, it eliminates the
    /// invalid runtime states at compile time by driving the alert's presentation from a single,
    /// optional binding. When this binding is non-`nil`, the alert will be presented. Further, the
    /// title can be customized from the alert data.
    ///
    /// ```swift
    /// struct AlertDemo: View {
    ///   @State var randomMovie: Movie?
    ///
    ///   var body: some View {
    ///     Button("Pick a random movie", action: self.getRandomMovie)
    ///       .alert(
    ///         title: { Text($0.title) },
    ///         unwrapping: self.$randomMovie,
    ///         actions: { _ in
    ///           Button("Pick another", action: self.getRandomMovie)
    ///         },
    ///         message: { Text($0.summary) }
    ///       )
    ///   }
    ///
    ///   func getRandomMovie() {
    ///     self.randomMovie = Movie.allCases.randomElement()
    ///   }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: A closure returning the alert's title given the current alert state.
    ///   - value: A binding to an optional value that determines whether an alert should be
    ///     presented. When the binding is updated with non-`nil` value, it is unwrapped and passed
    ///     to the modifier's closures. You can use this data to populate the fields of an alert
    ///     that the system displays to the user. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `nil` and dismisses the alert.
    ///   - actions: A view builder returning the alert's actions given the current alert state.
    ///   - message: A view builder returning the message for the alert given the current alert
    ///     state.
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    public func alert<Value, A: View, M: View>(
      title: (Value) -> Text,
      unwrapping value: Binding<Value?>,
      @ViewBuilder actions: @escaping (Value) -> A,
      @ViewBuilder message: @escaping (Value) -> M
    ) -> some View {
      self.alert(
        value.wrappedValue.map(title) ?? Text(""),
        isPresented: value.isPresent(),
        presenting: value.wrappedValue,
        actions: actions,
        message: message
      )
    }

    /// Presents an alert from a binding to an optional enum, and a case path to a specific case.
    ///
    /// A version of `alert(unwrapping:)` that works with enum state.
    ///
    /// - Parameters:
    ///   - title: A closure returning the alert's title given the current alert state.
    ///   - enum: A binding to an optional enum that holds alert state at a particular case. When
    ///     the binding is updated with a non-`nil` enum, the case path will attempt to extract this
    ///     state
    ///     and then pass it to the modifier's closures. You can use it to populate the fields of an
    ///     alert that the system displays to the user. When the user presses or taps one of the
    ///     alert's actions, the system sets this value to `nil` and dismisses the alert.
    ///   - casePath: A case path that identifies a particular case that holds alert state.
    ///   - actions: A view builder returning the alert's actions given the current alert state.
    ///   - message: A view builder returning the message for the alert given the current alert
    ///     state.
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    public func alert<Enum, Case, A: View, M: View>(
      title: (Case) -> Text,
      unwrapping enum: Binding<Enum?>,
      case casePath: CasePath<Enum, Case>,
      @ViewBuilder actions: @escaping (Case) -> A,
      @ViewBuilder message: @escaping (Case) -> M
    ) -> some View {
      self.alert(
        title: title,
        unwrapping: `enum`.case(casePath),
        actions: actions,
        message: message
      )
    }

    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    public func alert<Enum, A: View, M: View>(
      title: Text,
      unwrapping enum: Binding<Enum?>,
      case casePath: CasePath<Enum, Void>,
      @ViewBuilder actions: @escaping () -> A,
      @ViewBuilder message: @escaping () -> M
    ) -> some View {
      self.alert(
        title: { title },
        unwrapping: `enum`,
        case: casePath,
        actions: actions,
        message: message
      )
    }
  }
#endif
