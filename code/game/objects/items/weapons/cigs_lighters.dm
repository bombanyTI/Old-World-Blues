//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

//For anything that can light stuff on fire
/obj/item/weapon/flame
	var/lit = 0

/proc/isflamesource(A)
	if(istype(A, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = A
		return (WT.isOn())
	else if(istype(A, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = A
		return (F.lit)
	else if(istype(A, /obj/item/device/assembly/igniter))
		return 1
	return 0

///////////
//MATCHES//
///////////
/obj/item/weapon/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = 0
	var/smoketime = 5
	w_class = ITEM_SIZE_TINY
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")

/obj/item/weapon/flame/match/process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		burn_out()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/weapon/flame/match/dropped(mob/user as mob)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		spawn(0)
			var/turf/location = src.loc
			if(istype(location))
				location.hotspot_expose(700, 5)
			burn_out()
	return ..()

/obj/item/weapon/flame/match/proc/burn_out()
	lit = 0
	burnt = 1
	damtype = "brute"
	icon_state = "match_burnt"
	item_state = "cigoff"
	name = "burnt match"
	desc = "A match. This one has seen better days."
	processing_objects.Remove(src)

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	body_parts_covered = 0
	var/lit = 0
	var/icon_on
	var/icon_off
	var/type_butt = null
	var/chem_volume = 0
	var/smoketime = 0
	var/matchmes = "USER lights their NAME with their FLAME."
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/brand

/obj/item/clothing/mask/smokable/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15

/obj/item/clothing/mask/smokable/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		die()
		return
	if(location)
		location.hotspot_expose(700, 5)
	if(reagents && reagents.total_volume) // check if it has any reagents at all
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if (src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2) // Most of it is not inhaled... balance reasons.
		else // else just remove some of the reagents
			reagents.remove_any(REM)

/obj/item/clothing/mask/smokable/examine(mob/user, return_dist)
	. = ..()
	if(lit == 1)
		var/smoke_percent = round((smoketime / initial(smoketime)) * 100)
		switch(smoke_percent)
			if(90 to INFINITY)
				user << "[src] has just begun to burn."
			if(60 to 90)
				user << "[src] has a good amount of burn time remaining."
			if(30 to 60)
				user << "[src] is about half finished."
			if(10 to 30)
				user << "[src] is starting to burn low."
			else
				user << "[src] is nearly burnt out!"

/obj/item/clothing/mask/smokable/on_mob_description(mob/living/carbon/human/H, datum/gender/T, slot, slot_name)
	if(slot == slot_wear_mask)
		if(lit)
			return "[T.He] smokes \icon[src] \a [src]."
		else
			return "[T.He] holding \icon[src] \a [src] in [T.his] mouth."
	else
		return ..()

/obj/item/clothing/mask/smokable/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("phoron") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		if(ismob(loc))
			var/mob/living/M = loc
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		set_light(2, 0.25, "#E38F46")
		processing_objects.Add(src)

/obj/item/clothing/mask/smokable/proc/die(var/nomessage = 0)
	var/turf/T = get_turf(src)
	kill_light()
	if (type_butt)
		var/obj/item/butt = new type_butt(T)
		transfer_fingerprints_to(butt)
		if(brand)
			butt.desc += " This one is \a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				M << SPAN_NOTE("Your [name] goes out.")
			M.remove_from_mob(src) //un-equip it so the overlays can update
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		processing_objects.Remove(src)
		qdel(src)
	else
		new /obj/effect/decal/cleanable/ash(T)
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				M << SPAN_NOTE("Your [name] goes out, and you empty the ash.")
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		processing_objects.Remove(src)

/obj/item/clothing/mask/smokable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(isflamesource(W))
		var/text = SPAN_NOTE(matchmes)
		if(istype(W, /obj/item/weapon/flame/match))
			text = SPAN_NOTE(matchmes)
		else if(istype(W, /obj/item/weapon/flame/lighter/zippo))
			text = zippomes
		else if(istype(W, /obj/item/weapon/flame/lighter))
			text = SPAN_NOTE(lightermes)
		else if(istype(W, /obj/item/weapon/weldingtool))
			text = SPAN_NOTE(weldermes)
		else if(istype(W, /obj/item/device/assembly/igniter))
			text = SPAN_NOTE(ignitermes)
		text = replacetext(text, "USER", "[user]")
		text = replacetext(text, "NAME", "[name]")
		text = replacetext(text, "FLAME", "[W.name]")
		light(text)

/obj/item/clothing/mask/smokable/attack(var/mob/living/M, var/mob/living/user, def_zone)
	if(istype(M) && M.on_fire)
		user.do_attack_animation(M)
		light(SPAN_NOTE("[user] coldly lights the [name] with the burning body of [M]."))
		return 1
	else
		return ..()

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	icon_off = "cigoff"
	type_butt = /obj/item/weapon/cigbutt
	chem_volume = 15
	smoketime = 300
	lightermes = "USER manages to light their NAME with FLAME."
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "USER casually lights the NAME with FLAME."
	ignitermes = "USER fiddles with FLAME, and manages to light their NAME."

/obj/item/clothing/mask/smokable/cigarette/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
		if(S.active)
			light("<span class='warning'>[user] swings their [W], barely missing their nose. They light their [name] in the process.</span>")

	return

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/weapon/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if(!proximity)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			user << SPAN_NOTE("You dip \the [src] into \the [glass].")
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				user << SPAN_NOTE("[glass] is empty.")
			else
				user << SPAN_NOTE("[src] is full.")

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user as mob)
	if(lit == 1)
		user.visible_message(SPAN_NOTE("[user] calmly drops and treads on the lit [src], putting it out instantly."))
		die(1)
	return ..()

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/weapon/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500
	chem_volume = 20
	lightermes = "USER manages to offend their NAME by lighting it with FLAME."
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "USER insults NAME by lighting it with FLAME."
	ignitermes = "USER fiddles with FLAME, and manages to light their NAME with the power of science."

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 30

/obj/item/weapon/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/inv_slots/masks/icon.dmi'
	icon_state = "cigbutt"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 1
	randpixel = 10

/obj/item/weapon/cigbutt/New()
	..()
	transform = turn(transform,rand(0,360))

/obj/item/weapon/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/weapon/cigbutt/samokrutkabutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/samokrutka.dmi'
	icon_state = "roach"


/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Made of fine, stained cherry wood."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	w_class = ITEM_SIZE_TINY
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 0
	chem_volume = 50
	lightermes = "USER manages to light their NAME with FLAME."
	zippomes = "<span class='rose'>With much care, USER lights their NAME with their FLAME.</span>"
	weldermes = "USER recklessly lights NAME with FLAME."
	ignitermes = "USER fiddles with FLAME, and manages to light their NAME with the power of science."

/obj/item/clothing/mask/smokable/pipe/New()
	..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit && src.smoketime)
		src.lit = 1
		damtype = "fire"
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		processing_objects.Add(src)
		if(ismob(loc))
			var/mob/living/M = loc
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/attack_self(mob/user as mob)
	if(lit == 1)
		user.visible_message(SPAN_NOTE("[user] puts out [src]."), SPAN_NOTE("You put out [src]."))
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		processing_objects.Remove(src)
	else if (smoketime)
		var/turf/location = get_turf(user)
		user.visible_message(SPAN_NOTE("[user] empties out [src]."), SPAN_NOTE("You empty out [src]."))
		new /obj/effect/decal/cleanable/ash(location)
		smoketime = 0
		reagents.clear_reagents()
		name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/melee/energy/sword))
		return

	..()

	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = W
		if (!G.dry)
			user << SPAN_NOTE("[G] must be dried before you stuff it into [src].")
			return
		if (smoketime)
			user << SPAN_NOTE("[src] is already packed.")
			return
		smoketime = 1000
		if(G.reagents)
			G.reagents.trans_to_obj(src, G.reagents.total_volume)
		name = "[G.name]-packed [initial(name)]"
		qdel(G)

	else if(istype(W, /obj/item/weapon/flame/lighter))
		var/obj/item/weapon/flame/lighter/L = W
		if(L.lit)
			light(SPAN_NOTE("[user] manages to light their [name] with [W]."))

	else if(istype(W, /obj/item/weapon/flame/match))
		var/obj/item/weapon/flame/match/M = W
		if(M.lit)
			light(SPAN_NOTE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTE("[user] fiddles with [W], and manages to light their [name] with the power of science."))

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	chem_volume = 35

