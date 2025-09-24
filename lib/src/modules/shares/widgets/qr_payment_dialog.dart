import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import '../../../core/theme/ceas_colors.dart';
import '../models/qr_payment_response.dart';
import '../services/qr_payment_service.dart';

class QrPaymentDialog extends StatefulWidget {
  final QrPaymentResponse qrResponse;

  const QrPaymentDialog({
    super.key,
    required this.qrResponse,
  });

  @override
  State<QrPaymentDialog> createState() => _QrPaymentDialogState();
}

class _QrPaymentDialogState extends State<QrPaymentDialog> {
  bool _isVerificando = false;

  @override
  Widget build(BuildContext context) {
    final qrData = widget.qrResponse.qrData.qrDataInner;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con gradiente
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CeasColors.primaryBlue,
                    CeasColors.primaryBlue.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.qr_code_2,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago QR Generado',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Escanea o transfiere con los datos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // QR Code con diseño mejorado
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          data: _generateQrData(),
                          version: QrVersions.auto,
                          size: 180.0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: CeasColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CeasColors.primaryBlue.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Referencia: ${qrData.referencia}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: CeasColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Información del pago con diseño moderno
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade50,
                          Colors.indigo.shade50,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.account_balance,
                                color: Colors.blue.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Datos de Transferencia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildModernInfoRow('🏦 Banco', qrData.banco),
                        _buildModernInfoRow('💳 Cuenta', qrData.cuenta),
                        _buildModernInfoRow('👤 Titular', qrData.titular),
                        _buildModernInfoRow(
                          '💰 Monto',
                          'Bs. ${qrData.monto.toStringAsFixed(2)}',
                          isAmount: true,
                        ),
                        _buildModernInfoRow('📅 Vence', qrData.fechaLimite),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón de verificar con diseño mejorado
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.shade600,
                          Colors.green.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isVerificando ? null : _verificarPago,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: _isVerificando
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.verified_user_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                      label: Text(
                        _isVerificando ? 'Verificando...' : 'Verificar Pago',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildModernInfoRow(String label, String value, {bool isAmount = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: isAmount ? Colors.green.shade700 : Colors.black87,
                fontWeight: isAmount ? FontWeight.bold : FontWeight.w500,
                fontSize: isAmount ? 16 : 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _generateQrData() {
    final qrData = widget.qrResponse.qrData.qrDataInner;
    return json.encode({
      'banco': qrData.banco,
      'cuenta': qrData.cuenta,
      'titular': qrData.titular,
      'monto': qrData.monto,
      'concepto': qrData.concepto,
      'referencia': qrData.referencia,
      'fecha_limite': qrData.fechaLimite,
    });
  }

  Future<void> _verificarPago() async {
    setState(() {
      _isVerificando = true;
    });

    try {
      final resultado = await QrPaymentService.verificarPago(
        widget.qrResponse.referenciaTemporal,
      );

      if (mounted) {
        setState(() {
          _isVerificando = false;
        });

        // Mostrar resultado
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  resultado['estado'] == 'confirmado' ? Icons.check_circle : Icons.schedule,
                  color: resultado['estado'] == 'confirmado' ? Colors.green : Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  resultado['estado'] == 'confirmado' ? 'Pago Confirmado' : 'Pago Pendiente',
                  style: TextStyle(
                    color: resultado['estado'] == 'confirmado' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(resultado['mensaje'] ?? 'Estado del pago verificado'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar diálogo de resultado
                  Navigator.of(context).pop(); // Cerrar diálogo de QR
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: resultado['estado'] == 'confirmado' ? Colors.green : Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerificando = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error verificando pago: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
