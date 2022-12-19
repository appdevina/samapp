part of 'controllers.dart';

class RegisterNooController extends GetxController {
  TextEditingController? namaOutlet,
      alamatOutlet,
      daerahOutlet,
      namaPemilikOutlet,
      ktpOutlet,
      nomorPemilikOutlet,
      nomerWakilOutlet,
      distric;

  String? oppo,
      vivo,
      realme,
      samsung,
      xiaomi,
      fl,
      selectedClus,
      selectedBu,
      selectedReg,
      selectedDiv,
      selectedJenis;

  int? role;
  CameraPosition? initialCamera;
  double? lat, long;
  Marker? lokasi;
  File? shopSign, depan, kanan, kiri, video, ktp;
  VideoPlayerController? videoPlayerController;
  List<BadanUsahaModel>? badanUsaha;
  List<DivisiModel>? div;
  List<RegionModel>? reg;
  List<ClusterModel>? clus;

  final submitFormKey = GlobalKey<FormState>();

  List<String> opsiAngka = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  List<String> jenis = [
    'NOO',
    'LEAD',
  ];

  void onChangeCluster(String value) {
    selectedClus = value;
    print(selectedClus);
    update(['position']);
  }

  Future<int> getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getInt('role');
    update(['position']);
    return role!;
  }

  void onChangeDigit(String val, String nama) {
    switch (nama) {
      case 'oppo':
        oppo = val;
        break;
      case 'vivo':
        vivo = val;
        break;
      case 'realme':
        realme = val;
        break;
      case 'infinix':
        samsung = val;
        break;
      case 'xiaomi':
        xiaomi = val;
        break;
      default:
        fl = val;
    }
    update(['dropdowndigit']);
  }

  void getImage(String namaFile, ImageSource source) async {
    Get.back();
    Get.defaultDialog(
        title: 'Tunggu ...',
        middleText: 'sedang memproses foto',
        actions: [
          Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ]);
    final _picker = ImagePicker();

    XFile? pickedFile = await _picker.pickImage(
      source: source,
    );

    if (pickedFile != null) {
      switch (namaFile) {
        case 'fotodepan':
          File convert = await convertImage(namaFile, pickedFile);
          depan = convert;
          update(['fotodepan']);
          break;
        case 'fotokanan':
          File convert = await convertImage(namaFile, pickedFile);
          kanan = convert;
          update(['fotokanan']);
          break;
        case 'fotokiri':
          File convert = await convertImage(namaFile, pickedFile);
          kiri = convert;
          update(['fotokiri']);
          break;
        case 'fotoktp':
          File convert = await convertImage(namaFile, pickedFile);
          ktp = convert;
          update(['fotoktp']);
          break;
        default:
          File convert = await convertImage(namaFile, pickedFile);
          shopSign = convert;
          update(['fotoshopsign']);
      }
      Get.back();
      update(['butfoto']);
    }
    if (pickedFile == null) {
      Get.back();
    }
  }

  Future<File> convertImage(String namaFile, XFile pickedFile) async {
    String _time = DateFormat('MMM-d-yyyy-kk-mm-ss').format(DateTime.now());
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final title = 'noo-' + _time + '-' + namaFile;
    final bytes = await pickedFile.readAsBytes();
    Img.Image? image = Img.decodeImage(bytes);
    Img.Image? resizeImg = Img.copyResize(image!, width: 720, height: 1280);
    var pureImg = new File("$path/$title.jpg")
      ..writeAsBytesSync(Img.encodeJpg(resizeImg));
    return pureImg;
  }

  void opsiMediaFoto(String namaFile) {
    Get.defaultDialog(
      title: 'Upload Foto',
      titleStyle: blackFontStyle2,
      middleText: 'Pilih media :',
      middleTextStyle: blackFontStyle3,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all("FF3F0A".toColor()),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () {
                getImage(namaFile, ImageSource.gallery);
              },
              child: Text(
                "Galeri",
                style: blackFontStyle3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all("FF3F0A".toColor()),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () {
                getImage(namaFile, ImageSource.camera);
              },
              child: Text(
                "Kamera",
                style: blackFontStyle3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void deleteFoto(String namaFile) {
    switch (namaFile) {
      case 'fotodepan':
        depan = null;
        update(['fotodepan']);
        break;
      case 'fotokanan':
        kanan = null;
        update(['fotokanan']);
        break;
      case 'fotokiri':
        kiri = null;
        update(['fotokiri']);
        break;
      default:
        shopSign = null;
        update(['fotoshopsign']);
    }
    update(['butfoto']);
  }

  Future<bool> getCurrentPosition() async {
    bool isMockLocation = await TrustLocation.isMockLocation;
    if (isMockLocation) {
      return false;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;
    initialCamera = CameraPosition(
      target: LatLng(lat!, long!),
      zoom: 16,
    );
    lokasi = Marker(
      markerId: MarkerId(
        'lokasi',
      ),
      infoWindow: InfoWindow(title: "lokasi"),
      position: LatLng(lat!, long!),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    update(['gmaps']);
    return true;
  }

  String? validater(String? value) {
    if (value == null) {
      return 'wajib di isi';
    }

    if (value.isEmpty) {
      return 'wajib di isi';
    }
    return null;
  }

  void getVideo(BuildContext context) async {
    ImagePicker picker = ImagePicker();

    XFile? pickedVideo = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(
        minutes: 1,
      ),
    );
    if (pickedVideo != null) {
      compressvideo(context, pickedVideo);
    }
  }

  Future compressvideo(BuildContext context, XFile pickedVideo) async {
    showDialog(
        context: context,
        builder: (context) => Dialog(child: ProgressDialogWidget()),
        barrierDismissible: false);
    final info = await VideoCompressApi.compressVideo(
      File(pickedVideo.path),
    );

    if (info != null) {
      video = info.file;
      Get.back();
      videoPlayerController = VideoPlayerController.file(video!)
        ..initialize().then((_) {
          videoPlayerController!.play();
          update(['video', 'butvid']);
        });
    }
  }

  void play() => videoPlayerController!.play();

  void pause() =>
      videoPlayerController != null ? videoPlayerController!.pause() : null;

  void deleteVideo() {
    video = null;
    update(['video', 'butvid']);
  }

  void notif(String judul, String msg) => Get.snackbar('title', 'message',
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(10),
      titleText:
          Text(judul, style: blackFontStyle1.copyWith(color: Colors.white)),
      messageText:
          Text(msg, style: blackFontStyle2.copyWith(color: Colors.white)),
      backgroundColor: Colors.red[900]);

  void notifLoading(String title, String subtitle) => Get.defaultDialog(
        title: title,
        middleText: subtitle,
        barrierDismissible: false,
        actions: [
          Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ],
      );

  void dialogSubmit(String jenis) => Get.defaultDialog(
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  "FF3F0A".toColor(),
                ),
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                Get.offAll(() => MainPage(), arguments: 0);
              },
              child: Text(
                "OK",
                style: blackFontStyle3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          title: 'Berhasil',
          middleText: 'Data $jenis sudah di tambahkan',
          titleStyle: blackFontStyle3.copyWith(fontSize: 14),
          middleTextStyle: blackFontStyle2);

  Future<List<BadanUsahaModel>> getBu() async {
    ApiReturnValue<List<BadanUsahaModel>> result = await NooService.getBu();

    return result.value!;
  }

  void onChangeTmBu(String val) async {
    selectedBu = null;
    selectedDiv = null;
    selectedReg = null;
    selectedClus = null;
    div = [];
    reg = [];
    clus = [];
    selectedBu = val;
    await getDiv(val).then((value) => div = value);
    update(['position']);
  }

  void onChangeJenis(String val) {
    selectedJenis = null;
    selectedJenis = val;
    update(['jenis', 'fotoktp']);
  }

  void onChangeTmDiv(String val) async {
    selectedDiv = null;
    selectedReg = null;
    selectedClus = null;
    reg = [];
    clus = [];
    selectedDiv = val;
    await getReg(selectedBu!, val).then((value) => reg = value);
    update(['position']);
  }

  void onChangeTmReg(String val) async {
    selectedReg = null;
    selectedClus = null;
    clus = [];
    selectedReg = val;
    await getCluster(bu: selectedBu, div: selectedDiv, reg: selectedReg)
        .then((value) => clus = value);
    update(['position']);
  }

  void onChangeTmClus(String val) async {
    selectedClus = null;
    selectedClus = val;
    print("${selectedBu} - ${selectedDiv} - ${selectedReg} - ${selectedClus}");
    update(['position']);
  }

  Future<List<DivisiModel>> getDiv(String bu) async {
    ApiReturnValue<List<DivisiModel>> result = await NooService.getDiv(bu);

    return result.value!;
  }

  Future<List<RegionModel>> getReg(String bu, String div) async {
    ApiReturnValue<List<RegionModel>> result = await NooService.getReg(bu, div);

    return result.value!;
  }

  Future<List<ClusterModel>> getCluster(
      {String? bu, String? div, String? reg, int? role}) async {
    ApiReturnValue<List<ClusterModel>> result =
        await NooService.getClus(bu: bu, div: div, reg: reg, role: role);

    return result.value!;
  }

  void send(String jenis) async {
    List<File> images = [];
    if (jenis == "NOO") {
      images.add(shopSign!);
      images.add(depan!);
      images.add(kanan!);
      images.add(kiri!);
      images.add(ktp!);
    } else {
      images.add(shopSign!);
      images.add(depan!);
      images.add(kanan!);
      images.add(kiri!);
    }
    notifLoading('Tunggu', 'Sedang mengirim data');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String latlong = '${position.latitude},${position.longitude}';
    ApiReturnValue<bool> result = await NooService.submit(
      images,
      video!,
      namaOutlet!.text,
      namaPemilikOutlet!.text,
      ktpOutlet!.text,
      alamatOutlet!.text,
      nomorPemilikOutlet!.text,
      nomerWakilOutlet!.text,
      distric!.text,
      oppo ?? '0',
      vivo ?? '0',
      samsung ?? '0',
      realme ?? '0',
      xiaomi ?? '0',
      fl ?? '0',
      latlong,
      bu: selectedBu,
      div: selectedDiv,
      reg: selectedReg,
      clus: selectedClus,
      jenis: jenis,
    );
    if (result.value != null) {
      Get.back();
      if (result.value!) {
        dialogSubmit(jenis);
      } else {
        notif("Gagal", result.message!);
      }
    }
  }

  void submit() async {
    if (submitFormKey.currentState!.validate()) {
      if (selectedJenis == 'NOO') {
        if (video == null ||
            shopSign == null ||
            depan == null ||
            kanan == null ||
            kiri == null ||
            ktp == null) {
          notif("Registrasi NOO",
              "Data belum lengkap silahkan cek pada bagian foto/video \nMode NOO wajib KTP/NPWP");
        } else {
          send(selectedJenis!);
        }
      } else {
        if (video == null ||
            shopSign == null ||
            depan == null ||
            kanan == null ||
            kiri == null) {
          notif("Registrasi LEAD",
              "Data belum lengkap silahkan cek pada bagian foto/video");
        } else {
          send(selectedJenis!);
        }
      }
    } else {
      notif("Salah",
          'Data belum lengkap pada kolom bertuliskan wajib isi, cek kembali dan lengkapi data');
    }
  }

  @override
  void onInit() async {
    namaOutlet = TextEditingController();
    alamatOutlet = TextEditingController();
    daerahOutlet = TextEditingController();
    namaPemilikOutlet = TextEditingController();
    ktpOutlet = TextEditingController();
    nomorPemilikOutlet = TextEditingController();
    nomerWakilOutlet = TextEditingController();
    distric = TextEditingController();
    getCurrentPosition();
    await getRole().then((value) async => (value == 1 || value == 9)
        ? await getBu().then((value) => badanUsaha = value)
        : (value == 2)
            ? await getCluster(role: value).then((value) => clus = value)
            : print("skip"));
    update(['position']);
    super.onInit();
  }

  @override
  void onClose() {
    namaOutlet!.dispose();
    alamatOutlet!.dispose();
    daerahOutlet!.dispose();
    namaPemilikOutlet!.dispose();
    ktpOutlet!.dispose();
    nomorPemilikOutlet!.dispose();
    distric!.dispose();
    super.onClose();
  }
}
