//Simple borg hand.
//Limited use.
/obj/item/weapon/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"

	flags = NOBLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/weapon/cell,
		/obj/item/weapon/firealarm_electronics,
		/obj/item/weapon/airalarm_electronics,
		/obj/item/weapon/airlock_electronics,
		/obj/item/weapon/tracker_electronics,
		/obj/item/weapon/power_control,
		/obj/item/weapon/stock_parts,
		/obj/item/frame,
		/obj/item/weapon/camera_assembly,
		/obj/item/weapon/tank,
		/obj/item/weapon/circuitboard,
		/obj/item/weapon/smes_coil
	)

	var/obj/item/wrapped = null // Item currently being held.

	var/force_holder = null //

// VEEEEERY limited version for mining borgs. Basically only for swapping cells and upgrading the drills.
/obj/item/weapon/gripper/miner
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."
	icon_state = "gripper-mining"

	can_hold = list(
	/obj/item/weapon/cell,
	/obj/item/weapon/stock_parts
	)

/obj/item/weapon/gripper/paperwork
	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		/obj/item/weapon/clipboard,
		/obj/item/weapon/paper,
		/obj/item/weapon/paper_bundle,
		/obj/item/weapon/card/id,
		/obj/item/weapon/book,
		/obj/item/weapon/newspaper
		)

/obj/item/weapon/gripper/research //A general usage gripper, used for toxins/robotics/xenobio/etc
	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(
		/obj/item/weapon/cell,
		/obj/item/weapon/stock_parts,
		/obj/item/device/mmi,
		/obj/item/robot_parts,
		/obj/item/storage/firstaid,
		/obj/item/device/assembly,
		/obj/item/borg/upgrade,
		/obj/item/mecha_parts/,
		/obj/item/device/flash, //to build borgs
		/obj/item/organ/internal/brain, //to insert into MMIs.
		/obj/item/stack/cable_coil, //again, for borg building
		/obj/item/weapon/disk,
		/obj/item/weapon/circuitboard,
		/obj/item/slime_extract,
		/obj/item/weapon/reagent_containers/glass,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube

		)

/obj/item/weapon/gripper/service //Used to handle food, drinks, and seeds.
	name = "service gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(
		/obj/item/weapon/reagent_containers/glass,
		/obj/item/weapon/reagent_containers/food,
		/obj/item/seeds,
		/obj/item/weapon/grown,
		/obj/item/storage/fancy,
		/obj/item/weapon/reagent_containers/condiment //����� ������ ������ �����,����, ������������� ������ � �.�.
		)

/obj/item/weapon/gripper/no_use/organ
	name = "organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used to preserve and manipulate organic material."

	can_hold = list(
		/obj/item/organ
		)

/obj/item/weapon/gripper/no_use/organ/Entered(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 1
		for(var/obj/item/organ/organ in O)
			organ.preserved = 1
	..()

/obj/item/weapon/gripper/no_use/organ/Exited(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 0
		for(var/obj/item/organ/organ in O)
			organ.preserved = 0
	..()
/*
/obj/item/weapon/gripper/no_use/organ/robotics
	name = "external organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used in robotics work."

	can_hold = list(
		/obj/item/organ/external,
		/obj/item/organ/internal/cell
		)
*/
/obj/item/weapon/gripper/no_use/mech
	name = "exosuit gripper"
	icon_state = "gripper-mech"
	desc = "A large, heavy-duty grasping tool used in construction of mechs."

	can_hold = list(
		/obj/item/mecha_parts/part,
		/obj/item/mecha_parts/mecha_equipment
		)

/obj/item/weapon/gripper/no_use //Used when you want to hold and put items in other things, but not able to 'use' the item

/obj/item/weapon/gripper/no_use/attack_self(mob/user as mob)
	return

/obj/item/weapon/gripper/no_use/loader //This is used to disallow building with metal.
	name = "sheet loader"
	desc = "A specialized loading device, designed to pick up and insert sheets of materials inside machines."
	icon_state = "gripper-sheet"

	can_hold = list(/obj/item/stack/material)

/obj/item/weapon/gripper/attack_self(mob/user as mob)
	if(wrapped)
		return wrapped.attack_self(user)
	return ..()

/obj/item/weapon/gripper/verb/drop_item()

	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Robot Commands"

	drop_to(get_turf(src))


/obj/item/weapon/gripper/proc/drop_to(var/atom/target)
	if(!target) target = get_turf(src)

	if(!wrapped)
		//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
		for(var/obj/item/thing in src.contents)
			thing.forceMove(target)
		return TRUE

	if(wrapped.loc != src)
		wrapped = null
		return FALSE

	src.loc << SPAN_NOTE("You drop \the [wrapped].")
	wrapped.forceMove(target)
	wrapped = null
	return TRUE

/obj/item/weapon/gripper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(wrapped) 	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
		force_holder = wrapped.force
		wrapped.force = 0.0
		wrapped.attack(M,user)
		if(QDELETED(wrapped))
			wrapped = null
		return TRUE
	return FALSE

/obj/item/weapon/gripper/afterattack(var/atom/target, var/mob/living/user, proximity, params)

	//Prevent using guns at range.
	if(!proximity)
		return

	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			break

	if(wrapped) //Already have an item.
		//Temporary put wrapped into user so target's attackby() checks pass.
		wrapped.loc = user

		//Pass the attack on to the target. This might delete/relocate wrapped.
		var/resolved = target.attackby(wrapped,user)
		if(!resolved && wrapped && target)
			wrapped.afterattack(target,user,1)

		//wrapped's force was set to zero.  This resets it to the value it had before.
		wrapped.force = force_holder
		force_holder = null
		//If wrapped was neither deleted nor put into target, put it back into the gripper.
		if(wrapped && user && (wrapped.loc == user))
			wrapped.loc = src
		else
			wrapped = null
			return

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.

		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		var/obj/item/I = target

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			user << "You collect \the [I]."
			I.loc = src
			wrapped = I
			return
		else
			user << "<span class='danger'>Your gripper cannot hold \the [target].</span>"

	else if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.opened)
			if(A.cell)

				wrapped = A.cell

				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.cell.loc = src
				A.cell = null

				A.charging = 0
				A.update_icon()

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")

	else if(isrobot(target))
		var/mob/living/silicon/robot/A = target
		if(A.opened)
			if(A.cell)

				wrapped = A.cell

				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.updateicon()
				A.cell.loc = src
				A.cell = null

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")