part of 'controllers.dart';

class CiCoController extends GetxController {
  final String? region;
  final String? divisi;
  CiCoController({this.region, this.divisi});
  String? selectedOutlet;
  int? outletId;
  double? latOutlet, longOutlet, radius;
  List<VisitModel> visits = [];
  List<PlanVisitModel> planVisit = [];
  List<String> showList = [];
  var isplaned = false.obs;
  var isnoo = false.obs;
  TextEditingController laporanVisit = TextEditingController();
  String? transaksi;
  String? outletDivisi;

  List<String> yesNo = [
    'YES',
    'NO',
  ];

  String? validater(String? value) {
    if (value == null) {
      return 'wajib di isi';
    }

    if (value.isEmpty) {
      return 'wajib di isi';
    }
    return null;
  }

  //variable di halaman cico
  CameraPosition? initialCamera;
  GoogleMapController? controller;
  Marker? lokasi;
  Set<Circle>? circles;
  TextEditingController report = TextEditingController();
  File? foto;
  var isProcess = false.obs;

  //function di halaman awal cico
  Future<void> getPlan() async {
    ApiReturnValue<List<PlanVisitModel>> result =
        await PlanVisitServices.getPlanVisit(isNoo: isnoo.value);

    if (result.value != null) {
      planVisit = result.value!;
      List<String> namaOutlet = planVisit
          .map(
            (e) =>
                "${e.outlet!.namaOutlet} (${e.outlet!.distric}) ${isnoo.value ? e.outlet!.id : e.outlet!.kodeOutlet}",
          )
          .toList();
      showList = namaOutlet;
      update(['dropdown']);
    }
    update();
  }

  void changeTrans(String value) {
    transaksi = value;
    print(transaksi);
    update(['transaksi']);
  }

