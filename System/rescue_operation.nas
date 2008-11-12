#Rescue Op  Gérard Robin  Copyright GPL v2
#Au sol 0.07 => Agl ft 3.27
# Alt 1 => Agl ft 33.51

var AGL_REF = 33.51;
print (AGL_REF);
setprop ("/sim/model/rescue-lift",0.00);
setprop ("/position/altitude-agl-ft",0.01);


rope_size = func {
	var rescue = getprop("/sim/model/rescue");
	if ( rescue == 1) {
	var agl = getprop("/position/altitude-agl-ft");
	var rope = getprop("/sim/model/rescue-lift");
	var terrain = getprop("/environment/terrain");
	
	var agl_low = agl - 1;
		if (( rope * AGL_REF  > agl_low ) and (terrain == 1 )) {
		var rescue_lift = agl_low / AGL_REF;
			if (rescue_lift < 0) {
			rescue_lift = 0;
			}
		setprop ("/sim/model/rescue-lift", rescue_lift );
		}
		}
	settimer(rope_size, 0.05);
	}



rope_size();