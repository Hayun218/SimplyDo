//
//  MainView.swift
//  SimplyToDo
//
//  Created by yun on 2023/08/04.
//

import SwiftUI

struct MainView: View {
    @State var currentDate: Date = Date()
    var body: some View {
        CalendarView(month: .now)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