/////////
//ZIPPO//
/////////
/obj/item/weapon/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = ITEM_SIZE_TINY
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	attack_verb = list("burnt", "singed")
	var/base_state
	var/activation_sound = 'sound/items/lighter_on.ogg'
	var/desactivation_sound = 'sound/items/lighter_off.ogg'

/obj/item/weapon/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"
	activation_sound = 'sound/items/zippo_on.ogg'
	desactivation_sound = 'sound/items/zippo_off.ogg'

/obj/item/weapon/flame/lighter/random
	New()
		icon_state = "lighter-[pick("r","c","y","g")]"
		item_state = icon_state
		base_state = icon_state

/obj/item/weapon/flame/lighter/attack_self(mob/living/user)
	if(!base_state)
		base_state = icon_state
	if(!lit)
		lit = 1
		icon_state = "[base_state]on"
		item_state = "[base_state]on"
		playsound(src.loc, activation_sound, 75, 1)
		if(istype(src, /obj/item/weapon/flame/lighter/zippo) )
			user.visible_message("<span class='rose'>Without even breaking stride, [user] flips open and lights [src] in one smooth movement.</span>")
		else
			if(prob(95))
				user.visible_message(SPAN_NOTE("After a few attempts, [user] manages to light the [src]."))
			else
				user << "<span class='warning'>You burn yourself while lighting the lighter.</span>"
				if (user.l_hand == src)
					user.apply_damage(2,BURN,BP_L_HAND)
				else
					user.apply_damage(2,BURN,BP_R_HAND)
				user.visible_message(SPAN_NOTE("After a few attempts, [user] manages to light the [src], they however burn their finger in the process."))

		set_light(2)
		processing_objects.Add(src)
	else
		lit = 0
		icon_state = "[base_state]"
		item_state = "[base_state]"
		playsound(src.loc, desactivation_sound, 75, 1)
		if(istype(src, /obj/item/weapon/flame/lighter/zippo) )
			user.visible_message("<span class='rose'>You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing.</span>")
		else
			user.visible_message(SPAN_NOTE("[user] quietly shuts off the [src]."))

		kill_light()
		processing_objects.Remove(src)
	return


