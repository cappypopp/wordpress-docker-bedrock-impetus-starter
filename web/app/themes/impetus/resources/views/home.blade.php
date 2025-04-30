@extends('layouts.app')

@section('content')
<section class="min-h-screen bg-gray-100 flex items-center justify-center p-8">
  <div class="text-center">
    <h1 class="text-5xl font-bold text-brand-blue mb-6">Welcome to My WordPress Site</h1>
    <p class="text-lg text-gray-700 mb-8">
      Built with Bedrock, Sage, Vite, and TailwindCSS 🚀
    </p>
    <a href="/blog" class="bg-blue-600 text-white px-6 py-3 rounded-lg shadow hover:bg-blue-700 transition">
      View Blog
    </a>
  </div>
</section>

<section class="py-16 bg-white">
  <div class="container mx-auto px-4">
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <div class="p-6 bg-gray-100 rounded-lg text-center">
        <h3 class="text-xl font-bold mb-2">Fast Development</h3>
        <p class="text-gray-600">Vite + Sage accelerates your builds with hot reloads and production optimization.</p>
      </div>
      <div class="p-6 bg-gray-100 rounded-lg text-center">
        <h3 class="text-xl font-bold mb-2">Modern Stack</h3>
        <p class="text-gray-600">Blade templates and TailwindCSS keep your code clean, beautiful, and scalable.</p>
      </div>
      <div class="p-6 bg-gray-100 rounded-lg text-center">
        <h3 class="text-xl font-bold mb-2">Powered by WordPress</h3>
        <p class="text-gray-600">Classic WordPress functionality with modern DevOps workflows under the hood.</p>
      </div>
    </div>
  </div>
</section>
@endsection