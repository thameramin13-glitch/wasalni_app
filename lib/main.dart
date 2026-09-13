import 'package:flutter/material.dart';

void main() {
  runApp(const WasalniApp());
}

class WasalniApp extends StatefulWidget {
  const WasalniApp({super.key});

  @override
  State<WasalniApp> createState() => _WasalniAppState();
}

class _WasalniAppState extends State<WasalniApp> {
  bool isLoggedIn = false;
  String userPhoneNumber = '';
  String? selectedRole; // 'راكب' | 'سائق' | 'مقدم خدمة'
  String currentCity = 'صنعاء';

  void loginUser(String phone) {
    setState(() {
      userPhoneNumber = phone;
      isLoggedIn = true;
    });
  }

  void selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void updateCity(String newCity) {
    setState(() => currentCity = newCity);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وصلني',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: !isLoggedIn
          ? PhoneAuthScreen(onLoginSuccess: loginUser)
          : (selectedRole == null
              ? RoleSelectionScreen(onRoleSelected: selectRole)
              : MainTabNavigation(
                  userPhone: userPhoneNumber,
                  activeRole: selectedRole!,
                  currentCity: currentCity,
                  onRoleChanged: selectRole,
                  onCityChanged: updateCity,
                )),
    );
  }
}

// =========================================================================
// 1. شاشة توثيق رقم الجوال OTP
// =========================================================================
class PhoneAuthScreen extends StatefulWidget {
  final Function(String) onLoginSuccess;
  const PhoneAuthScreen({super.key, required this.onLoginSuccess});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isOtpSent = false;

