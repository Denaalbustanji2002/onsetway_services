// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/presentation/home/widget/appbar_widget.dart';
import 'package:onsetway_services/services/appointment_api.dart';
import 'package:onsetway_services/state/appointment_state.dart';
import 'package:onsetway_services/cubit/appointment_cubit.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    // e.g. Mon, 8 Sep 2025
    return '${_weekDay(d.weekday)}, ${d.day} ${_month(d.month)} ${d.year}';
  }

  String _weekDay(int w) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];

  String _month(int m) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];

  @override
  Widget build(BuildContext context) {
    final http = context.read<HttpClient>();

    return BlocProvider(
      create: (_) => AppointmentCubit(AppointmentApi(http))..loadAll(),
      child: OWScaffold(
        title: 'Appointment',
        body: Column(
          children: [
            const SizedBox(height: 8),
            _TabHeader(controller: _tabController),
            Expanded(
              child: BlocConsumer<AppointmentCubit, AppointmentState>(
                listener: (context, state) {
                  if (state is AppointmentMessage) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: ConstColor.darkGold,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  if (state is AppointmentFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AppointmentLoading || state is AppointmentIdle) {
                    return const Center(
                      child: CircularProgressIndicator(color: ConstColor.gold),
                    );
                  }

                  if (state is AppointmentLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Tab 1: Available slots
                        RefreshIndicator(
                          color: ConstColor.gold,
                          onRefresh: () => context
                              .read<AppointmentCubit>()
                              .refreshAvailable(),
                          child: state.available.isEmpty
                              ? const _EmptyBox(
                                  icon: Icons.event_busy,
                                  text: 'No available slots right now.',
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: state.available.length,
                                  itemBuilder: (context, i) {
                                    final s = state.available[i];
                                    return _SlotCard(
                                      title:
                                          '${_formatDate(s.date)} • ${s.dayOfWeek}',
                                      subtitle:
                                          '${s.startTime.substring(0, 5)} - ${s.endTime.substring(0, 5)}',
                                      // 🔒 The trailing widget is wrapped inside _SlotCard to avoid width errors
                                      trailing: s.isBooked
                                          ? const Icon(
                                              Icons.lock,
                                              color: Colors.red,
                                            )
                                          : TextButton(
                                              onPressed: () => context
                                                  .read<AppointmentCubit>()
                                                  .book(s.availabilityId),
                                              child: const Text('Book'),
                                            ),
                                    );
                                  },
                                ),
                        ),

                        // Tab 2: My bookings
                        RefreshIndicator(
                          color: ConstColor.gold,
                          onRefresh: () =>
                              context.read<AppointmentCubit>().refreshMine(),
                          child: state.myAppointments.isEmpty
                              ? const _EmptyBox(
                                  icon: Icons.event_available_outlined,
                                  text: 'You have no booked appointments.',
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: state.myAppointments.length,
                                  itemBuilder: (context, i) {
                                    final a = state.myAppointments[i];
                                    return _SlotCard(
                                      title:
                                          '${_formatDate(a.date)} • ${a.dayOfWeek}',
                                      subtitle:
                                          '${a.startTime.substring(0, 5)} - ${a.endTime.substring(0, 5)}',
                                      trailing: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.red,
                                            width: 1.4,
                                          ),
                                          foregroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(Icons.cancel_outlined),
                                        label: const Text('Cancel'),
                                        onPressed: () => context
                                            .read<AppointmentCubit>()
                                            .cancel(a.appointmentId),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  }

                  if (state is AppointmentFailure) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabHeader extends StatelessWidget {
  const _TabHeader({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorColor: ConstColor.gold,
      indicatorWeight: 3,
      labelColor: ConstColor.gold,
      unselectedLabelColor: Colors.white70,
      tabs: const [
        Tab(icon: Icon(Icons.event_available), text: 'Available'),
        Tab(icon: Icon(Icons.book_online_outlined), text: 'My bookings'),
      ],
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70),
        ),
        // ✅ HARDENED trailing: never lets it consume the whole tile
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160), // tweak if needed
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(mainAxisSize: MainAxisSize.min, children: [trailing]),
          ),
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 80),
        Icon(icon, color: Colors.white30, size: 56),
        const SizedBox(height: 16),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, fontSize: 16),
        ),
      ],
    );
  }
}
