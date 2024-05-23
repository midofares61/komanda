import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoKScreen extends StatelessWidget {
  const InfoKScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text("تبذة عن كوماندا"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SelectableText(
                  "سياسة الخصوصية لتطبيق 'كوماندا' لتوظيف العمالة غير المنتظمة تلعب دورًا مهمًا في ضمان حماية معلومات المستخدمين وبياناتهم الشخصية. يجب أن تكون هذه السياسة شفافة ومفهومة للمستخدمين، وتحترم التشريعات واللوائح المحلية والدولية المعمول بها في مجال حماية البيانات الشخصية. فيما يلي نموذج لسياسة الخصوصية لتطبيق 'كوماندا':",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
          )),
    );
  }
}
