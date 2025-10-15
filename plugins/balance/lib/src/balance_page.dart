import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:microkernel_core/microkernel_core.dart';
import 'package:core_models/core_models.dart';

import 'balance_service.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  bool _loading = true;
  BalanceResponse? _balanceData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final balanceService = ServiceLocator().get<BalanceService>();
      final balance = await balanceService.getBalance();

      setState(() {
        _balanceData = balance;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    final authService = ServiceLocator().get<IAuthService>();
    await authService.logout();

    // Emitir evento de logout
    EventBus().emit(LogoutEvent());

    if (!mounted) return;
    context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $_error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBalance,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : _balanceData != null
          ? _buildBalanceContent()
          : const Center(child: Text('No hay datos')),
    );
  }

  Widget _buildBalanceContent() {
    final balance = _balanceData!;

    return RefreshIndicator(
      onRefresh: _loadBalance,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card de balance principal
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuenta',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    balance.accountNumber,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Balance disponible',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${balance.currency} ${balance.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Título de transacciones
          Text(
            'Últimas 5 Transacciones',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          // Lista de transacciones
          ...balance.last5Transactions.map((transaction) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    transaction.recipientName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(transaction.recipientName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.destinationBank),
                    Text(
                      'ID: ${transaction.id}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                trailing: Text(
                  '${balance.currency} ${transaction.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
