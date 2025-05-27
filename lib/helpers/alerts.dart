// alert_manager.dart
import 'package:flutter/material.dart';

// Enumeración para tipos de alerta
enum AlertType { success, error, warning, info }

// Modelo para la configuración de una alerta
class AlertConfig {
  final String title;
  final String message;
  final AlertType type;
  final Duration duration;
  final bool isDismissible;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final Widget? customIcon;
  final List<AlertAction>? actions;

  const AlertConfig({
    required this.title,
    required this.message,
    this.type = AlertType.info,
    this.duration = const Duration(seconds: 4),
    this.isDismissible = true,
    this.onTap,
    this.onDismiss,
    this.customIcon,
    this.actions,
  });
}

// Modelo para acciones de alerta
class AlertAction {
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  const AlertAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });
}

// Singleton para manejar alertas globalmente
class AlertManager {
  static final AlertManager _instance = AlertManager._internal();
  factory AlertManager() => _instance;
  AlertManager._internal();

  static AlertManager get instance => _instance;

  // Contextos y overlays
  BuildContext? _context;
  OverlayEntry? _currentOverlay;

  // Cola de alertas pendientes
  final List<AlertConfig> _alertQueue = [];
  bool _isShowingAlert = false;

  // Inicializar el contexto global
  void initialize(BuildContext context) {
    _context = context;
  }

  // Mostrar alerta de éxito
  void showSuccess({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    _showAlert(
      AlertConfig(
        title: title,
        message: message,
        type: AlertType.success,
        duration: duration ?? const Duration(seconds: 3),
        onTap: onTap,
      ),
    );
  }

  // Mostrar alerta de error
  void showError({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    _showAlert(
      AlertConfig(
        title: title,
        message: message,
        type: AlertType.error,
        duration: duration ?? const Duration(seconds: 5),
        onTap: onTap,
      ),
    );
  }

  // Mostrar alerta de advertencia
  void showWarning({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    _showAlert(
      AlertConfig(
        title: title,
        message: message,
        type: AlertType.warning,
        duration: duration ?? const Duration(seconds: 4),
        onTap: onTap,
      ),
    );
  }

  // Mostrar alerta de información
  void showInfo({
    required String title,
    required String message,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    _showAlert(
      AlertConfig(
        title: title,
        message: message,
        type: AlertType.info,
        duration: duration ?? const Duration(seconds: 4),
        onTap: onTap,
      ),
    );
  }

  // Mostrar alerta personalizada
  void showCustomAlert(AlertConfig config) {
    _showAlert(config);
  }

  // Mostrar diálogo de confirmación
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDestructive = false,
  }) async {
    if (_context == null) return false;

    return await showDialog<bool>(
          context: _context!,
          builder:
              (context) => AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelText),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style:
                        isDestructive
                            ? TextButton.styleFrom(foregroundColor: Colors.red)
                            : null,
                    child: Text(confirmText),
                  ),
                ],
              ),
        ) ??
        false;
  }

  // Método interno para mostrar alertas
  void _showAlert(AlertConfig config) {
    if (_context == null) return;

    _alertQueue.add(config);
    _processAlertQueue();
  }

  // Procesar cola de alertas
  void _processAlertQueue() {
    if (_isShowingAlert || _alertQueue.isEmpty) return;

    final config = _alertQueue.removeAt(0);
    _displayAlert(config);
  }

  // Mostrar la alerta en pantalla
  void _displayAlert(AlertConfig config) {
    if (_context == null) return;

    _isShowingAlert = true;

    _currentOverlay = OverlayEntry(
      builder:
          (context) => AlertWidget(
            config: config,
            onDismiss: () => _dismissCurrentAlert(),
          ),
    );

    Overlay.of(_context!).insert(_currentOverlay!);

    // Auto-dismiss después del tiempo especificado
    if (config.duration != Duration.zero) {
      Future.delayed(config.duration, () {
        if (_currentOverlay != null) {
          _dismissCurrentAlert();
        }
      });
    }
  }

  // Descartar alerta actual
  void _dismissCurrentAlert() {
    if (_currentOverlay != null) {
      _currentOverlay!.remove();
      _currentOverlay = null;
      _isShowingAlert = false;

      // Procesar siguiente alerta en la cola
      Future.delayed(const Duration(milliseconds: 300), () {
        _processAlertQueue();
      });
    }
  }

  // Limpiar todas las alertas
  void clearAll() {
    _alertQueue.clear();
    _dismissCurrentAlert();
  }
}

// Widget personalizado para mostrar las alertas
class AlertWidget extends StatefulWidget {
  final AlertConfig config;
  final VoidCallback onDismiss;

  const AlertWidget({super.key, required this.config, required this.onDismiss});

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _getBackgroundColor(),
                border: Border.all(color: _getBorderColor(), width: 1),
              ),
              child: InkWell(
                onTap: widget.config.onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildIcon(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.config.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _getTextColor(),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.config.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: _getTextColor().withOpacity(0.8),
                              ),
                            ),
                            if (widget.config.actions != null) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:
                                    widget.config.actions!
                                        .map(
                                          (action) => Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: TextButton(
                                              onPressed: action.onPressed,
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    action.isDestructive
                                                        ? Colors.red
                                                        : _getAccentColor(),
                                              ),
                                              child: Text(action.label),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.config.isDismissible)
                        IconButton(
                          onPressed: widget.onDismiss,
                          icon: Icon(
                            Icons.close,
                            color: _getTextColor().withOpacity(0.6),
                            size: 20,
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

  Widget _buildIcon() {
    if (widget.config.customIcon != null) {
      return widget.config.customIcon!;
    }

    IconData iconData;
    Color iconColor;

    switch (widget.config.type) {
      case AlertType.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case AlertType.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      case AlertType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
      case AlertType.info:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
    }

    return Icon(iconData, color: iconColor, size: 24);
  }

  Color _getBackgroundColor() {
    switch (widget.config.type) {
      case AlertType.success:
        return Colors.green.shade50;
      case AlertType.error:
        return Colors.red.shade50;
      case AlertType.warning:
        return Colors.orange.shade50;
      case AlertType.info:
        return Colors.blue.shade50;
    }
  }

  Color _getBorderColor() {
    switch (widget.config.type) {
      case AlertType.success:
        return Colors.green.shade200;
      case AlertType.error:
        return Colors.red.shade200;
      case AlertType.warning:
        return Colors.orange.shade200;
      case AlertType.info:
        return Colors.blue.shade200;
    }
  }

  Color _getTextColor() {
    switch (widget.config.type) {
      case AlertType.success:
        return Colors.green.shade800;
      case AlertType.error:
        return Colors.red.shade800;
      case AlertType.warning:
        return Colors.orange.shade800;
      case AlertType.info:
        return Colors.blue.shade800;
    }
  }

  Color _getAccentColor() {
    switch (widget.config.type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
    }
  }
}
