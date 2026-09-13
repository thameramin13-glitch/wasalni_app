import 'package:flutter/material.dart';

void main() {
  runApp(const WasalniApp());
}

class WasalniApp extends StatelessWidget {
  const WasalniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وصلني',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        fontFamily: 'sans-serif',
      ),
      home: const MainTabNavigation(),
    );
  }
}

class MainTabNavigation extends StatefulWidget {
  const MainTabNavigation({super.key});

  @override
  State<MainTabNavigation> createState() => _MainTabNavigationState();
}

class _MainTabNavigationState extends State<MainTabNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TripBookingScreen(),
    const ServicesScreen(),
    const DriverRegistrationScreen(),
    const SubscriptionPaymentScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: 'الرحلات'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'الخدمات'),
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'التسجيل'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'الاشتراك'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// ---------------- 1. شاشة طلب الرحلات والوجهات ----------------
class TripBookingScreen extends StatefulWidget {
  const TripBookingScreen({super.key});

  @override
  State<TripBookingScreen> createState() => _TripBookingScreenState();
}

class _TripBookingScreenState extends State<TripBookingScreen> {
  String selectedUserRole = 'راكب';
  String selectedScope = 'داخل المدينة';
  String selectedVehicle = 'اقتصادية';

  String? selectedFromCity = 'صنعاء';
  String? selectedToCity = 'عدن';

  final List<String> yemeniCities = ['صنعاء', 'عدن', 'تعز', 'الحديدة', 'إب', 'حضرموت (المكلا)', 'سيئون', 'مأرب', 'ذمار'];
  final List<String> saudiCities = ['الرياض', 'جدة', 'مكة المكرمة', 'المدينة المنورة', 'جازان', 'شرورة', 'الدمام'];

  List<String> getAvailableScopes() {
    if (selectedUserRole == 'مقدم خدمة') {
      return ['بين المدن', 'دولي (اليمن - السعودية)'];
    }
    return ['داخل المدينة', 'بين المدن', 'دولي (اليمن - السعودية)'];
  }

  @override
  Widget build(BuildContext context) {
    List<String> scopes = getAvailableScopes();
    if (!scopes.contains(selectedScope)) {
      selectedScope = scopes.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('وصلني - الرحلات والوجهات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('نوع الحساب الحالي:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: ['راكب', 'سائق', 'مقدم خدمة'].map((role) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(role, style: const TextStyle(fontSize: 12)),
                    value: role,
                    groupValue: selectedUserRole,
                    onChanged: (val) => setState(() => selectedUserRole = val!),
                  ),
                );
              }).toList(),
            ),
            const Divider(),
            const Text('نطاق الرحلة:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedScope,
              items: scopes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => selectedScope = val!),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'من'),
                    value: selectedFromCity,
                    items: yemeniCities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => selectedFromCity = val),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'إلى'),
                    value: selectedToCity,
                    items: (selectedScope.contains('دولي') ? saudiCities : yemeniCities)
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedToCity = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text('نوع المركبة:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ['اقتصادية', 'VIP', 'باص', 'دراجة نارية'].map((v) {
                return ChoiceChip(
                  label: Text(v),
                  selected: selectedVehicle == v,
                  onSelected: (selected) => setState(() => selectedVehicle = v),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 40, color: Colors.teal),
                  const SizedBox(height: 5),
                  Text('مسار الرحلة: من $selectedFromCity إلى $selectedToCity', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم البحث عن رحلات $selectedScope من $selectedFromCity إلى $selectedToCity')),
                  );
                },
                child: const Text('تأكيد وبحث عن طلبات', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- 2. قسم خدمات الطريق ----------------
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خدمات الطريق والإنقاذ'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTile(Icons.minor_crash, 'سطحات ونشال', 'نقل المركبات بين المدن والدولي'),
          _buildTile(Icons.build, 'صيانة وميكانيك متنقل', 'إصلاح أعطال الطرق الطويلة'),
          _buildTile(Icons.local_gas_station, 'توصيل وقود', 'تزويد طارئ بالبنزين/الديزل'),
          _buildTile(Icons.tire_repair, 'إصلاح إطارات', 'بنشر متنقل في السفر'),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.teal.shade100, child: Icon(icon, color: Colors.teal)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

// ---------------- 3. قسم رفع الوثائق ----------------
class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  String selectedVehicleType = 'اقتصادية';
  String idType = 'بطاقة شخصية';

  @override
  Widget build(BuildContext context) {
    bool isMotorcycle = (selectedVehicleType == 'دراجة نارية');

    return Scaffold(
      appBar: AppBar(title: const Text('رفع وتوثيق الوثائق'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('نوع المركبة:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedVehicleType,
              items: ['اقتصادية', 'VIP', 'باص', 'دراجة نارية'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (val) => setState(() => selectedVehicleType = val!),
            ),
            const SizedBox(height: 10),
            const Text('نوع الهوية الوطنية:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: ['بطاقة شخصية', 'جواز سفر'].map((type) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(type, style: const TextStyle(fontSize: 12)),
                    value: type,
                    groupValue: idType,
                    onChanged: (val) => setState(() => idType = val!),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            _buildUploadBox('صورة الهوية ($idType)', Icons.badge),
            if (!isMotorcycle) ...[
              const SizedBox(height: 10),
              _buildUploadBox('صورة رخصة القيادة', Icons.card_membership),
              const SizedBox(height: 10),
              _buildUploadBox('صورة استمارة السيارة', Icons.directions_car),
            ] else ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.amber.shade100,
                child: const Text('ملاحظة: سائق الدراجة النارية يتطلب منه صورة الهوية فقط.', style: TextStyle(fontSize: 12)),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الوثائق لمراجعة الإدارة')));
                },
                child: const Text('إرسال للتحقق', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
          OutlinedButton(onPressed: () {}, child: const Text('رفع')),
        ],
      ),
    );
  }
}

// ---------------- 4. قسم الاشتراك والدفع ----------------
class SubscriptionPaymentScreen extends StatefulWidget {
  const SubscriptionPaymentScreen({super.key});

  @override
  State<SubscriptionPaymentScreen> createState() => _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  String paymentMethod = 'تحويل بنكي';
  String selectedBank = 'بنك الكريمي للتمويل الأصغر الإسلامي';

  final List<String> yemeniBanks = [
    'بنك الكريمي للتمويل الأصغر الإسلامي',
    'بنك البسيري للصرافة',
    'بنك اليمن والكويت',
    'محفظة جيب (Jeeb)',
    'محفظة جوالي (Jawali)',
    'تطبيق كاش (Cash)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اشتراك السائق والدفع'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('رسوم الاشتراك الشهري للسائق ومقدم الخدمة', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('1,000 ريال يمني / شهر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text('طريقة الدفع:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: ['تحويل بنكي', 'نقداً (عبر الموزع)'].map((method) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(method, style: const TextStyle(fontSize: 12)),
                    value: method,
                    groupValue: paymentMethod,
                    onChanged: (val) => setState(() => paymentMethod = val!),
                  ),
                );
              }).toList(),
            ),
            if (paymentMethod == 'تحويل بنكي') ...[
              DropdownButton<String>(
                isExpanded: true,
                value: selectedBank,
                items: yemeniBanks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (val) => setState(() => selectedBank = val!),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'رقم الإشعار أو حوالة السداد', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تقديم طلب التفعيل للإدارة عبر $paymentMethod')));
                },
                child: const Text('إرسال طلب التفعيل', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- 5. شاشة الحساب الشخصي (مع مدخل الإدارة المخفي) ----------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAdminLoginDialog(BuildContext context) {
    TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('دخول لوحة التحكم (للإدارة فقط)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'أدخل رمز المرور السري (7777)', border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                if (pinController.text == "7777") {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboardScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رمز المرور غير صحيح!')));
                }
              },
              child: const Text('دخول', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الحساب الشخصي'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Column(
              children: [
                CircleAvatar(radius: 40, backgroundColor: Colors.teal, child: Icon(Icons.person, size: 50, color: Colors.white)),
                SizedBox(height: 10),
                Text('أمين ثامر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('+967 777123456', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ListTile(leading: const Icon(Icons.history), title: const Text('سجل الرحلات'), trailing: const Icon(Icons.arrow_forward_ios, size: 16)),
          const Divider(),
          ListTile(leading: const Icon(Icons.wallet), title: const Text('المحفظة'), trailing: const Icon(Icons.arrow_forward_ios, size: 16)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('إصدار التطبيق v1.0.0', style: TextStyle(color: Colors.grey)),
            onLongPress: () => _showAdminLoginDialog(context),
            onTap: () => _showAdminLoginDialog(context),
          ),
        ],
      ),
    );
  }
}

