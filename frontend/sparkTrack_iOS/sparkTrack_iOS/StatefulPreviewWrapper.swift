//
//  StatefulPreviewWrapper.swift
//  sparkTrack_iOS
//
//  Created by 박서현 on 4/27/25.
//

import SwiftUI

struct StatefulPreviewWrapper<Value, Content: View>: View {
  @State private var value: Value
  var content: (Binding<Value>) -> Content
  
  init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
    _value = State(initialValue: value)
    self.content = content
  }
  
  var body: some View {
    content($value)
  }
}

#Preview {
  StatefulPreviewWrapper(EventStore()) { store in
    CustomCalendarView(eventStore: store.wrappedValue)
  }
}
