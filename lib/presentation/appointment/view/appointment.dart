// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_element_parameter, unused_element
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/presentation/appointment/widget/tab_header.dart';
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
  late final TabController _tab;
  bool _busyBooking = false;
  int? _busyCancelId;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ---------- safe helpers ----------
  String _safeSub(String? s, int n) =>
      (s ?? '').length <= n ? (s ?? '') : (s ?? '').substring(0, n);
  String _formatDate(DateTime? d) => d == null
      ? '—'
      : '${_weekDay(d.weekday)}, ${d.day} ${_month(d.month)} ${d.year}';
  String _weekDay(int w) => const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ][((w - 1) % 7).clamp(0, 6)];
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
  ][((m - 1) % 12).clamp(0, 11)];
  DateTime _combine(DateTime? date, String? hhmmss) {
    final d = date ?? DateTime.now();
    final p = (hhmmss ?? '').split(':');
    int get(int i) => (i >= 0 && i < p.length) ? int.tryParse(p[i]) ?? 0 : 0;
    return DateTime(d.year, d.month, d.day, get(0), get(1), get(2));
  }

  AppointmentModel? _firstActive(List<AppointmentModel>? list) {
    final items = list ?? const <AppointmentModel>[];
    final now = DateTime.now();
    for (final a in items) {
      final end = _combine(a.date, a.endTime);
      if (end.isAfter(now)) return a;
    }
    return null;
  }

  Future<bool?> _confirmSwapDialog({
    required AppointmentModel current,
    required String newDateStr,
    required String newTimeStr,
  }) {
    final currentWindow =
        '${_safeSub(current.startTime, 5)} - ${_safeSub(current.endTime, 5)}';
    final currentDate = _formatDate(current.date);
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[800]!, Colors.grey[900]!],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ConstColor.gold.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.6),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.amber[700]!],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Active Appointment Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850]!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[700]!, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Appointment',
                      style: TextStyle(
                        color: ConstColor.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$currentDate • $currentWindow',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Do you want to cancel it and book the new slot\n$newDateStr • $newTimeStr instead?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.85),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      label: 'Keep \nCurrent',

                      onTap: () => Navigator.of(ctx).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryButton(
                      label: 'Cancel \n & Book',

                      onTap: () => Navigator.of(ctx).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleBookTap({
    required BuildContext ctx,
    required int availabilityId,
    required DateTime? slotDate,
    required String? startTime,
    required String? endTime,
  }) async {
    if (_busyBooking) return;
    _busyBooking = true;
    try {
      final bloc = ctx.read<AppointmentCubit>();
      final st = bloc.state;

      final newDateStr = _formatDate(slotDate);
      final newTimeStr = '${_safeSub(startTime, 5)} - ${_safeSub(endTime, 5)}';

      AppointmentModel? active;
      if (st is AppointmentLoaded) {
        active = _firstActive(st.myAppointments);
      }

      if (active != null) {
        final wantSwap = await _confirmSwapDialog(
          current: active,
          newDateStr: newDateStr,
          newTimeStr: newTimeStr,
        );
        if (wantSwap != true) {
          _snack(
            'Kept your current appointment.',
            icon: Icons.info_outline,
            bg: Colors.grey[700]!,
          );
          return;
        }
        await bloc.cancel(active.appointmentId);
        await bloc.stream.firstWhere(
          (s) => s is AppointmentLoaded || s is AppointmentFailure,
        );
        await bloc.book(availabilityId);
        return;
      }

      await bloc.book(availabilityId);
    } finally {
      _busyBooking = false;
    }
  }

  Future<void> _handleCancelTap(BuildContext ctx, int appointmentId) async {
    if (_busyCancelId == appointmentId) return;
    setState(() => _busyCancelId = appointmentId);
    final bloc = ctx.read<AppointmentCubit>();
    await bloc.cancel(appointmentId);
    await bloc.stream.firstWhere(
      (s) => s is AppointmentLoaded || s is AppointmentFailure,
    );
    if (mounted) setState(() => _busyCancelId = null);
  }

  void _snack(String msg, {required IconData icon, required Color bg}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        elevation: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final http = context.read<HttpClient>();

    return BlocProvider(
      create: (_) => AppointmentCubit(AppointmentApi(http))..loadAll(),
      child: Builder(
        builder: (ctx) => OWScaffold(
          title: 'Appointments',
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.grey[900]!,
                  Colors.grey[850]!,
                  Colors.black,
                ],
                stops: const [0, .25, .75, 1],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  EnhancedTabHeader(controller: _tab),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocConsumer<AppointmentCubit, AppointmentState>(
                      listener: (ctx, state) {
                        if (state is AppointmentMessage) {
                          _snack(
                            state.message,
                            icon: Icons.check_circle_outline,
                            bg: ConstColor.darkGold,
                          );
                        } else if (state is AppointmentFailure) {
                          _snack(
                            state.message,
                            icon: Icons.error_outline,
                            bg: Colors.red[700]!,
                          );
                        }
                      },
                      builder: (ctx, state) {
                        if (state is AppointmentLoading ||
                            state is AppointmentIdle) {
                          return const _LoadingView();
                        }

                        if (state is AppointmentLoaded) {
                          final flattened = <_SlotView>[];
                          for (final day in state.availableDays) {
                            final date = day.date;
                            final slots = day.slots;
                            for (final s in slots) {
                              flattened.add(_SlotView(date: date, slot: s));
                            }
                          }
                          final mine = state.myAppointments;

                          return TabBarView(
                            controller: _tab,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              // Available
                              RefreshIndicator(
                                color: ConstColor.gold,
                                backgroundColor: Colors.grey[850],
                                strokeWidth: 3,
                                onRefresh: () => ctx
                                    .read<AppointmentCubit>()
                                    .refreshAvailable(),
                                child: flattened.isEmpty
                                    ? const _EmptyView(
                                        icon: Icons.event_busy,
                                        title: 'No Available Slots',
                                        subtitle:
                                            'Check back later for new appointments',
                                      )
                                    : ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          12,
                                          16,
                                          24,
                                        ),
                                        itemCount: flattened.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 12),
                                        itemBuilder: (context, i) {
                                          final v = flattened[i];
                                          final s = v.slot;
                                          final title =
                                              '${_formatDate(v.date)} • ${s.dayOfWeek}';
                                          final subtitle =
                                              '${_safeSub(s.startTime, 5)} - ${_safeSub(s.endTime, 5)}';
                                          return _SlotCard(
                                            title: title,
                                            subtitle: subtitle,
                                            isBooked: s.isBooked,
                                            onTap: (s.isBooked || _busyBooking)
                                                ? null
                                                : () => _handleBookTap(
                                                    ctx: ctx,
                                                    availabilityId:
                                                        s.availabilityId,
                                                    slotDate: v.date,
                                                    startTime: s.startTime,
                                                    endTime: s.endTime,
                                                  ),
                                          );
                                        },
                                      ),
                              ),

                              // My bookings
                              RefreshIndicator(
                                color: ConstColor.gold,
                                backgroundColor: Colors.grey[850],
                                strokeWidth: 3,
                                onRefresh: () =>
                                    ctx.read<AppointmentCubit>().refreshMine(),
                                child: mine.isEmpty
                                    ? const _EmptyView(
                                        icon: Icons.event_available_outlined,
                                        title: 'No Bookings Yet',
                                        subtitle:
                                            'Your booked appointments will appear here',
                                      )
                                    : ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          12,
                                          16,
                                          24,
                                        ),
                                        itemCount: mine.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 12),
                                        itemBuilder: (context, i) {
                                          final a = mine[i];
                                          final title =
                                              '${_formatDate(a.date)} • ${a.dayOfWeek}';
                                          final subtitle =
                                              '${_safeSub(a.startTime, 5)} - ${_safeSub(a.endTime, 5)}';
                                          return _BookingCard(
                                            title: title,
                                            subtitle: subtitle,
                                            isBusy:
                                                _busyCancelId ==
                                                a.appointmentId,
                                            onCancel: () => _CancelDialog.show(
                                              ctx,
                                              onConfirm: () => _handleCancelTap(
                                                ctx,
                                                a.appointmentId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        }

                        if (state is AppointmentFailure) {
                          return _ErrorView(
                            message: state.message,
                            onRetry: () =>
                                ctx.read<AppointmentCubit>().loadAll(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotView {
  final DateTime? date;
  final AvailabilitySlot slot;
  _SlotView({required this.date, required this.slot});
}

// ======== Enhanced UI Components ========

const _r = 16.0;
const _pad = 16.0;
const _font = 13.0;
const _titleFont = 15.0;
const _icon = 20.0;

BoxDecoration _cardBox({
  Color? border,
  List<Color>? gradient,
  bool elevated = true,
}) => BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: gradient ?? [Colors.grey[850]!, Colors.grey[900]!],
  ),
  borderRadius: BorderRadius.circular(_r),
  border: Border.all(
    color: (border ?? ConstColor.gold).withOpacity(0.4),
    width: 1.2,
  ),
  boxShadow: elevated
      ? [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: (border ?? ConstColor.gold).withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 0),
            spreadRadius: -4,
          ),
        ]
      : null,
);

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    this.icon,
    this.onTap,
    this.danger = false,
    this.enabled = true,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool danger;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = danger
        ? [Colors.red[500]!, Colors.red[700]!]
        : [ConstColor.gold, ConstColor.darkGold];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !enabled,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : .5,
          duration: const Duration(milliseconds: 200),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(_r - 2),
              boxShadow: [
                BoxShadow(
                  color: colors[1].withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(_r - 2),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: _icon - 2,
                          color: danger ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: danger ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: _font + 1,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    this.icon,
    this.onTap,
    this.enabled = true,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !enabled,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : .5,
          duration: const Duration(milliseconds: 200),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[700]!, Colors.grey[800]!],
              ),
              borderRadius: BorderRadius.circular(_r - 2),
              border: Border.all(color: Colors.grey[600]!, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(_r - 2),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: _icon - 2, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: _font + 1,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ListTileCompact extends StatelessWidget {
  const _ListTileCompact({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.borderColor,
    this.gradient,
    this.locked = false,
  });
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? borderColor;
  final List<Color>? gradient;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: _cardBox(
          border: borderColor ?? (locked ? Colors.red : ConstColor.gold),
          gradient: gradient,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_r),
            onTap: locked ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.all(_pad),
              child: Row(
                children: [
                  leading,
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: _titleFont,
                            letterSpacing: 0.3,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: ConstColor.gold.withOpacity(.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 14,
                                color: ConstColor.gold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ConstColor.gold.withOpacity(.9),
                                  fontSize: _font,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.title,
    required this.subtitle,
    required this.isBooked,
    this.onTap,
  });
  final String title;
  final String subtitle;
  final bool isBooked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final leading = Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: isBooked
            ? LinearGradient(colors: [Colors.grey[700]!, Colors.grey[800]!])
            : LinearGradient(
                colors: [
                  ConstColor.gold.withOpacity(.2),
                  ConstColor.gold.withOpacity(.1),
                ],
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBooked ? Colors.grey[500]! : ConstColor.gold.withOpacity(.8),
          width: 1.5,
        ),
        boxShadow: !isBooked
            ? [
                BoxShadow(
                  color: ConstColor.gold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Icon(
        isBooked ? Icons.lock : Icons.schedule,
        color: isBooked ? Colors.grey[300] : ConstColor.gold,
        size: _icon + 2,
      ),
    );

    final trailing = isBooked
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey[700]!.withOpacity(.6),
                  Colors.grey[800]!.withOpacity(.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: Colors.red[300], size: 16),
                const SizedBox(width: 6),
                Text(
                  'Booked',
                  style: TextStyle(
                    color: Colors.red[200],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          )
        : _PrimaryButton(
            label: 'Book Now',
            icon: Icons.add_circle_outline,
            onTap: onTap,
            enabled: onTap != null,
          );

    return _ListTileCompact(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      locked: isBooked,
      borderColor: isBooked ? Colors.red.withOpacity(0.6) : ConstColor.gold,
      gradient: isBooked
          ? [
              Colors.grey[850]!.withOpacity(0.5),
              Colors.grey[900]!.withOpacity(0.8),
            ]
          : [Colors.grey[850]!, Colors.grey[900]!],
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.title,
    required this.subtitle,
    required this.onCancel,
    required this.isBusy,
  });
  final String title;
  final String subtitle;
  final VoidCallback onCancel;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final leading = Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ConstColor.gold.withOpacity(.3),
            ConstColor.gold.withOpacity(.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ConstColor.gold.withOpacity(.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ConstColor.gold.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.event_available,
        color: ConstColor.gold,
        size: _icon + 2,
      ),
    );

    return _ListTileCompact(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: _PrimaryButton(
        label: isBusy ? 'Cancelling…' : 'Cancel',
        icon: isBusy ? Icons.hourglass_empty : Icons.cancel_outlined,
        onTap: isBusy ? null : onCancel,
        danger: true,
        enabled: !isBusy,
      ),
      gradient: [
        ConstColor.gold.withOpacity(.12),
        Colors.grey[850]!.withOpacity(.95),
        Colors.grey[900]!.withOpacity(.95),
      ],
      borderColor: ConstColor.gold,
    );
  }
}

// ======== Additional UI Enhancements ========

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color, this.icon});

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentStats extends StatelessWidget {
  const _AppointmentStats({
    required this.totalBooked,
    required this.totalAvailable,
  });

  final int totalBooked;
  final int totalAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[850]!.withOpacity(0.8),
            Colors.grey[900]!.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ConstColor.gold.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.event_available,
              label: 'Available',
              value: totalAvailable.toString(),
              color: ConstColor.gold,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[700]),
          Expanded(
            child: _StatItem(
              icon: Icons.event_busy,
              label: 'Booked',
              value: totalBooked.toString(),
              color: Colors.blue[400]!,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  const _PulseAnimation({required this.child});

  final Widget child;

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(opacity: _animation.value, child: widget.child);
      },
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[850]!, Colors.grey[800]!, Colors.grey[850]!],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _PulseAnimation(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[700]!.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[850]!, Colors.grey[900]!],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ConstColor.gold.withOpacity(.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: ConstColor.gold.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: CircularProgressIndicator(
            color: ConstColor.gold,
            strokeWidth: 3.5,
            backgroundColor: Colors.grey[700]!.withOpacity(.3),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Loading appointments…',
          style: TextStyle(
            color: ConstColor.gold.withOpacity(.9),
            fontSize: _font + 1,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please wait while we fetch your data',
          style: TextStyle(
            color: Colors.white.withOpacity(.6),
            fontSize: _font - 1,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(32),
    children: [
      const SizedBox(height: 80),
      Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[850]!, Colors.grey[900]!],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ConstColor.gold.withOpacity(.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: ConstColor.gold.withOpacity(.7), size: 56),
        ),
      ),
      const SizedBox(height: 32),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: _titleFont + 4,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(.7),
          fontSize: _font + 1,
          height: 1.4,
          letterSpacing: 0.2,
        ),
      ),
      const SizedBox(height: 32),
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ConstColor.gold.withOpacity(.15),
                ConstColor.gold.withOpacity(.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ConstColor.gold.withOpacity(.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.refresh,
                color: ConstColor.gold.withOpacity(.8),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Pull down to refresh',
                style: TextStyle(
                  color: ConstColor.gold.withOpacity(.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red[800]!.withOpacity(.3),
                  Colors.red[900]!.withOpacity(.5),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.red.withOpacity(.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(Icons.error_outline, color: Colors.red[400], size: 48),
          ),
          const SizedBox(height: 24),
          const Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.white,
              fontSize: _titleFont + 3,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850]!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(.85),
                fontSize: _font + 1,
                height: 1.4,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _PrimaryButton(
            label: 'Try Again',
            icon: Icons.refresh,
            onTap: onRetry,
          ),
        ],
      ),
    ),
  );
}

class _CancelDialog {
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[800]!, Colors.grey[900]!],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.6),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: 4,
              ),
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 32,
                offset: const Offset(0, 0),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[600]!, Colors.red[800]!],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cancel Appointment?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _titleFont + 3,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850]!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Are you sure you want to cancel this appointment? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.85),
                    fontSize: _font + 1,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      label: 'Keep',

                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryButton(
                      label: 'Cancel',

                      danger: true,
                      onTap: () {
                        Navigator.of(ctx).pop();
                        onConfirm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
