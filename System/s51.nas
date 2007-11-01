# $Id: s51.nas







# engines/rotor =====================================================
rotor = props.globals.getNode("controls/engines/engine/rotorgear");
state = props.globals.getNode("sim/model/s51/state");
turbine = props.globals.getNode("sim/model/s51/turbine-rpm-pct", 1);
brake = props.globals.getNode("controls/rotor/brake");
master_bat = props.globals.getNode("controls/engines/engine/master-bat");
magnetos = props.globals.getNode("controls/engines/engine/magnetos");
master_switch = props.globals.getNode("controls/electric/master-switch");
battery_switch = props.globals.getNode("controls/electric/battery-switch");
blade0 = props.globals.getNode("rotors/main/blade[0]/position-deg");
blade1 = props.globals.getNode("rotors/main/blade[1]/position-deg");
blade2 = props.globals.getNode("rotors/main/blade[2]/position-deg");
blad_fold = props.globals.getNode("/surface-positions/blade-fold-pos-norm");
rpm = props.globals.getNode("rotors/main/rpm");


print("engines off");
engines = func {
        
	s = state.getValue();
	if (arg[0] == 1)  {
		if (s == 0  and master_switch.getValue() == 1 and blad_fold.getValue() == 0) {
			state.setValue(1);
			print("engines started");
                        brake.setValue(0);
			settimer(func { rotor.setValue(1) }, 3);
			interpolate(turbine, 100, 10.5);
			settimer(func { state.setValue(2) ; print("engines running") }, 10.5);
	}
	} else {
		if (s == 2) {
			print("engines stopped");
			rotor.setValue(0);
			state.setValue(3);
			interpolate(turbine, 0, 18);
			settimer(func { state.setValue(0) ; print("engines off") }, 18);
                        }
                        magnetos.setValue(0);
                        master_bat.setValue(0);
                        master_switch.setValue(0);
                        battery_switch.setValue(0);
                    }
                            
}

electric = func {
                    magnetos.setValue(3);
                    master_bat.setValue(1);
                    master_switch.setValue(1);
                    battery_switch.setValue(1);
}

blades_fold = func {
        s = state.getValue();
        if (s == 0 and rpm.getValue() < 0.1 and brake.getValue() == 1){
            diff0 = 360 - blade0.getValue() ;
            #print ("Fold position: ", diff0);
            setprop ("/controls/rotor/blade0-fold-pos", diff0);
            
            diff1 = 480 - blade1.getValue() ;
            #print ("Fold position: ", diff1);
            setprop ("/controls/rotor/blade1-fold-pos", diff1);
            
            diff2 = 600 - blade2.getValue() ;
            #print ("Fold position: ", diff2);
            setprop ("/controls/rotor/blade2-fold-pos", diff2);
            
            setprop ("/controls/flight/wing-fold",1);
        }
}
