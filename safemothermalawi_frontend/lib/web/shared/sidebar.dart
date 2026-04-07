import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

enum UserRole { admin, dho }

// Flat nav items (non-grouped)
class NavItem {
  final String label;
  final IconData icon;
  final String route;
  final List<UserRole> allowedRoles;

  const NavItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.allowedRoles,
  });
}

// Grouped nav items
class NavGroup {
  final String label;
  final IconData icon;
  final List<NavItem> children;
  final List<UserRole> allowedRoles;

  const NavGroup({
    required this.label,
    required this.icon,
    required this.children,
    required this.allowedRoles,
  });
}

// Sidebar entries — either a NavItem or NavGroup
const List<NavItem> _flatItems = [
  NavItem(label: 'Overview', icon: Icons.dashboard_rounded, route: '/overview', allowedRoles: [UserRole.admin, UserRole.dho]),
  NavItem(label: 'Clinician Management', icon: Icons.people_alt_rounded, route: '/clinicians', allowedRoles: [UserRole.admin]),
  NavItem(label: 'Data Source', icon: Icons.storage_rounded, route: '/data-explorer', allowedRoles: [UserRole.admin]),
  NavItem(label: 'Generate Analytics', icon: Icons.auto_graph_rounded, route: '/generate-analytics', allowedRoles: [UserRole.admin]),
  NavItem(label: 'Analytics Dashboard', icon: Icons.bar_chart_rounded, route: '/analytics', allowedRoles: [UserRole.admin, UserRole.dho]),
  NavItem(label: 'Heatmaps', icon: Icons.map_rounded, route: '/heatmaps', allowedRoles: [UserRole.admin, UserRole.dho]),
  NavItem(label: 'Rule Builder', icon: Icons.account_tree_rounded, route: '/rule-builder', allowedRoles: [UserRole.admin]),
  NavItem(label: 'Reports', icon: Icons.summarize_rounded, route: '/reports', allowedRoles: [UserRole.admin, UserRole.dho]),
];

const NavGroup _insightsGroup = NavGroup(
  label: 'Insights',
  icon: Icons.insights_rounded,
  allowedRoles: [UserRole.admin, UserRole.dho],
  children: [
    NavItem(label: 'IVR Insights', icon: Icons.phone_in_talk_rounded, route: '/ivr-insights', allowedRoles: [UserRole.admin, UserRole.dho]),
    NavItem(label: 'Question Insights', icon: Icons.quiz_rounded, route: '/question-insights', allowedRoles: [UserRole.admin, UserRole.dho]),
  ],
);

const NavGroup _activityGroup = NavGroup(
  label: 'Activity Logs',
  icon: Icons.history_rounded,
  allowedRoles: [UserRole.admin],
  children: [
    NavItem(label: 'System Logs', icon: Icons.receipt_long_rounded, route: '/system-logs', allowedRoles: [UserRole.admin]),
    NavItem(label: 'Task Analytics', icon: Icons.task_alt_rounded, route: '/task-analytics', allowedRoles: [UserRole.admin]),
  ],
);

class AppSidebar extends StatefulWidget {
  final UserRole role;
  final String currentRoute;
  final ValueChanged<String> onNavigate;

  const AppSidebar({
    super.key,
    required this.role,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  // Track which groups are expanded
  final Set<String> _expanded = {'Insights', 'Activity Logs'};

  bool _groupContainsActive(NavGroup group) =>
      group.children.any((c) => c.route == widget.currentRoute);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Container(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Safe Mother',
                          style: GoogleFonts.publicSans(
                              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Malawi',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.sidebarMuted, letterSpacing: 1.5)),
              ],
            ),
          ),

          // Role chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.role == UserRole.admin ? 'System Admin' : 'District Health Officer',
                style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.sidebarMuted),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Nav list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Flat items before Insights group
                ..._flatItems
                    .where((i) => i.allowedRoles.contains(widget.role))
                    .where((i) => ['Overview', 'Clinician Management', 'Data Source',
                        'Generate Analytics', 'Analytics Dashboard', 'Heatmaps']
                        .contains(i.label))
                    .map((i) => _NavTile(
                          item: i,
                          isActive: widget.currentRoute == i.route,
                          onTap: () => widget.onNavigate(i.route),
                        )),

                // Insights group
                if (_insightsGroup.allowedRoles.contains(widget.role))
                  _GroupTile(
                    group: _insightsGroup,
                    isExpanded: _expanded.contains('Insights'),
                    isGroupActive: _groupContainsActive(_insightsGroup),
                    currentRoute: widget.currentRoute,
                    onToggle: () => setState(() {
                      if (_expanded.contains('Insights')) {
                        _expanded.remove('Insights');
                      } else {
                        _expanded.add('Insights');
                      }
                    }),
                    onNavigate: widget.onNavigate,
                    role: widget.role,
                  ),

                // Activity Logs group
                if (_activityGroup.allowedRoles.contains(widget.role))
                  _GroupTile(
                    group: _activityGroup,
                    isExpanded: _expanded.contains('Activity Logs'),
                    isGroupActive: _groupContainsActive(_activityGroup),
                    currentRoute: widget.currentRoute,
                    onToggle: () => setState(() {
                      if (_expanded.contains('Activity Logs')) {
                        _expanded.remove('Activity Logs');
                      } else {
                        _expanded.add('Activity Logs');
                      }
                    }),
                    onNavigate: widget.onNavigate,
                    role: widget.role,
                  ),

                // Remaining flat items
                ..._flatItems
                    .where((i) => i.allowedRoles.contains(widget.role))
                    .where((i) => ['Rule Builder', 'Reports'].contains(i.label))
                    .map((i) => _NavTile(
                          item: i,
                          isActive: widget.currentRoute == i.route,
                          onTap: () => widget.onNavigate(i.route),
                        )),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Ministry of Health\nMalawi',
                style: GoogleFonts.inter(
                    fontSize: 10, color: AppColors.sidebarMuted, height: 1.6)),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final NavGroup group;
  final bool isExpanded;
  final bool isGroupActive;
  final String currentRoute;
  final VoidCallback onToggle;
  final ValueChanged<String> onNavigate;
  final UserRole role;

  const _GroupTile({
    required this.group,
    required this.isExpanded,
    required this.isGroupActive,
    required this.currentRoute,
    required this.onToggle,
    required this.onNavigate,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Group header
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isGroupActive && !isExpanded
                      ? AppColors.sidebarActive
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(group.icon,
                        size: 18,
                        color: isGroupActive ? Colors.white : AppColors.sidebarMuted),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(group.label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isGroupActive ? FontWeight.w600 : FontWeight.w500,
                            color: isGroupActive ? Colors.white : AppColors.sidebarText,
                          )),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      size: 16,
                      color: AppColors.sidebarMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Children (animated)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              children: group.children
                  .where((c) => c.allowedRoles.contains(role))
                  .map((c) => _NavTile(
                        item: c,
                        isActive: currentRoute == c.route,
                        onTap: () => onNavigate(c.route),
                        isChild: true,
                      ))
                  .toList(),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  final bool isChild;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
    this.isChild = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
                horizontal: isChild ? 10 : 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.sidebarActive : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (isChild)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : AppColors.sidebarMuted,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  Icon(item.icon,
                      size: 18,
                      color: isActive ? Colors.white : AppColors.sidebarMuted),
                SizedBox(width: isChild ? 0 : 12),
                Expanded(
                  child: Text(item.label,
                      style: GoogleFonts.inter(
                        fontSize: isChild ? 12 : 13,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? Colors.white : AppColors.sidebarText,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
