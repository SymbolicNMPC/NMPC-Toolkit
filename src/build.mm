pckg := "NMPCToolkit";
pckgname := "NMPC Toolkit";

NMPCT := cat(pckg,".maple");
PackageTools:-Create(NMPCT);
PackageTools:-SetProperty(NMPCT, "X-CloudVersion", "2");
PackageTools:-SetProperty(NMPCT, "X-CloudId", "5086116991467520");
PackageTools:-SetProperty(NMPCT, "X-CloudXId", "behzad.samadi@gmail.com");


# Overview
PackageTools:-AddAttachment(NMPCT, "../doc/Overview.mw");

# Linear System
PackageTools:-AddAttachment(NMPCT,
                            cat("/Examples/LinearSystem/LinearSystem.mw") =
                                cat("../doc/examples/LinearSystems/LinearSystem.mw") );
PackageTools:-AddAttachment(NMPCT,
                            cat("/Examples/LinearSystem/LinearSystem.msim") =
                                cat("../doc/examples/LinearSystems/LinearSystem.msim") );
PackageTools:-AddAttachment(NMPCT,
                            cat("/Examples/LinearSystem/LinearSystemExtputs.mw") =
                                cat("../doc/examples/LinearSystems/LinearSystemExtputs.mw") );

# Electrohydraulic Servo System
PackageTools:-AddAttachment(NMPCT,
                            cat("/Examples/ElectrohydraulicServoSystem/ElectrohydraulicServoSystem.mw") =
                                cat("../doc/examples/ElectroHydraulicServoSystem/ElectrohydraulicServoSystem.mw") );
PackageTools:-AddAttachment(NMPCT,
                            cat("/Examples/ElectrohydraulicServoSystem/ElectrohydraulicServoSystem.msim") =
                                cat("../doc/examples/ElectroHydraulicServoSystem/ElectrohydraulicServoSystem.msim") );

# Autonomous Race Car
PackageTools:-AddAttachment(NMPCT,
                            cat("/Examples/AutonomousRaceCar/AutonomousRaceCar.mw") =
                                cat("../doc/examples/AutonomousRaceCar/AutonomousRaceCar.mw") );
PackageTools:-AddAttachment(NMPCT,
                            cat("/Examples/AutonomousRaceCar/AutonomousRaceCar.msim") =
                                cat("../doc/examples/AutonomousRaceCar/AutonomousRaceCar.msim") );

read cat(pckg, ".mpl");
savelib(convert(pckg,name),NMPCT);
PackageTools:-SetProperty(NMPCT,"authors","Behzad Samadi");

helpfile := cat(pckg, ".help");


HelpTools:-Database:-Create( helpfile );

# MPCDesignTools
makehelp(cat(pckg,"/Overview"),
         cat("../doc/help/MPCDesignToolsOverview.mw"),
         helpfile,
         browser = [pckgname,"Overview"] );

# Linear System
makehelp( cat(pckgname,"/LinearSystem"),
          cat("../doc/examples/LinearSystems/LinearSystem.mw"),
          helpfile,
          browser = [pckgname,"Examples","Linear System"] );

makehelp( cat(pckgname,"/LinearSystemExtputs"),
          cat("../doc/examples/LinearSystems/LinearSystemExtputs.mw"),
          helpfile,
          browser = [pckgname,"Examples","Linear System with External Inputs"] );

# ElectrohydraulicServoSystem
makehelp( cat(pckgname,"/ElectrohydraulicServoSystem"),
          cat("../doc/examples/ElectroHydraulicServoSystem/ElectrohydraulicServoSystem.mw"),
          helpfile,
          browser = [pckgname,"Examples","Electrohydraulic Servo System"] );

# Autonomous Race Car
makehelp( cat(pckgname,"/AutonomousRaceCar"),
          cat("../doc/examples/AutonomousRaceCar/AutonomousRaceCar.mw"),
          helpfile,
          browser = [pckgname,"Examples","Autonomous Race Car"] );

PackageTools:-AddAttachment(NMPCT,
                            cat("/lib/", pckg, ".help") =
                                cat(pckg, ".help") );
