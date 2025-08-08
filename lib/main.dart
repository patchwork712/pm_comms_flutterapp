import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// ROM Calculator Screen
class RomCalculatorScreen extends StatefulWidget {
  const RomCalculatorScreen({super.key});

  @override
  State<RomCalculatorScreen> createState() => _RomCalculatorScreenState();
}

class _RomCalculatorScreenState extends State<RomCalculatorScreen> {
  final _hoursController = TextEditingController();
  final _rateController = TextEditingController();
  double _riskFactor = 1.2;
  double? _romEstimate;

  @override
  void dispose() {
    _hoursController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _calculateROM() {
    final hours = double.tryParse(_hoursController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    if (hours > 0 && rate > 0) {
      setState(() {
        _romEstimate = hours * rate * _riskFactor;
      });
    } else {
      setState(() {
        _romEstimate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROM Calculator'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Rough Order of Magnitude (ROM) Cost Estimator',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimated Effort (hours)',
                  prefixIcon: Icon(Icons.timer),
                ),
                onChanged: (_) => _calculateROM(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Hourly Rate (\$)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                onChanged: (_) => _calculateROM(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Risk Factor:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Slider(
                      value: _riskFactor,
                      min: 1.0,
                      max: 2.0,
                      divisions: 10,
                      label: _riskFactor.toStringAsFixed(2),
                      onChanged: (value) {
                        setState(() {
                          _riskFactor = value;
                        });
                        _calculateROM();
                      },
                    ),
                  ),
                  Text(_riskFactor.toStringAsFixed(2)),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateROM,
                child: const Text('Calculate ROM'),
              ),
              const SizedBox(height: 32),
              if (_romEstimate != null)
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text('Estimated ROM Cost', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        Text(
                          '\$${_romEstimate!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Includes risk factor (${_riskFactor.toStringAsFixed(2)})'),
                      ],
                    ),
                  ),
                ),
              if (_romEstimate == null)
                const Text('Enter valid hours and rate to estimate cost.', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final customLightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
    );
    final customDarkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    );
    return MaterialApp(
      title: 'PM Communication Tools',
      theme: ThemeData(
        colorScheme: customLightColorScheme,
        useMaterial3: true,
        textTheme: Typography.englishLike2021.apply(
          fontFamily: 'Roboto',
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: customDarkColorScheme,
        useMaterial3: true,
        textTheme: Typography.englishLike2021.apply(
          fontFamily: 'Roboto',
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onThemeToggle: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PM Communication Tools'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            tooltip: widget.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Communication & Alignment Tools',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildFeatureCard(
                  context,
                  'The Pocket Roadmap',
                  'Visualize and share your product roadmap on the go',
                  Icons.map_outlined,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RoadmapScreen()),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildFeatureCard(
                  context,
                  'Stakeholder Update Generator',
                  'Create structured progress updates quickly',
                  Icons.auto_graph_outlined,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateGeneratorScreen()),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildFeatureCard(
                  context,
                  'ROM Calculator',
                  'Estimate the cost of software efforts quickly',
                  Icons.calculate_outlined,
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RomCalculatorScreen()),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  _version == null ? '' : 'Version: $_version',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
  splashColor: color.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Roadmap Models
class RoadmapItem {
  final String id;
  final String title;
  final String description;
  final String problem;
  final String keyMetrics;
  final String status; // 'now', 'next', 'later'

  RoadmapItem({
    required this.id,
    required this.title,
    required this.description,
    required this.problem,
    required this.keyMetrics,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'problem': problem,
      'keyMetrics': keyMetrics,
      'status': status,
    };
  }

  factory RoadmapItem.fromJson(Map<String, dynamic> json) {
    return RoadmapItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      problem: json['problem'] ?? '',
      keyMetrics: json['keyMetrics'] ?? '',
      status: json['status'] ?? 'now',
    );
  }
}

class Roadmap {
  final String id;
  final String name;
  final List<RoadmapItem> items;

  Roadmap({
    required this.id,
    required this.name,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Roadmap.fromJson(Map<String, dynamic> json) {
    return Roadmap(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => RoadmapItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

// Roadmap Screen
class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  List<Roadmap> roadmaps = [];
  int currentRoadmapIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadRoadmaps();
  }

  Future<void> _loadRoadmaps() async {
    final prefs = await SharedPreferences.getInstance();
    final roadmapsJson = prefs.getString('roadmaps');
    
    if (roadmapsJson != null) {
      try {
        final List<dynamic> roadmapsList = json.decode(roadmapsJson);
        setState(() {
          roadmaps = roadmapsList
              .map((json) => Roadmap.fromJson(json as Map<String, dynamic>))
              .toList();
        });
      } catch (e) {
        // If there's an error loading, start with sample data
        setState(() {
          roadmaps = [_getSampleRoadmap()];
        });
        _saveRoadmaps();
      }
    } else {
      // Initialize with sample data
      setState(() {
        roadmaps = [_getSampleRoadmap()];
      });
      _saveRoadmaps();
    }
  }

  Future<void> _saveRoadmaps() async {
    final prefs = await SharedPreferences.getInstance();
    final roadmapsJson = json.encode(roadmaps.map((r) => r.toJson()).toList());
    await prefs.setString('roadmaps', roadmapsJson);
  }

  Roadmap _getSampleRoadmap() {
    return Roadmap(
      id: '1',
      name: 'Mobile App Roadmap',
      items: [
        RoadmapItem(
          id: '1',
          title: 'User Authentication',
          description: 'Implement secure login and registration',
          problem: 'Users need a secure way to access their personal data',
          keyMetrics: 'Registration completion rate, Login success rate',
          status: 'now',
        ),
        RoadmapItem(
          id: '2',
          title: 'Push Notifications',
          description: 'Real-time notifications for important updates',
          problem: 'Users miss important updates when not actively using the app',
          keyMetrics: 'Notification open rate, User engagement',
          status: 'next',
        ),
        RoadmapItem(
          id: '3',
          title: 'Offline Mode',
          description: 'Allow app usage without internet connection',
          problem: 'Users in areas with poor connectivity cannot use the app',
          keyMetrics: 'Offline usage time, Data sync success rate',
          status: 'later',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (roadmaps.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pocket Roadmap'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentRoadmap = roadmaps[currentRoadmapIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket Roadmap'),
        actions: [
          if (roadmaps.length > 1)
            PopupMenuButton<int>(
              icon: const Icon(Icons.swap_horiz),
              onSelected: (index) {
                setState(() {
                  currentRoadmapIndex = index;
                });
              },
              itemBuilder: (context) => roadmaps.asMap().entries.map((entry) {
                return PopupMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value.name),
                );
              }).toList(),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Text(
                  currentRoadmap.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).orientation == Orientation.landscape ? 400 : 600,
                child: Row(
                  children: [
                    _buildStatusColumn('Now', 'now', Colors.red),
                    _buildStatusColumn('Next', 'next', Colors.orange),
                    _buildStatusColumn('Later', 'later', Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Item'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildStatusColumn(String title, String status, Color color) {
    final items = roadmaps[currentRoadmapIndex].items
        .where((item) => item.status == status)
        .toList();

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.18), width: 1.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.09),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 17,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _buildRoadmapCard(items[index], color),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapCard(RoadmapItem item, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: () => _showItemDetails(item),
        borderRadius: BorderRadius.circular(14),
  splashColor: color.withValues(alpha: 0.13),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.label_important_rounded, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(RoadmapItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.description),
              const SizedBox(height: 12),
              const Text(
                'Problem it solves:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.problem),
              const SizedBox(height: 12),
              const Text(
                'Key Metrics:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.keyMetrics),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }



  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Text('Add item dialog placeholder.'),
      ),
    );
  }
}

// StakeholderUpdate model (moved to top-level)
class StakeholderUpdate {
  final String id;
  final DateTime date;
  final String launched;
  final String workingOn;
  final String keyMetrics;
  final String blockers;

  StakeholderUpdate({
    required this.id,
    required this.date,
    required this.launched,
    required this.workingOn,
    required this.keyMetrics,
    required this.blockers,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'launched': launched,
      'workingOn': workingOn,
      'keyMetrics': keyMetrics,
      'blockers': blockers,
    };
  }

  factory StakeholderUpdate.fromJson(Map<String, dynamic> json) {
    return StakeholderUpdate(
      id: json['id'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      launched: json['launched'] ?? '',
      workingOn: json['workingOn'] ?? '',
      keyMetrics: json['keyMetrics'] ?? '',
      blockers: json['blockers'] ?? '',
    );
  }
}

// Update Generator Screen
class UpdateGeneratorScreen extends StatefulWidget {
  const UpdateGeneratorScreen({super.key});

  @override
  State<UpdateGeneratorScreen> createState() => _UpdateGeneratorScreenState();
}

class _UpdateGeneratorScreenState extends State<UpdateGeneratorScreen> {
  final _launchedController = TextEditingController();
  final _workingOnController = TextEditingController();
  final _keyMetricsController = TextEditingController();
  final _blockersController = TextEditingController();
  
  List<StakeholderUpdate> previousUpdates = [];

  @override
  void initState() {
    super.initState();
    _loadPreviousUpdates();
  }

  Future<void> _loadPreviousUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final updatesJson = prefs.getString('stakeholder_updates');
    
    if (updatesJson != null) {
      try {
        final List<dynamic> updatesList = json.decode(updatesJson);
        setState(() {
          previousUpdates = updatesList
              .map((json) => StakeholderUpdate.fromJson(json as Map<String, dynamic>))
              .toList();
          // Sort by date descending
          previousUpdates.sort((a, b) => b.date.compareTo(a.date));
        });
      } catch (e) {
        // If there's an error loading, start with empty list
        setState(() {
          previousUpdates = [];
        });
      }
    }
  }

  Future<void> _savePreviousUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final updatesJson = json.encode(previousUpdates.map((u) => u.toJson()).toList());
    await prefs.setString('stakeholder_updates', updatesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showPreviousUpdates,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Stakeholder Update Form',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildSection(
                'What we launched',
                _launchedController,
                'List the features or improvements that went live...',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildSection(
                'What we\'re working on',
                _workingOnController,
                'Describe current development priorities...',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Key Metrics',
                _keyMetricsController,
                'Share important numbers, usage stats, or KPIs...',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Blockers',
                _blockersController,
                'Any obstacles or dependencies that need attention...',
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _generateAndCopy,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Generate & Copy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveUpdate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _clearForm,
                child: const Text('Clear Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  void _generateAndCopy() {
    final update = _generateMarkdownUpdate();
    Clipboard.setData(ClipboardData(text: update));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Update copied to clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Show preview dialog
    _showPreviewDialog(update);
  }

  String _generateMarkdownUpdate() {
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year}';
    
  return '''# Weekly Update - $formattedDate

## 🚀 What we launched
${_launchedController.text.isEmpty ? '_Nothing to report this week._' : _launchedController.text}

## 🔨 What we're working on
${_workingOnController.text.isEmpty ? '_Development priorities will be updated next week._' : _workingOnController.text}

## 📊 Key Metrics
${_keyMetricsController.text.isEmpty ? '_Metrics will be shared in the next update._' : _keyMetricsController.text}

## 🚧 Blockers
${_blockersController.text.isEmpty ? '_No blockers at this time._' : _blockersController.text}

---
_Generated on $formattedDate''';
  }

  void _showPreviewDialog(String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Preview'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _saveUpdate() {
    if (_launchedController.text.isEmpty && 
        _workingOnController.text.isEmpty && 
        _keyMetricsController.text.isEmpty && 
        _blockersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in at least one section before saving.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final update = StakeholderUpdate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      launched: _launchedController.text,
      workingOn: _workingOnController.text,
      keyMetrics: _keyMetricsController.text,
      blockers: _blockersController.text,
    );

    setState(() {
      previousUpdates.insert(0, update);
    });
    _savePreviousUpdates();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Update saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearForm() {
    _launchedController.clear();
    _workingOnController.clear();
    _keyMetricsController.clear();
    _blockersController.clear();
  }

  void _showPreviousUpdates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Previous Updates'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: previousUpdates.isEmpty
              ? const Center(child: Text('No previous updates found.'))
              : ListView.builder(
                  itemCount: previousUpdates.length,
                  itemBuilder: (context, index) {
                    final update = previousUpdates[index];
                    final formattedDate = '${update.date.day}/${update.date.month}/${update.date.year}';
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text('Update - $formattedDate'),
                        subtitle: Text(
                          update.launched.isNotEmpty 
                              ? '${update.launched.substring(0, update.launched.length > 50 ? 50 : update.launched.length)}...'
                              : 'No launches reported',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _loadPreviousUpdate(update),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _loadPreviousUpdate(StakeholderUpdate update) {
    setState(() {
      _launchedController.text = update.launched;
      _workingOnController.text = update.workingOn;
      _keyMetricsController.text = update.keyMetrics;
      _blockersController.text = update.blockers;
    });
    Navigator.pop(context); // Close the dialog
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Previous update loaded for reference.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    _launchedController.dispose();
    _workingOnController.dispose();
    _keyMetricsController.dispose();
    _blockersController.dispose();
    super.dispose();
  }
}