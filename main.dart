import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- DATA PERSISTENCE LAYER ---
class DataStore {
  static Map<String, List<Map<String, dynamic>>> savedSellerData = {};
  static Map<String, double> savedSellerTotals = {};
  static List<String> savedSellerList = [];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepOrange,
          brightness: Brightness.dark),
      home: const MainGatekeeper(),
    );
  }
}

class MainGatekeeper extends StatefulWidget {
  const MainGatekeeper({super.key});

  @override
  State<MainGatekeeper> createState() => _MainGatekeeperState();
}

class _MainGatekeeperState extends State<MainGatekeeper> {
  bool isLoggedIn = false;
  final String adminUser = "Chandrama";
  final String adminPass = "maya123";
  
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  void tryLogin() {
    if (userCtrl.text == adminUser && passCtrl.text == adminPass) {
      HapticFeedback.heavyImpact();
      setState(() => isLoggedIn = true);
    } else {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Invalid Credentials!"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeInOutCubic,
      child: isLoggedIn
          ? SalesWorkflowPage(onLogout: () => setState(() => isLoggedIn = false))
          : _buildLoginScreen(),
    );
  }

  Widget _buildLoginScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              ),
            ),
          ),
          Positioned(top: -50, right: -50, child: _blurCircle(150, Colors.pinkAccent.withValues(alpha: 0.2))),
          Positioned(bottom: -50, left: -50, child: _blurCircle(200, Colors.cyanAccent.withValues(alpha: 0.1))),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _animatedEntrance(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.orange, Colors.pinkAccent, Colors.cyanAccent],
                      ).createShader(bounds),
                      child: const Text(
                        "WELCOME TO\nCHANDRAMA GARAM MASALA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _animatedEntrance(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            children: [
                              const Text("ADMIN ACCESS",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2)),
                              const SizedBox(height: 25),
                              _modernField(userCtrl, "Username", Icons.person_outline, false),
                              const SizedBox(height: 15),
                              _modernField(passCtrl, "Password", Icons.lock_outline, true),
                              const SizedBox(height: 30),
                              _glowButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }

  Widget _animatedEntrance({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Opacity(
        opacity: value.clamp(0, 1),
        child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
      ),
      child: child,
    );
  }

  Widget _modernField(TextEditingController ctrl, String hint, IconData icon, bool isPass) {
    return TextField(
      controller: ctrl,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.cyanAccent),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.cyanAccent, width: 1)),
      ),
    );
  }

  Widget _glowButton() {
    return GestureDetector(
      onTap: tryLogin,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
          boxShadow: [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: const Center(child: Text("LOGIN", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 2))),
      ),
    );
  }
}

class SalesWorkflowPage extends StatefulWidget {
  final VoidCallback onLogout;
  const SalesWorkflowPage({super.key, required this.onLogout});

  @override
  State<SalesWorkflowPage> createState() => _SalesWorkflowPageState();
}

