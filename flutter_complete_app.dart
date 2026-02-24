// lib/main.dart - Complete Flutter App Setup
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🧪 Test API Connection First
  print('🚀 Starting Shwe Flash Flutter App...');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider()..loadUser(),
      child: MaterialApp(
        title: 'Shwe Flash',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Show loading screen while checking auth
            if (authProvider.isLoading && authProvider.user == null) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading...'),
                    ],
                  ),
                ),
              );
            }
            
            // Show login if not authenticated
            if (!authProvider.isAuthenticated) {
              return LoginScreen();
            }
            
            // Show home if authenticated
            return HomeScreen();
          },
        ),
      ),
    );
  }
}

// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
        backgroundColor: Colors.blue[800],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Title
                  Icon(
                    Icons.flash_on,
                    size: 80,
                    color: Colors.blue[800],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Shwe Flash',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 40),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  
                  // Additional fields for registration
                  if (!_isLogin) ...[
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                  ],
                  
                  SizedBox(height: 24),
                  
                  // Error Message
                  if (authProvider.errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.errorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  SizedBox(height: 16),
                  
                  // Login/Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          if (_isLogin) {
                            await authProvider.login(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          } else {
                            // For registration, you'd need to add first/last name controllers
                            await authProvider.register(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              firstName: 'User', // Get from form
                              lastName: 'Name',   // Get from form
                            );
                          }
                        }
                      },
                      child: authProvider.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(_isLogin ? 'Login' : 'Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Toggle Login/Register
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        authProvider._clearError();
                      });
                    },
                    child: Text(
                      _isLogin ? 'Don\'t have an account? Register' : 'Already have an account? Login',
                    ),
                  ),
                  
                  // Test Connection Button
                  SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () async {
                      await authProvider.testConnection();
                    },
                    child: Text('Test API Connection'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Shwe Flash'),
            backgroundColor: Colors.blue[800],
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await authProvider.logout();
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                Text(
                  'Welcome, ${authProvider.user?['firstName'] ?? 'User'}!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: ${authProvider.user?['email'] ?? ''}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                
                // Premium Status
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: authProvider.user?['isPaid'] == true 
                        ? Colors.green[50] 
                        : Colors.orange[50],
                    border: Border.all(
                      color: authProvider.user?['isPaid'] == true 
                          ? Colors.green 
                          : Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        authProvider.user?['isPaid'] == true 
                            ? Icons.verified 
                            : Icons.lock,
                        color: authProvider.user?['isPaid'] == true 
                            ? Colors.green 
                            : Colors.orange,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.user?['isPaid'] == true 
                                  ? 'Premium Member' 
                                  : 'Free Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: authProvider.user?['isPaid'] == true 
                                    ? Colors.green 
                                    : Colors.orange,
                              ),
                            ),
                            Text(
                              authProvider.user?['isPaid'] == true 
                                  ? 'Access to all HSK levels' 
                                  : 'Upgrade to Premium for full access',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Quick Actions
                SizedBox(height: 30),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                
                // Action Buttons
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildActionCard(
                        context,
                        'HSK Vocabulary',
                        Icons.book,
                        Colors.blue,
                        () {
                          // Navigate to vocabulary
                        },
                      ),
                      _buildActionCard(
                        context,
                        'Practice',
                        Icons.quiz,
                        Colors.green,
                        () {
                          // Navigate to practice
                        },
                      ),
                      _buildActionCard(
                        context,
                        'Progress',
                        Icons.trending_up,
                        Colors.orange,
                        () {
                          // Navigate to progress
                        },
                      ),
                      _buildActionCard(
                        context,
                        'Settings',
                        Icons.settings,
                        Colors.grey,
                        () {
                          // Navigate to settings
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
