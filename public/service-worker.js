<<<<<<< HEAD
// 캐시 이름 및 캐시할 파일 목록 정의
const CACHE_NAME = 'kookmin-alarm-cache-v1';
const urlsToCache = ['/', '/index.html', '/logo192.png', '/logo512.png'];

// 설치 이벤트: 앱을 처음 로드할 때 캐시 파일을 저장
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(urlsToCache);
    })
  );
});

// 네트워크 요청을 가로채 캐시 또는 네트워크에서 리소스를 가져옴
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});

// 활성화 이벤트: 오래된 캐시를 삭제
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});
=======
// public/service-worker.js

self.addEventListener('install', (event) => {
    event.waitUntil(
      caches.open('kookmin-alarm-cache').then((cache) => {
        return cache.addAll([
          '/',
          '/index.html',
          '/manifest.json',
          '/icons/icon-192x192.png',
          '/icons/icon-512x512.png'
        ]);
      })
    );
    console.log('Service Worker: Installed');
  });
  
  self.addEventListener('fetch', (event) => {
    event.respondWith(
      caches.match(event.request).then((response) => {
        return response || fetch(event.request);
      })
    );
  });
  
>>>>>>> 8b0abc2590f29324a15640d51e25334772f9a907
