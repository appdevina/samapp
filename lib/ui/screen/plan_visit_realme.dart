part of 'screen.dart';

class PlanVisitRealme extends StatelessWidget {
  PlanVisitRealme({Key? key}) : super(key: key);
  final controller = Get.find<PlanVisitController>();
  final List<PlanVisitModel> planVisit = [
    PlanVisitModel()
    // add more PlanVisitModel objects here
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 300,
      child: ListView.separated(
        itemBuilder: (_, i) => (controller.planVisit.length > 0)
            ? ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      width: 135,
                      child: Text(
                        controller.planVisit[i].outlet!.namaOutlet.toString(),
                        style: blackFontStyle3.copyWith(fontSize: 14),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: 135,
                      child: Text(
                        DateFormat('d MMM y')
                            .format(controller.planVisit[i].tanggalVisit!),
                      ),
                    ),
                    controller.selectedMonth != '-'
                        ? Container(
                            width: 60,
                            child: IconButton(
                              onPressed: () {
                                controller.confirmDelete(
                                  controller.planVisit[i].outlet!.namaOutlet
                                      .toString(),
                                  true,
                                  idPlanVisit:
                                      controller.planVisit[i].id.toString(),
                                );
                              },
                              icon: Icon(
                                MdiIcons.close,
                                color: Colors.red[400],
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              )
            : ListTile(
                title: Center(
                  child: Text(
                    'Belum ada Data',
                    style: blackFontStyle1,
                  ),
                ),
              ),
        itemCount: controller.planVisit.length,
        separatorBuilder: (_, index) => Divider(
          height: 10,
        ),
      ),
    );
  }
}
