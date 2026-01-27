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

class _TgPayWebViewPageState extends State<TgPayWebViewPage> with AutomaticKeepAliveClientMixin {
  WebViewController? _controller;
  bool isLoading = true;
  bool _isInitialized = false;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    // Validate token before proceeding
    if (widget.token.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }
    
    // Properly encode the token in the URL to handle special characters
    final url = Uri.https(
      'dev.transgo.id',
      '/transgo-pay',
      {'token': widget.token},
    );
    
    // Create controller with performance optimizations
    final controller = WebViewController();
    
    // Set up navigation delegate using the controller
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    
    // Set background color to prevent white flash during loading
    controller.setBackgroundColor(Colors.white);
    
    // Add JavaScript channel for early communication
    controller.addJavaScriptChannel(
      'TransgoAuth',
      onMessageReceived: (JavaScriptMessage message) {
        // Channel available for future use
      },
    );
    
    // Add JavaScript channel for console logging from webview
    controller.addJavaScriptChannel(
      'ConsoleLog',
      onMessageReceived: (JavaScriptMessage message) {
        // Log console messages from webview to Flutter console
        print('[WebView Console] ${message.message}');
      },
    );
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          // Inject early console capture script immediately
          if (_controller != null) {
            _controller!.runJavaScript('''
              (function() {
                if (window.ConsoleLog && !window.__consoleCaptured) {
                  window.__consoleCaptured = true;
                  const originalConsoleError = console.error;
                  const originalConsoleLog = console.log;
                  const originalConsoleWarn = console.warn;
                  
                  const sendToFlutter = function(level, args) {
                    try {
                      const message = args.map(function(arg) {
                        if (typeof arg === 'object') {
                          try {
                            return JSON.stringify(arg, null, 2);
                          } catch (e) {
                            return String(arg);
                          }
                        }
                        return String(arg);
                      }).join(' ');
                      window.ConsoleLog.postMessage('[' + level + '] ' + message);
                    } catch (e) {}
                  };
                  
                  console.error = function(...args) {
                    originalConsoleError.apply(console, args);
                    sendToFlutter('ERROR', args);
                  };
                  
                  console.log = function(...args) {
                    originalConsoleLog.apply(console, args);
                    sendToFlutter('LOG', args);
                  };
                  
                  console.warn = function(...args) {
                    originalConsoleWarn.apply(console, args);
                    sendToFlutter('WARN', args);
                  };
                }
              })();
            ''');
          }
          
