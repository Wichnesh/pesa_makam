class Employeelist {
  String? name;
  Employeelist({this.name});
}

class EmployeeRecord {
  String currentDate;
  String checkIn;
  bool checkInBool;
  String checkOut;
  bool checkOutBool;

  EmployeeRecord({
    required this.currentDate,
    required this.checkIn,
    required this.checkInBool,
    required this.checkOut,
    required this.checkOutBool,
  });

  factory EmployeeRecord.fromMap(Map<String, dynamic> map) {
    return EmployeeRecord(
      currentDate: map['current date'],
      checkIn: map['check in'],
      checkInBool: map['check in bool'],
      checkOut: map['check out'],
      checkOutBool: map['check out bool'],
    );
  }
}
