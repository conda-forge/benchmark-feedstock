#include <benchmark/benchmark.h>
#include <iostream>
static int iterations = 0;
static void native_consumer(benchmark::State& state) {
    for (auto ignored : state) {
        ++iterations;
        benchmark::DoNotOptimize(iterations);
    }
}
int main(int argc, char** argv) {
    benchmark::Initialize(&argc, argv);
    benchmark::RegisterBenchmark("native_consumer", native_consumer)->Iterations(3);
    const auto count = benchmark::RunSpecifiedBenchmarks();
    benchmark::Shutdown();
    if (count != 1 || iterations != 3) return 1;
    std::cout << "Installed benchmark registration and three iterations passed\n";
}
