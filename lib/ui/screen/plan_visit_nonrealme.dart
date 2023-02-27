part of 'screen.dart';

class PlanVisitNonRealme extends StatelessWidget {
  PlanVisitNonRealme({Key? key}) : super(key: key);
  final controller = Get.find<PlanVisitController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 300,
      child: ListView.separated(
        itemBuilder: (_, i) => (controller.plans.length > 0)
            ? ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      width: 135,
                      child: Text(
                        controller.plans[i],
                        style: blackFontStyle3.copyWith(fontSize: 14),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: 135,
                      child: Text(
                        controller.showDate(
                          controller.plans[i],
                        ),
                      ),
                    ),
                    controller.selectedMonth != '-'
                        ? Container(
                            width: 60,
                            child: IconButton(
                              onPressed: () {
                                controller.confirmDelete(
                                  controller.plans[i],
                                  false,
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
        itemCount: controller.plans.length,
        separatorBuilder: (_, index) => Divider(
          height: 10,
        ),
      ),
    );
  }
}
