import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/earnings_controller.dart';

class EarningsView extends GetView<EarningsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.loadCompletedProjects(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading data',
                  style: TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () => controller.loadCompletedProjects(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMonthSelector(),
              SizedBox(height: 20),
              _buildSummaryCards(),
              SizedBox(height: 20),
              _buildEarningsChart(),
              SizedBox(height: 20),
              _buildProjectList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => controller.changeMonth(false),
        ),
        Obx(() => Text(
              DateFormat('MMMM yyyy').format(controller.selectedMonth.value),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () => controller.changeMonth(true),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Total Earnings',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Obx(() => Text(
                        '\$${controller.totalEarnings.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Total Hours',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Obx(() => Text(
                        '${controller.totalHours.value.toStringAsFixed(1)}h',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsChart() {
    return Obx(() {
      if (controller.monthlyEarningsData.isEmpty) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Monthly Earnings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('No earnings data available'),
              ],
            ),
          ),
        );
      }

      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Monthly Earnings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: controller.monthlyEarningsData
                        .fold<double>(0, (prev, element) => element['earnings'] > prev 
                            ? element['earnings'] 
                            : prev) * 1.2,
                    barGroups: controller.monthlyEarningsData
                        .asMap()
                        .entries
                        .map((entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              fromY: 0,
                              toY: entry.value['earnings']?.toDouble() ?? 0.0,
                              color: Colors.blue,
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ))
                        .toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < controller.monthlyEarningsData.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  controller.monthlyEarningsData[index]['month'],
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text('\$${value.toInt()}');
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProjectList() {
    return Obx(() {
      if (controller.completedProjects.isEmpty) {
        return Center(
          child: Text(
            'No completed projects yet',
            style: TextStyle(fontSize: 16),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completed Projects',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...controller.completedProjects.map((project) => Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(project.title),
                  subtitle: Text(project.clientName),
                  trailing: Text(
                    '\$${project.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              )),
        ],
      );
    });
  }
}