  void _sendOtp() {
    if (_phoneController.text.trim().length >= 8) {
      setState(() => isOtpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال رمز التحقق OTP (رمز الاختبار: 1234)')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رقم جوال صحيح')),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.trim() == "1234") {
      widget.onLoginSuccess(_phoneController.text.trim());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رمز التحقق غير صحيح! أدخل 1234')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_taxi, size: 70, color: Colors.teal),
              ),
              const SizedBox(height: 15),
              const Text('تطبيق وصلني', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal)),
              const Text('منظومة النقل وخدمات الطرق الشاملة', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 40),
              if (!isOtpSent) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الجوال (مثال: 777123456)',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _sendOtp,
                    child: const Text('إرسال رمز التحقق (OTP)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ] else ...[
                Text('تم إرسال الرمز إلى: ${_phoneController.text}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '1234',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _verifyOtp,
                    child: const Text('تأكيد الدخول', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 2. شاشة اختيار نوع الحساب الجذابة
// =========================================================================
class RoleSelectionScreen extends StatelessWidget {
  final Function(String) onRoleSelected;
  const RoleSelectionScreen({super.key, required this.onRoleSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('مرحباً بك في وصلني 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
              const SizedBox(height: 5),
              const Text('يرجى اختيار نوع الحساب للمتابعة:', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _buildRoleCard(
                      context,
                      title: 'حساب راكب',
                      subtitle: 'طلب رحلات وحجز مقاعد بين المدن وداخلها بسهولة',
                      icon: Icons.person_pin,
                      color: Colors.teal,
                      onTap: () => onRoleSelected('راكب'),
                    ),
                    const SizedBox(height: 15),
                    _buildRoleCard(
                      context,
                      title: 'حساب سائق',
                      subtitle: 'تقديم خدمات النقل (سيارة، باص، دراجة نارية)',
                      icon: Icons.time_to_leave,
                      color: Colors.blue.shade700,
                      onTap: () => onRoleSelected('سائق'),
                    ),
                    const SizedBox(height: 15),
                    _buildRoleCard(
                      context,
                      title: 'حساب مقدم خدمة طريق',
                      subtitle: 'تقديم خدمات (بنشر، ميكانيك، سطحة، تموينات، مجمع خدمات)',
                      icon: Icons.build_circle,
                      color: Colors.orange.shade800,
                      onTap: () => onRoleSelected('مقدم خدمة'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 3. التنقل الرئيسي والتبويبات
// =========================================================================
class MainTabNavigation extends StatefulWidget {
  final String userPhone;
  final String activeRole;
  final String currentCity;
  final Function(String) onRoleChanged;
  final Function(String) onCityChanged;

  const MainTabNavigation({
    super.key,
    required this.userPhone,
    required this.activeRole,
    required this.currentCity,
    required this.onRoleChanged,
    required this.onCityChanged,
  });

  @override
  State<MainTabNavigation> createState() => _MainTabNavigationState();
}

class _MainTabNavigationState extends State<MainTabNavigation> {
  int _currentIndex = 0;
  final List<String> yemeniCities = ['صنعاء', 'عدن', 'تعز', 'الحديدة', 'إب', 'حضرموت (المكلا)', 'سيئون', 'مأرب', 'ذمار', 'عمران'];

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      TripBookingScreen(activeRole: widget.activeRole, currentCity: widget.currentCity),
      ServicesScreen(currentCity: widget.currentCity),
      InAppChatScreen(userPhone: widget.userPhone),
      AccountVerificationScreen(activeRole: widget.activeRole, currentCity: widget.currentCity, yemeniCities: yemeniCities),
      ProfileScreen(userPhone: widget.userPhone, activeRole: widget.activeRole, onRoleChanged: widget.onRoleChanged),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('وصلني - (${widget.activeRole})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'تغيير نوع الحساب',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('اختر نوع الحساب للانتقال إليه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.teal),
                        title: const Text('حساب راكب'),
                        onTap: () {
                          widget.onRoleChanged('راكب');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.directions_car, color: Colors.blue),
                        title: const Text('حساب سائق'),
                        onTap: () {
                          widget.onRoleChanged('سائق');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.build, color: Colors.orange),
                        title: const Text('حساب مقدم خدمة'),
                        onTap: () {
                          widget.onRoleChanged('مقدم خدمة');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: 'الرحلات'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'الخدمات'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'الرسائل'),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: 'توثيق الحساب'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// =========================================================================
// 4. شاشة توثيق الحساب الديناميكية (تتغير حسب نوع الحساب)
// =========================================================================
class AccountVerificationScreen extends StatefulWidget {
  final String activeRole;
  final String currentCity;
  final List<String> yemeniCities;

  const AccountVerificationScreen({
    super.key,
    required this.activeRole,
    required this.currentCity,
    required this.yemeniCities,
  });

  @override
  State<AccountVerificationScreen> createState() => _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  // الحقول النصية
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();

  // الخيارات والقوائم
  String selectedCountry = 'اليمن';
  String selectedCity = 'صنعاء';
  String selectedIdType = 'الهوية الوطنية';
  String selectedVehicleType = 'سيارة'; // سيارة، باص، دراجة نارية

  final List<String> countries = ['اليمن', 'السعودية'];
  final List<String> saudiCities = ['الرياض', 'جدة', 'مكة المكرمة', 'المدينة المنورة', 'الدمام', 'الخبر'];

  // خيارات مقدم الخدمة
  List<String> selectedServices = ['ميكانيك وبنشر'];
  final List<String> availableServices = [
    'ميكانيك وبنشر',
    'سطحة ونشال',
    'تموينات وسوبرماركت',
    'تزويد بالوقود',
    'مطاعم واستراحات',
    'رعاية طبية وإسعاف',
  ];

  bool idUploaded = false;

  List<String> getIdTypes() {
    if (widget.activeRole == 'سائق' && selectedVehicleType == 'دراجة نارية') {
      return ['الهوية الوطنية', 'جواز سفر', 'أخرى'];
    }
    return ['الهوية الوطنية', 'جواز سفر'];
  }

  @override
  void initState() {
    super.initState();
    selectedCity = widget.currentCity;
  }

  @override
  Widget build(BuildContext context) {
    bool isMotorcycle = (widget.activeRole == 'سائق' && selectedVehicleType == 'دراجة نارية');
    List<String> currentCitiesList = selectedCountry == 'اليمن' ? widget.yemeniCities : saudiCities;

    if (!currentCitiesList.contains(selectedCity)) {
      selectedCity = currentCitiesList.first;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الترويسة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.verified, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'توثيق حساب (${widget.activeRole})',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade900),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.activeRole == 'سائق'
                              ? 'أدخل بياناتك الرسمية لتفعيل الحساب فوراً بدون الحاجة لرفع أوراق حالياً.'
                              : 'قم بإكمال بياناتك لرفع مستوى الأمان وتفعيل كافة الصلاحيات.',
                          style: const TextStyle(fontSize: 12, color: Colors.black64),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // البيانات الأساسية
            const Text('البيانات الشخصية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'الاسم كاملاً',
                hintText: 'أدخل الاسم كما هو في الهوية',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال الاسم كاملاً' : null,
            ),
            const SizedBox(height: 14),

            // الدولة والمدينة
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCountry,
                    decoration: InputDecoration(
                      labelText: 'الدولة',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.flag_outlined),
                    ),
                    items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCountry = val!;
                        selectedCity = selectedCountry == 'اليمن' ? widget.yemeniCities.first : saudiCities.first;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCity,
                    decoration: InputDecoration(
                      labelText: 'المدينة',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.location_city_outlined),
                    ),
                    items: currentCitiesList.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => selectedCity = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // نوع الهوية ورقمها
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: getIdTypes().contains(selectedIdType) ? selectedIdType : getIdTypes().first,
                    decoration: InputDecoration(
                      labelText: 'نوع الهوية',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: getIdTypes().map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (val) => setState(() => selectedIdType = val!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _idNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'رقم الهوية',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                  ),
                ),
              ],
            ),

            // ------------------ تفاصيل السائق ------------------
            if (widget.activeRole == 'سائق') ...[
              const SizedBox(height: 20),
              const Text('بيانات المركبة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedVehicleType,
                decoration: InputDecoration(
                  labelText: 'نوع المركبة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.directions_car_outlined),
                ),
                items: ['سيارة', 'باص', 'دراجة نارية'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedVehicleType = val!;
                    if (!getIdTypes().contains(selectedIdType)) {
                      selectedIdType = getIdTypes().first;
                    }
                  });
                },
              ),
              const SizedBox(height: 14),

              if (!isMotorcycle) ...[
                TextFormField(
                  controller: _licenseNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'رقم الرخصة',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.card_membership_outlined),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال رقم الرخصة' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _registrationNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'رقم الاستمارة',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.article_outlined),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال رقم الاستمارة' : null,
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.two_wheeler, color: Colors.amber),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'لسائقي الدراجات النارية: يُكتفى بإدخال بيانات الهوية الشخصية فقط.',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 15),
              _buildSubscriptionCard('الاشتراك الشهري للسائق', '1000 ريال يمني'),
            ],

            // ------------------ تفاصيل مقدم الخدمة ------------------
            if (widget.activeRole == 'مقدم خدمة') ...[
              const SizedBox(height: 15),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: BorderSide(color: idUploaded ? Colors.green : Colors.teal),
                ),
                onPressed: () => setState(() => idUploaded = true),
                icon: Icon(idUploaded ? Icons.check_circle : Icons.cloud_upload, color: idUploaded ? Colors.green : Colors.teal),
                label: Text(idUploaded ? 'تم رفع الهوية بنجاح' : 'رفع صورة الهوية', style: TextStyle(color: idUploaded ? Colors.green : Colors.teal)),
              ),
              const SizedBox(height: 20),
              const Text('نوع الخدمة (يمكن اختيار أكثر من خدمة للمجمع):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: availableServices.map((service) {
                  final isSelected = selectedServices.contains(service);
                  return FilterChip(
                    label: Text(service),
                    selected: isSelected,
                    selectedColor: Colors.teal.shade100,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          selectedServices.add(service);
                        } else {
                          if (selectedServices.length > 1) selectedServices.remove(service);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              _buildSubscriptionCard('الاشتراك الشهري لمقدم الخدمة', '1000 ريال يمني'),
            ],

            const SizedBox(height: 25),

            // زر التوثيق وحفظ البيانات
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم توثيق بيانات حساب (${widget.activeRole}) بنجاح!'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  'حفظ البيانات وتفعيل الحساب',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(String title, String amount) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.teal.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.payments, color: Colors.amber, size: 28),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  Text(amount, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('اختر طريقة السداد: الكريمي / جوالي / كاش')),
              );
            },
            child: const Text('تسديد الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 5. شاشات التبويبات التكميلية
// =========================================================================
class TripBookingScreen extends StatelessWidget {
  final String activeRole;
  final String currentCity;

  const TripBookingScreen({super.key, required this.activeRole, required this.currentCity});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.teal.shade300),
          const SizedBox(height: 10),
          Text('خريطة والرحلات النشطة ($currentCity)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('الدور الحالي: $activeRole', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class ServicesScreen extends StatelessWidget {
  final String currentCity;
  const ServicesScreen({super.key, required this.currentCity});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_circle_outlined, size: 80, color: Colors.orange.shade300),
          const SizedBox(height: 10),
          Text('دليل خدمات الطريق بالقرب من ($currentCity)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class InAppChatScreen extends StatelessWidget {
  final String userPhone;
  const InAppChatScreen({super.key, required this.userPhone});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.blue),
          SizedBox(height: 10),
          Text('مركز المحادثات والدعم الفني', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userPhone;
  final String activeRole;
  final Function(String) onRoleChanged;

  const ProfileScreen({super.key, required this.userPhone, required this.activeRole, required this.onRoleChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.teal, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 15),
            Text('رقم الجوال: $userPhone', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('نوع الحساب: $activeRole', style: const TextStyle(fontSize: 14, color: Colors.teal)),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(200, 45)),
              onPressed: () => onRoleChanged(activeRole == 'راكب' ? 'سائق' : 'راكب'),
              icon: const Icon(Icons.swap_horiz, color: Colors.white),
              label: const Text('تبديل نوع الحساب', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
