import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'dashboard/dashboard_screen.dart';
import 'pantry/pantry_screen.dart';
import 'planner/planner_screen.dart';
import 'recipes/recipes_screen.dart';
import 'shopping/shopping_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const int _homeIndex = 2;

  late final PageController _pageController;
  int _selectedIndex = _homeIndex;

  static const List<Widget> _screens = [
    RecipesScreen(),
    PantryScreen(),
    DashboardScreen(),
    PlannerScreen(),
    ShoppingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _homeIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppState>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _selectedIndex = index);
                },
                children: _screens,
              ),
      ),
      bottomNavigationBar: _PlanEatBottomNav(
        selectedIndex: _selectedIndex,
        onSelected: _animateToPage,
      ),
    );
  }

  void _animateToPage(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }
}

class _PlanEatBottomNav extends StatelessWidget {
  const _PlanEatBottomNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<_NavItemData> _items = [
    _NavItemData(
      index: 0,
      label: 'Ricette',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
    ),
    _NavItemData(
      index: 1,
      label: 'Dispensa',
      icon: Icons.kitchen_outlined,
      selectedIcon: Icons.kitchen,
    ),
    _NavItemData(
      index: 3,
      label: 'Planner',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
    ),
    _NavItemData(
      index: 4,
      label: 'Spesa',
      icon: Icons.shopping_basket_outlined,
      selectedIcon: Icons.shopping_basket,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 104,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              child: Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _BottomNavItem(
                      data: _items[0],
                      isSelected: selectedIndex == _items[0].index,
                      onSelected: onSelected,
                    ),
                    _BottomNavItem(
                      data: _items[1],
                      isSelected: selectedIndex == _items[1].index,
                      onSelected: onSelected,
                    ),
                    const SizedBox(width: 82),
                    _BottomNavItem(
                      data: _items[2],
                      isSelected: selectedIndex == _items[2].index,
                      onSelected: onSelected,
                    ),
                    _BottomNavItem(
                      data: _items[3],
                      isSelected: selectedIndex == _items[3].index,
                      onSelected: onSelected,
                    ),
                  ],
                ),
              ),
            ),
            _HomeNavButton(
              isSelected: selectedIndex == _MainShellState._homeIndex,
              onPressed: () => onSelected(_MainShellState._homeIndex),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.data,
    required this.isSelected,
    required this.onSelected,
  });

  final _NavItemData data;
  final bool isSelected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: Tooltip(
        message: data.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onSelected(data.index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.secondary.withValues(alpha: 0.16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  scale: isSelected ? 1.08 : 1,
                  child: Icon(
                    isSelected ? data.selectedIcon : data.icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    data.label,
                    maxLines: 1,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeNavButton extends StatelessWidget {
  const _HomeNavButton({required this.isSelected, required this.onPressed});

  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: 'Home',
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.06 : 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isSelected
                        ? [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ]
                        : [
                            theme.colorScheme.surface,
                            theme.colorScheme.surfaceContainerHighest,
                          ],
                  ),
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.28),
                      blurRadius: isSelected ? 24 : 16,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(
                  isSelected ? Icons.home_rounded : Icons.home_outlined,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Home',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
