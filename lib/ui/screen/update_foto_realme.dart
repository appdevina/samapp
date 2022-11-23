part of 'screen.dart';

class UpdateFotoRealme extends StatelessWidget {
  final controller = Get.put(UpdateFotoOutletController());
  final String? namaOutlet;

  UpdateFotoRealme({required this.namaOutlet});
  @override
  Widget build(BuildContext context) {
    return GeneralPage(
      title: "Update Outlet",
      subtitle: "Upload FOTO",
      onBackButtonPressed: () {
        Get.back();
      },
      child: Container(
        child: Column(
          children: [
            Form(
              key: controller.submitFormKey,
              child: Column(
                children: [
                  LabelFormRegister(
                    nama: 'Nama Pemilik Outlet*',
                  ),
                  FormRegisterNoo(
                    nama: "Isi Nama Pemilik Outlet",
                    controller: controller.namaPemilikOutlet,
                    validator: controller.validater,
                  ),
                  LabelFormRegister(
                    nama: 'Nomor Telepon Pemilik Outlet*',
                  ),
                  FormRegisterNoo(
                    nama: "Isi Nomor Telepon Pemilik Outlet",
                    controller: controller.nomorPemilikOutlet,
                    validator: controller.validater,
                    type: TextInputType.number,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultMargin,
            ),
            Divider(),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                LabelFormRegisterHalf(
                                  nama: 'Foto Depan Luar + Shop Sign',
                                  width: 130,
                                ),
                                GetBuilder<UpdateFotoOutletController>(
                                  id: 'fotoshopsign',
                                  builder: (_) {
                                    return (controller.shopSign == null)
                                        ? SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              controller
                                                  .deleteFoto('fotoshopsign');
                                            },
                                            iconSize: defaultMargin,
                                            color: Colors.red,
                                            icon: Icon(
                                              MdiIcons.closeBox,
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<UpdateFotoOutletController>(
                        id: 'fotoshopsign',
                        builder: (_) {
                          return (controller.shopSign == null)
                              ? BoxFotoRegistration(
                                  function: () {
                                    controller.opsiMediaFoto('fotoshopsign');
                                  },
                                )
                              : BoxFotoRegistrationNoo(
                                  foto: controller.shopSign!,
                                );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                LabelFormRegisterHalf(
                                  nama: 'Foto Depan Dalam',
                                  width: 130,
                                ),
                                GetBuilder<UpdateFotoOutletController>(
                                  id: 'fotodepan',
                                  builder: (_) {
                                    return (controller.depan == null)
                                        ? SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              controller
                                                  .deleteFoto('fotodepan');
                                            },
                                            iconSize: defaultMargin,
                                            color: Colors.red,
                                            icon: Icon(
                                              MdiIcons.closeBox,
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<UpdateFotoOutletController>(
                        id: 'fotodepan',
                        builder: (_) {
                          return (controller.depan == null)
                              ? BoxFotoRegistration(
                                  function: () {
                                    controller.opsiMediaFoto('fotodepan');
                                  },
                                )
                              : BoxFotoRegistrationNoo(
                                  foto: controller.depan!,
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                LabelFormRegisterHalf(
                                  nama: 'Foto Samping Kanan',
                                  width: 130,
                                ),
                                GetBuilder<UpdateFotoOutletController>(
                                  id: 'fotokanan',
                                  builder: (_) {
                                    return (controller.kanan == null)
                                        ? SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              controller
                                                  .deleteFoto('fotokanan');
                                            },
                                            iconSize: defaultMargin,
                                            color: Colors.red,
                                            icon: Icon(
                                              MdiIcons.closeBox,
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<UpdateFotoOutletController>(
                        id: 'fotokanan',
                        builder: (_) {
                          return (controller.kanan == null)
                              ? BoxFotoRegistration(
                                  function: () {
                                    controller.opsiMediaFoto('fotokanan');
                                  },
                                )
                              : BoxFotoRegistrationNoo(
                                  foto: controller.kanan!,
                                );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                LabelFormRegisterHalf(
                                  nama: 'Foto Samping Kiri',
                                  width: 130,
                                ),
                                GetBuilder<UpdateFotoOutletController>(
                                  id: 'fotokiri',
                                  builder: (_) {
                                    return (controller.kiri == null)
                                        ? SizedBox()
                                        : IconButton(
                                            onPressed: () {
                                              controller.deleteFoto('fotokiri');
                                            },
                                            iconSize: defaultMargin,
                                            color: Colors.red,
                                            icon: Icon(MdiIcons.closeBox),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<UpdateFotoOutletController>(
                        id: 'fotokiri',
                        builder: (_) {
                          return (controller.kiri == null)
                              ? BoxFotoRegistration(
                                  function: () {
                                    controller.opsiMediaFoto('fotokiri');
                                  },
                                )
                              : BoxFotoRegistrationNoo(
                                  foto: controller.kiri!,
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 24),
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.submitFormKey.currentState!.validate()) {
                    await controller
                        .submitRealme(
                          namaOutlet!,
                          controller.namaPemilikOutlet.text,
                          controller.nomorPemilikOutlet.text,
                        )
                        .then(
                          (value) => value
                              ? controller.dialog(
                                  'Berhasil update',
                                  'Anda sudah bisa Check In\nOutlet ini',
                                )
                              : print('error'),
                        );
                  } else {
                    controller.notif(
                        'Salah', "Isi nama pemilik dan nomer telepon");
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all("FF3F0A".toColor()),
                    elevation: MaterialStateProperty.all(0)),
                child: Text(
                  "Submit",
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: defaultMargin,
            )
          ],
        ),
      ),
    );
  }
}