class _SalesWorkflowPageState extends State<SalesWorkflowPage> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> itemsTemplate = [
    {"name": "Garam Masala", "rate": 400.0, "qty": 0.0, "return": 0.0, "color": Colors.red.shade600},
    {"name": "Jaidana", "rate": 420.0, "qty": 0.0, "return": 0.0, "color": Colors.blue.shade600},
    {"name": "10 Marich", "rate": 400.0, "qty": 0.0, "return": 0.0, "color": Colors.teal.shade600},
    {"name": "10 Lwang", "rate": 400.0, "qty": 0.0, "return": 0.0, "color": Colors.deepPurple.shade400},
    {"name": "10 Sukmel", "rate": 400.0, "qty": 0.0, "return": 0.0, "color": Colors.green.shade600},
    {"name": "10 Supari", "rate": 420.0, "qty": 0.0, "return": 0.0, "color": Colors.orange.shade700},
    {"name": "20 Supari", "rate": 300.0, "qty": 0.0, "return": 0.0, "color": Colors.brown.shade400},
    {"name": "Poti Fish", "rate": 300.0, "qty": 0.0, "return": 0.0, "color": Colors.pink.shade400},
    {"name": "Jhinge Fish", "rate": 300.0, "qty": 0.0, "return": 0.0, "color": Colors.cyan.shade700},
    {"name": "Bhujuri Fish", "rate": 300.0, "qty": 0.0, "return": 0.0, "color": Colors.indigo.shade400},
    {"name": "Boi Fish", "rate": 300.0, "qty": 0.0, "return": 0.0, "color": Colors.amber.shade800},
    {"name": "Hallude Fish", "rate": 400.0, "qty": 0.0, "return": 0.0, "color": Colors.deepOrange.shade600},
  ];

  late List<Map<String, dynamic>> items;
  late List<TextEditingController> qtyControllers;
  late List<TextEditingController> returnControllers;
  final TextEditingController nameController = TextEditingController();
  
  Map<String, List<Map<String, dynamic>>> get sellerData => DataStore.savedSellerData;
  Map<String, double> get sellerTotal => DataStore.savedSellerTotals;
  List<String> get sellerList => DataStore.savedSellerList;

  String selectedSeller = '';
  bool isEditable = true;
  bool canCalculate = false; 
  bool showMenu = false;
  bool showTotal = false;
  double totalAmount = 0;
  late AnimationController _menuAnim;
  late Animation<double> _drawerSlide;
  int _tableAnimationKey = 0;
  
  final Map<int, TableColumnWidth> _tableWidths = const {
    0: FlexColumnWidth(2.5), 
    1: FlexColumnWidth(1.1), 
    2: FlexColumnWidth(1.2), 
    3: FlexColumnWidth(1.1), 
    4: FlexColumnWidth(1.3)
  };

  @override
  void initState() {
    super.initState();
    _resetTable();
    _menuAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _drawerSlide = CurvedAnimation(parent: _menuAnim, curve: Curves.easeOutBack);
  }

  void _vibrate() => HapticFeedback.lightImpact();

  void _resetTable() {
    items = itemsTemplate.map((e) => Map<String, dynamic>.from(e)).toList();
    qtyControllers = List.generate(items.length, (_) => TextEditingController(text: "0"));
    returnControllers = List.generate(items.length, (_) => TextEditingController(text: "0"));
    isEditable = true; canCalculate = false; showTotal = false; totalAmount = 0; _tableAnimationKey++;
  }

  void saveDraft() {
    _vibrate();
    String sellerName = nameController.text.trim();
    if (sellerName.isEmpty) return;
    DataStore.savedSellerData[sellerName] = items.map((e) => Map<String, dynamic>.from(e)).toList();
    DataStore.savedSellerTotals[sellerName] = totalAmount;
    if (!DataStore.savedSellerList.contains(sellerName)) DataStore.savedSellerList.add(sellerName);
    setState(() { selectedSeller = sellerName; nameController.clear(); _resetTable(); });
  }

  void loadSeller(String seller) {
    _vibrate();
    setState(() {
      items = DataStore.savedSellerData[seller]!.map((e) => Map<String, dynamic>.from(e)).toList();
      qtyControllers = List.generate(items.length, (i) => TextEditingController(text: fmt(items[i]["qty"])));
      returnControllers = List.generate(items.length, (i) => TextEditingController(text: fmt(items[i]["return"])));
      totalAmount = DataStore.savedSellerTotals[seller] ?? 0;
      showTotal = totalAmount > 0; selectedSeller = seller; nameController.text = seller;
      isEditable = false; 
      canCalculate = false; // Original logic: Restricted when loaded
      showMenu = false; _menuAnim.reverse(); _tableAnimationKey++;
    });
  }

  void enableEdit() { _vibrate(); setState(() { isEditable = true; canCalculate = true; }); }
  void calculateTotal() { _vibrate(); double total = 0; for (var item in items) { double sold = item["qty"] - item["return"]; if (sold < 0) sold = 0; total += sold * item["rate"]; } setState(() { totalAmount = total; showTotal = true; }); }
  void deleteSeller(String seller) { _vibrate(); showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text("Delete Seller"), content: Text("Do you want to delete '$seller' permanently?"), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("No", style: TextStyle(color: Colors.grey))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () { HapticFeedback.heavyImpact(); setState(() { DataStore.savedSellerData.remove(seller); DataStore.savedSellerTotals.remove(seller); DataStore.savedSellerList.remove(seller); if (selectedSeller == seller) { selectedSeller = ''; nameController.clear(); _resetTable(); } }); Navigator.pop(ctx); }, child: const Text("Yes, Delete", style: TextStyle(color: Colors.white))),],),); }
  String fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
              child: Column(
                children: [
                  _buildHeader(), 
                  const SizedBox(height: 10),
                  _buildSellerInput(), 
                  const SizedBox(height: 10),
                  _buildTableCard(), 
                  const SizedBox(height: 16), 
                  _buildActionButtons(), 
                  _buildTotalDisplay(),
                ],
              ),
            ),
          ),
          _buildAnimatedSidebar(),
        ],
      ),
    );
  }

  Widget _buildAnimatedSidebar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _drawerSlide,
      builder: (context, child) {
        return Stack(
          children: [
            if (showMenu) GestureDetector(onTap: () { setState(() => showMenu = false); _menuAnim.reverse(); }, child: Container(color: Colors.black45)),
            Positioned(
              left: -280 + (_drawerSlide.value * 280),
              top: 0, bottom: 0,
              child: Container(
                width: 260,
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15)],),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const ListTile(leading: CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.history, color: Colors.white)), title: Text("Recent Sellers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: sellerList.length,
                        itemBuilder: (context, i) {
                          String s = sellerList[i];
                          return ListTile(
                            title: Text(s, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: sellerTotal[s] != null && sellerTotal[s]! > 0 ? Text("Total: ₹ ${fmt(sellerTotal[s]!)}", style: const TextStyle(color: Colors.green)) : null,
                            trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => deleteSeller(s)),
                            onTap: () => loadSeller(s),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text("Logout Admin", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      onTap: widget.onLogout,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(children: [IconButton.filled(onPressed: () { setState(() { showMenu = !showMenu; showMenu ? _menuAnim.forward() : _menuAnim.reverse(); }); }, icon: Icon(showMenu ? Icons.close : Icons.menu), style: IconButton.styleFrom(backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.deepOrange : Colors.black, foregroundColor: Colors.white),), const SizedBox(width: 12), Expanded(child: Container(height: 55, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF512F), Color(0xFFDD2476)]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]), child: const Center(child: Text("CHANDRAMA MASALA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2))),),),],);
  }

  Widget _buildSellerInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(10), 
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.indigo.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))]
      ), 
      child: Row(
        children: [
          const Icon(Icons.person_pin_rounded, color: Colors.indigo, size: 28), 
          const SizedBox(width: 10), 
          const Text("Seller:", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.indigo)), 
          const SizedBox(width: 12), 
          Expanded(
            child: TextField(
              controller: nameController, 
              style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 16), 
              decoration: InputDecoration(
                hintText: "Enter Name Here", 
                hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.indigo.withValues(alpha: 0.3)),
                isDense: true, 
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15), 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.indigo.shade50)), 
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.indigo.shade50)), 
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.indigo, width: 1.5)), 
                filled: true, 
                fillColor: isDark ? Colors.black26 : const Color(0xFFF0F3FF)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(child: Container(decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],), clipBehavior: Clip.antiAlias, child: Column(children: [Table(columnWidths: _tableWidths, children: [TableRow(decoration: BoxDecoration(color: isDark ? Colors.indigo.withValues(alpha: 0.2) : Colors.indigo.shade50), children: const [_H("Item"), _H("Qty"), _H("Return"), _H("Rate"), _H("Total")],)],), const Divider(height: 1), Expanded(child: SingleChildScrollView(child: Table(key: ValueKey(_tableAnimationKey), columnWidths: _tableWidths, border: TableBorder.symmetric(inside: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade100)), children: List.generate(items.length, (index) => _staggeredRow(index)),),),),],),),);
  }

  TableRow _staggeredRow(int index) {
    return TableRow(children: List.generate(5, (cellIndex) { return TweenAnimationBuilder<double>(duration: Duration(milliseconds: 300 + (index * 80)), tween: Tween(begin: 0.0, end: 1.0), curve: Curves.easeOut, builder: (context, value, child) { return Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 15 * (1 - value)), child: child)); }, child: _getCellForIndex(index, cellIndex),); }),);
  }

  Widget _getCellForIndex(int itemIndex, int cellIndex) {
    var item = items[itemIndex]; double sold = item["qty"] - item["return"]; if (sold < 0) sold = 0;
    switch (cellIndex) {
      case 0: return _T(item["name"], align: TextAlign.left, textColor: item["color"]);
      case 1: return _Q(controller: qtyControllers[itemIndex], enabled: isEditable, onChanged: (v) => setState(() => item["qty"] = double.tryParse(v) ?? 0));
      case 2: return _Q(controller: returnControllers[itemIndex], enabled: isEditable, onChanged: (v) => setState(() => item["return"] = double.tryParse(v) ?? 0));
      case 3: return _T(item["rate"].toString());
      case 4: return _T((sold * item["rate"]).toString(), bold: true);
      default: return const SizedBox();
    }
  }

  Widget _buildActionButtons() { 
    return Row(
      children: [
        Expanded(child: _modernBtn(isEditable ? "Save Draft" : "Edit Seller", isEditable ? Colors.orange : Colors.blueGrey, isEditable ? Icons.save : Icons.edit, isEditable ? saveDraft : enableEdit)), 
        const SizedBox(width: 12), 
        Expanded(child: _modernBtn("Calculate", Colors.green, Icons.calculate, canCalculate ? calculateTotal : null)) // Fixed: Restored original logic
      ],
    ); 
  }

  Widget _modernBtn(String label, Color color, IconData icon, VoidCallback? action) { 
    bool isDisabled = action == null;
    return ElevatedButton.icon(
      onPressed: action, 
      icon: Icon(icon, size: 18), 
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), 
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? color.withValues(alpha: 0.3) : color, 
        foregroundColor: Colors.white, 
        elevation: isDisabled ? 0 : 4, 
        padding: const EdgeInsets.symmetric(vertical: 14), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ); 
  }

  Widget _buildTotalDisplay() { if (!showTotal) return const SizedBox.shrink(); final isDark = Theme.of(context).brightness == Brightness.dark; return Container(margin: const EdgeInsets.only(top: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: isDark ? Colors.green.withValues(alpha: 0.1) : Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.withValues(alpha: 0.5)),), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Grand Total:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), Text("₹ $totalAmount", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.green)),],),); }
}

