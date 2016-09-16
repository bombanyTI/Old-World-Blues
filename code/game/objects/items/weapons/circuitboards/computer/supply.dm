#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/order/supply
	name = T_BOARD("supply control console")
	build_path = /obj/machinery/computer/order/supply
	origin_tech = "programming=3"
	var/contraband_enabled = 0

/obj/item/weapon/circuitboard/order/supply/qm
	name = T_BOARD("quartermaster control console")
	build_path = /obj/machinery/computer/order/supply/qm
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/order/supply/construct(var/obj/machinery/computer/order/supply/SC)
	if (..(SC))
		SC.can_order_contraband = contraband_enabled

/obj/item/weapon/circuitboard/order/supply/deconstruct(var/obj/machinery/computer/order/supply/SC)
	if (..(SC))
		contraband_enabled = SC.can_order_contraband

/obj/item/weapon/circuitboard/order/supply/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/device/multitool))
		var/catastasis = src.contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch( alert("Current receiver spectrum is set to: [catastasis]","Multitool-Circuitboard interface","Switch to [opposite_catastasis]","Cancel") )
		//switch( alert("Current receiver spectrum is set to: " {(src.contraband_enabled) ? ("BROAD") : ("STANDARD")} , "Multitool-Circuitboard interface" , "Switch to " {(src.contraband_enabled) ? ("STANDARD") : ("BROAD")}, "Cancel") )
			if("Switch to STANDARD","Switch to BROAD")
				src.contraband_enabled = !src.contraband_enabled

			if("Cancel")
				return
			else
				user << "DERP! BUG! Report this (And what you were doing to cause it) to Agouri"
	return
