import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/data.dart';
import '../../../widget/widgets.dart';

class TgPayWebViewPage extends StatefulWidget {
  final String token;

  const TgPayWebViewPage({
    super.key,
    required this.token,
  });

  @override
  State<TgPayWebViewPage> createState() => _TgPayWebViewPageState();
}

class _TgPayWebViewPageState extends State<TgPayWebViewPage> {
  WebViewController? _controller;
  bool isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    final url = Uri.parse('https://dev.transgo.id/transgo-pay?token=${widget.token}');
    
    // Create controller first
    final controller = WebViewController();
    
    // Set up navigation delegate using the controller
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    
    // Add JavaScript channel for early communication
    controller.addJavaScriptChannel(
      'TransgoAuth',
      onMessageReceived: (JavaScriptMessage message) {
        print('Message from WebView: ${message.message}');
      },
    );
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          if (mounted) {
            setState(() {
              isLoading = true;
            });
            // Inject script IMMEDIATELY when page starts loading
            // This ensures interceptors are set up before Next.js makes API calls
            Future.delayed(const Duration(milliseconds: 50), () {
              if (mounted && _controller != null) {
                _injectAuthScript(_controller!);
              }
            });
          }
        },
        onProgress: (int progress) {
          // Inject at 25%, 50%, 75% progress to catch early API calls
          if (progress == 25 || progress == 50 || progress == 75) {
            if (mounted && _controller != null) {
              _injectAuthScript(_controller!);
            }
          }
        },
        onPageFinished: (String url) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            // Inject multiple times after page finishes to ensure it runs
            if (_controller != null) {
              _injectAuthScript(_controller!);
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted && _controller != null) {
                  _injectAuthScript(_controller!);
                }
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted && _controller != null) {
                  _injectAuthScript(_controller!);
                }
              });
            }
          }
        },
        onWebResourceError: (WebResourceError error) {
          print('WebView error: ${error.description}');
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
      ),
    );
    
    // Set controller in state before loading
    if (mounted) {
      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    }
    
    // Load the URL
    controller.loadRequest(url);
  }

  void _injectAuthScript(WebViewController controller) {
    // Enhanced script with URL fix interceptor and token storage
    // This script must run BEFORE Next.js makes any API calls
    final script = '''
      (function() {
        // Prevent multiple injections
        if (window.__transgoAuthInjected) {
          return;
        }
        window.__transgoAuthInjected = true;
        
        try {
          const token = '${widget.token}';
          console.log('[Transgo] Setting auth token in storage');
          
          // Store token in localStorage for the website to access
          localStorage.setItem('transgo_auth_token', token);
          localStorage.setItem('accessToken', token);
          localStorage.setItem('auth_token', token);
          localStorage.setItem('token', token);
          
          // Also store in sessionStorage
          sessionStorage.setItem('accessToken', token);
          sessionStorage.setItem('auth_token', token);
          
          // Set token in window object for website to access
          window.transgoToken = token;
          window.transgoAuthToken = token;
          
          // Fix Next.js environment variables if they exist
          if (window.process && window.process.env) {
            const env = window.process.env;
            if (env.NEXT_PUBLIC_API_HOST) {
              // Fix if it has duplicated /api/v1
              env.NEXT_PUBLIC_API_HOST = env.NEXT_PUBLIC_API_HOST.replace(/\\/api\\/v1\\/api\\/v1/g, '/api/v1');
            }
          }
          
          // Override Next.js getServerSideProps or API route calls if possible
          // Intercept Next.js router if it exists
          if (window.next && window.next.router) {
            const originalPush = window.next.router.push;
            window.next.router.push = function(url, as, options) {
              if (typeof url === 'string' && url.includes('/api/v1/api/v1/')) {
                url = url.replace('/api/v1/api/v1/', '/api/v1/');
              }
              return originalPush.call(this, url, as, options);
            };
          }
          
          // CRITICAL: Intercept fetch BEFORE Next.js initializes
          // This must be done immediately to catch all API calls
          const originalFetch = window.fetch;
          window.fetch = function(...args) {
            let url = args[0];
            
            // Fix duplicated /api/v1/api/v1 paths - multiple patterns
            if (typeof url === 'string') {
              // Pattern 1: /api/v1/api/v1/auth (with trailing slash)
              url = url.replace(/\\/api\\/v1\\/api\\/v1\\//g, '/api/v1/');
              // Pattern 2: /api/v1/api/v1/auth (without trailing slash - end of string)
              url = url.replace(/\\/api\\/v1\\/api\\/v1([^\\/])/g, '/api/v1\$' + '1');
              // Pattern 3: Full URL with duplication
              url = url.replace(/(https?:\\/\\/[^\\/]+)\\/api\\/v1\\/api\\/v1/g, '\$' + '1/api/v1');
              
              if (url !== args[0]) {
                console.log('[Transgo] Fixed duplicated API path:', args[0], '->', url);
                args[0] = url;
              }
            } else if (url && typeof url === 'object' && url.url) {
              // Handle Request object
              if (url.url.includes('/api/v1/api/v1/')) {
                url.url = url.url.replace(/\\/api\\/v1\\/api\\/v1\\//g, '/api/v1/');
                url.url = url.url.replace(/\\/api\\/v1\\/api\\/v1([^\\/])/g, '/api/v1\$' + '1');
                console.log('[Transgo] Fixed duplicated API path in Request:', url.url);
              }
            }
            
            // Ensure Authorization header is set for API calls
            if (args[1] && typeof args[1] === 'object') {
              args[1].headers = args[1].headers || {};
              if (typeof args[1].headers === 'object' && !args[1].headers['Authorization']) {
                args[1].headers['Authorization'] = 'Bearer ' + token;
              }
            } else if (args.length === 1 || !args[1]) {
              args[1] = {
                headers: {
                  'Authorization': 'Bearer ' + token
                }
              };
            }
            
            return originalFetch.apply(this, args);
          };
          
          // Also intercept XMLHttpRequest (for older code or libraries)
          const originalXHROpen = XMLHttpRequest.prototype.open;
          XMLHttpRequest.prototype.open = function(method, url, ...rest) {
            // Fix duplicated /api/v1/api/v1 paths - multiple patterns
            if (typeof url === 'string') {
              const originalUrl = url;
              // Pattern 1: /api/v1/api/v1/auth (with trailing slash)
              url = url.replace(/\\/api\\/v1\\/api\\/v1\\//g, '/api/v1/');
              // Pattern 2: /api/v1/api/v1/auth (without trailing slash)
              url = url.replace(/\\/api\\/v1\\/api\\/v1([^\\/])/g, '/api/v1\$' + '1');
              // Pattern 3: Full URL with duplication
              url = url.replace(/(https?:\\/\\/[^\\/]+)\\/api\\/v1\\/api\\/v1/g, '\$' + '1/api/v1');
              
              if (url !== originalUrl) {
                console.log('[Transgo] Fixed duplicated API path in XHR:', originalUrl, '->', url);
              }
            }
            return originalXHROpen.apply(this, [method, url, ...rest]);
          };
          
          // Intercept axios if it's being used
          if (window.axios) {
            const axios = window.axios;
            const originalAxiosRequest = axios.request || axios;
            if (typeof originalAxiosRequest === 'function') {
              axios.request = function(config) {
                if (config && config.url) {
                  config.url = config.url.replace(/\\/api\\/v1\\/api\\/v1\\//g, '/api/v1/');
                  config.url = config.url.replace(/\\/api\\/v1\\/api\\/v1([^\\/])/g, '/api/v1\$' + '1');
                }
                if (config && !config.headers) {
                  config.headers = {};
                }
                if (config && config.headers && !config.headers['Authorization']) {
                  config.headers['Authorization'] = 'Bearer ' + token;
                }
                return originalAxiosRequest.call(this, config);
              };
            }
          }
          
          const originalXHRSend = XMLHttpRequest.prototype.send;
          XMLHttpRequest.prototype.send = function(...args) {
            // Add Authorization header if not present
            try {
              if (!this.getRequestHeader('Authorization')) {
                this.setRequestHeader('Authorization', 'Bearer ' + token);
              }
            } catch (e) {
              // Header might already be set, ignore error
            }
            return originalXHRSend.apply(this, args);
          };
          
          // Override Next.js API route calls if they use a different pattern
          // Some Next.js apps use relative paths that get prefixed
          const originalPushState = history.pushState;
          const originalReplaceState = history.replaceState;
          
          // Dispatch event that website can listen to
          window.dispatchEvent(new CustomEvent('transgoAuth', { 
            detail: { token: token } 
          }));
          
          console.log('[Transgo] Auth token set successfully and interceptors installed');
        } catch (e) {
          console.log('[Transgo] Auth script error:', e);
        }
      })();
    ''';
    
    controller.runJavaScript(script).catchError((error) {
      print('JavaScript injection error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: gabaritoText(
          text: 'Transgo Pay Top Up',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          textColor: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              if (_controller != null) {
                _controller!.reload();
              }
            },
          ),
        ],
      ),
      body: _isInitialized && _controller != null
          ? Stack(
              children: [
                WebViewWidget(controller: _controller!),
                if (isLoading)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