class _H extends StatelessWidget { final String t; const _H(this.t); @override Widget build(BuildContext context) { final isDark = Theme.of(context).brightness == Brightness.dark; return Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Text(t, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: isDark ? Colors.indigoAccent : Colors.indigo))); } }

class _T extends StatelessWidget { 
  final String t; 
  final bool bold; 
  final TextAlign align; 
  final Color? textColor; 
  
  const _T(this.t, {this.bold = false, this.align = TextAlign.center, this.textColor}); 
  
  @override 
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10), 
    child: Text(
      t, 
      textAlign: align, 
      maxLines: 1, 
      overflow: TextOverflow.ellipsis, 
      style: TextStyle(
        fontWeight: bold ? FontWeight.w900 : FontWeight.bold, 
        fontSize: 13, 
        color: textColor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87)
      )
    )
  ); 
}

class _Q extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool enabled;

  const _Q({required this.controller, required this.onChanged, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: controller,
        enabled: enabled,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300)),
          filled: !enabled,
          fillColor: enabled
              ? (isDark ? Colors.black12 : Colors.white)
              : (isDark ? Colors.white10 : Colors.grey.shade50),
        ),
        onTap: () {
          if (controller.text == "0") controller.clear();
        },
        onChanged: (v) => onChanged(v.isEmpty ? "0" : v),
      ),
    );
  }
}