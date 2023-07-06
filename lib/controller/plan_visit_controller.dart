part of 'controllers.dart';

class PlanVisitController extends GetxController {
  final String? region;
  final String? divisi;
  PlanVisitController({this.region, this.divisi});
  String selectedMonth = '-';
  String? selectedOutlet;
  String? bulan;
  String? tahun;
  int? idPlanVisit;
  DateTime? selectedDateTime;
  List<String> plans = [];
  List<String> allOutlet = [];
  List<PlanVisitModel> planVisit = [];
  var isnoo = false.obs;
  bool isinit = false;
  //final homeController = Get.find<HomePageController>();

  String? validater(String? value) {
    if (value!.isEmpty) {
      return 'wajib di isi';
    }
    return null;
  }

  void show() {
    Get.bottomSheet(
      SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.multiple,
        initialDisplayDate: selectedDateTime,
        maxDate: selectedDateTime!.add(Duration(days: 31)),
        minDate: DateTime(selectedDateTime!.year, selectedDateTime!.month),
        backgroundColor: Colors.white,
        cancelText: "CANCEL",
        confirmText: "OK",
        onCancel: () {
          Get.back();
        },
        showActionButtons: true,
        onSubmit: (Object? value) {
          if (selectedOutlet == null) {
            Get.back();
            Future.delayed(Duration(milliseconds: 400))
                .then((value) => notif('Salah', 'Pilih outlet dahulu'));
          } else {
            if (value != null) {
              List datas = (value as List).map((e) => e).toList();
              datas.sort();
              for (var data in datas) {
                addPlan(DateFormat("yyyy-MM-dd").format(data));
              }
            }
            Future.delayed(Duration(seconds: 1))
                .then((value) => getPlanByMonth(tahun!, bulan!));
            selectedOutlet = null;
            update(['dropdown']);
            Get.back();
          }
        },
      ),
    );
  }

  void addPlan(String date) async {
    if (selectedOutlet != null) {
      String kodeOutlet = selectedOutlet!.split(' ').last;
      ApiReturnValue<bool> result = await PlanVisitServices.addPlanVisit(
          date, kodeOutlet,
          isNoo: isnoo.value);
      print(date);
      print(kodeOutlet);
      if (result.value!) {
        notif(
          'Berhasil',
          "Menambahkan plan visit",
        );
      } else {
        notif(
          "Error",
          result.message!,
        );
      }
    }
  }

  void changeMonth(DateTime value) {
    selectedDateTime = value;
    selectedMonth = DateFormat("MMMM, y").format(value);
    bulan = DateFormat('MM').format(value);
    tahun = DateFormat('y').format(value);
    if (tahun != null && bulan != null) {
      getPlanByMonth(tahun!, bulan!);
    }
    update(['tanggal', 'list', 'button']);
  }

  Future<void> getOutlet() async {
    print('proses');
    if (isnoo.value) {
      ApiReturnValue<List<NooModel>> result =
          await NooService.getNooOutlet(divisi: divisi, region: region);

      if (result.value != null) {
        allOutlet = result.value!
            .map((e) => "${e.namaOutlet} (${e.distric}) ${e.id}")
            .toList();
      }
    } else {
      ApiReturnValue<List<OutletModel>> result =
          await OutletServices.getOutlet(divisi: divisi, region: region);

      if (result.value != null) {
        allOutlet = result.value!
            .map((e) => "${e.namaOutlet} (${e.distric}) ${e.kodeOutlet}")
            .toList();
      }
    }
    update(['dropdown']);
  }

  void getPlanByMonth(String tahun, String bulan) async {
    ApiReturnValue<List<PlanVisitModel>> plan =
        await PlanVisitServices.getPlanbyMonth(tahun, bulan,
            isNoo: isnoo.value);

    if (isnoo.value) {
      if (plan.value != null) {
        planVisit = plan.value!;
        plans = plan.value!
            .map((e) =>
                "${e.outlet!.namaOutlet} (${e.outlet!.distric}) ${e.outlet!.id}")
            .toSet()
            .toList();
        plans.sort();
        update(['list']);
      }
    } else {
      if (plan.value != null) {
        planVisit = plan.value!;
        plans = plan.value!
            .map((e) =>
                "${e.outlet!.namaOutlet} (${e.outlet!.distric}) ${e.outlet!.kodeOutlet}")
            .toSet()
            .toList();
        plans.sort();
        update(['list']);
      }
    }
  }

  void changeOutlet(String val) {
    selectedOutlet = val;
    update(['dropdown']);
  }

  String showDate(String outlet) {
    List<String> tanggal = [];
    for (var plan in planVisit) {
      if (isnoo.value) {
        if ("${plan.outlet!.namaOutlet} (${plan.outlet!.distric}) ${plan.outlet!.id}" ==
            outlet) {
          tanggal.add(DateFormat('d').format(plan.tanggalVisit!));
        }
      } else {
        if ("${plan.outlet!.namaOutlet} (${plan.outlet!.distric}) ${plan.outlet!.kodeOutlet}" ==
            outlet) {
          tanggal.add(DateFormat('d').format(plan.tanggalVisit!));
        }
      }
    }
    return tanggal.join(', ');
  }

  void confirmDelete(String namaOutlet, bool isRealme,
      {String idPlanVisit = ''}) {
    Get.defaultDialog(
        title: 'Delete :',
        middleText: 'Hapus plan visit outlet\n$namaOutlet ?',
        titleStyle: blackFontStyle1,
        middleTextStyle: blackFontStyle2,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  delete(
                    namaOutlet: namaOutlet,
                    isRealme: isRealme,
                    idPlanVisit: idPlanVisit,
                  );
                  Get.back();
                },
                child: Text("YA"),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("TIDAK"),
              )
            ],
          ),
        ]);
  }

  void delete({
    required String namaOutlet,
    required bool isRealme,
    String? tahunParam,
    String? bulanParam,
    String? idPlanVisit,
  }) async {
    String kodeOutlet = namaOutlet.split(' ').last;
    print(kodeOutlet);
    ApiReturnValue<bool> result = await PlanVisitServices.deletePlanVisit(
        kodeOutlet: kodeOutlet,
        isRealme: isRealme,
        isnoo: int.tryParse(kodeOutlet) != null,
        tahun: tahun,
        bulan: bulan,
        idPlanVisit: idPlanVisit);

    if (result.value != null) {
      if (result.value!) {
        notif("Berhasil", result.message!);
        Future.delayed(Duration(seconds: 1)).then((_) => getPlanByMonth(
            tahun ?? '${DateTime.now().year}',
            bulan ?? '${DateTime.now().month}'));
      } else {
        notif('Salah', result.message!);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOutlet();
    isinit = true;
  }

  void notif(String judul, String pesan) {
    Get.snackbar('title', 'message',
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.only(bottom: 10),
        titleText:
            Text(judul, style: blackFontStyle1.copyWith(color: Colors.white)),
        messageText:
            Text(pesan, style: blackFontStyle2.copyWith(color: Colors.white)),
        backgroundColor: "FF3F0A".toColor());
  }

  void changeListNoo() {
    selectedOutlet = null;
    isnoo.toggle();
    update(['noo']);
  }
}
