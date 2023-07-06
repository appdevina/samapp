part of 'services.dart';

class VisitServices {
  static Future<ApiReturnValue<bool>> submit(
    String namaOutlet,
    String latlong,
    File pictureFile,
    bool checkin,
    String tipeVisit, {
    http.MultipartRequest? request,
    String? laporan,
    String? transaksi,
    required bool isnoo,
  }) async {
    try {
      String url = '${baseUrl}${isnoo ? 'visitNoo' : 'visit'}';
      Uri uri = Uri.parse(url);
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (request == null) {
        request = http.MultipartRequest("POST", uri)
          ..headers["Content-Type"] = "application/json"
          ..headers["Authorization"] = "Bearer ${pref.getString('token')}";
      }

      var multiPartFile =
          await http.MultipartFile.fromPath('picture_visit', pictureFile.path);

      String kodeOutlet = namaOutlet.split(' ').last;

      if (checkin) {
        request
          ..fields['kode_outlet'] = kodeOutlet
          ..fields['latlong_in'] = latlong
          ..fields['tipe_visit'] = tipeVisit
          ..files.add(multiPartFile);
      } else {
        request
          ..fields['latlong_out'] = latlong
          ..fields['laporan_visit'] = laporan!
          ..fields['transaksi'] = transaksi!
          ..files.add(multiPartFile);
      }

      var response = await request.send();

      if (response.statusCode != 200) {
        return ApiReturnValue(
            message: 'Ada permasalahan pada server', value: false);
      }

      return ApiReturnValue(value: true);
    } catch (err) {
      return ApiReturnValue(value: false, message: err.toString());
    }
  }

  static Future<ApiReturnValue<List<VisitModel>>> getVisit({
    http.Client? client,
    required bool isnoo,
  }) async {
    if (client == null) {
      client = http.Client();
    }

    try {
      String url = '${baseUrl}visit?isnoo=${isnoo ? 1 : ''}';
      Uri uri = Uri.parse(url);
      SharedPreferences pref = await SharedPreferences.getInstance();

      print(url);

      var response = await client.get(uri, headers: {
        'Content-Type': "application/json",
        'Authorization': "Bearer ${pref.getString('token')}",
      });

      if (response.statusCode != 200) {
        var data = jsonDecode(response.body);
        String message = data['message'];
        return ApiReturnValue(message: message);
      }

      log('${isnoo} ${response.body}');
      var data = jsonDecode(response.body);

      List<VisitModel> value = (data['data'] as Iterable)
          .map((e) => VisitModel.fromJson(e))
          .toList();

      return ApiReturnValue(value: value);
    } catch ($err) {
      log($err.toString());
      return ApiReturnValue(message: $err.toString());
    }
  }

  static Future<ApiReturnValue<bool>> check(String namaOutlet, bool checkin,
      {http.Client? client}) async {
    try {
      String kodeOutlet = namaOutlet.split(' ').last;
      if (client == null) {
        client = http.Client();
      }

      String url = (checkin)
          ? baseUrl + "visit/check/?kode_outlet=$kodeOutlet&check_in=$checkin"
          : baseUrl + "visit/check/?kode_outlet=$kodeOutlet";
      Uri uri = Uri.parse(url);

      SharedPreferences pref = await SharedPreferences.getInstance();

      var response = await client.get(uri, headers: {
        'Content-Type': "application/json",
        'Authorization': "Bearer ${pref.getString('token')}",
      });

      if (response.statusCode != 200) {
        var data = jsonDecode(response.body);
        String message = data['meta']['message'];
        return ApiReturnValue(value: false, message: message);
      }

      return ApiReturnValue(value: true);
    } catch (err) {
      return ApiReturnValue(value: false, message: err.toString());
    }
  }

  static Future<ApiReturnValue<List<VisitModel>>> getMonitorVisit({
    http.Client? client,
    required DateTime date,
  }) async {
    try {
      if (client == null) {
        client = http.Client();
      }

      String url = baseUrl +
          "visit/monitor?date=${DateFormat('yyyy-MM-dd').format(date)}";
      //bikin 2 isnoo di hardcode kaya getVisit() di ci_co_controller
      Uri uri = Uri.parse(url);

      SharedPreferences pref = await SharedPreferences.getInstance();

      var response = await client.get(uri, headers: {
        'Content-Type': "application/json",
        'Authorization': "Bearer ${pref.getString('token')}",
      });

      if (response.statusCode != 200) {
        var data = jsonDecode(response.body);
        String message = data['meta']['message'];
        return ApiReturnValue(value: [], message: message);
      }
      var data = jsonDecode(response.body);

      List<VisitModel> value = (data['data'] as Iterable)
          .map((e) => VisitModel.fromJson(e))
          .toList();

      return ApiReturnValue(value: value);
    } catch (e) {
      return ApiReturnValue(value: [], message: e.toString());
    }
  }
}
