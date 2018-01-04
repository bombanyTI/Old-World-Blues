/client/verb/print_data()
	var/list/dat = list("Path\tName\tForce")
	for(var/path in subtypesof(/obj/item))
		var/obj/item/I = path
		var/name = initial(I.name)
		var/force = initial(I.force)
		dat += "[I]\t[name]\t[force]"
	src << browse(jointext(dat, "\n"), "window=debug")