          if (mounted) {
            // Use microtask to reduce setState overhead
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            });
          }
        },
        onProgress: (int progress) {
          // Skip progress callbacks to reduce overhead
        },
        onPageFinished: (String url) {
          if (mounted) {
            // Inject script once after page finishes
            if (_controller != null) {
              _injectAuthScript(_controller!);
              // Use microtask for setState to reduce jank
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            }
          }
        },
        onWebResourceError: (WebResourceError error) {
          // Log network errors for debugging
          print('[WebView Network Error]');
          print('  URL: ${error.url}');
          print('  Description: ${error.description}');
          print('  Error Code: ${error.errorCode}');
          print('  Error Type: ${error.errorType}');
          
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
    // Optimized to reduce execution time and improve performance
    
    // Escape the token for safe JavaScript string insertion
    // Replace backslashes, single quotes, and newlines to prevent XSS and syntax errors
    final escapedToken = widget.token
        .replaceAll('\\', '\\\\')  // Escape backslashes
        .replaceAll("'", "\\'")    // Escape single quotes
        .replaceAll('\n', '\\n')   // Escape newlines
        .replaceAll('\r', '\\r');  // Escape carriage returns
    
    final script = '''
      (function() {
        try {
          const token = '$escapedToken';
          
          // If script already injected with the same token, no work needed
          if (window.__transgoAuthInjected === true && window.transgoAuthToken === token) {
            return;
          }
          
          // Mark as injected for this token
          window.__transgoAuthInjected = true;
          
          // Capture console logs and send to Flutter
          if (window.ConsoleLog) {
            const originalConsoleLog = console.log;
            const originalConsoleError = console.error;
            const originalConsoleWarn = console.warn;
            const originalConsoleInfo = console.info;
            
            const sendToFlutter = function(level, args) {
              try {
                const message = args.map(function(arg) {
                  if (typeof arg === 'object') {
                    try {
                      return JSON.stringify(arg, null, 2);
                    } catch (e) {
                      return String(arg);
                    }
                  }
                  return String(arg);
                }).join(' ');
                window.ConsoleLog.postMessage('[' + level + '] ' + message);
              } catch (e) {
                // Ignore errors in logging
              }
            };
            
            console.log = function(...args) {
              originalConsoleLog.apply(console, args);
              sendToFlutter('LOG', args);
            };
            
            console.error = function(...args) {
              originalConsoleError.apply(console, args);
              sendToFlutter('ERROR', args);
            };
            
            console.warn = function(...args) {
              originalConsoleWarn.apply(console, args);
              sendToFlutter('WARN', args);
            };
            
            console.info = function(...args) {
              originalConsoleInfo.apply(console, args);
              sendToFlutter('INFO', args);
            };
          }
          
          // CLEAR previous auth/session data so switching account uses the new one
          try {
            // Clear localStorage keys commonly used for auth
            localStorage.removeItem('transgo_auth_token');
            localStorage.removeItem('accessToken');
            localStorage.removeItem('auth_token');
            localStorage.removeItem('token');
          } catch (e) {}
          
          try {
            // Clear sessionStorage auth keys
            sessionStorage.removeItem('accessToken');
            sessionStorage.removeItem('auth_token');
          } catch (e) {}
          
          try {
            // Best-effort cookie cleanup (NextAuth / custom cookies)
            const cookieNames = [
              'next-auth.session-token',
              'next-auth.csrf-token',
              'accessToken',
              'auth_token',
              'token'
            ];
            const domainParts = window.location.hostname.split('.');
            const possibleDomains = [];
            if (domainParts.length >= 2) {
              const rootDomain = domainParts.slice(-2).join('.');
              possibleDomains.push(rootDomain);
              possibleDomains.push(window.location.hostname);
            } else {
              possibleDomains.push(window.location.hostname);
            }
            cookieNames.forEach(function(name) {
              // Clear for current path
              document.cookie = name + '=; Max-Age=0; path=/';
              // Clear for possible domains
              possibleDomains.forEach(function(d) {
                document.cookie = name + '=; Max-Age=0; path=/; domain=' + d;
              });
            });
          } catch (e) {}
          
          // Store NEW token in localStorage for the website to access
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
                args[0] = url;
              }
            } else if (url && typeof url === 'object' && url.url) {
              // Handle Request object
              if (url.url.includes('/api/v1/api/v1/')) {
                url.url = url.url.replace(/\\/api\\/v1\\/api\\/v1\\//g, '/api/v1/');
                url.url = url.url.replace(/\\/api\\/v1\\/api\\/v1([^\\/])/g, '/api/v1\$' + '1');
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
              
              // URL fixed silently
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
          
          // AGGRESSIVE Performance optimizations for smoother scrolling
          // Force GPU acceleration on all elements
          const style = document.createElement('style');
          style.textContent = \`
            * {
              -webkit-transform: translateZ(0);
              transform: translateZ(0);
              -webkit-backface-visibility: hidden;
              backface-visibility: hidden;
              -webkit-perspective: 1000;
              perspective: 1000;
            }
            body, html {
              -webkit-overflow-scrolling: touch;
              overflow-scrolling: touch;
              -webkit-transform: translate3d(0, 0, 0);
              transform: translate3d(0, 0, 0);
              will-change: transform;
            }
            /* Optimize all scrollable containers */
            [class*="scroll"], [id*="scroll"], main, section, div {
              -webkit-transform: translateZ(0);
              transform: translateZ(0);
              will-change: scroll-position;
            }
          \`;
          document.head.appendChild(style);
          
          // Optimize scroll performance with throttling
          let lastScrollTime = 0;
          const scrollThrottle = 16; // ~60fps
          
          const optimizedScroll = function() {
            const now = Date.now();
            if (now - lastScrollTime >= scrollThrottle) {
              lastScrollTime = now;
              // Use requestAnimationFrame for smooth updates
              requestAnimationFrame(function() {
                // Scroll handling is done by browser
              });
            }
          };
          
          // Use passive listeners for better performance
          if (window.addEventListener) {
            window.addEventListener('scroll', optimizedScroll, { passive: true, capture: false });
            window.addEventListener('touchmove', function() {}, { passive: true });
            window.addEventListener('wheel', function() {}, { passive: true });
          }
          
          // Disable expensive operations during scroll
          let isScrolling = false;
          const scrollStart = function() {
            isScrolling = true;
          };
          const scrollEnd = function() {
            isScrolling = false;
          };
          
          let scrollTimeout;
          window.addEventListener('scroll', function() {
            if (!isScrolling) scrollStart();
            clearTimeout(scrollTimeout);
            scrollTimeout = setTimeout(scrollEnd, 150);
          }, { passive: true });
          
          // Optimize images and media during scroll
          if (window.IntersectionObserver) {
            const observer = new IntersectionObserver(function(entries) {
              entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                  const img = entry.target;
                  if (img.dataset && img.dataset.src) {
                    img.src = img.dataset.src;
                    observer.unobserve(img);
                  }
                }
              });
            }, { rootMargin: '50px' });
            
            document.querySelectorAll('img[data-src]').forEach(function(img) {
              observer.observe(img);
            });
          }
          
          // Auth token and interceptors installed successfully
        } catch (e) {
          // Silently handle injection errors
        }
      })();
    ''';
    
    controller.runJavaScript(script).catchError((error) {
      // Silently handle JavaScript injection errors
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Memoize AppBar to prevent rebuilds
    final appBar = AppBar(
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
    );
    
    return Scaffold(
      appBar: appBar,
      body: _isInitialized && _controller != null
          ? Stack(
              children: [
                // Use multiple optimization layers
                RepaintBoundary(
                  child: ClipRect(
                    child: WebViewWidget(
                      controller: _controller!,
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
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
