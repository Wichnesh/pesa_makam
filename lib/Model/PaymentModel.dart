class EmployeeRecord {
  String totalWorkingHours;
  String checkIn;
  String currentDate;
  String checkOut;

  EmployeeRecord({
    required this.totalWorkingHours,
    required this.checkIn,
    required this.currentDate,
    required this.checkOut,
  });

  // Create a factory method to parse the data from Firestore's document snapshot
  factory EmployeeRecord.fromFirestore(Map<String, dynamic>? data) {
    final Map<String, dynamic> parsedData = data as Map<String, dynamic>? ?? {};

    return EmployeeRecord(
      totalWorkingHours: parsedData['total working hr'] ?? '',
      checkIn: parsedData['check in'] ?? '',
      currentDate: parsedData['current date'] ?? '',
      checkOut: parsedData['check out'] ?? '',
    );
  }
}

class Employee {
  final String name;
  final String employeeId;
  final String doj;

  Employee(this.name, this.employeeId,this.doj);
}

class Advance {
  final String advance;
  final String currentdate;

  Advance({required this.advance, required this.currentdate});

  // Create a factory method to parse the data from Firestore's document snapshot
  factory Advance.fromFirestore(Map<String, dynamic>? data) {
    final Map<String, dynamic> parsedData = data as Map<String, dynamic>? ?? {};
    return Advance(
      advance: parsedData['Advance amount'] ?? '',
      currentdate: parsedData['current date'] ?? '',
    );
  }
}
