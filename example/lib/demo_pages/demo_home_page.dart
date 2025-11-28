import 'package:flutter/material.dart';
import 'list_card_demo.dart';
import 'grid_card_demo.dart';
import 'compact_row_demo.dart';
import 'interactive_demo.dart';
import 'spline_chart_demo.dart';

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  final List<dynamic> _groupsData = [
    {
      'name': 'Core Value',
      'competencies': [
        {'name': 'Integrity', 'percentScore': 80.0},
        {'name': 'Continuous Learning', 'percentScore': 65.0},
        {'name': 'Accountability', 'percentScore': 90.0},
        {'name': 'Teamwork', 'percentScore': 75.0},
        {'name': 'Innovation', 'percentScore': 85.0},
      ],
    },
    {
      'name': 'Core Competency',
      'competencies': [
        {'name': 'Problem Solving', 'percentScore': 70.0},
        {'name': 'Communication', 'percentScore': 88.0},
        {'name': 'Adaptability', 'percentScore': 60.0},
        {'name': 'Time Management', 'percentScore': 75.0},
        {'name': 'Leadership', 'percentScore': 82.0},
      ],
    },
    {
      'name': 'Sale Competency',
      'competencies': [
        {'name': 'Negotiation', 'percentScore': 95.0},
        {'name': 'Product Knowledge', 'percentScore': 85.0},
        {'name': 'Closing Skills', 'percentScore': 78.0},
        {'name': 'Customer Service', 'percentScore': 92.0},
        {'name': 'Prospecting', 'percentScore': 68.0},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LinSpiderMonkeyChart Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome, Plumber User',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          _buildMenuButton(
            context,
            'List Card Demo',
            'Show charts in a vertical list with details',
            Icons.list,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListCardDemo(groups: _groupsData),
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
                builder: (context) => GridCardDemo(groups: _groupsData),
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
                builder: (context) => CompactRowDemo(groups: _groupsData),
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
                builder: (context) => InteractiveDemo(groups: _groupsData),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildMenuButton(
            context,
            'Spline Chart Demo',
            'Curved lines chart (Image Style)',
            Icons.show_chart,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SplineChartDemo(groups: _groupsData),
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
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
