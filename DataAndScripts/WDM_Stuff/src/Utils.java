public class Utils {

    public static double[] linspace(double a, double b, double dx) {
        double min = Math.min(a,b);
        double max = Math.max(a,b);

        int N = (int) Math.ceil((max - min)/dx) + 1;
        double[] array = new double[N];
        for (int i = 0; i < N; i++) {
            array[i] = min + dx*i;
        }

        return array;
    }

}
