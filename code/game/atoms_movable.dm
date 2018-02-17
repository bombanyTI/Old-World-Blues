/atom/movable
	layer = 3
	var/tmp/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/tmp/throwing = 0
	var/tmp/thrower
	var/tmp/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/tmp/mob/pulledby = null


/atom/movable/New()
	..()
	if(auto_init && ticker && ticker.current_state == GAME_STATE_PLAYING)
		initialize()

/*
/atom/movable/Del()
	if(isnull(gcDestroyed) && loc)
		testing("GC: -- [type] was deleted via del() rather than qdel() --")

		// stick a stack trace in the runtime logs
		crash_with("GC: -- [type] was deleted via del() rather than qdel() --")
*/

/atom/movable/Destroy()
	. = ..()
	if(reagents)
		qdel(reagents)
		reagents = null
	for(var/atom/movable/AM in contents)
		qdel(AM)
	loc = null
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

/atom/movable/proc/initialize()
	return

/atom/movable/Bump(var/atom/A, yes)
	if(src.throwing)
		src.throw_impact(A)
		src.throwing = 0

	spawn(0)
		if ((A && yes))
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

/atom/movable/proc/forceMove(atom/NewLoc, Dir = 0)
	var/OldLoc = loc
	if(!Dir)
		Dir = dir
	if(loc == NewLoc)
		if(dir != Dir)
			dir = Dir
			return TRUE
		else
			return FALSE
	else if(isturf(NewLoc) && isturf(loc))
		if(z == NewLoc.z)
			var/dx = (x - NewLoc.x)
			var/dy = (y - NewLoc.y)
			if(!dx && !dy)
				if(dir != Dir)
					dir = Dir
					return TRUE
				else
					return FALSE

	var/list/olocs, list/nlocs
	var/list/oareas = list(), list/nareas = list()
	var/list/oobjs, list/nobjs

	olocs = locs

	if(isturf(loc))
		for(var/turf/t in olocs)
			oareas |= t.loc
		oobjs = obounds(src) || list()
		oobjs -= locs
	else
		oobjs = list()

	loc = NewLoc
	dir = Dir

	nlocs = locs
	if(isturf(loc))
		nlocs = locs
		for(var/turf/t in nlocs)
			nareas |= t.loc
		nobjs = obounds(src) || list()
		nobjs -= locs
	else
		nobjs = list()

	var/list/xareas = oareas-nareas, list/eareas = nareas-oareas
	var/list/xlocs = olocs-nlocs, list/elocs = nlocs-olocs
	var/list/xobjs = oobjs-nobjs, list/eobjs = nobjs-oobjs

	for(var/area/a in xareas)
		a.Exited(src,loc)
	for(var/turf/t in xlocs)
		t.Exited(src,loc)
	for(var/atom/movable/o in xobjs)
		o.Uncrossed(src)

	for(var/area/a in eareas)
		a.Entered(src, OldLoc)
	for(var/turf/t in elocs)
		t.Entered(src, OldLoc)
	for(var/atom/movable/o in eobjs)
		o.Crossed(src)

	return TRUE


//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.dir)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(src.dir, 180))
			if(isliving(src))
				var/mob/living/M = src
				M.turf_collision(T, speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(isliving(A))
				if(A:lying) continue
				src.throw_impact(A,speed)
			if(isobj(A))
				// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
				if(A.density && !A.throwpass)
					src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	if(!target || !src)	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	src.throwing = 1
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf

	//TODO: DNA3 hulk
	/*
	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!
	*/

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH
	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = get_area(src.loc)
	if(dist_x > dist_y)
		var/error = dist_x/2 - dist_y


		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile,
		// or hit something, or hit the end of the map, or someone picks it up
		while(
			src && target && \
			src.throwing && \
			istype(src.loc, /turf) && ( \
				(((src.x<target.x && dx==EAST) || (src.x>target.x && dx==WEST)) && dist_travelled < range) || \
				(a && a.has_gravity == 0)  || istype(src.loc, /turf/space) \
			)
		) //while
			if(error < 0)
				var/atom/step = get_step(src, dy)
				// going off the edge of the map makes get_step return null, don't let things go off the edge
				if(!step)
					break
				src.Move(step)
				hit_check(speed)
				error += dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				// going off the edge of the map makes get_step return null, don't let things go off the edge
				if(!step)
					break
				src.Move(step)
				hit_check(speed)
				error -= dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			a = get_area(src.loc)
	else
		var/error = dist_y/2 - dist_x
		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile,
		// or hit something, or hit the end of the map, or someone picks it up
		while(
			src && target && \
			src.throwing && \
			istype(src.loc, /turf) && ( \
				(((src.y<target.y && dy==NORTH) || (src.y>target.y && dy==SOUTH)) && dist_travelled < range) || \
				(a && a.has_gravity == 0)  || istype(src.loc, /turf/space) \
			)
		) //while
			if(error < 0)
				var/atom/step = get_step(src, dx)
				// going off the edge of the map makes get_step return null, don't let things go off the edge
				if(!step)
					break
				src.Move(step)
				hit_check(speed)
				error += dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				// going off the edge of the map makes get_step return null, don't let things go off the edge
				if(!step)
					break
				src.Move(step)
				hit_check(speed)
				error -= dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			a = get_area(src.loc)

	//done throwing, either because it hit something or it finished moving
	if(isobj(src)) src.throw_impact(get_turf(src),speed)
	src.throwing = 0
	src.thrower = null
	src.throw_source = null


//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	for(var/x in src.verbs)
		src.verbs -= x
	..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return
