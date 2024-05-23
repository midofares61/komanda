import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:komanda/modules/stories/stories_screen.dart';
import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../info/info_screen.dart';
import '../search/search_screen.dart';
import '../servises/servises_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<String> item = ["نجار", "نقاش", "سيراميك", "حداد"];
  List<Map> data = [
    {
      "name": "الصيانه المنزليه",
      "image": "assets/images/flat-color-icons_home.svg",
      "content":
          "الأعمال المنزلية هي المهام والواجبات التي يُقوم بها في المنزل للحفاظ على نظافته وتنظيمه وراحة أفراد الأسرة. تشمل هذه الأعمال مجموعة واسعة من المهام، ومن بينها : النجاره و الكهرباء و...الخ",
    },
    {
      "name": "صيانه السيارات",
      "image": "assets/images/twemoji_racing-car.svg",
      "content":
          "صيانة السيارات تشمل مجموعة من الأعمال الضرورية للحفاظ على سلامة وأداء السيارة. هنا بعض الأعمال التي قد تكون جزءًا من صيانة السيارات:تغيير زيت المحرك وفلتر الزيت و ....الخ",
    },
    {
      "name": "تبريد و تكيف ",
      "image": "assets/images/air-conditioner 1.svg",
      "content":
          "صيانة نظام التبريد وتكييف السيارة تشمل العديد من الأعمال التي تهدف إلى الحفاظ على أداء وكفاءة نظام التبريد والتكييف. بعض هذه الأعمال تشمل:فحص مستوى وجودة سائل التبريد (الكولانت) وإعادة تعبئته إذا لزم الأمر.",
    },
    {
      "name": "اعمال بناء",
      "image": "assets/images/civil-engineering 5.svg",
      "content":
          "أعمال البناء تشمل مجموعة واسعة من الأنشطة والعمليات التي تتعلق بإنشاء المباني والهياكل. إليك بعض أمثلة على أعمال البناء :أعمال الأساسات: تشمل حفر الأرض وتجهيزها لاستقبال الأساسات، وصب الخرسانة لتكوين الأساسات القوية التي تدعم المبنى و.......الخ",
    },
    {
      "name": "اباده حشرات",
      "image": "assets/images/pesticide 1.svg",
      "content":
          "ابادة الحشرات تعني التخلص من الحشرات الضارة أو المزعجة في المنزل أو المكان الذي يتم تنفيذها. هناك العديد من الطرق المختلفة لابادة الحشرات، بما في ذلك:",
    },
    {
      "name": "حمايه البيئه",
      "image": "assets/images/flat-color-icons_home.svg",
      "content":
          "حماية البيئة تعني اتخاذ التدابير والإجراءات للحفاظ على البيئة الطبيعية والحفاظ على التوازن البيئي. تتضمن حماية البيئة العديد من الجوانب والممارسات التي تهدف إلى الحد من التأثير السلبي للأنشطة البشرية على البيئة ",
    },
  ];

  List<Map> dataMarket = [
    {
      "name": "ادوات منزليه",
      "image": "assets/images/flat-color-icons_home.svg",
      "content":
          "هنا بعض الأدوات المنزلية الشائعة التي يستخدمها الناس في حياتهم اليومية مثله  : مفك زاوية: يستخدم للوصول إلى البراغي والمسامير في الأماكن الضيقة و قياس الشريط: يستخدم لقياس الأبعاد والمسافات.والخ....",
    },
    {
      "name": "مستلزمات السيارات",
      "image": "assets/images/twemoji_racing-car.svg",
      "content":
          "مستلزمات السيارات تشمل مجموعة واسعة من العناصر والأدوات التي يمكن استخدامها لراحة وأداء أفضل للسيارة والسائق. إليك بعض المستلزمات الشائعة للسيارات:غطاء السيارة و حصيرة الأرضية  و .....الخ",
    },
    {
      "name": "ادوات التكيف ",
      "image": "assets/images/air-conditioner 1.svg",
      "content":
          "دوات التكييف تشمل مجموعة من الأجهزة والمعدات التي تستخدم لتوفير وضبط درجة الحرارة والرطوبة وجودة الهواء في البيئة المحيطة. إليك بعض الأدوات المشتركة في أنظمة التكييف:وحدة التكييف المركزية و.....الخ",
    },
    {
      "name": "موارد البناء",
      "image": "assets/images/civil-engineering 5.svg",
      "content":
          "هنا بعض الموارد الشائعة المستخدمة في عمليات البناء:الخرسانة: تُستخدم في البناء لإنشاء الأساسات والأعمدة والجدران والأرضياتالحجر: يستخدم في بناء الجدران الخارجية والواجهات والأرضيات. يتم قطع الحجر إلى قطع مستطيلة أو مربعة وتثبيتها بشكل متراص.",
    },
    {
      "name": "مبيدات حشرية",
      "image": "assets/images/pesticide 1.svg",
      "content":
          "مبيدات الحشرات هي المواد التي تستخدم للتحكم في الحشرات المزعجة والضارة في البيئة المحيطة. تستخدم هذه المبيدات للحماية من الآفات الحشرية التي تهاجم المحاصيل الزراعية والنباتات والحيوانات الأليفة",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 500;
    final ismobile = MediaQuery.of(context).size.width <= 500;

    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "كوماندا",
                style: TextStyle(fontFamily: "jomhuria", fontSize: 44),
              ),
              elevation: 1,
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context: context, widget: InfoScreeen());
                    },
                    icon: Icon(
                      Icons.menu,
                      size: 35,
                    )),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          navigateTo(context: context, widget: SearchScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: cubit.isDark ? darkColor : defaultColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.search, color: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                              FittedBox(
                                child: Text(
                                  "ابحث عن المهنة المطلوبة",
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: isDesktop ? 20 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "المهن الاكثر شيوعا",
                        style: TextStyle(
                            color: cubit.isDark ? Colors.white : secondeColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 45,
                        padding: EdgeInsets.symmetric(vertical: 2.5),
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 0),
                                      blurRadius: 2)
                                ],
                                color: cubit.isDark ? darkColor : defaultColor,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 2),
                              child: Text(
                                item[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isDesktop ? 22 : 18),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 15),
                          itemCount: item.length,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 90 : 30),
                      InkWell(
                        onTap: () {
                          navigateTo(
                              context: context,
                              widget: ServisesScreen(
                                name: "خدمات مهنيه",
                              ));
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      cubit.isDark ? darkColor : defaultColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 0),
                                        blurRadius: 5)
                                  ],
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: isDesktop ? 30 : 20,
                                      ),
                                      Text(
                                        "خدمات مهنيه ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isDesktop ? 25 : 22,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  offset: Offset(4, 2),
                                                  blurRadius: 8)
                                            ]),
                                      ),
                                      Text(
                                        "الخدمات المهنية هي الخدمات التي تقدمها الشركات والمؤسسات المتخصصة لعملائها. تتميز هذه الخدمات بالاحترافية والمهارة المتقدمة التي يتمتع بها الخبراء والمتخصصون في مجالاتهم. تعتبر الخدمات المهنية متخصصة ومتعمقة، يتم توفير هذه الخدمات في مجالات مثل الاستشارات الإدارية، والتسويق، لمحاسبة،....الخ",
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: isDesktop ? 25 : 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                        color: defaultColor,
                                        offset: Offset(0, -4),
                                        blurRadius: 5)
                                  ]),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: isDesktop ? 30 : 25,
                                child: SvgPicture.asset(
                                    "assets/images/twemoji_factory-worker.svg"),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(
                              context: context,
                              widget: StoriesScreen(
                                name: "متاجر و محلات",
                              ));
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      cubit.isDark ? darkColor : defaultColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 0),
                                        blurRadius: 5)
                                  ],
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: isDesktop ? 30 : 20,
                                      ),
                                      Text(
                                        "متاجر و محلات ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isDesktop ? 25 : 22,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  offset: Offset(4, 2),
                                                  blurRadius: 8)
                                            ]),
                                      ),
                                      Text(
                                        "تقدم خدمات المتاجر والمحلات مجموعة متنوعة من الخدمات التي تلبي احتياجات وتفضيلات العملاء المختلفة.تتميز خدمات المتاجر والمحلات بالسلاسة واليسر في العمليات التجارية والتسوق.انتقائية: تساعد خدمات المتاجر والمحلات العملاء في اختيار المنتجات المناسبة وفقًا لاحتياجاتهم ومتطلباتهم الشخصية.",
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: isDesktop ? 25 : 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                        color: defaultColor,
                                        offset: Offset(0, -4),
                                        blurRadius: 5)
                                  ]),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: isDesktop ? 30 : 25,
                                child: SvgPicture.asset(
                                    "assets/images/flat-color-icons_shop.svg"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
  }
}
