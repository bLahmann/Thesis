import cStopPow.StopPow;
import cStopPow.StopPow_SRIM;

public class Program {

    public static void main(String ... args) throws Exception {

        System.load("/home/lahmann/dropbox/Apps/Overleaf/Thesis/DataAndScripts/WDM_Stuff/src/cStopPow/libcStopPow.so");

        scanLengths();



    }

    public static void scanLengths() {
        double[] lengths = Utils.linspace(5, 1000, 5);
        for (double length : lengths) {
            WDM_Target target = WDM_Target.berylliumTarget(length, 800);
            double T = 1e-3*target.getTemperature(30, 0.01, 5.0);
            //T = 1e-6;

            System.out.printf("%.1f, %.4e, %.4e, %.4e\n",
                    length,
                    T,
                    target.getZimmermanEnergyLoss(14.7, T),
                    target.getSRIMEnergyLoss(14.7));
        }
    }

    public static void scanTemps() {

        WDM_Target target = WDM_Target.berylliumTarget(500, 1000);

        double[] Ts = Utils.linspace(0.001, 0.1, 0.001);
        for (double T : Ts) {
            System.out.println(T + ", " + target.getZimmermanStopping(14.7, T, 2));
        }

    }

}
