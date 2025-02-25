// src/index.js

import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

// PWA 서비스 워커 등록
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js').then(
      (registration) => {
        console.log('Service Worker registered with scope:', registration.scope);
      },
      (error) => {
        console.log('Service Worker registration failed:', error);
      }
    );
  });
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
