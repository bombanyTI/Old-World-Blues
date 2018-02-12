/*
 * Contains:
 *		Security
 *		Detective
 *		Warden
 *		Forensic Technican
 *		Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hos_red"
	item_state = "red"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/head_of_security/skirt
	desc = "It's a fashionable jumpskirt worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpskirt"
	icon_state = "hos_redf"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "warden_red"
	item_state = "red"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/warden/skirt
	desc = "Standard feminine fashion for a Warden. It is made of sturdier material than standard jumpskirts. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpskirt"
	icon_state = "warden_redf"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "officer_red"
	item_state = "red"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security/skirt
	name = "security officer's jumpskirt"
	desc = "Standard feminine fashion for Security Officers. It's made of sturdier material than the standard jumpskirts."
	icon_state = "officer_redf"

/obj/item/clothing/under/rank/forentech
	name = "red forensic technician suit"
	desc = "Someone who wears this means business."
	icon_state = "forensic_red"
	item_state = "red"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/warden_f
	desc = "A warden's dress."
	name = "warden's dress"
	icon_state = "warden_f"

/*
 * Corporate
 */
/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corp"
	item_state = "black"

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corp"
	item_state = "black"

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corp"
	item_state = "black"

/obj/item/clothing/under/rank/det/corp
	icon_state = "det_corp"
	item_state = "black"

/*
 * Navy uniforms
 */
/obj/item/clothing/under/rank/head_of_security/dnavy
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon_state = "hos_dnavy"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/warden/dnavy
	desc = "Dark. Navy. Sexy."
	name = "warden's uniform"
	icon_state = "warden_dnavy"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/security/dnavy
	name = "security officer's uniform"
	desc = "Dark, navy and stylish. Enough to be the perfect piece of clothing."
	icon_state = "officer_dnavy"
	item_state = "ba_suit"

/*
 * Jeans uniforms
 */
/obj/item/clothing/under/rank/head_of_security/jeans
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon_state = "hosj"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/warden/jeans
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon_state = "wardenj"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/security/jeans
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerj"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/det/jeans
	desc = "That's a simple blue dress shirt with the jeans."
	icon_state = "detj"
	item_state = "ba_suit"

/*
 * Tan uniforms
 */
/obj/item/clothing/under/rank/head_of_security/tan
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon_state = "hos_tan"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/warden/tan
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon_state = "warden_tan"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/security/tan
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officer_tan"
	item_state = "ba_suit"

/*
 * Blue uniforms
 */
/obj/item/clothing/under/rank/warden/blue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon_state = "wardenblue"
	item_state = "ba_suit"

/obj/item/clothing/under/rank/security/blue
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "secblue"
	item_state = "ba_suit"

/*
 * Head of Security
 */
//Jensen cosplay gear
/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"

/obj/item/clothing/under/rank/head_of_security/hos_f
	desc = "A head of security's dress."
	name = "head of security's dress"
	icon_state = "hos_f"

/obj/item/clothing/under/rank/head_of_security/hos_turtleneck
	desc = "A head of security's red turtleneck."
	name = "head of security's red turtleneck"
	icon_state = "hos_turtleneck"

/*
 * Detective
 */
/obj/item/clothing/under/rank/det
	name = "detective's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon_state = "detective"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	starting_accessories = list(/obj/item/clothing/accessory/blue_clip)

/obj/item/clothing/under/rank/det/grey
	icon_state = "det_grey"
	item_state = "gray"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	starting_accessories = list(/obj/item/clothing/accessory/red_long)

/obj/item/clothing/under/rank/det/black
	name = "worn suit"
	desc = "That's a simple white dress shirt with the pants."
	icon_state = "det_black"
	item_state = "ba_suit"
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants."
	starting_accessories = null

/*
 *Forensic Technician
 */
/obj/item/clothing/under/rank/forensic
	name = "black turtleneck"
	desc = "That's the black turtleneck with pants."
	icon_state = "forensic"
	item_state = "black"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	item_state = "lawyer_blue"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/cadet
	name = "security junior's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "cadet"
	item_state = "red"

/obj/item/clothing/under/rank/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	item_state = "green"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