  Future<bool> getLatlong(String namaOutlet, bool checkin) async {
    bool isMockLocation = await TrustLocation.isMockLocation;

    if (isMockLocation) {
      notif("Peringatan !",
          "Anda menggunakan aplikasi gps palsu harap hapus terlebih dahulu");
      return false;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double lat = position.latitude;
    double long = position.longitude;

    if (isnoo.value || int.tryParse(namaOutlet) != null) {
      ApiReturnValue<NooModel> result =
          await OutletServices.getSingleOutletNoo(namaOutlet);
      if (result.value != null) {
        List<String> latlong = result.value!.latlong!.split(',').toList();
        for (int i = 0; i < latlong.length; i++) {
          if (i == 0) {
            latOutlet = double.parse(latlong[i]);
          } else {
            longOutlet = double.parse(latlong[i]);
          }
        }
        radius = 0;
        outletId = result.value!.id!;
      } else {
        return false;
      }
    } else {
      ApiReturnValue<OutletModel> result =
          await OutletServices.getSingleOutlet(namaOutlet);
      if (result.value != null) {
        List<String> latlong = result.value!.latlong!.split(',').toList();
        for (int i = 0; i < latlong.length; i++) {
          if (i == 0) {
            latOutlet = double.parse(latlong[i]);
          } else {
            longOutlet = double.parse(latlong[i]);
          }
        }
        radius = result.value!.radius!.toDouble();
        outletId = result.value!.id!;
      } else {
        return false;
      }
    }

    double isInRadius =
        Geolocator.distanceBetween(latOutlet!, longOutlet!, lat, long);

    if (checkin && radius != 0) {
      if (isInRadius > radius!) {
        notif("Salah", "Anda berada di luar radius outlet ini");
        return false;
      }
    }

    getCurrentPosition(lat, long);
    update();
    return true;
  }

  Future<void> getVisit() async {
    ApiReturnValue<List<VisitModel>> result =
        await VisitServices.getVisit(isnoo: true);
    ApiReturnValue<List<VisitModel>> result2 =
        await VisitServices.getVisit(isnoo: false);

    log('RESULT 1 ${result.value} - RESULT 2 ${result2.value}');
    if (result.value != null && result2.value != null) {
      final value = [...result.value!, ...result2.value!];
      value.sort(((a, b) => b.checkInTime!.compareTo(a.checkInTime!)));
      visits = value;
    }

    update(['logvisit']);
  }

  void extraCall() async {
    if (isplaned.value) {
      Get.defaultDialog(
          contentPadding: EdgeInsets.all(defaultMargin),
          barrierDismissible: false,
          title: "Loading ....",
          titleStyle: blackFontStyle1,
          middleText: 'Mengambil data Outlet',
          actions: [
            Center(
              child: CircularProgressIndicator(),
            )
          ]);
      ApiReturnValue<List<OutletModel>> result =
          await OutletServices.getOutlet(divisi: divisi, region: region);
      if (result.value != null) {
        List<String> outletName = result.value!
            .map(
              (e) => "${e.namaOutlet} (${e.distric}) ${e.kodeOutlet}",
            )
            .toList();
        Set setPlan = Set.from(showList);
        Set setOutlet = Set.from(outletName);

        List<String> data = List.from(setOutlet.difference(setPlan));
        showList = data;
      }

      Get.back();
    }
    update(['dropdown']);
  }

  void extraCallNoo() async {
    if (isnoo.value) {
      Get.defaultDialog(
          contentPadding: EdgeInsets.all(defaultMargin),
          barrierDismissible: false,
          title: "Loading ....",
          titleStyle: blackFontStyle1,
          middleText: 'Mengambil data Outlet',
          actions: [
            Center(
              child: CircularProgressIndicator(),
            )
          ]);
      ApiReturnValue<List<NooModel>> result =
          await NooService.getNooOutlet(divisi: divisi, region: region);
      if (result.value != null) {
        List<String> outletName = result.value!
            .map(
              (e) => "${e.namaOutlet} (${e.distric}) ${e.id}",
            )
            .toList();
        Set setPlan = Set.from(showList);
        Set setOutlet = Set.from(outletName);

        List<String> data = List.from(setOutlet.difference(setPlan));
        showList = data;
      }

      Get.back();
    }
    update(['dropdown']);
  }

  void changeListPlaned() {
    selectedOutlet = null;
    isplaned.toggle();
    update(['extracall']);
  }

  //TOGGLE NOO
  void changeListNooPlaned() {
    selectedOutlet = null;
    isnoo.toggle();
    update(['noo']);
  }

  void newSelected(String val) {
    selectedOutlet = null;
    selectedOutlet = val;
    update(['dropdown']);
  }

  Future<bool> check(String namaOutlet, bool checkin) async {
    ApiReturnValue<bool> result =
        await VisitServices.check(namaOutlet, checkin);

    if (result.value != null) {
      if (!result.value!) {
        notif("Salah", result.message!);
        return false;
      }
    }
    return true;
  }

  @override
  void onInit() async {
    getPlan();
    getVisit();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    super.onInit();
  }

  void notif(String judul, String msg) {
    Get.snackbar('title', 'message',
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(10),
        titleText:
            Text(judul, style: blackFontStyle1.copyWith(color: Colors.white)),
        messageText:
            Text(msg, style: blackFontStyle2.copyWith(color: Colors.white)),
        backgroundColor: Colors.red[900]);
  }

  //function googlemaps
  void getImage() async {
    final _picker = ImagePicker();
    isProcess.toggle();

    String _time = DateTime.now().toString();

    XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    if (pickedFile != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      final title = "FotoCiCo-$_time";
      final bytes = await pickedFile.readAsBytes();
      Img.Image? image = Img.decodeImage(bytes);
      Img.Image? resizeImg = Img.copyResize(image!, width: 720, height: 1280);
      var pureImg = new File("$path/$title.jpg")
        ..writeAsBytesSync(Img.encodeJpg(resizeImg));
      foto = pureImg;
      isProcess.toggle();
      update(['foto']);
    } else {
      isProcess.toggle();
      update(['foto']);
    }
  }

  Future<bool> getCurrentPosition(double lat, double long) async {
    initialCamera = CameraPosition(
      target: LatLng(latOutlet!, longOutlet!),
      zoom: 15.5,
    );
    lokasi = Marker(
      markerId: MarkerId(
        'lokasi',
      ),
      infoWindow: InfoWindow(title: "lokasi"),
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    circles = Set.from(
      [
        Circle(
            circleId: CircleId('lokasi'),
            center: LatLng(latOutlet!, longOutlet!),
            fillColor: Colors.red[200]!.withOpacity(0.5),
            strokeColor: Colors.red,
            strokeWidth: 0,
            radius: radius!),
      ],
    );
    update();
    return true;
  }

  Future<bool> submit(
    bool checkin,
    String tipeVisit, {
    String? laporan,
    String? transaksi,
    String? kodeOutlet,
  }) async {
    if (!checkin && laporan == '') {
      notif("Salah", "Laporan kunjungan harus di lampirkan");
      return false;
    }

    if (!checkin && transaksi == null) {
      notif("Salah", "Harus pilih transaksi");
      return false;
    }

    log(selectedOutlet.toString());

    Get.defaultDialog(
        contentPadding: EdgeInsets.all(defaultMargin),
        barrierDismissible: false,
        title: "Loading ....",
        titleStyle: blackFontStyle1,
        middleText: '',
        actions: [
          Center(
            child: CircularProgressIndicator(),
          )
        ]);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    ApiReturnValue<bool> result = await VisitServices.submit(
        selectedOutlet ?? '-',
        '${position.latitude},${position.longitude}',
        foto!,
        checkin,
        tipeVisit,
        laporan: laporan,
        transaksi: transaksi,
        isnoo:
            (isnoo.value && checkin) || int.tryParse(kodeOutlet ?? '') != null);
    if (result.value!) {
      return true;
    } else {
      notif("Salah", result.message!);
      return false;
    }
  }

  Future<bool> checkFoto(String outlet) async {
    ApiReturnValue<dynamic> result;

    if (isnoo.value) {
      result = await OutletServices.getSingleOutletNoo(outlet);
    } else {
      result = await OutletServices.getSingleOutlet(outlet);
    }

    if (result.value != null) {
      // outletDivisi = result.value!.divisi!.name;
      // print(outletDivisi);
      // print('cek video');
      if (result.value!.divisi!.name == 'REALME' &&
          (result.value!.potoDepan == null ||
              result.value!.potoKanan == null ||
              result.value!.potoKiri == null ||
              result.value!.potoShopSign == null)) {
        outletDivisi = result.value!.divisi!.name;
        return false;
      } else if (result.value!.divisi!.name == 'REALME' &&
          result.value!.video == null) {
        return true;
      } else {
        if (result.value!.divisi!.name != 'REALME' &&
            result.value!.video == null) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> getDivisi(String outlet) async {
    ApiReturnValue<OutletModel> result =
        await OutletServices.getSingleOutlet(outlet);

    if (result.value != null) {
      outletDivisi = result.value!.divisi!.name;
      print(outletDivisi);
      //return outletDivisi;
    }
  }

  Future<bool> checkFotoRealme(String outlet) async {
    ApiReturnValue<OutletModel> result =
        await OutletServices.getSingleOutlet(outlet);
    print('cek foto realme');
    if (result.value != null) {
      if (result.value!.potoShopSign == null ||
          result.value!.potoDepan == null ||
          result.value!.potoKanan == null ||
          result.value!.potoKiri == null) {
        return false;
      }
    }
    return true;
  }

  void notifUpdateFoto(String namaOutlet, String divisiOutlet) {
    Get.defaultDialog(
      title: 'Info',
      titleStyle: blackFontStyle1,
      middleText:
          'Outlet ini belum update \nSilahkan upload foto/video\ndan detail pemilik outlet\nkemudian lanjut Check In',
      middleTextStyle: blackFontStyle3,
      barrierDismissible: false,
      onConfirm: () => divisiOutlet == 'REALME'
          ? Get.to(() => UpdateFotoRealme(namaOutlet: namaOutlet))
          : Get.to(() => UpdateFotoOutlet(
                namaOutlet: namaOutlet,
              )),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
    );
  }

  void notifUpdateRealme(String namaOutlet) {
    Get.defaultDialog(
      title: 'Info',
      titleStyle: blackFontStyle1,
      middleText:
          'Outlet ini belum update foto\nSilahkan upload foto\ndan detail pemilik outlet\nkemudian lanjut Check In',
      middleTextStyle: blackFontStyle3,
      barrierDismissible: false,
      onConfirm: () => Get.to(() => UpdateFotoRealme(
            namaOutlet: namaOutlet,
          )),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
    );
  }

  @override
  void dispose() {
    laporanVisit.dispose();
    super.dispose();
  }
}
