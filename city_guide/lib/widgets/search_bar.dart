import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool showClearButton;
  final bool autofocus;
  final List<Widget>? actions;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search attractions...',
    this.onChanged,
    this.onSearch,
    this.onClear,
    this.controller,
    this.showClearButton = true,
    this.autofocus = false,
    this.actions,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.inputDecoration,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              onSubmitted: (_) => widget.onSearch?.call(),
              autofocus: widget.autofocus,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
              ),
            ),
          ),
          if (widget.showClearButton && _hasText)
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                _controller.clear();
                widget.onClear?.call();
              },
            ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppColors.primary)
              : (unselectedColor ?? AppColors.surface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppColors.primary)
                : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body3.copyWith(
            color: isSelected ? AppColors.surface : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final String title;
  final bool showTitle;

  const FilterSection({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.title = 'Filter by',
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            title,
            style: AppTextStyles.headline4,
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < filters.length - 1 ? 8 : 0,
                ),
                child: FilterChipWidget(
                  label: filter,
                  isSelected: selectedFilter == filter,
                  onTap: () => onFilterChanged(filter),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SearchAndFilterWidget extends StatefulWidget {
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback? onSearch;
  final TextEditingController? searchController;

  const SearchAndFilterWidget({
    super.key,
    this.searchHint = 'Search attractions...',
    this.onSearchChanged,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.onSearch,
    this.searchController,
  });

  @override
  State<SearchAndFilterWidget> createState() => _SearchAndFilterWidgetState();
}

class _SearchAndFilterWidgetState extends State<SearchAndFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        SearchBarWidget(
          hintText: widget.searchHint,
          onChanged: widget.onSearchChanged,
          onSearch: widget.onSearch,
          controller: widget.searchController,
        ),
        const SizedBox(height: 16),
        
        // Filter Section
        FilterSection(
          filters: widget.filters,
          selectedFilter: widget.selectedFilter,
          onFilterChanged: widget.onFilterChanged,
          showTitle: false,
        ),
      ],
    );
  }
}
