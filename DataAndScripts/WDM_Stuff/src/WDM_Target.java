import cStopPow.*;

import java.io.File;
import java.io.IOException;

public class WDM_Target {

    double A, Z;
    double massDensity;
    double length, diameter;

    File srimFile;
    File xrayFile;

    public WDM_Target(double a, double z, double massDensity, double length, double diameter, File srimFile, File xrayFile) {
        A = a;
        Z = z;
        this.massDensity = massDensity;
        this.length = length;
        this.diameter = diameter;
        this.srimFile = srimFile;
        this.xrayFile = xrayFile;
    }

    public static WDM_Target berylliumTarget(double length, double diameter) {
        return new WDM_Target(9.012, 4, 1.85, length, diameter,
                new File("data/Hydrogen in Beryllium (1.85).txt"),
                new File("data/nistXray_Be.dat"));
    }

    public double getTemperature(int numBeams, double xrayEfficiency, double xrayEnergy) {

        double volume = Math.PI * diameter * diameter * length / 4;     // um^3
        volume *= Math.pow(1e-4, 3);                                    // cc
        double mass = massDensity * volume;         // g
        double mols = mass / A;                     // mols

        double heatCapacity = Constants.cV * mols / Constants.kB;

        double energy = Constants.ENERGY_PER_BEAM * numBeams;
        energy *= xrayEfficiency;

        return energy / heatCapacity;

    }

    public double getZimmermanEnergyLoss(double Et, double Te) {
        double Zbar = Math.min(Z, 20*Math.sqrt(Te));
        return getZimmermanEnergyLoss(Et, Te, Zbar);
    }

    public double getZimmermanEnergyLoss(double Et, double Te, double Zbar) {


        DoubleVector mf = new DoubleVector();       // Field masses (amu)
        mf.add(A);

        DoubleVector Zf = new DoubleVector();       // Field charges (e)
        Zf.add(Z);

        DoubleVector Tf = new DoubleVector();       // Field temperatures (keV)
        Tf.add(Te);

        DoubleVector nf = new DoubleVector();       // Field density (#/cc)
        nf.add(massDensity / A / Constants.GRAMS_PER_AMU);

        DoubleVector Zbarf = new DoubleVector();
        Zbarf.add(Zbar);

        // Make the model
        StopPow_Zimmerman stopPow = new StopPow_Zimmerman(1, 1, mf, Zf, Tf, nf, Zbarf, Te);
        stopPow.set_mode(StopPow.getMODE_LENGTH());

        return Et - stopPow.Eout(Et, length);

    }

    public double getZimmermanStopping(double Et, double Te) {
        double Zbar = Math.min(Z, 20*Math.sqrt(Te));
        return getZimmermanStopping(Et, Te, Zbar);
    }

    public double getZimmermanStopping(double Et, double Te, double Zbar) {


        DoubleVector mf = new DoubleVector();       // Field masses (amu)
        mf.add(A);

        DoubleVector Zf = new DoubleVector();       // Field charges (e)
        Zf.add(Z);

        DoubleVector Tf = new DoubleVector();       // Field temperatures (keV)
        Tf.add(Te);

        DoubleVector nf = new DoubleVector();       // Field density (#/cc)
        nf.add(massDensity / A / Constants.GRAMS_PER_AMU);

        DoubleVector Zbarf = new DoubleVector();
        Zbarf.add(Zbar);

        // Make the model
        StopPow_Zimmerman stopPow = new StopPow_Zimmerman(1, 1, mf, Zf, Tf, nf, Zbarf, Te);
        stopPow.set_mode(StopPow.getMODE_RHOR());

        return stopPow.dEdx(Et);

    }

    public double getSRIMEnergyLoss(double Et) {

        try {

            StopPow_SRIM stopPow = new StopPow_SRIM(srimFile.getAbsolutePath());
            stopPow.set_mode(StopPow.getMODE_LENGTH());

            return Et - stopPow.Eout(Et, length);

        } catch (IOException e) {
            e.printStackTrace();
            return Double.NaN;
        }

    }

    public double getSRIMStopping(double Et) {

        try {

            StopPow_SRIM stopPow = new StopPow_SRIM(srimFile.getAbsolutePath());
            stopPow.set_mode(StopPow.getMODE_RHOR());

            return stopPow.dEdx(Et);

        } catch (IOException e) {
            e.printStackTrace();
            return Double.NaN;
        }

    }


}
