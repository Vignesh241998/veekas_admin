import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/dashboard_modal.dart';
import '../viewmodal/dashboard_view_modal.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(
      dashboardViewModelProvider,
    );

    return dashboardAsync.when(
      // ==========================================================
      // LOADING
      // ==========================================================

      loading: () {
        return const _DashboardLoading();
      },

      // ==========================================================
      // ERROR
      // ==========================================================

      error: (error, stackTrace) {
        return _DashboardError(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(
              dashboardViewModelProvider,
            );
          },
        );
      },

      // ==========================================================
      // DATA
      // ==========================================================

      data: (response) {
        if (!response.status) {
          return _DashboardError(
            message: response.message,
            onRetry: () {
              ref.invalidate(
                dashboardViewModelProvider,
              );
            },
          );
        }

        final dashboardData = response.data;

        if (dashboardData == null) {
          return const _DashboardEmpty();
        }

        return _DashboardContent(
          dashboardData: dashboardData,
          onRefresh: () {
            ref.invalidate(
              dashboardViewModelProvider,
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// DASHBOARD CONTENT
// ============================================================================

class _DashboardContent extends StatelessWidget {
  final DashboardDataModel dashboardData;
  final VoidCallback onRefresh;

  const _DashboardContent({
    required this.dashboardData,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ========================================================
            // HEADER
            // ========================================================

            _DashboardHeader(
              onRefresh: onRefresh,
            ),

            const SizedBox(height: 28),

            // ========================================================
            // CHARTS
            // ========================================================

            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop =
                    constraints.maxWidth >= 1000;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      // BAR CHART
                      Expanded(
                        flex: 3,
                        child: OrdersBarChart(
                          orders:
                          dashboardData.ordersLast7Days,
                        ),
                      ),

                      const SizedBox(width: 24),

                      // PIE CHART
                      Expanded(
                        flex: 2,
                        child: OrdersPieChart(
                          ordersByStatus:
                          dashboardData.ordersByStatus,
                        ),
                      ),
                    ],
                  );
                }

                // TABLET / SMALL SCREEN

                return Column(
                  children: [

                    OrdersBarChart(
                      orders:
                      dashboardData.ordersLast7Days,
                    ),

                    const SizedBox(height: 24),

                    OrdersPieChart(
                      ordersByStatus:
                      dashboardData.ordersByStatus,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            // ========================================================
            // SUMMARY CARDS
            // ========================================================

            _SummaryCards(
              summary: dashboardData.summary,
            ),

          ],
        ),
      ),
    );
  }
}

// ============================================================================
// DASHBOARD HEADER
// ============================================================================

class _DashboardHeader extends StatelessWidget {
  final VoidCallback onRefresh;

  const _DashboardHeader({
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                'Dashboard',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Overview of your e-commerce business',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        // REFRESH BUTTON

        IconButton(
          tooltip: 'Refresh',
          onPressed: onRefresh,
          icon: const Icon(
            Icons.refresh,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SUMMARY CARDS
// ============================================================================

class _SummaryCards extends StatelessWidget {
  final DashboardSummaryModel summary;

  const _SummaryCards({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [

      _SummaryCardData(
        title: 'Total Customers',
        value: summary.totalCustomers.toString(),
        icon: Icons.people_outline,
      ),

      _SummaryCardData(
        title: 'Total Orders',
        value: summary.totalOrders.toString(),
        icon: Icons.shopping_bag_outlined,
      ),

      _SummaryCardData(
        title: 'Total Products',
        value: summary.totalProducts.toString(),
        icon: Icons.inventory_2_outlined,
      ),

      _SummaryCardData(
        title: 'Total Revenue',
        value:
        '₹${summary.totalRevenue.toStringAsFixed(0)}',
        icon: Icons.currency_rupee,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {

        int columns;

        if (constraints.maxWidth >= 1200) {
          columns = 4;
        } else if (constraints.maxWidth >= 700) {
          columns = 2;
        } else {
          columns = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,

            childAspectRatio:
            columns == 1 ? 4.0 : 2.1,
          ),
          itemBuilder: (context, index) {
            return _SummaryCard(
              data: cards[index],
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// SUMMARY CARD DATA
// ============================================================================

class _SummaryCardData {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.icon,
  });
}

// ============================================================================
// SUMMARY CARD
// ============================================================================

class _SummaryCard extends StatelessWidget {
  final _SummaryCardData data;

  const _SummaryCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [

            // ======================================================
            // ICON
            // ======================================================

            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Icon(
                data.icon,
                color: primaryColor,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // ======================================================
            // TEXT
            // ======================================================

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    data.title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color:
                      Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data.value,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ORDERS BAR CHART
// ============================================================================

class OrdersBarChart extends StatelessWidget {
  final List<OrdersLast7DaysModel> orders;

  const OrdersBarChart({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {

    if (orders.isEmpty) {
      return const _ChartCard(
        title: 'Orders - Last 7 Days',
        child: _ChartEmpty(
          message:
          'No order data available',
        ),
      );
    }

    final maxOrders = orders.fold<int>(
      0,
          (max, item) {
        return item.orders > max
            ? item.orders
            : max;
      },
    );

    final double maxY;

    if (maxOrders == 0) {
      maxY = 5;
    } else {
      maxY = (maxOrders + 1).toDouble();
    }

    return _ChartCard(
      title: 'Orders - Last 7 Days',
      child: SizedBox(
        height: 320,
        child: BarChart(
          BarChartData(

            // ======================================================
            // Y AXIS
            // ======================================================

            maxY: maxY,

            minY: 0,

            alignment:
            BarChartAlignment.spaceAround,

            // ======================================================
            // GRID
            // ======================================================

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
            ),

            // ======================================================
            // BORDER
            // ======================================================

            borderData: FlBorderData(
              show: false,
            ),

            // ======================================================
            // TOUCH
            // ======================================================

            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData:
              BarTouchTooltipData(
                getTooltipItem: (
                    group,
                    groupIndex,
                    rod,
                    rodIndex,
                    ) {
                  final item =
                  orders[groupIndex];

                  return BarTooltipItem(
                    '${item.date}\n'
                        '${item.orders} orders',
                    const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  );
                },
              ),
            ),

            // ======================================================
            // TITLES
            // ======================================================

            titlesData: FlTitlesData(

              // TOP
              topTitles:
              const AxisTitles(
                sideTitles:
                SideTitles(
                  showTitles: false,
                ),
              ),

              // RIGHT
              rightTitles:
              const AxisTitles(
                sideTitles:
                SideTitles(
                  showTitles: false,
                ),
              ),

              // LEFT
              leftTitles:
              AxisTitles(
                sideTitles:
                SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  interval: 1,

                  getTitlesWidget:
                      (value, meta) {

                    return Text(
                      value
                          .toInt()
                          .toString(),
                      style:
                      const TextStyle(
                        fontSize: 11,
                      ),
                    );
                  },
                ),
              ),

              // BOTTOM
              bottomTitles:
              AxisTitles(
                sideTitles:
                SideTitles(
                  showTitles: true,
                  reservedSize: 40,

                  getTitlesWidget:
                      (value, meta) {

                    final index =
                    value.toInt();

                    if (index < 0 ||
                        index >=
                            orders.length) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding:
                      const EdgeInsets
                          .only(top: 8),
                      child: Text(
                        orders[index].date,
                        style:
                        const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ======================================================
            // BAR GROUPS
            // ======================================================

            barGroups:
            List.generate(
              orders.length,
                  (index) {

                final item =
                orders[index];

                return BarChartGroupData(
                  x: index,

                  barRods: [
                    BarChartRodData(
                      toY:
                      item.orders.toDouble(),

                      width: 28,

                      color: Theme.of(context)
                          .colorScheme
                          .primary,

                      borderRadius:
                      const BorderRadius
                          .vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ORDERS PIE CHART
// ============================================================================

class OrdersPieChart extends StatelessWidget {
  final List<OrdersByStatusModel>
  ordersByStatus;

  const OrdersPieChart({
    super.key,
    required this.ordersByStatus,
  });

  @override
  Widget build(BuildContext context) {

    // ============================================================
    // REMOVE ZERO COUNT STATUS
    // ============================================================

    final activeStatuses =
    ordersByStatus
        .where(
          (item) => item.count > 0,
    )
        .toList();

    if (activeStatuses.isEmpty) {
      return const _ChartCard(
        title: 'Orders by Status',
        child: _ChartEmpty(
          message:
          'No order status data available',
        ),
      );
    }

    // ============================================================
    // CHART COLORS
    // ============================================================

    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.indigo,
      Colors.teal,
      Colors.green,
      Colors.red,
      Colors.deepOrange,
      Colors.cyan,
      Colors.grey,
    ];

    return _ChartCard(
      title: 'Orders by Status',
      child: SizedBox(
        height: 320,
        child: Row(
          children: [

            // ======================================================
            // PIE
            // ======================================================

            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(

                  centerSpaceRadius: 45,

                  sectionsSpace: 3,

                  pieTouchData:
                  PieTouchData(
                    enabled: true,
                  ),

                  sections:
                  List.generate(
                    activeStatuses.length,
                        (index) {

                      final item =
                      activeStatuses[index];

                      return PieChartSectionData(
                        value:
                        item.count.toDouble(),

                        title:
                        item.count.toString(),

                        radius: 70,

                        color: colors[
                        index %
                            colors.length],

                        titleStyle:
                        const TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // ======================================================
            // LEGEND
            // ======================================================

            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount:
                activeStatuses.length,

                itemBuilder:
                    (context, index) {

                  final item =
                  activeStatuses[index];

                  final color =
                  colors[
                  index %
                      colors.length];

                  return Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      vertical: 7,
                    ),
                    child: Row(
                      children: [

                        // DOT

                        Container(
                          width: 10,
                          height: 10,
                          decoration:
                          BoxDecoration(
                            color: color,
                            shape:
                            BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // STATUS

                        Expanded(
                          child: Text(
                            _formatStatus(
                              item.status,
                            ),
                            maxLines: 2,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        // COUNT

                        Text(
                          item.count.toString(),
                          style:
                          const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(String status) {
    return status
        .toLowerCase()
        .split('_')
        .map(
          (word) {
        if (word.isEmpty) {
          return '';
        }

        return word[0].toUpperCase() +
            word.substring(1);
      },
    )
        .join(' ');
  }
}

// ============================================================================
// CHART CARD
// ============================================================================

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            child,
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CHART EMPTY
// ============================================================================

class _ChartEmpty extends StatelessWidget {
  final String message;

  const _ChartEmpty({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LOADING
// ============================================================================

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

// ============================================================================
// ERROR
// ============================================================================

class _DashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [

            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red.shade400,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load dashboard',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color:
                Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,
              icon:
              const Icon(Icons.refresh),
              label:
              const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY
// ============================================================================

class _DashboardEmpty
    extends StatelessWidget {
  const _DashboardEmpty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [

          Icon(
            Icons.dashboard_outlined,
            size: 64,
          ),

          SizedBox(height: 16),

          Text(
            'No dashboard data available',
          ),
        ],
      ),
    );
  }
}