// ---------------- 6. لوحة التحكم الإدارية المخفية ----------------
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم والإدارة الإرشيفية'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.verified_user), text: 'توثيق السائقين'),
            Tab(icon: Icon(Icons.payments), text: 'تأكيد الاشتراكات'),
            Tab(icon: Icon(Icons.analytics), text: 'الإحصائيات والرحلات'),
            Tab(icon: Icon(Icons.settings), text: 'إعدادات النظام'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDriversApprovalTab(),
          _buildSubscriptionsTab(),
          _buildStatsTab(),
          _buildSystemSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildDriversApprovalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAdminCard(
          title: 'طلب توثيق: علي المحمدي (سيارة VIP)',
          subtitle: 'الوثائق: بطاقة شخصية + رخصة + استمارة',
          onApprove: () {},
          onReject: () {},
        ),
        _buildAdminCard(
          title: 'طلب توثيق: صالح أحمد (دراجة نارية)',
          subtitle: 'الوثائق: جواز سفر فقط',
          onApprove: () {},
          onReject: () {},
        ),
      ],
    );
  }

  Widget _buildSubscriptionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance, color: Colors.teal),
            title: const Text('تحويل عبر: بنك الكريمي'),
            subtitle: const Text('المبلغ: 1,000 ر.ي | رقم الإشعار: 8945201\nالسائق: حسن المقطري'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {},
              child: const Text('تأكيد التفعيل', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatBox('إجمالي السائقين', '142', Colors.blue),
              const SizedBox(width: 10),
              _buildStatBox('الرحلات النشطة', '28', Colors.green),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatBox('الاشتراكات المفعلة', '110', Colors.orange),
              const SizedBox(width: 10),
              _buildStatBox('الإيرادات (ر.ي)', '110,000', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text('قيمة الاشتراك الشهري للسائق'),
          subtitle: const Text('1,000 ريال يمني'),
          trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ),
        const Divider(),
        ListTile(
          title: const Text('إدارة قائمة المدن والخطوط الدولية'),
          subtitle: const Text('اليمن (9 مدن) - السعودية (7 مدن)'),
          trailing: IconButton(icon: const Icon(Icons.add_location), onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildAdminCard({required String title, required String subtitle, required VoidCallback onApprove, required VoidCallback onReject}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: onApprove,
                  icon: const Icon(Icons.check, color: Colors.white, size: 16),
                  label: const Text('موافقة وتفعيل', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: onReject,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('رفض'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
