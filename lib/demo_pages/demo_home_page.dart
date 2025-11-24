import 'package:flutter/material.dart';
import '../api_service.dart';
import 'list_card_demo.dart';
import 'grid_card_demo.dart';
import 'compact_row_demo.dart';
import 'interactive_demo.dart';

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<dynamic> _groups = [];
  String? _userName;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loginResult = await _apiService.login();
      if (loginResult.containsKey('user')) {
        final user = loginResult['user'];
        _userName = '${user['firstName']} ${user['lastName'] ?? ''}';
      }

      final groups = await _apiService.getCompetencyGroups();
      setState(() {
        _groups = groups;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chard Kit V2 Demo'),
        actions: [
          if (_groups.isEmpty)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _isLoading ? null : _fetchData,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No data loaded'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _fetchData,
                    child: const Text('Load Data from API'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_userName != null) ...[
                  Text(
                    'Welcome, $_userName',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                ],
                _buildMenuButton(
                  context,
                  'List Card Demo',
                  'Show charts in a vertical list with details',
                  Icons.list,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListCardDemo(groups: _groups),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  'Grid Card Demo',
                  'Show charts in a grid layout',
                  Icons.grid_view,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GridCardDemo(groups: _groups),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  'Compact Row Demo',
                  'Show charts in a compact row format',
                  Icons.table_rows,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompactRowDemo(groups: _groups),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  'Interactive Chart Demo',
                  'Full screen interactive chart',
                  Icons.touch_app,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InteractiveDemo(groups: _groups),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
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
