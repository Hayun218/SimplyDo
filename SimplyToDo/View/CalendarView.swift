import SwiftUI

struct CalendarView: View {
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @State var clickedDate: String = ""
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        changeMonth(by: 1)
                    } else if gesture.translation.width > 100 {
                        changeMonth(by: -1)
                    }
                    self.offset = CGSize()
                }
        )
    }
    
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            HStack{
                Text(month, formatter: Self.monthFormatter)
                    .padding()
                Spacer()
            }
            
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                        
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        
                        let clicked = (clickedDate == date)
                        
                        CellView(day: day, clicked: clicked)
                            .onTapGesture {
                                clickedDate = date
                            }
                            .onAppear(){
                                clickedDate = self.dateFormatter(date: Date())
                            }
                    }
                }
            }
        }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var day: Int
    var clicked: Bool
    
    init(day: Int, clicked: Bool) {
        self.day = day
        self.clicked = clicked
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(clicked ? .yellow : .blue)
                .opacity(0.5)
                .frame(width: 22, height: 22)
                .overlay(Text(String(day)))
                .padding()
            
        }
    }
}

// MARK: - 내부 메서드
private extension CalendarView {
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
        return self.dateFormatter(date: date)
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
}

// MARK: -
extension CalendarView {
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
    func dateFormatter(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
