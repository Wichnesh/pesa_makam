class Employeelist {
  String? name;
  Employeelist({this.name});
}

class EmployeeRecordA {
  String currentDate;
  String checkIn;
  bool checkInBool;
  String checkOut;
  bool checkOutBool;

  EmployeeRecordA({
    required this.currentDate,
    required this.checkIn,
    required this.checkInBool,
    required this.checkOut,
    required this.checkOutBool,
  });

  factory EmployeeRecordA.fromMap(Map<String, dynamic> map) {
    return EmployeeRecordA(
      currentDate: map['current date'],
      checkIn: map['check in'],
      checkInBool: map['check in bool'],
      checkOut: map['check out'],
      checkOutBool: map['check out bool'],
    );
  }
}