/obj/item/weapon/flame/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!ismob(M))
		return

	if(lit == 1)
		M.IgniteMob()
		self_attack_log(user, "attacked [key_name(M)] with [src.name] and lit them on fire")

	if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == O_MOUTH && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/weapon/flame/lighter/zippo))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M].</span>")
			else
				cig.light(SPAN_NOTE("[user] holds the [name] out for [M], and lights the [cig.name]."))
	else
		..()

/obj/item/weapon/flame/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

/obj/item/weapon/weed_paper
	name = "Weed Paper"
	desc = "Paper with some weed poured on it."
	icon = 'icons/obj/samokrutka.dmi'
	icon_state = "weed_paper"
	item_state = "paper"

	New()
		create_reagents(10)
		..()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown))
			var/obj/item/weapon/reagent_containers/food/snacks/grown/G = W
			if(G.reagents && (G.reagents.has_reagent("space_drugs") || G.reagents.has_reagent("psilocybin")))
				if(reagents.maximum_volume-reagents.total_volume+G.reagents.total_volume > 200)
					return
				G.reagents.del_reagent("nutriment")
				if(G.reagents.has_reagent("toxin"))
					G.reagents.remove_reagent("toxin",G.reagents.get_reagent_amount("toxin")*0.6) //Reducing the amount of toxic chemicals
				if(G.reagents.has_reagent("synaptizine"))
					G.reagents.remove_reagent("synaptizine",G.reagents.get_reagent_amount("synaptizine")*0.6)
				if(reagents.maximum_volume-reagents.total_volume<G.reagents.total_volume)
					reagents.maximum_volume = reagents.total_volume + G.reagents.total_volume
				G.reagents.trans_to(src,G.reagents.total_volume)
				desc = initial(desc)+" There are [reagents.total_volume] units of stuff."
				user.u_equip(W)
				del(W)

	attack_self(mob/user as mob)
		if(reagents.total_volume>0)
			var/obj/item/clothing/mask/smokable/cigarette/samokrutka/S = new(src.loc)
			user << "You roll an [S] from the paper."
			reagents.my_atom = S
			S.reagents = reagents
			S.chem_volume = reagents.total_volume
			reagents = null
			user.unEquip(src)
			user.put_in_hands(S)
			del(src)

/obj/item/clothing/mask/smokable/cigarette/samokrutka
	name = "Amp joint"
	desc = "Hand rolled weed 'cigar'."
	item_state = "samokrutkaoff"
	icon_state = "samokrutkaoff"
	icon_on = "samokrutkaon"
	icon_off = "samokrutkaoff"
	smoketime = 120
	chem_volume = 30
	type_butt = /obj/item/weapon/cigbutt/samokrutkabutt


	process()
		if(reagents.total_volume > 24 && prob(20))
			var/datum/effect/effect/system/smoke_spread/chem/smoke = new
			var/num = 0
			var/amnt = reagents.total_volume
			while(amnt>24 && prob(80))
				amnt -= 15
				num++
			var/datum/reagents/tosmoke = new(num*5)
			reagents.trans_to(tosmoke,num*2,5)
			smoke.set_up(tosmoke,min(1,num),0,get_turf(src),0,1)
			smoke.start()
		..()
