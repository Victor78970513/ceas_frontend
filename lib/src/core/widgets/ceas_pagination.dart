import 'package:flutter/material.dart';
import '../../core/theme/ceas_colors.dart';

class CeasPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final int currentItemsCount;
  final bool hasMorePages;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final Function(int)? onPageChanged;
  final Function(int)? onItemsPerPageChanged;
  final List<int> itemsPerPageOptions;

  const CeasPagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.currentItemsCount,
    required this.hasMorePages,
    this.onPreviousPage,
    this.onNextPage,
    this.onPageChanged,
    this.onItemsPerPageChanged,
    this.itemsPerPageOptions = const [10, 20, 50, 100],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información de la página
          _buildPageInfo(),

          // Controles de navegación
          _buildNavigationControls(),

          // Selector de elementos por página
          _buildItemsPerPageSelector(),
        ],
      ),
    );
  }

  Widget _buildPageInfo() {
    return Text(
      'Mostrando $currentItemsCount de $totalItems elementos',
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Row(
      children: [
        // Botón anterior
        IconButton(
          onPressed: currentPage > 1 ? onPreviousPage : null,
          icon: const Icon(Icons.chevron_left),
          color:
              currentPage > 1 ? CeasColors.primaryBlue : Colors.grey.shade400,
          tooltip: 'Página anterior',
        ),

        // Número de página actual
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: CeasColors.primaryBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$currentPage',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Separador
        Text(
          ' de $totalPages',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        // Botón siguiente
        IconButton(
          onPressed: hasMorePages ? onNextPage : null,
          icon: const Icon(Icons.chevron_right),
          color: hasMorePages ? CeasColors.primaryBlue : Colors.grey.shade400,
          tooltip: 'Página siguiente',
        ),
      ],
    );
  }

  Widget _buildItemsPerPageSelector() {
    return Row(
      children: [
        Text(
          'Mostrar: ',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: itemsPerPage,
          onChanged: (int? newValue) {
            if (newValue != null && onItemsPerPageChanged != null) {
              onItemsPerPageChanged!(newValue);
            }
          },
          items: itemsPerPageOptions.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value'),
            );
          }).toList(),
          underline: Container(),
          style: TextStyle(
            color: CeasColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Mixin para agregar funcionalidad de paginación a cualquier provider
mixin PaginationMixin<T> {
  int _currentPage = 1;
  int _itemsPerPage = 20;
  int _totalItems = 0;
  bool _hasMorePages = true;

  // Getters de paginación
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  bool get hasMorePages => _hasMorePages;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();

  // Métodos de paginación
  void nextPage() {
    if (_hasMorePages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  void setItemsPerPage(int itemsPerPage) {
    _itemsPerPage = itemsPerPage;
    _currentPage = 1; // Reset a la primera página
    _hasMorePages = _totalItems > _itemsPerPage;
    notifyListeners();
  }

  void resetPagination() {
    _currentPage = 1;
    _hasMorePages = _totalItems > _itemsPerPage;
    notifyListeners();
  }

  void updateTotalItems(int total) {
    _totalItems = total;
    _hasMorePages = _totalItems > _itemsPerPage;
    notifyListeners();
  }

  // Método abstracto que debe implementar el provider
  void notifyListeners();
}



