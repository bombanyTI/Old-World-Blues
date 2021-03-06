/datum/power/changeling/boost_range
	name = "Boost Range"
	desc = "We evolve the ability to shoot our stingers at humans, with some preperation."
	helptext = "Allows us to prepare the next sting to have a range of two tiles."
	enhancedtext = "The range is extended to five tiles."
	genomecost = 1
	allowduringlesserform = 1
	verbpath = /mob/living/proc/changeling_boost_range

//Boosts the range of your next sting attack by 1
/mob/living/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc="Your next sting ability can be used against targets 2 squares away."

	var/datum/changeling/changeling = changeling_power(10,0,100)
	if(!changeling)
		return 0
	changeling.chem_charges -= 10
	src << SPAN_NOTE("Your throat adjusts to launch the sting.")
	var/range = 2
	if(src.mind.changeling.recursive_enhancement)
		range = range + 3
		src << SPAN_NOTE("We can fire our next sting from five squares away.")
		src.mind.changeling.recursive_enhancement = 0
	changeling.sting_range = range
	src.verbs -= /mob/living/proc/changeling_boost_range
	spawn(5)
		src.verbs += /mob/living/proc/changeling_boost_range
	return 1
