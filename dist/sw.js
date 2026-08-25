const CACHE_NAME = 'fotopanel-v1';
const ASSETS = [
  '/',
  '/manifest.json',
  '/src/styles/global.css',
  '/src/scripts/fotopanel.js',
  '/img/favicon.png'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS))
  );
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((response) => response || fetch(e.request))
  );
});
