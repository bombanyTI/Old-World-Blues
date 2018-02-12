//Food
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	addcional_access = list(access_hydroponics, access_kitchen)
	minimal_access = list(access_bar)

	uniform = /obj/item/clothing/under/rank/bartender
	pda = /obj/item/device/pda/bar
	suit = /obj/item/clothing/suit/storage/vest
	ear = /obj/item/device/radio/headset/service

	put_in_backpack = list(
		/obj/item/valentine
		)

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		var/obj/item/storage/box/survival/Barpack = null
		if(H.back)
			Barpack = locate() in H.back
			if(!Barpack)
				Barpack = new(H)
				H.equip_to_slot_or_del(Barpack, slot_in_backpack)

		if(!Barpack)
			if(!H.r_hand)
				Barpack = new /obj/item/storage/box/survival(H)
				H.equip_to_slot_or_del(Barpack, slot_r_hand)
			else if(istype(H.r_hand, /obj/item/storage/box))
				Barpack = H.r_hand

		if(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)

		return 1



/datum/job/chef
	title = "Chef"
	flag = CHEF
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	addcional_access = list(access_hydroponics, access_bar)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")

	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda/chef
	hat = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef
	ear = /obj/item/device/radio/headset/service

	put_in_backpack = list(
		/obj/item/valentine
	)

/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	addcional_access = list(access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Hydroponicist")

	uniform = /obj/item/clothing/under/rank/hydroponics
	pda = /obj/item/device/pda/botanist
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	ear = /obj/item/device/radio/headset/service

	backpack  = /obj/item/storage/backpack/hydroponics
	satchel_j = /obj/item/storage/backpack/satchel/hyd
	messenger = /obj/item/storage/backpack/messenger/hyd

	put_in_backpack = list(
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/valentine
	)


//Cargo
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	minimal_access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining,
		access_mining_station
	)

	uniform = /obj/item/clothing/under/rank/qm
	shoes = /obj/item/clothing/shoes/brown
	pda = /obj/item/device/pda/quartermaster
	gloves = /obj/item/clothing/gloves/black
	ear = /obj/item/device/radio/headset/cargo
	hand = /obj/item/weapon/clipboard
	glasses = /obj/item/clothing/glasses/sunglasses

	put_in_backpack = list(
		/obj/item/valentine
	)

/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dddddd"
	addcional_access = list(access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)

	uniform = /obj/item/clothing/under/rank/cargoshort
	pda = /obj/item/device/pda/cargo
	ear = /obj/item/device/radio/headset/cargo

	put_in_backpack = list(
		/obj/item/valentine
	)

/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dddddd"
	addcional_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_qm)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	alt_titles = list("Drill Technician","Prospector")

	uniform = /obj/item/clothing/under/rank/miner
	pda = /obj/item/device/pda/shaftminer
	ear = /obj/item/device/radio/headset/cargo

	put_in_backpack = list(
		/obj/item/weapon/crowbar,
		/obj/item/storage/bag/ore,
		/obj/item/valentine
	)

/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	minimal_access = list(
		access_janitor, access_maint_tunnels, access_engine, access_research, access_sec_doors, access_medical
	)

	uniform = /obj/item/clothing/under/rank/janitor
	pda = /obj/item/device/pda/janitor
	ear = /obj/item/device/radio/headset/service

	put_in_backpack = list(
		/obj/item/valentine
	)

//More or less assistants
/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	addcional_access = list(access_maint_tunnels)
	minimal_access = list(access_library)
	alt_titles = list("Journalist")

	uniform = /obj/item/clothing/under/suit_jacket/red
	pda = /obj/item/device/pda/librarian
	hand = /obj/item/weapon/barcodescanner

	put_in_backpack = list(
		/obj/item/valentine
	)

/datum/job/lawyer
	title = "Internal Affairs Agent"
	flag = LAWYER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Nanotrasen officials and Corporate Regulations"
	selection_color = "#dddddd"
	addcional_access = list(access_maint_tunnels)
	minimal_access = list(access_lawyer, access_court, access_sec_doors, access_heads)

	implanted = 1
	uniform = /obj/item/clothing/under/rank/internalaffairs
	shoes = /obj/item/clothing/shoes/brown
	pda = /obj/item/device/pda/lawyer
	suit = /obj/item/clothing/suit/storage/toggle/internalaffairs
	ear = /obj/item/device/radio/headset/ia
	hand = /obj/item/storage/briefcase
	glasses = /obj/item/clothing/glasses/sunglasses/big

	put_in_backpack = list(
		/obj/item/valentine
	)