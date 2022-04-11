// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_trivia/core/network/network_info_interface.dart';
// import 'package:mocktail/mocktail.dart';
//
// class DataConnectionCheckerMock extends Mock implements DataConnectionChecker {}
//
// main() {
//   late DataConnectionCheckerMock dataConnectionCheckerMock;
//   late INetworkInfo networkInfo;
//
//   setUp(() {
//     dataConnectionCheckerMock = DataConnectionCheckerMock();
//     networkInfo = NetworkInfo(dataConnectionCheckerMock);
//   });
//
//   group("Is connected", () {
//     test("Should forward the call to DataConnectionChecker.hasConnection", () {
//       final hasConnectionFuture = Future.value(true);
//
//       when(() => dataConnectionCheckerMock.hasConnection)
//           .thenAnswer((_) => hasConnectionFuture);
//
//       final result = networkInfo.isConnected;
//
//       verify(() => dataConnectionCheckerMock.hasConnection);
//       expect(result, hasConnectionFuture);
//     });
//   });
// }
main() {}
