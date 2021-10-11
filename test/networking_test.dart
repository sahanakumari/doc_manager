import 'package:doc_manager/models/models.dart';
import 'package:doc_manager/networking_n_storage/networking.dart';
import 'package:test/test.dart';

class NetworkingTest {
  Future getDoctors() {
    return Networking.get("/contacts").then((value) {
      if (value.response is List) {
        return value.response
                .map<Doctor>((e) => Doctor.fromJson(e))
                ?.toList() ??
            [];
      }
      throw value.response;
    }).catchError((err) {
      throw err;
    });
  }
}

void main() {
  test('Provided should fetch data and add to the list', () async {
    final provider = NetworkingTest();
    var items = await provider.getDoctors();
    print(items);
    expect(items.isNotEmpty, true);
  });
}
