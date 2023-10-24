// import 'package:esc_pos_printer/esc_pos_printer.dart';
//
// void printReceipt() async {
//   final profile = await CapabilityProfile.load();
//   final printer = NetworkPrinter(PaperSize.mm80, profile);
//
//   const PaperSize paper = PaperSize.mm80;
//   final profile = await CapabilityProfile.load();
//
//   final printer = NetworkPrinter(paper, profile);
//
//   final PosPrintResult res = await printer.connect('192.168.1.100', port: 9100);
//
//   if (res != PosPrintResult.success) {
//     print('Could not connect to the printer. Aborting...');
//     return;
//   }
//
//   final PosPrintResult printRes = await printer.printTicket(buildReceipt());
//   if (printRes == PosPrintResult.success) {
//     print('Receipt printed successfully.');
//   } else {
//     print('Error printing receipt: $printRes');
//   }
//
//   printer.disconnect();
// }
//
// PosPrintResult buildReceipt() {
//   final profile = await CapabilityProfile.load();
//   final printer = NetworkPrinter(paper, profile);
//
//   const PaperSize paper = PaperSize.mm80;
//   final profile = await CapabilityProfile.load();
//
//   final printer = NetworkPrinter(paper, profile);
// }
//
// PosPrintResult buildReceipt() {
//   final profile = await CapabilityProfile.load();
//   final printer = NetworkPrinter(paper, profile);
//
//   const PaperSize paper = PaperSize.mm80;
//   final profile = await CapabilityProfile.load();
//
//   final printer = NetworkPrinter(paper, profile);
//
//   final PosPrintResult res = await printer.connect('192.168.1.100', port: 9100);
//
//   if (res != PosPrintResult.success) {
//     print('Could not connect to the printer. Aborting...');
//     return res;
//   }
//
//   printer.text('Restaurant Name',
//       styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2));
//   printer.text('Address: Restaurant Address');
//   printer.text('Phone: Restaurant Phone Number');
//   printer.text('Website: Restaurant Website');
//   printer.feed(1);
//
//   printer.text('TAX INVOICE / BILL',
//       styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2));
//   printer.text('Date: Date');
//   printer.text('Table: Table Number');
//   printer.text('Server: Server\'s Name');
//   printer.feed(1);
//
//   printer.row([
//     PosColumn(text: 'Item', width: 6),
//     PosColumn(text: 'Quantity', width: 3),
//     PosColumn(text: 'Unit Price', width: 3),
//     PosColumn(text: 'Total', width: 4),
//   ]);
//
//   printer.row([
//     PosColumn(text: 'Apple', width: 6),
//     PosColumn(text: '2', width: 3, align: PosAlign.right),
//     PosColumn(text: '20', width: 3, align: PosAlign.right),
//     PosColumn(text: '40', width: 4, align: PosAlign.right),
//   ]);
//
//   printer.feed(1);
//
//   printer.text('Subtotal: Subtotal');
//   printer.text('Tax (%): Tax Amount');
//   printer.text('Total: Total Amount');
//   printer.feed(1);
//
//   printer.text('Payment Method: Payment Method');
//   printer.text('Transaction ID: Transaction ID (if applicable)');
//   printer.feed(1);
//
//   printer.text('Thank you for dining with us!',
//       styles: PosStyles(align: PosAlign.center));
//   printer.text('For feedback or inquiries, please contact Contact Information');
//   printer.feed(2);
//
//   final PosPrintResult printRes = await printer.cut();
//   printer.disconnect();
//   return printRes;
// }
