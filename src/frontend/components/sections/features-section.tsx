export function FeaturesSection() {
  return (
    <section className="py-16 bg-gray-50">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold text-center mb-12">
          Why Choose ABP Framework?
        </h2>
        <div className="grid md:grid-cols-3 gap-8">
          <div className="text-center p-6">
            <h3 className="text-xl font-semibold mb-4">Modern Architecture</h3>
            <p className="text-gray-600">Built with the latest technologies and best practices</p>
          </div>
          <div className="text-center p-6">
            <h3 className="text-xl font-semibold mb-4">Enterprise Ready</h3>
            <p className="text-gray-600">Production-ready features for enterprise applications</p>
          </div>
          <div className="text-center p-6">
            <h3 className="text-xl font-semibold mb-4">Developer Friendly</h3>
            <p className="text-gray-600">Easy to learn and use with comprehensive documentation</p>
          </div>
        </div>
      </div>
    </section>
  )
}