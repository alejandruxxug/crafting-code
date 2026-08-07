public class Demo {

    static long sink;                       // keeps the optimizer honest

    static long sum(int n) {                // small body, called many times
        long s = 0;
        for (int i = 0; i < n; i++) s += i;
        return s;
    }

    static long timeBatch(int calls, int n) {
        long t = System.nanoTime();
        for (int i = 0; i < calls; i++) sink += sum(n);
        return System.nanoTime() - t;
    }

    public static void main(String[] args) {
        long cold = timeBatch(1_000, 1_000);                    // still interpreted
        for (int i = 0; i < 200_000; i++) sink += sum(1_000);   // warm it up
        long hot  = timeBatch(1_000, 1_000);                    // now JIT-compiled

        System.out.printf("cold (interpreted) : %,10d ns%n", cold);
        System.out.printf("hot  (JIT native)  : %,10d ns%n", hot);
        System.out.printf("speedup            : %.1fx%n", (double) cold / hot);
    }
}
