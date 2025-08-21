// ignore_for_file: deprecated_member_use

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// خدمة الاتصال العامة
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  
  final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();
  
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  void startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final bool connected = !results.contains(ConnectivityResult.none);
        if (connected != _isConnected) {
          _isConnected = connected;
          _connectionStatusController.add(_isConnected);
        }
      },
    );
    
    checkInitialConnectivity();
  }

  Future<void> checkInitialConnectivity() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    final bool connected = !results.contains(ConnectivityResult.none);
    if (connected != _isConnected) {
      _isConnected = connected;
      _connectionStatusController.add(_isConnected);
    }
  }

  Future<bool> checkConnection() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    final bool connected = !results.contains(ConnectivityResult.none);
    _isConnected = connected;
    _connectionStatusController.add(_isConnected);
    return connected;
  }

  void dispose() {
    _connectivitySubscription.cancel();
    _connectionStatusController.close();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // بدء مراقبة الاتصال
  ConnectivityService().startMonitoring();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const ConnectivityWrapper(
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// Global connectivity wrapper that wraps the entire app
class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  
  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper>
    with TickerProviderStateMixin {
  bool isConnected = true;
  bool showConnectionRestored = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );

    // Check initial connectivity
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool connected = !results.contains(ConnectivityResult.none);
    
    if (connected != isConnected) {
      setState(() {
        isConnected = connected;
      });

      if (!connected) {
        // Connection lost - show disconnected alert
        setState(() {
          showConnectionRestored = false;
        });
        _scaleController.forward();
        _fadeController.forward();
        _pulseController.repeat(reverse: true);
      } else {
        // Connection restored - show connected alert briefly then hide
        _pulseController.stop();
        _pulseController.reset();
        
        setState(() {
          showConnectionRestored = true;
        });
        
        // Hide the alert after 3 seconds
        Timer(const Duration(seconds: 3), () {
          _scaleController.reverse();
          _fadeController.reverse().then((_) {
            // After animation completes, hide the overlay completely
            if (mounted) {
              setState(() {
                showConnectionRestored = false;
              });
            }
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _scaleController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          widget.child,
          
          // Global connectivity alert - Centered and above all components
          if (!isConnected || showConnectionRestored)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: showConnectionRestored 
                            ? _buildConnectionRestoredAlert()
                            : _buildNoConnectionAlert(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoConnectionAlert() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.wifi_off,
              color: Colors.red,
              size: 50,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionRestoredAlert() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.wifi,
            color: Colors.green,
            size: 50,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Connection Restored!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'You are back online',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: Colors.green.shade400,
              ),
              const SizedBox(width: 8),
              const Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  bool isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late AnimationController _bounceController;
  late AnimationController _rotationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Listen to connectivity changes for local UI updates
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        setState(() {
          isConnected = !results.contains(ConnectivityResult.none);
        });
      },
    );

    // Check initial connectivity
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = !results.contains(ConnectivityResult.none);
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    
    // Trigger bounce animation
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
  }

  Future<void> _checkConnection() async {
    _rotationController.forward();
    
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = !results.contains(ConnectivityResult.none);
    });
    
    await Future.delayed(const Duration(milliseconds: 1000));
    _rotationController.reverse();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _bounceController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isConnected 
                  ? [Colors.blue.shade400, Colors.blue.shade600]
                  : [Colors.grey.shade400, Colors.grey.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isConnected 
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isConnected ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  color: isConnected ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  isConnected ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isConnected
                ? [Colors.blue.shade50, Colors.white]
                : [Colors.grey.shade100, Colors.grey.shade50],
          ),
        ),
        child: isConnected ? _buildConnectedUI() : _buildDisconnectedUI(),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildConnectedUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.touch_app,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                const Text(
                  'You have pushed the button this many times:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '$_counter',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.wifi_off,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please check your internet connection and try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: ElevatedButton.icon(
                    onPressed: _checkConnection,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Check Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get floatingActionButton {
    if (!isConnected) return const SizedBox.shrink();
    
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      backgroundColor: Colors.blue.shade600,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}