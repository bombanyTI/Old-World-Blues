#define IC_INPUT "input"
#define IC_OUTPUT "output"
#define IC_ACTIVATOR "activator"

#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

#define IC_SPAWN_DEFAULT			1 // If the circuit comes in the default circuit box.
#define IC_SPAWN_RESEARCH 		2 // If the circuit design will be autogenerated for RnD.

#define IC_FORMAT_STRING		"\<TEXT\>"
#define IC_FORMAT_NUMBER		"\<NUM\>"
#define IC_FORMAT_REF			"\<REF\>"
#define IC_FORMAT_LIST			"\<LIST\>"
#define IC_FORMAT_ANY			"\<ANY\>"
#define IC_FORMAT_PULSE			"\<PULSE\>"

var/list/all_integrated_circuits = list()

/datum/unit_test/proc/get_standard_turf()
	return locate(20,20,1)
/*
/datum/unit_test/proc/log_bad(var/message)
	log_unit_test("[ascii_red]\[[name]\]: [message][ascii_reset]")
*/
/proc/initialize_integrated_circuits_list()
	for(var/thing in typesof(/obj/item/integrated_circuit))
		all_integrated_circuits += new thing()

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "template"
	w_class = 1.0
	var/obj/item/device/electronic_assembly/assembly = null // Reference to the assembly holding this circuit, if any.
	var/extended_desc = null
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/activators = list()
	var/next_use = 0 //Uses world.time
	var/complexity = 1 				//This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/cooldown_per_use = 1 SECOND // Circuits are limited in how many times they can be work()'d by this variable.
	var/power_draw_per_use = 0 		// How much power is drawn when work()'d.
	var/power_draw_idle = 0			// How much power is drawn when doing nothing.
	var/spawn_flags = null			// Used for world initializing, see the #defines above.
	var/category_text = "NO CATEGORY THIS IS A BUG"	// To show up on circuit printer, and perhaps other places.
	var/autopulse = -1 				// When input is received, the circuit will pulse itself if set to 1.  0 means it won't. -1 means it is permanently off.
	var/removable = TRUE 			// Determines if a circuit is removable from the assembly.


