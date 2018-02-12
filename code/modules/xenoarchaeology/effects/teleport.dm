/datum/artifact_effect/teleport
	effecttype = "teleport"
	effect_type = EFFECT_BLUESPACE

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(100 * weakness))
		user << "\red You are suddenly zapped away elsewhere!"
		if (user.buckled)
			user.buckled.unbuckle_mob()

		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(user))
		sparks.start()

		var/turf/current_loc = get_turf(src)
		var/new_x = current_loc.x + pick(-50,50)
		var/new_y = current_loc.y + pick(-50,50)

		user.Move(locate(new_x, new_y, current_loc.z))

		sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, user.loc)
		sparks.start()

/datum/artifact_effect/teleport/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				M << "\red You are displaced by a strange force!"
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(RANGE_TURFS(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()

/datum/artifact_effect/teleport/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				M << "\red You are displaced by a strange force!"
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(RANGE_TURFS(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()
