/*

    Tracking test. Used to simulate realtime tracking
    Useful when debugging when no GPS signal is available.

    Copyright (C) 2009 Marc Poulhiès, dkm@kataplop.net
    Copyright (C) 2005  Robert Lipe, robertlipe@usa.net

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111 USA

 */

#include "defs.h"
#include <ctype.h>
#include <unistd.h>

#define MYNAME "tracktest"


// Any arg in this list will appear in command line help and will be 
// populated for you.
// Values for ARGTYPE_xxx can be found in defs.h and are used to 
// select the type of option.
static
arglist_t tracktest_args[] = {
// {"foo", &fooopt, "The text of the foo option in help", 
//   "default", ARGYTPE_STRING, ARG_NOMINMAX} , 
	ARG_TERMINATOR
};

/*******************************************************************************
* %%%        global callbacks called by gpsbabel main process              %%% *
*******************************************************************************/

static void
tracktest_rd_init(const char *fname)
{
//	fin = gbfopen(fname, "r", MYNAME);
}

static void 
tracktest_rd_deinit(void)
{
//	gbfclose(fin);
}

static void
tracktest_read(void)
{
//	your special code to extract waypoint, route and track
//	information from gbfile "fin"
//
// Sample text-file read code:
//	char *s;
//	while ((s = gbfgetstr(fin))) {
//		do_anything(s);
//	}
//
//
// For waypoints:
//         while (have waypoints) {
//                 waypoint = waypt_new()
//                 populate waypoint
//                 waypt_add(waypoint);
//         }
// 
// For routes:
// 
//         route = route_head_alloc();
//         populate struct route_hdr
//	   route_add_head(route);      
//         while (have more routepoints) {
//                 waypoint = waypt_new()
//                 populate waypoint
//                 route_add_wpt(route, waypoint)
//         }
// 
// Tracks are just like routes, except the word "track" replaces "routes".
//
}


static void
tracktest_exit(void)		/* optional */
{
}


static void
wpt_init(const char *fname)
{
}

static void
fill_wpt(waypoint *wpt){
  double wptime, wptimes;
  static count = 0;

  wpt->altitude = 100;
  wpt->latitude = 10;
  wpt->longitude = 45;
  WAYPT_SET(wpt,course,1);
  WAYPT_SET(wpt,speed,1);

  wpt->course = 90;

  /*
   * The unit reports time in three fields:
   * 1) The # of days to most recent Sun. since  1989-12-31 midnight UTC.
   * 2) The number of seconds (fractions allowed) since that Sunday.
   * 3) The number of leap seconds that offset the current UTC and GPS
   *    reference clocks.
   */
  wptime = 631065600.0 + 365*10 * 86400.0 + (count++);
  wptimes = floor(wptime);
  wpt->creation_time = wptimes;
  wpt->microseconds = 1000000.0 * (wptime - wptimes);
}

static waypoint *
wpt_read(posn_status *posn_status)
{
  static count = 0;
  waypoint *wpt = waypt_new();
  count++;

  if (count == 10){
	fatal(MYNAME ": Fatal error reading position.\n");
  }

  sleep(1);
  fill_wpt(wpt);

  return wpt;
}


/**************************************************************************/

// capabilities below means: we can only read and write waypoints
// please change this depending on your new module 

ff_vecs_t tracktest_vecs = {
	ff_type_file,
	{ 
		ff_cap_read | ff_cap_write 	/* waypoints */, 
	  	ff_cap_none 			/* tracks */, 
	  	ff_cap_none 			/* routes */
	},
	tracktest_rd_init,	
	NULL,	
	tracktest_rd_deinit,	
	NULL,	
	tracktest_read,
	NULL,
	tracktest_exit,
	tracktest_args,
	CET_CHARSET_ASCII, 0,
        { wpt_init, wpt_read, NULL, NULL, NULL, NULL }
};
/**************************************************************************/
