export function HeroSection() {
  return (
    <section className="py-20 text-center">
      <h1 className="text-4xl font-bold mb-6">
        Welcome to ABP Framework
      </h1>
      <p className="text-xl text-gray-600 mb-8">
        A complete infrastructure to create modern web applications
      </p>
      <div className="space-x-4">
        <button className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700">
          Get Started
        </button>
        <button className="border border-gray-300 px-6 py-3 rounded-lg hover:bg-gray-50">
          Learn More
        </button>
      </div>
    </section>
  )
}